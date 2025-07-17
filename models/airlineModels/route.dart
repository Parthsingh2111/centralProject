import 'package:centralproject/models/airlineModels/leg.dart';

class FlightRoute {
  final String routeId;
  final List<Leg> legs;

  FlightRoute({required this.routeId, required this.legs});

  Map<String, dynamic> toJson() => {
        'routeId': routeId,
        'legData': legs.map((leg) => leg.toJson()).toList(),
      };
}