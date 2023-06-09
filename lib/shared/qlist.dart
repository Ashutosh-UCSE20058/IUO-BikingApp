import 'package:betterroute/shared/grievance_form.dart';
import 'package:flutter/material.dart';
import 'package:betterroute/services/models.dart';

class QuestionList extends StatelessWidget {
  final Questionnaire qn;
  final String routeId;
  const QuestionList({super.key, required this.qn, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: qn.questions.map((question) {
        return Card(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 4,
            margin: const EdgeInsets.all(4),
            child: Material(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => GrievanceForm(
                            routeId: routeId,
                            grievanceDescription: question.desc,
                            grievanceType: question.id)));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                          title: Text(question.desc,
                              style:
                                  Theme.of(context).textTheme.headlineSmall)))),
            ));
      }).toList(),
    );
  }
}
