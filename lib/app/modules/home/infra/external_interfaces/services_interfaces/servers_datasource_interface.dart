import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

abstract class IServersDataSource{

  Future<List<String>> getServersFromDatabase();
  Future<void> updateDatabase({List<IServerEntity> serversList});

}