
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:addit/presentation/widgets/widgets.dart';
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/providers/inputs/create_counter_state_provider.dart';

class CreateCounterScreen extends StatelessWidget {


  const CreateCounterScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu contador'),
      ),
      body: const _CreateCounterView(),
    );
  }
}

class _CreateCounterView extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formStateNotifier = ref.watch(createCounterStateProviderProvider(null).notifier);
    final formState = ref.watch(createCounterStateProviderProvider(null));



    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconDisplay(textTheme: textTheme, icon: formState.icon, iconChanged: formStateNotifier.iconChanged,),
              
              Text('Nombre', style: textTheme.titleMedium,),
              const SizedBox(height: 10,),
              CustomTextFormField(
                maxLength: 40, 
                onChanged: (value) => formStateNotifier.nameChanged(value),
                error: formState.nameError,
              ),
              const SizedBox(height: 20,),
              Text('Descripción (opcional)', style: textTheme.titleMedium,),
              const SizedBox(height: 10,),
              CustomTextFormField(
                maxLength: 300,
                onChanged: (value) => formStateNotifier.descriptionChanged(value),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))),
                  onPressed: () async {
                    final isValid = formStateNotifier.validateForm();
                    if (!isValid) return;
                    await ref.read(countersProvider.notifier).createCounter(formState.name, formState.icon, [], formState.description);
                    if (!context.mounted) return;
                    context.pop();
                  }, 
                  child: const Text('Crear')
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
