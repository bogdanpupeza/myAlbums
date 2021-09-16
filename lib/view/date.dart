import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final DateTime? date;
  final bool? liveUpdate;
  DateWidget({
    required this.date,
    required this.liveUpdate,
  });

  String showDuration(Duration lastUpdate){
    String duration = "";
    if(lastUpdate.inDays > 0){
      duration += "${(lastUpdate.inDays.toString())} days ";
    } else {
      if(lastUpdate.inMinutes > 0){
        int minutes = lastUpdate.inMinutes % 60;
        duration += "${(minutes.toString())} minutes ";
      }
      if(lastUpdate.inSeconds >= 0){
        int seconds = lastUpdate.inSeconds % 60;
        duration += "${(seconds.toString())} seconds";
      }
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    if (date != null){
      Duration lastUpdate = DateTime.now().difference(date!);
      return Text(
        liveUpdate == true
        ? "Results updated just now"
        : "Results updated ${(showDuration(lastUpdate))} ago");
    }
    return Container();
  }
}