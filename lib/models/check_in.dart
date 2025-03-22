class CheckInData {
  String userID;
  String time;
  String location;
  String deviceID;
  String date;


  CheckInData(this.userID, this.time, this.date,this.deviceID,this.location);

  factory CheckInData.fromJson(Map<dynamic, dynamic> json) {
    return CheckInData(
      json['userID']??"",
      json['time']??"",
      json['date']??"",
      json['location']??"",
      json['deviceID']??"",
    );
  }
}