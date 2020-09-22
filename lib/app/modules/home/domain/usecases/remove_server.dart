import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/app_controller.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';

class RemoveServerUseCase {
  Future<List<ServerEntity>> execute({@required String serversDomain}) async {
    // This is how the Dependence Injector is invoked
    final di = Modular.get<AppController>();

    //Remove the ServerEntity from the cache variable
    di.serversList.removeWhere((server) => server.domain == serversDomain);

    return di.serversList;
  }
}
