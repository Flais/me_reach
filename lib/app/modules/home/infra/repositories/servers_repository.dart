import 'package:flutter/widgets.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/drivers_interfaces/server_status_checker_interface.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';

class ServersRepository implements IServersRepository {
  final IGetServersListLocalDataSource _getServersListDataSource;
  final IServerStatusCheckerDriver _serverStatusCheckerDriver;

  ServersRepository(
      {@required IGetServersListLocalDataSource getServersListDataSource,
      @required IServerStatusCheckerDriver serverStatusCheckerDriver})
      : this._getServersListDataSource = getServersListDataSource,
        this._serverStatusCheckerDriver = serverStatusCheckerDriver;

  @override
  Future<List<IServerEntity>> getServers() async {
    final _response = await this._getServersListDataSource.getLocalData();

    //Converts the data received from dataSource to a List<IServerEntity>
    final List<IServerEntity> _entityReturn = _response
        .map(
          (serverData) => ServerEntity(
            domain: serverData['domain'],
            lastUpdate: DateTime.now(),
            isOnline: true,
          ),
        )
        .toList();

    return _entityReturn;
  }

  @override
  Future<bool> checkServerStatus({@required String serverDomain}) async {
    final _serverStatus = await _serverStatusCheckerDriver.checkServerStatus(
        serverDomain: serverDomain);
    return _serverStatus;
  }
}
