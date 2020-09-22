import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

abstract class IServersRepository{
  Future<List<IServerEntity>> getServers();
  Future<bool> checkServerStatus({String serverDomain});
}
