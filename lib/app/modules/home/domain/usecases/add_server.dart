import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';

class AddServerUseCase {
  final IServersRepository _repository;

  AddServerUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<ServerEntity>> execute({@required String serversDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    final _serverStatus =
        await _repository.checkServerStatus(serverDomain: serversDomain);

    final IServerEntity _server = ServerEntity(
      domain: serversDomain,
      isOnline: _serverStatus,
      lastUpdate: DateTime.now(),
    );

    //Save the ServerEntity in the global variable
    di.serversList.add(_server);

    return di.serversList;
  }
}
