class HomeBean {
  String title;
  String url;

  HomeBean({this.title, this.url});

  HomeBean.fromJson(Map<String, dynamic> json) {    
    this.title = json['title'];
    this.url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }

}
