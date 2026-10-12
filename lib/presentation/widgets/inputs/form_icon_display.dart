import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class IconDisplay extends StatelessWidget {

  final String icon;
  final void Function(String) iconChanged;
  final TextTheme textTheme;

  const IconDisplay({
    super.key,
    required this.textTheme,
    required this.icon,
    required this.iconChanged
  });


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
                  iconChanged(emoji.emoji);
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