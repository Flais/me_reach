import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/get_servers_list.dart';
import 'package:me_reach/app/modules/home/domain/usecases/refresh_server_status.dart';
import 'package:me_reach/app/modules/home/domain/usecases/remove_server.dart';
import 'package:me_reach/app/modules/home/domain/usecases/reorder_servers_list.dart';
import 'package:me_reach/app/modules/home/external/drivers/dio_server_status_checker.dart';
import 'package:me_reach/app/modules/home/external/services/hive_get_servers_list_local_datasource.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/drivers_interfaces/server_status_checker_interface.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/servers_datasource_interface.dart';
import 'package:me_reach/app/modules/home/infra/repositories/servers_repository.dart';

import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        $HomeController,
        //DataSources
        Bind((i) => HiveServersLocalDataSource()),

        //Drivers
        Bind((i) => DioServerStatusChecker()),

        //Repositories
        Bind((i) => ServersRepository(
            dataSource: i.get<IServersDataSource>(),
            serverStatusCheckerDriver: i.get<IServerStatusCheckerDriver>(),
        )),

        //UseCases
        Bind((i) => AddServerUseCase(repository: i.get<IServersRepository>())),
        Bind((i) => GetServersListUseCase(repository: i.get<IServersRepository>())),
        Bind((i) => RemoveServerUseCase(repository: i.get<IServersRepository>())),
        Bind((i) => ReorderServersListUseCase(repository: i.get<IServersRepository>())),
        Bind((i) => RefreshServerStatus(repository: i.get<IServersRepository>())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
