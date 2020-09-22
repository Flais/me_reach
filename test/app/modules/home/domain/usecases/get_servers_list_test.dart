import 'package:flutter_test/flutter_test.dart';
import 'package:me_reach/app/fixtures/local_datasource_data_fixture.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/domain/repositories_interfaces/get_servers_list_repository_interface.dart';
import 'package:me_reach/app/modules/home/domain/usecases/get_servers_list_local_datasource.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/get_servers_list_local_datasource_interface.dart';
import 'package:me_reach/app/modules/home/infra/repositories/get_servers_list_repository.dart';
import 'package:mockito/mockito.dart';

class MockGetServersListLocalDataSource extends Mock
    implements IGetServersListLocalDataSource {}

void main() {
  GetServersListUseCase useCase;
  IGetServersListRepository repository;
  IGetServersListLocalDataSource dataSource;

  setUp(() {
    dataSource = MockGetServersListLocalDataSource();
    repository = GetServersListRepository(dataSource: dataSource);
    useCase = GetServersListUseCase(repository: repository);
  });

  group('GetServersListUseCase', (){
    test('Success - Should return a instance of [List<ServerEntity>] when the data source returns a list with values', () async {
      //Arrange
      when(dataSource.getLocalData())
          .thenAnswer((_) => Future.value(localDataSourceDataFixture));

      //Act
      final tResult = await useCase.execute();

      //Expect
      expect(tResult, isInstanceOf<List<IServerEntity>>());
    });

    test('Success - Should return a instance of [List<ServerEntity>] when the data source returns a empty list', () async {
      //Arrange
      when(dataSource.getLocalData())
          .thenAnswer((_) => Future.value(emptyLocalDataSourceDataFixture));

      //Act
      final tResult = await useCase.execute();

      //Expect
      expect(tResult, isInstanceOf<List<IServerEntity>>());
    });
  });

}
