import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter_test/flutter_test.dart';

class CapturingAdapter implements HttpClientAdapter {
  RequestOptions? captured;
  int status = 302;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    if (status == 302 && options.followRedirects) {
      return ResponseBody.fromString('', 200);
    }
    return ResponseBody.fromString('', status);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late CapturingAdapter adapter;
  late TicketClient client;

  setUp(() {
    adapter = CapturingAdapter();
    client = TicketClient(
      dio: Dio(BaseOptions(baseUrl: 'https://example.invalid'))
        ..httpClientAdapter = adapter,
    );
  });

  QueryMap sent() => adapter.captured!.queryParameters.map(
    (key, value) => MapEntry(key, value.toString()),
  );

  test('treats a redirect as a created ticket', () async {
    adapter.status = 302;

    await expectLater(
      client.create(type: TicketType.post, item: 123, reason: 'spam'),
      completes,
    );
  });

  test('treats a form page as a failed ticket', () async {
    adapter.status = 200;

    await expectLater(
      client.create(type: TicketType.post, item: 123, reason: 'spam'),
      throwsA(isA<DioException>()),
    );
  });

  test('sends the ticket type and item', () async {
    await client.create(type: TicketType.forum, item: 123, reason: 'spam');

    expect(sent(), {
      'ticket[qtype]': 'forum',
      'ticket[disp_id]': '123',
      'ticket[reason]': 'spam',
    });
  });

  test('sends the post report reason as its id', () async {
    await client.create(
      type: TicketType.post,
      item: 123,
      reason: 'spam',
      postReportType: PostReportType.rating,
    );

    expect(sent()['ticket[report_reason]'], '6');
  });
}
