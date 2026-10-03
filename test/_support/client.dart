import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';

import 'fake_e621.dart';

Dio dioFor(FakeE621 fake, {Credentials? credentials}) => createDefaultDio(
  Identity(
    id: 1,
    host: fake.url,
    username: credentials?.username,
    headers: credentials == null
        ? null
        : {'authorization': credentials.basicAuth},
  ),
);
