// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_aliases_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _TagAliasesClient implements TagAliasesClient {
  _TagAliasesClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<TagAlias>> getTagAliases({
    int? page,
    int? limit,
    String? searchNameMatches,
    String? searchAntecedentName,
    String? searchConsequentName,
    String? searchCreatorName,
    String? searchApproverName,
    int? searchAntecedentTagCategory,
    int? searchConsequentTagCategory,
    GetTagAliasesSearchStatus? searchStatus,
    GetTagAliasesSearchOrder? searchOrder,
    String? searchCreatedAt,
    String? searchUpdatedAt,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'limit': limit,
      r'search[name_matches]': searchNameMatches,
      r'search[antecedent_name]': searchAntecedentName,
      r'search[consequent_name]': searchConsequentName,
      r'search[creator_name]': searchCreatorName,
      r'search[approver_name]': searchApproverName,
      r'search[antecedent_tag_category]': searchAntecedentTagCategory,
      r'search[consequent_tag_category]': searchConsequentTagCategory,
      r'search[status]': searchStatus,
      r'search[order]': searchOrder,
      r'search[created_at]': searchCreatedAt,
      r'search[updated_at]': searchUpdatedAt,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TagAlias>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/tag_aliases.json',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TagAlias> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => TagAlias.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TagAlias> getTagAlias({required int id}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TagAlias>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/tag_aliases/${id}.json',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late TagAlias _value;
    try {
      _value = TagAlias.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
