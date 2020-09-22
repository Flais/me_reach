import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';

class HiveGetServersListLocalDataSource
    implements IGetServersListLocalDataSource {
  @override
  Future<List<Map<String, dynamic>>> getLocalData() {
    return Future.value([
      {'name': 'joão'},
      {'name': 'maria'},
      {'name': 'josé'},
    ]);
  }
}
