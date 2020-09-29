import 'package:dio/dio.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/drivers_interfaces/server_status_checker_interface.dart';

class DioServerStatusChecker implements IServerStatusCheckerDriver {
  @override
  Future<bool> checkServerStatus({String serverDomain}) async {
    try {
      Response response = await Dio().get(serverDomain).timeout(Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      print('$serverDomain Not connected');
      return false;
    }
  }
}
