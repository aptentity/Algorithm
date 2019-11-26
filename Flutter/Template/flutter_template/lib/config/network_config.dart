class NetWorkConfig {
  String localProxyIPAddress;
  String localProxyPort;

  int connectTimeout=10000;
  int receiveTimeout=10000;

  NetWorkConfig(
      {this.localProxyIPAddress='172.16.41.163',
      this.localProxyPort='8888',
      this.connectTimeout,
      this.receiveTimeout});
}
