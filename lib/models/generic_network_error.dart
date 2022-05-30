import 'dart:convert';

class GenericNetworkError {
  String? detail;
  String? code;

  GenericNetworkError({this.detail, this.code});

  GenericNetworkError.fromJson(Map<String, dynamic> json) {
    detail = json['detail'] ??= utf8.decode(utf8.encode(json.entries.first.value));
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['code'] = code;
    return data;
  }
}
