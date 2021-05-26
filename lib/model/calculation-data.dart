class CalculationData {
  String equation;
  String result;
  String id;
  String previousId;
  String time;

  CalculationData(
      {this.equation, this.result, this.id, this.previousId, this.time});

  CalculationData.fromJson(Map<String, dynamic> json) {
    equation = json['equation'];
    result = json['result'];
    id = json['id'];
    previousId = json['previous_id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equation'] = this.equation;
    data['result'] = this.result;
    data['id'] = this.id;
    data['previous_id'] = this.previousId;
    data['time'] = this.time;
    return data;
  }
}