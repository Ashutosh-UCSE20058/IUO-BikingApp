// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) =>
    Questionnaire(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuestionnaireToJson(Questionnaire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      desc: json['desc'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
    };

Grievance _$GrievanceFromJson(Map<String, dynamic> json) => Grievance(
      comment: json['comment'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      location: (json['location'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$GrievanceToJson(Grievance instance) => <String, dynamic>{
      'comment': instance.comment,
      'desc': instance.desc,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
      'type': instance.type,
    };

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      routeId: json['routeId'] as String,
      routeCoordinates: (json['routeCoordinates'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ))
          .toList(),
      routeMode: json['routeMode'] as String,
      createdAt: Route._dateTimeFromTimestamp(json['createdAt'] as Timestamp),
      totalTime: json['totalTime'] as String,
      totalDist: (json['totalDist'] as num).toDouble(),
      totalGriefs: json['totalGriefs'] as int,
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'routeCoordinates': instance.routeCoordinates,
      'routeId': instance.routeId,
      'routeMode': instance.routeMode,
      'createdAt': Route._dateTimeToTimestamp(instance.createdAt),
      'totalDist': instance.totalDist,
      'totalTime': instance.totalTime,
      'totalGriefs': instance.totalGriefs,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      totalGrievances: json['totalGrievances'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      trips: json['trips'] as int? ?? 0,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'totalDistance': instance.totalDistance,
      'totalGrievances': instance.totalGrievances,
      'trips': instance.trips,
    };
