import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class NoUserLoginException implements Exception {
  NoUserLoginException();

  @override
  String toString() => 'NoUserLoginException';
}

Future<void> guardWithLogin({
  required BuildContext context,
  required VoidCallback callback,
  String? error,
}) async {
  if (context.read<Client>().hasLogin) {
    callback();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error ?? 'You must be logged in to perform this action.'),
        action: SnackBarAction(
          label: 'Choose identity',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const IdentitiesPage()),
          ),
        ),
      ),
    );
  }
}
