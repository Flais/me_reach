import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/get_servers_list.dart';
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
  ObservableList<IServerEntity> listOfServers = <IServerEntity>[].asObservable();

  final addServerUseCase = Modular.get<AddServerUseCase>();
  final removeServerUseCase = Modular.get<RemoveServerUseCase>();
  final getServersListUseCase = Modular.get<GetServersListUseCase>();

  Future getServers() async{
    getServersListUseCase
        .execute()
        .then((value) => listOfServers = value.asObservable());
  }

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
