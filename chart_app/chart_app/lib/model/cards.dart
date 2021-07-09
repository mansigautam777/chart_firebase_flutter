class MessageCard {
  String title;
  int year;
  int stat;

  MessageCard({this.title, this.year,this.stat});

  MessageCard.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        year = json['year'],
        stat = json['stat'];

  // Need toJson method to serialize the data for the MessageCard so it can be accepted to be stored in Cloud firestore
  Map<String, dynamic> toJson() => {
        'title': title,
        'year': year,
        'stat' : stat
      };

  @override
  String toString() {
    return '$title | $year | $stat';
  }
}
