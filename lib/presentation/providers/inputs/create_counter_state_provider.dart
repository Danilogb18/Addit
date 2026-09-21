import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_counter_state_provider.g.dart';


class CreateCounterFormState {

  final String name;
  final String icon;
  final String? nameError;
  final String? description;

  CreateCounterFormState({
    required this.name, 
    required this.icon,
    this.nameError, 
    this.description
  });

  bool get isValid {
    return nameError == null;
  }

  CreateCounterFormState copyWith ({
    String? name,
    String? icon,
    String? nameError,
    String? description
  }) => CreateCounterFormState(
    name: name ?? this.name, 
    icon: icon ?? this.icon,
    nameError: nameError, 
    description: description
  );

}


@riverpod
class CreateCounterStateProvider extends _$CreateCounterStateProvider {

  @override
  CreateCounterFormState build() => CreateCounterFormState(name: '', icon: '💯​'); //* Emoji por defecto

  void nameChanged (String value) {
    String? error;
    if (value.isEmpty || value.trim().isEmpty) error = 'Campo obligatorio';
    state = state.copyWith(name: value, nameError: error);
  }

  void iconChanged (String value) {
    // No hay que validar nada, siempre va a haber un ícono escogido por defecto
    state = state.copyWith(icon: value);
  }

  bool validateForm () {
    nameChanged(state.name); 
    return state.isValid;
  }

}