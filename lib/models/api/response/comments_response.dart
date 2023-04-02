// To parse this JSON data, do
//
//     final commentsResponse = commentsResponseFromJson(jsonString);

import 'dart:convert';

import 'base/app_base_response.dart';

CommentsResponse commentsResponseFromJson(String str) =>
    CommentsResponse.fromJson(json.decode(str));

//String commentsResponseToJson(CommentsResponse data) => json.encode(data.toJson());

class CommentsResponse extends AppBaseResponse {
  CommentsResponse({
    required result,
    this.data,
  }) : super(result);

  CommentData? data;

  factory CommentsResponse.fromJson(json) => CommentsResponse(
        result: json["result"],
        data: CommentData.fromJson(json["data"]),
      );
}

class CommentData {
  CommentData({
    required this.commentsNum,
    this.comments,
  });

  int commentsNum;
  List<Comment>? comments;

  factory CommentData.fromJson(json) => CommentData(
        commentsNum: json["comments_num"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  /*Map<String, dynamic> toJson() => {
    "comments_num": commentsNum,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };*/
}

class Comment {
  Comment({
    required this.timestamp,
    required this.mark,
    required this.name,
    required this.comment,
    required this.answer,
  });

  int timestamp;
  int mark;
  String name;
  String comment;
  String answer;

  factory Comment.fromJson(json) => Comment(
        timestamp: json["timestamp"],
        mark: json["mark"],
        name: json["name"],
        comment: json["comment"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "mark": mark,
        "name": name,
        "comment": comment,
        "answer": answer,
      };
}
