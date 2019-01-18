part of rest;

abstract class _ClientUsersMixin implements _ClientWrapper {
  Future<void> login(UserCredentials credentials) {
    Completer<void> completer = Completer();
    http
        .post('${_getUrl()}/login',
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(<String, String>{
              'user': credentials.name,
              'password': credentials.password,
            }))
        .then((response) {
      _hackResponseHeader(response);
      final data = json.decode(response.body)['data'];
      this._auth = _AuthInfo(data['userId'], data['authToken']);
      completer.complete(null);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  setCredentials(UserCredentials credentials) {
    this._auth = _AuthInfo(credentials.id, credentials.token);
  }

  Future<dynamic> savePushToken(
      String id, String token, String type, String appName) {
    Completer<dynamic> completer = Completer();
    http
        .post('${_getUrl()}/push.token',
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(<String, String>{
              'id': id,
              'type': type,
              'value': token,
              'appName': appName,
            }))
        .then((response) {
      _hackResponseHeader(response);
      final data = json.decode(response.body)['data'];
      completer.complete(data);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }
}
