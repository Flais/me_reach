import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/get_servers_list.dart';
import 'package:me_reach/app/modules/home/domain/usecases/remove_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/reorder_servers_list.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final domainTextEditingController = TextEditingController();
  final animatedListKey = GlobalKey<AnimatedListState>();
  final scrollController = ScrollController();

  @observable
  ObservableList<IServerEntity> listOfServers =
      <IServerEntity>[].asObservable();

  final addServerUseCase = Modular.get<AddServerUseCase>();
  final removeServerUseCase = Modular.get<RemoveServerUseCase>();
  final getServersListUseCase = Modular.get<GetServersListUseCase>();
  final _reOrderServersListUseCase = Modular.get<ReorderServersListUseCase>();

  Future getServersList() async {
    await getServersListUseCase
        .execute()
        .then((value) => listOfServers = value.asObservable());
  }

  @action
  addServer({@required String serverDomain}) async {
    await addServerUseCase
        .execute(serverDomain: serverDomain)
        .then((value) => listOfServers = value.asObservable());

    domainTextEditingController.text = '';

    //Jump to start
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeIn,
    );
  }

  @action
  removeServer({@required String serverDomain}) async {
    removeServerUseCase
        .execute(serverDomain: serverDomain)
        .then((value) => listOfServers = value.asObservable());
  }

  @action
  reOrderServersList(List<IServerEntity> newList) async {
    listOfServers = newList.asObservable();
    await _reOrderServersListUseCase.execute(serversList: newList);
  }
}
