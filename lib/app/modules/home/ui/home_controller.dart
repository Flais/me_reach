import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/remove_server.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final TextEditingController domainTextEditingController =
      TextEditingController();

  @observable
  ObservableList<ServerEntity> listOfServers = <ServerEntity>[].asObservable();

  final addServerUseCase = Modular.get<AddServerUseCase>();
  final removeServerUseCase = Modular.get<RemoveServerUseCase>();

  @action
  addServer({@required String domainServer}) async {
    addServerUseCase
        .execute(serverDomain: domainServer)
        .then((value) => listOfServers = value.asObservable());
  }

  @action
  removeServer({@required String domainServer}) async {
    removeServerUseCase
        .execute(serversDomain: domainServer)
        .then((value) => listOfServers = value.asObservable());
  }
}
