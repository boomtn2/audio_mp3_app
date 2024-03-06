import 'dart:async';

import '/data/network/api_error.dart';
import '/data/network/base_response.dart';
import '/data/network/network_checker.dart';
import 'package:gsheets/gsheets.dart';

import 'credentials.dart';

class APIProviderGsheet {
  static final _singleton = APIProviderGsheet();
  static APIProviderGsheet get instance => _singleton;
  final gsheet = GSheets(credentials);
  Future<BaseResponse> fletchData() async {
    if (!(await NetWorkChecker.isConnected)) {
      throw FetchDataError('No InTernet connection');
    }
    try {
      final ss = await gsheet.spreadsheet(spreadsheetId);
      final sheet = ss.worksheetByTitle(titleSheet);
      final data = await sheet!.values.map.allRows();
      print(data);
      return BaseResponse(data: data, success: true);
    } catch (e) {
      return BaseResponse(success: false);
    }
  }
}
