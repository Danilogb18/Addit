
import 'package:addit/domain/entities/counter_entry.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Counter {

  final String id;
  final String name;
  final String icon;
  final List<CounterEntry> entries;
  final String? description;


  Counter({
    String? id,
    required this.name,
    required this.icon,
    required this.entries,
    this.description
  }) : id = id ?? _uuid.v4();

  int get count {
    return entries.length;
  }

  Counter copyWith ({
    String? name,
    String? icon,
    List<CounterEntry>? entries,
  }) => Counter(
    id: id,
    name: name ?? this.name, 
    icon: icon ?? this.icon,
    entries: entries ?? this.entries
  );

}