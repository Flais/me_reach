import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/core/exceptions.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';

class AddServerUseCase {
  final IServersRepository _repository;

  AddServerUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute({@required String serverDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    //Check if the server already exists in the cache variable
    if (_checkServerAlreadyExists(
      serversList: di.serversList,
      serverDomain: serverDomain,
    )) throw ServerAlreadyExistsException();

    //Check the status of the server
    final _serverStatus =
        await _repository.checkServerStatus(serverDomain: serverDomain);

    final IServerEntity _server = ServerEntity(
      domain: serverDomain,
      isOnline: _serverStatus,
      lastUpdate: DateTime.now(),
    );


    //Save the ServerEntity in the cache variable
    di.serversList.insert(0, _server);

    await _repository.updateDatabase(serversList: di.serversList);

    return di.serversList;
  }

  bool _checkServerAlreadyExists(
      {@required List<IServerEntity> serversList,
      @required String serverDomain}) {
    final _findServer =
        serversList.where((server) => server.domain == serverDomain);

    return _findServer.length > 0;
  }
}
