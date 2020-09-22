import 'package:flutter/widgets.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

class ServerEntity implements IServerEntity {
  @override
  String domain;

  @override
  bool isOnline;

  @override
  DateTime lastUpdate;

  ServerEntity(
      {@required this.domain,
      @required this.isOnline,
      @required this.lastUpdate});

  @override
  IServerEntity fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(IServerEntity serverEntity) {
    throw UnimplementedError();
  }
}
