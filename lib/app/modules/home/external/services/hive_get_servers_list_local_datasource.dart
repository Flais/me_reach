import 'package:hive/hive.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';
import 'package:path_provider/path_provider.dart';

class HiveGetServersListLocalDataSource
    implements IGetServersListLocalDataSource {
  @override
  Future<List<Map<String, dynamic>>> getLocalData() async {

    //Init the connection with Hive DataBase
    final _appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(_appDocumentDirectory.path);

    final _serversBox = await Hive.openBox('servers');

    final List<dynamic> serversList = _serversBox.get('servers');

    // Converts the List<dynamic> to a List<Map<String, dynamic>>
    final List<Map<String, dynamic>> _convertedList = serversList.map((e) => {'domain' : e['domain']}).toList();

    return _convertedList;
  }
}
