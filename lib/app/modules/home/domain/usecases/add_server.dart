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

    // Check if the serverDomain is valid
    if (!_validateServerDomain(serverDomain) &&
        !_validateNetworkAddress(serverDomain))
      throw InvalidNetworkAddressException();

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

  bool _validateServerDomain(String serverDomain) {
    return RegExp(
            r"^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]{0,1}\.(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})$")
        .hasMatch(serverDomain);
  }

  bool _validateNetworkAddress(String serverAddress) {
    return RegExp(r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b")
        .hasMatch(serverAddress);
  }
}
