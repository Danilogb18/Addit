
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
      appBar: CustomAppBar(title: 'Bienvenido, Danilo'),
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
  const _HomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(countersProvider);
    final incrementFunction = ref.watch(countersProvider.notifier).increment;

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: counters.when(
        data: (data) {
          if (data.isEmpty) return const Center(child: Text('Aún no has creado ningún contador'),);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tus contadores:', style: textTheme.titleLarge, textAlign: TextAlign.start,),
              
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final counter = data[index];
                    return CounterCard(counter: counter, incrementFunction: incrementFunction);
                  }, 
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(),
                  ), 
                  itemCount: data.length
                ),
              ),
              SizedBox(height: 100,)
            ],
          );
        }, 
        error: (err, stackTrace) => Center(child: Text('Error: $err'),), 
        loading: () => const CircularProgressIndicator()
      ),
    );
  }
}
