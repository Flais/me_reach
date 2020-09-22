abstract class IServerEntity {
  String domain;
  bool isOnline;

  Map<String, dynamic> toJson(IServerEntity serverEntity);

  IServerEntity formJson(Map<String, dynamic> json);
}
