class RequestsModel {
  final List requests;

  RequestsModel(this.requests);

  factory RequestsModel.fromJson(List json) {
    return RequestsModel(json);
  }

  List<dynamic> toJson() {
    List<dynamic> data = new List<String>();
    if (this.requests != null) {
      data = this.requests;
    }
    return data;
  }
}