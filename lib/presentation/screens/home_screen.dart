
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Bienvenido, Danilo', style: TextStyle(color: colors.onPrimary, fontSize: 25, fontWeight: FontWeight.w500),),
        backgroundColor: colors.primary,
      ),
      body: const _HomeView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create-counter');
        },
        backgroundColor: colors.primary,
        child: Icon(Icons.add, color: colors.onPrimary, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _HomeView extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(countersProvider);
    final incrementFunction = ref.watch(countersProvider.notifier).increment;

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: counters.when(
        data: (data) {
          return ListView.builder(
            
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return Text('Tus contadores:', style: textTheme.titleLarge, textAlign: TextAlign.start,);
              final currentCounter = data[index - 1];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: CounterCard(counter: currentCounter, incrementFunction: incrementFunction)
              );
            },
          );
        }, 
        error: (err, stackTrace) => Center(child: Text('Error: $err'),), 
        loading: () => const CircularProgressIndicator()
      ),
    );
  }
}
