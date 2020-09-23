import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/get_servers_list.dart';
import 'package:me_reach/app/modules/home/domain/usecases/refresh_server_status.dart';
import 'package:me_reach/app/modules/home/domain/usecases/remove_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/reorder_servers_list.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  //UseCases
  final _addServerUseCase = Modular.get<AddServerUseCase>();
  final _removeServerUseCase = Modular.get<RemoveServerUseCase>();
  final _getServersListUseCase = Modular.get<GetServersListUseCase>();
  final _reOrderServersListUseCase = Modular.get<ReorderServersListUseCase>();
  final _refreshServerStatusUseCase = Modular.get<RefreshServerStatus>();

  //Widgets Stuff
  final domainTextEditingController = TextEditingController();
  final animatedListKey = GlobalKey<AnimatedListState>();
  final scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  //Cache list variable
  @observable
  ObservableList<IServerEntity> listOfServers = <IServerEntity>[].asObservable();


  //Widgets State Management
  @observable
  String textFieldSecurityProtocolOption = 'https://';

  @action
  setTextFieldSecurityProtocolOption(String value) {
    textFieldSecurityProtocolOption = value;
  }

  @observable
  bool isAddingNewDomain = false;

  @action
  setIsAddingNewDomain(bool value) {
    isAddingNewDomain = value;
  }

  //General Methods
  getServersList() async {
    _getServersListUseCase
        .execute()
        .then((value) => _updateCacheList(value));
  }

  addServer({@required String serverDomain}) async {
    _addServerUseCase
        .execute(serverDomain: serverDomain)
        .then((value) => _updateCacheList(value));

    domainTextEditingController.text = '';

    //Jump to the beginning of the list
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeIn,
    );
  }

  removeServer({@required String serverDomain}) async {
    _removeServerUseCase
        .execute(serverDomain: serverDomain)
        .then((value) => _updateCacheList(value));
  }

  reOrderServersList(List<IServerEntity> newList) async {
    _updateCacheList(newList.asObservable());
    await _reOrderServersListUseCase.execute(serversList: newList);
  }

  refreshServerStatus({@required String serverDomain}) async {
    _refreshServerStatusUseCase
        .execute(serverDomain: serverDomain)
        .then((value) => _updateCacheList(value));
  }

  periodicRefreshServers() {
    const _periodicRefreshServersDuration = const Duration(minutes: 1);
    Timer.periodic(
        _periodicRefreshServersDuration,
        (Timer t) => _getServersListUseCase
            .execute()
            .then((value) => _updateCacheList(value)));
  }

  @action
  _updateCacheList(List<IServerEntity> newList) {
    listOfServers = newList.asObservable();
  }
}
