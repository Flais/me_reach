import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

abstract class IGetServersListRepository{
  Future<List<IServerEntity>> getServersEntities();
}
