import 'dart:io';
import 'package:me_reach/app/modules/home/infra/external_interfaces/drivers_interfaces/server_status_checker_interface.dart';

class ServerStatusChecker implements IServerStatusCheckerDriver {
  @override
  Future<bool> checkServerStatus({String serverDomain}) async {
    try {
      final result = await InternetAddress.lookup(serverDomain);

      final _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      _isConnected ? print('Connected') : print('Not connected');

      return _isConnected;
    } on SocketException catch (_) {
      print('Not connected');
      return false;
    }
  }
}