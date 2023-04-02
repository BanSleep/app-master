import 'dart:convert';

CommentRequest commentRequestFromJson(String str) =>
    CommentRequest.fromJson(json.decode(str));

String commentRequestToJson(CommentRequest data) => json.encode(data.toJson());

class CommentRequest {
  CommentRequest({
    required this.name,
    required this.email,
    required this.mark,
    required this.comment,
  });

  String name;
  String email;
  String mark;
  String comment;

  factory CommentRequest.fromJson(Map<String, dynamic> json) => CommentRequest(
        name: json["name"],
        email: json["email"],
        mark: json["mark"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mark": mark,
        "comment": comment,
      };
}
