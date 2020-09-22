import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

abstract class IServersRepository{
  Future<List<IServerEntity>> getServersFromDatabase();
  Future<void> saveServerOnDatabase({String serverDomain});
  Future<void> removeServerFromDatabase({String serverDomain});
  Future<bool> checkServerStatus({String serverDomain});
}
