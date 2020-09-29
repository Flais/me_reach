import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';

class RemoveServerUseCase {

  final IServersRepository _repository;

  RemoveServerUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute({@required String serverDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    //Remove the ServerEntity from the cache variable
    di.serversList.removeWhere((server) => server.domain == serverDomain);

    //Update database with the cache variable value
    await _repository.updateDatabase(serversList: di.serversList);

    return di.serversList;
  }
}
