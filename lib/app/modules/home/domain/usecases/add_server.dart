import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';

class AddServerUseCase {
  Future<List<ServerEntity>> execute({@required String serversDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();


    final IServerEntity _server = ServerEntity(domain: serversDomain);

    //Save the ServerEntity in the global variable
    di.serversList.add(_server);

    return di.serversList;
  }
}
