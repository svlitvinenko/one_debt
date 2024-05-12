import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class OneDebtLoggingInterceptor extends Interceptor {
  final JsonDecoder decoder = const JsonDecoder();
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  final Logger logger;

  OneDebtLoggingInterceptor(this.logger);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('🌎 Request Start');
    buffer.writeln('Method: ${options.method}');
    buffer.writeln('URL: ${options.uri}');

    buffer.writeln('Headers:');
    options.headers.forEach((key, value) {
      buffer.writeln('  $key:$value');
    });

    final data = options.data;
    if (data != null) {
      buffer.writeln('Data:');
      if (data is Map) {
        _prettyPrintJson(buffer, data);
      } else if (data is List) {
        _prettyPrintJson(buffer, data);
      } else if (data is FormData) {
        final Map<String, String> map = Map.fromEntries(data.fields);
        _prettyPrintJson(buffer, map);
      } else {
        buffer.writeln('  $data');
      }
    }

    buffer.write('Request End');

    logger.t(buffer.toString());

    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('🌎 Response Start: ${response.statusCode}');
    buffer.writeln(
      'Code: ${response.statusCode} (${(response.statusMessage?.isNotEmpty ?? false) ? response.statusMessage : 'No message'})',
    );
    buffer.writeln('Method: ${response.requestOptions.method}');
    buffer.writeln('URL: ${response.requestOptions.uri}');

    buffer.writeln('Headers:');
    response.headers.forEach((key, value) {
      buffer.writeln('  $key:$value');
    });

    final data = response.data;
    if (data != null) {
      buffer.writeln('Data:');
      if (data is Map) {
        _prettyPrintJson(buffer, data);
      } else if (data is List) {
        _prettyPrintJson(buffer, data);
      } else {
        buffer.writeln('  $data');
      }
    }

    buffer.write('Response End');

    logger.t(buffer.toString());

    return handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('🌎 Request failed: ${err.message}');
    logger.w(buffer.toString(), error: err.error);
    return handler.next(err);
  }

  void _prettyPrintJson(StringBuffer buffer, Object input) {
    final String prettyString = encoder.convert(input);
    prettyString.split('\n').forEach((String element) {
      buffer.writeln('  $element');
    });
  }
}
