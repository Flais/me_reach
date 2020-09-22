import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  final TextEditingController domainTextEditingController = TextEditingController();

  @observable
  ObservableList<ServerEntity> listOfServers = <ServerEntity>[].asObservable();

  final AddServerUseCase addServerUseCase = Modular.get<AddServerUseCase>();

  @action
  addServer({@required String domainServer}) async{
    listOfServers = await
        addServerUseCase.execute(serversDomain: domainServer).asObservable();
  }
}
