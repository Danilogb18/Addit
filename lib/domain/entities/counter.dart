
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
    String? description,
    List<CounterEntry>? entries,
  }) => Counter(
    id: id,
    name: name ?? this.name, 
    description: description ?? this.description,
    icon: icon ?? this.icon,
    entries: entries ?? this.entries
  );

    List<CounterEntry> get entriesByDateDesc => [...entries]..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    CounterEntry? get latestEntry {
      if (entries.isEmpty) return null;
      return entries.reduce((a, b) => a.dateTime.isAfter(b.dateTime) ? a : b);
    }

}