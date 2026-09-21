
import 'package:addit/domain/entities/counter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CounterCard extends StatelessWidget {

  final Counter counter;
  final Future<void> Function(String counterId) incrementFunction;

  const CounterCard({
    super.key, 
    required this.counter,
    required this.incrementFunction
  });

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20), // ** Esto debe matchear el border de la Card , que está en app_theme.dart
          onTap: () {
            context.push('counter/${counter.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(counter.icon, style: textTheme.displayLarge,),
                SizedBox(width: 20,),
                SizedBox(
                  width: size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(counter.name, style: textTheme.headlineSmall, overflow: TextOverflow.ellipsis,),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {}, 
                            icon: Icon(Icons.remove_circle_outline_outlined, size: 40, color: colors.primary,)
                          ),
                          Text('${counter.entries.length}', style: const TextStyle(fontSize: 60),),
                          IconButton(
                            onPressed: () async {
                              await incrementFunction(counter.id);
                            }, 
                            icon: Icon(Icons.add_circle_outline_outlined, size: 40, color: colors.primary,)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
