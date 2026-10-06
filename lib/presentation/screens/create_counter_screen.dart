
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/providers/inputs/create_counter_state_provider.dart';
import 'package:addit/presentation/widgets/widgets.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateCounterScreen extends StatelessWidget {
  const new({super.key});

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
    final formStateNotifier = ref.watch(createCounterStateProviderProvider.notifier);
    final formState = ref.watch(createCounterStateProviderProvider);



    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconDisplay(textTheme: textTheme, ref: ref,),
              
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
              const CustomTextFormField(maxLength: 300,),
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

class _IconDisplay extends StatelessWidget {
  const new({
    required this.textTheme,
    required this.ref
  });

  final TextTheme textTheme;
  final WidgetRef ref;

  void _openEmojiPicker(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              color: scaffoldColor
            ),
            child: SafeArea(
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  ref.read(createCounterStateProviderProvider.notifier).iconChanged(emoji.emoji);
                  Navigator.pop(context); // cierra el bottom sheet
                },
                config: Config(
                  height: MediaQuery.of(context).size.height * 0.6,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 28,
                    backgroundColor: scaffoldColor,
                    
                  ),
                  searchViewConfig: SearchViewConfig(
                    backgroundColor: scaffoldColor,
                    buttonIconColor: colors.primary
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: scaffoldColor,
                    buttonColor: colors.primary,
                    buttonIconColor: colors.onPrimary
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: colors.surfaceBright,
                    iconColor: colors.onSurface,
                    iconColorSelected: colors.primary,
                    indicatorColor: colors.primary,
                  ),

                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final icon = ref.watch(createCounterStateProviderProvider).icon;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Align(
          alignment: AlignmentGeometry.center,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
              )
            ),
            child: GestureDetector(
              onTap: () => _openEmojiPicker(context),
              child: CircleAvatar(
                radius: 50, 
                backgroundColor: colors.surfaceBright,

                child: Text(icon, style: textTheme.displayLarge,), 
              ),
            )
          ),
        ),
        Align(
          alignment: AlignmentGeometry.center,
          child: TextButton(
            onPressed: () => _openEmojiPicker(context),
            child: const Text('Cambiar ícono')
          ),
        ),
      ],
    );
  }
}