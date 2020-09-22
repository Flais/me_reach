abstract class IServersDataSource{

  Future<List<String>> getServersFromDatabase();
  Future<void> saveServerOnDatabase({String serverDomain});
  Future<void> removeServerFromDatabase({String serverDomain});

}