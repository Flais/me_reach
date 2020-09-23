import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';

class RefreshServerStatus {
  final IServersRepository _repository;

  RefreshServerStatus({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute({@required String serverDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    //Check the status of the server
    final _serverStatus =
        await _repository.checkServerStatus(serverDomain: serverDomain);

    //Update the cache variable
    di.serversList.forEach((server) {
      if (server.domain == serverDomain) {
        server.lastUpdate = DateTime.now();
        server.isOnline = _serverStatus;
      }
    });

    return di.serversList;
  }
}
