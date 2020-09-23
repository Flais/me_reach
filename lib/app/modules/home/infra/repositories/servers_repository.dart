import 'package:flutter/widgets.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/drivers_interfaces/server_status_checker_interface.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/servers_datasource_interface.dart';

class ServersRepository implements IServersRepository {
  final IServersDataSource _dataSource;
  final IServerStatusCheckerDriver _serverStatusCheckerDriver;

  ServersRepository(
      {@required IServersDataSource dataSource,
      @required IServerStatusCheckerDriver serverStatusCheckerDriver})
      : this._dataSource = dataSource,
        this._serverStatusCheckerDriver = serverStatusCheckerDriver;

  @override
  Future<List<IServerEntity>> getServersFromDatabase() async {
    final _response = await this._dataSource.getServersFromDatabase();

    //Converts the data received from dataSource to a List<IServerEntity>
    final List<IServerEntity> _entityReturn = await Future.wait(_response
        .map(
          (serverDomain) async => ServerEntity(
            domain: serverDomain,
            lastUpdate: DateTime.now(),
            isOnline: await _serverStatusCheckerDriver.checkServerStatus(
              serverDomain: serverDomain,
            ),
          ),
        )
        .toList());

    return _entityReturn;
  }

  @override
  Future<bool> checkServerStatus({@required String serverDomain}) async {
    final _serverStatus = await _serverStatusCheckerDriver.checkServerStatus(
        serverDomain: serverDomain);
    return _serverStatus;
  }

  @override
  Future<void> removeServerFromDatabase({String serverDomain}) async {
    await this._dataSource.removeServerFromDatabase(serverDomain: serverDomain);
  }

  @override
  Future<void> saveServerOnDatabase({String serverDomain}) async {
    await this._dataSource.saveServerOnDatabase(serverDomain: serverDomain);
  }
}
