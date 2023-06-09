import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Questionnaire {
  final String id;
  final String title;
  final List<Question> questions;
  Questionnaire({this.id = '', this.title = '', this.questions = const []});

  factory Questionnaire.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireToJson(this);
}

@JsonSerializable()
class Question {
  String desc;
  String id;

  Question({this.desc = '', this.id = ''});
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Grievance {
  final String comment;
  final String desc;
  final String imageUrl;
  final Map<String, double> location;
  final String type;

  Grievance(
      {this.comment = '',
      this.desc = '',
      this.imageUrl = '',
      this.location = const {},
      this.type = ''});
  factory Grievance.fromJson(Map<String, dynamic> json) =>
      _$GrievanceFromJson(json);
  Map<String, dynamic> toJson() => _$GrievanceToJson(this);
}

@JsonSerializable()
class Route {
  final List<Map<String, double>> routeCoordinates;
  final String routeId;
  final String routeMode;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  final double totalDist;
  final String totalTime;
  final int totalGriefs;

  Route(
      {required this.routeId,
      required this.routeCoordinates,
      required this.routeMode,
      required this.createdAt,
      required this.totalTime,
      required this.totalDist,
      required this.totalGriefs});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
  Map<String, dynamic> toJson() => _$RouteToJson(this);

  static DateTime _dateTimeFromTimestamp(Timestamp timestamp) =>
      timestamp.toDate();

  static Timestamp _dateTimeToTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}

@JsonSerializable()
class Report {
  final double totalDistance;
  final int totalGrievances;
  final int trips;

  Report({this.totalGrievances = 0, this.totalDistance = 0.0, this.trips = 0});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
