abstract class IServerEntity {
  String domain;
  DateTime lastUpdate;
  bool isOnline;

  Map<String, dynamic> toJson(IServerEntity serverEntity);

  IServerEntity fromJson(Map<String, dynamic> json);
}
