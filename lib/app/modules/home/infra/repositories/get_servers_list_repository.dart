import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';

class GetServersListRepository implements IGetServersListRepository {
  final IGetServersListLocalDataSource _dataSource;

  GetServersListRepository(
      {@required IGetServersListLocalDataSource dataSource})
      : this._dataSource = dataSource;

  @override
  Future<List<IServerEntity>> getServersEntities() async{


    final _response = await this._dataSource.getLocalData();

    //Converts the data received from dataSource to a List<IServerEntity>
    final List<IServerEntity> _entityReturn = _response.map((serverData) => ServerEntity(domain: serverData['domain'])).toList();

    return _entityReturn;

  }
}
