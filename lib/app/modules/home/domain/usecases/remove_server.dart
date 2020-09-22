import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';

class RemoveServerUseCase {

  final IServersRepository _repository;

  RemoveServerUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<ServerEntity>> execute({@required String serverDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();


    await _repository.removeServerFromDatabase(serverDomain: serverDomain);

    //Remove the ServerEntity from the cache variable
    di.serversList.removeWhere((server) => server.domain == serverDomain);

    return di.serversList;
  }
}
