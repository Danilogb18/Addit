
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class CounterEntry {

  final String id;
  final DateTime dateTime;
  final String description;

  CounterEntry({
    String? id,
    required this.dateTime,
    this.description = ''
  }) : id = id ?? _uuid.v4() ;

  CounterEntry copyWith ({
    String? description,
    DateTime? dateTime
  }) => CounterEntry(
    description: description ?? this.description,
    dateTime: dateTime ?? this.dateTime
  );

}