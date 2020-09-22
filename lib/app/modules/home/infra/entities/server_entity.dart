import 'package:flutter/cupertino.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';

class ServerEntity implements IServerEntity {
  @override
  String domain;

  @override
  bool isOnline;

  ServerEntity({@required this.domain});

  @override
  IServerEntity formJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(IServerEntity serverEntity) {
    throw UnimplementedError();
  }
}
