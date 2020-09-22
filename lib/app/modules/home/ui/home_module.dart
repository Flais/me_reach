import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/remove_server.dart';
import 'package:me_reach/app/modules/home/external/services/hive_get_servers_list_local_datasource.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';
import 'package:me_reach/app/modules/home/infra/repositories/get_servers_list_repository.dart';

import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $HomeController,
        //DataSources
        Bind((i) => HiveGetServersListLocalDataSource()),

        //Repositories
        Bind((i) => GetServersListRepository(dataSource: i.get<IGetServersListLocalDataSource>())),

        //UseCases
        Bind((i) => AddServerUseCase()),
        Bind((i) => RemoveServerUseCase()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
