class NetWorkConfig {
  String localProxyIPAddress;
  String localProxyPort;

  int connectTimeout=10000;
  int receiveTimeout=10000;

  NetWorkConfig(
      {this.localProxyIPAddress,
      this.localProxyPort='8000',
      this.connectTimeout,
      this.receiveTimeout});
}
