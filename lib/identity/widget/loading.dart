import 'dart:io';

import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class LoginLoadingDialog extends StatefulWidget {
  const LoginLoadingDialog({
    super.key,
    required this.identity,
    required this.host,
    required this.username,
    required this.apikey,
    this.activate = false,
    this.onError,
    this.onDone,
  });

  final Identity? identity;
  final String host;
  final String? username;
  final String? apikey;
  final bool activate;
  final ValueSetter<String?>? onError;
  final VoidCallback? onDone;

  @override
  State<LoginLoadingDialog> createState() => _LoginLoadingDialogState();
}

class _LoginLoadingDialogState extends State<LoginLoadingDialog> {
  @override
  void initState() {
    super.initState();
    login();
  }

  Future<void> login() async {
    NavigatorState navigator = Navigator.of(context);
    IdentityClient client = context.read<IdentityClient>();
    Identity? identity = widget.identity;
    String host = widget.host;
    String? username = widget.username;
    String? apikey = widget.apikey;
    Map<String, String>? headers = Map.of(identity?.headers ?? {});
    if (username != null && apikey != null) {
      if (apikey == OmittedPasswordTextInputFormatter.passwordOmitted) {
        apikey = parseBasicAuth(headers[HttpHeaders.authorizationHeader])?.$2;
        if (apikey == null) {
          throw StateError(
            'Login failed: API key was omitted but could not be recovered',
          );
        }
      }
      headers[HttpHeaders.authorizationHeader] = encodeBasicAuth(
        username,
        apikey,
      );
    } else {
      headers.remove(HttpHeaders.authorizationHeader);
    }
    try {
      if (identity != null) {
        await client.replace(
          identity.copyWith(host: host, username: username, headers: headers),
        );
      } else {
        Identity created = await client.add(
          IdentityRequest(host: host, username: username, headers: headers),
        );
        if (widget.activate) await client.activate(created.id);
      }
    } on DriftRemoteException catch (e) {
      Object error = e.remoteCause;
      String? reason;
      // Duplicate username/host combination
      if (error is SqliteException && error.extendedResultCode == 2067) {
        // Reuse an existing anonymous identity so picking Guest is idempotent.
        if (identity == null && username == null) {
          List<Identity> all = await client.page(page: 1, limit: 9999);
          Iterable<Identity> matches = all.where(
            (e) =>
                e.username == null &&
                normalizeHostUrl(e.host) == normalizeHostUrl(host),
          );
          if (matches.isNotEmpty) {
            if (widget.activate) await client.activate(matches.first.id);
            await navigator.maybePop();
            widget.onDone?.call();
            return;
          }
        }
        reason = t('You already have an identity under this host and username.');
      }
      await navigator.maybePop();
      widget.onError?.call(reason);
      return;
    }
    await navigator.maybePop();
    widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tf(
                  'Connecting to {host} as {user}...',
                  params: {
                    'host': linkToDisplay(widget.host),
                    'user': widget.username ?? 'anonymous',
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
