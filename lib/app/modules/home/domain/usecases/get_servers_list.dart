import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';


/// This use case gets the data from a local data source, saves the fetched result
/// in a global variable that will be used by others use cases and finally
/// returns the value fetched
class GetServersListUseCase {
  final IServersRepository _repository;

  GetServersListUseCase({@required IServersRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute() async {
    final List<IServerEntity> _listOfServersEntities =
        await _repository.getServers();


    // This is how the Dependence Injector is invoked
    Modular.get<AppController>().serversList = _listOfServersEntities;

    return _listOfServersEntities;
  }
}
