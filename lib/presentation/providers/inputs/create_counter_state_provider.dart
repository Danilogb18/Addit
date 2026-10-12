import 'package:addit/domain/entities/counter.dart';
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
    nameError: nameError ?? this.nameError, 
    description: description ?? this.description
  );

}


@riverpod
class CreateCounterStateProvider extends _$CreateCounterStateProvider {

  @override
  CreateCounterFormState build(Counter? counter) =>
   CreateCounterFormState(
    name: counter?.name ?? '', 
    description: counter?.description ?? '',
    icon: counter?.icon ?? '💯​'
  ); //* Emoji por defecto

  void nameChanged (String value) {
    final error = value.trim().isEmpty ? 'Campo obligatorio' : null;
    state = CreateCounterFormState( // en este caso uso constructor en vez del copywith porque si el error es nulo, el copywith detecta como que no lo enviaron y no sobreescribe el error anterior. aqui es mas explicito
      name: value,
      icon: state.icon,
      description: state.description,
      nameError: error,
    );
  }

  void descriptionChanged (String value) {
    state = state.copyWith(description: value);
  }

  void iconChanged (String value) {
    // No hay que validar nada, siempre va a haber un ícono escogido por defecto
    state = state.copyWith(icon: value);
  }


  bool validateForm () {
    nameChanged(state.name); 
    print(state.nameError);
    return state.isValid;
  }

}