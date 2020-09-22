import 'package:flutter/widgets.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';

class GetServersListUseCase {
  final IGetServersListRepository _repository;

  GetServersListUseCase({@required IGetServersListRepository repository})
      : this._repository = repository;

  Future<List<IServerEntity>> execute() async {
    final List<IServerEntity> _listOfServersEntities =
        await _repository.getServersEntities();

    return _listOfServersEntities;
  }
}
