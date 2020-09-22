import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:me_reach/app/app_module.dart';
import 'package:me_reach/app/modules/home/domain/usecases/add_server.dart';
import 'package:me_reach/app/modules/home/infra/entities/server_entity.dart';
import 'package:me_reach/app/modules/home/ui/home_module.dart';

void main() {
  initModules([
    AppModule(),
    HomeModule(),
  ]);

  AddServerUseCase useCase;

  setUp(() {
    useCase = AddServerUseCase();
  });

  test('Should return a instance of [List<ServerEntity>]', () async {
    //Act
    final _tResult = await useCase.execute(serverDomain: 'any.com');

    //Expect
    expect(_tResult, isInstanceOf<List<ServerEntity>>());
    expect(_tResult[0].domain, isInstanceOf<String>());
    expect(_tResult[0].lastUpdate, isInstanceOf<String>());
    expect(_tResult[0].isOnline, isInstanceOf<bool>());
  });
}
