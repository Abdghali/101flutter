import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/Company.dart';
import 'api_response.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  /// to get all Companyes  ----------------------------------------
  Future<APIResponse<List<Companies>>> getClassDataList(
      String token, int page) {
    var url ='https://instadealco.com/tager/api/all/company';
    print(token);
    final Map<String, String> _authHeaders = {
      'Authorization': 'Bearer $token','Accept': 'application/json','Content-Type': 'application/json','lang':'ar'};
    return http
        .get(url + '?$page', headers: _authHeaders)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        final jasonData = json.decode(response.body);
        final Company _company = Company.fromJson(jasonData);
        return APIResponse<List<Companies>>(data: _company.data.companies);
      }
      return APIResponse<List<Companies>>(error: true,errorMessage: 'an error accrued 1  ${response.statusCode}');
    }).catchError((e) => APIResponse<List<Companies>>(error: true, errorMessage: 'an error accrued 2 ' + e.toString()));
  }
}
