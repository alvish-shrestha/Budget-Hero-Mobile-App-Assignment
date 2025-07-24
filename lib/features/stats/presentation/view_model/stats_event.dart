import 'package:flutter/foundation.dart';

@immutable
sealed class StatsEvent {}

class LoadStatsEvent extends StatsEvent {}
