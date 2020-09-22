import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';


/// This use case gets the data from data source, saves the fetched result
/// in a cache variable that will be used by others use cases and finally
/// returns the value fetched
class GetServersListUseCase {
  final IServersRepository _repository;

  GetServersListUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute() async {

    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    final List<IServerEntity> _serversList =
        await _repository.getServers();


    //Update de cache variable with persistence data
    di.serversList = _serversList;

    return _serversList;
  }
}
