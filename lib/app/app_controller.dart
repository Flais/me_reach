import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/home/domain/entities_interfaces/server_entity_interface.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

// Here stay all global variables

abstract class _AppControllerBase with Store {
  List<IServerEntity> serversList = <IServerEntity>[];
}
