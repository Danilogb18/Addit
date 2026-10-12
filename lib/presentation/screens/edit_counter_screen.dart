
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/presentation/providers/counters/counter_by_id_provider.dart';
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/providers/inputs/create_counter_state_provider.dart';
import 'package:addit/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCounterScreen extends StatelessWidget {

  final String id;

  const EditCounterScreen({
    required this.id,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar contador'),
      ),
      body: _EditCounterView(id: id,),
    );
  }
}

class _EditCounterView extends ConsumerWidget {

  final String id;

  const _EditCounterView({
    required this.id
  });


  Future<void> _mostrarDialogo(BuildContext context, WidgetRef ref, Counter counter) async {
    final bool? confirmado = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // no se cierra al tocar fuera
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar contador'),
          content: const Text('¿Seguro que quieres eliminarlo? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      deleteCounter(context, ref, counter);
    } else {
      debugPrint('El usuario canceló o cerró el diálogo');
    }
  }

  void deleteCounter (BuildContext context, WidgetRef ref, Counter counter) {
    ref.read(countersProvider.notifier).deleteCounter(counter);
    if (!context.mounted) return;
    context.go('/');
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final counterToEdit = ref.watch(getCounterByIdProvider(id));
    final formStateNotifier = ref.watch(createCounterStateProviderProvider(counterToEdit).notifier);
    final formState = ref.watch(createCounterStateProviderProvider(counterToEdit));

    final colors = Theme.of(context).colorScheme;

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
                initialValue: counterToEdit?.name,
                maxLength: 40, 
                onChanged: (value) => formStateNotifier.nameChanged(value),
                error: formState.nameError,
              ),
              const SizedBox(height: 20,),
              Text('Descripción (opcional)', style: textTheme.titleMedium,),
              const SizedBox(height: 10,),
              CustomTextFormField(
                initialValue: counterToEdit?.description,
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
                    await ref.read(countersProvider.notifier).editCounter(id, formState.name, formState.icon, counterToEdit?.entries ?? [], formState.description);
                    if (!context.mounted) return;
                    context.pop();
                  }, 
                  child: const Text('Actualizar')
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: colors.errorContainer, foregroundColor: colors.onErrorContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))),
                  onPressed: () async {
                    await _mostrarDialogo(context, ref, counterToEdit!);
                  }, 
                  child: const Text('Borrar contador')
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}