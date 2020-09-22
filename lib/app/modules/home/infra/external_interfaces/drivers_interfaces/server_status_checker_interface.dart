abstract class IServerStatusCheckerDriver {
  Future<bool> checkServerStatus({String serverDomain});
}
