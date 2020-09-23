import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';

class ReorderServersListUseCase {
  final IServersRepository _repository;

  ReorderServersListUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<void> execute({@required List<IServerEntity> serversList}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    await _repository.updateDatabase(serversList: serversList);

    //Save the ServerEntity in the cache variable
    //Update de cache variable with persistence data
    di.serversList.clear();
    di.serversList.addAll(serversList);
  }
}
