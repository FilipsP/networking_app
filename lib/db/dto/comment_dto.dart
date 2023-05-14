class CommentDTO {
  String key;
  String userID;
  String body;
  int time;
  String? avatar;
  String? name;
  CommentDTO(
      {required this.key,
      required this.userID,
      required this.body,
      required this.time});

  factory CommentDTO.fromSnapshot(data) {
    return CommentDTO(
      key: data['key'],
      userID: data['userID'],
      body: data['body'],
      time: data['time'],
    );
  }

  void addData(data) {
    name = data['name'];
    avatar = data['avatarURL'];
  }
}
