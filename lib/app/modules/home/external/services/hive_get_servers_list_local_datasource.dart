import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/infra/external_interfaces/services_interfaces/servers_datasource_interface.dart';
import 'package:path_provider/path_provider.dart';

class HiveServersLocalDataSource implements IServersDataSource {
  Box _serversBox;

  Future<void> _openDatabase() async {
    final _appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(_appDocumentDirectory.path);

    _serversBox = await Hive.openBox('servers');
  }

  Future<void> _closeDatabase() async {
    await _serversBox.close();
  }

  @override
  Future<List<String>> getServersFromDatabase() async {
    await _openDatabase();

    final serversList = this._serversBox.toMap();

    // Converts the List<dynamic> to a List<Map<String, dynamic>>
    final List<String> _convertedServersList = <String>[];
    serversList.forEach((key, value) {
      _convertedServersList.add(value['domain']);
    });

    await _closeDatabase();

    return _convertedServersList;
  }

  @override
  Future<void> updateDatabase(
      {@required List<IServerEntity> serversList}) async {
    await _openDatabase();
    await this._serversBox.clear();
    await this
        ._serversBox
        .addAll(serversList.map((server) => {'domain': server.domain}));
    await _closeDatabase();
  }
}
