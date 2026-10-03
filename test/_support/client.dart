import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';

import 'fake_e621.dart';

// Timeouts are disabled: the fake clock would otherwise leave dio's timeout
// timers pending on requests still in flight when a test ends.
Dio dioFor(FakeE621 fake, {Credentials? credentials}) =>
    createDefaultDio(
        Identity(
          id: 1,
          host: fake.url,
          username: credentials?.username,
          headers: credentials == null
              ? null
              : {'authorization': credentials.basicAuth},
        ),
      )
      ..options.connectTimeout = null
      ..options.receiveTimeout = null;
