import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/base_error.dart';
import '../../../my_tasks/models/my_todo_model.dart';
import '../../model/user_profile_model.dart';
import '../../repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<GetRandomTodoEvent>((event, emit) async {
      emit(ProfileLoading());
      final successOrFailure = await _profileRepository.getRandomTodo();
      successOrFailure.fold(
        (error) => emit(ProfileGetRandomTodoFailed(error)),
        (randomTodo) => emit(ProfileGetRandomTodoSuccess(randomTodo)),
      );
    });

    on<ProfileGetCurrentUserEvent>((event, emit) async {
      emit(ProfileLoading());

      final successOrFailuer =
          await _profileRepository.getCurrentUser(event.token);

      successOrFailuer.fold((error) {
        emit(ProfileGetUserFailed(error));
      }, (user) async {
        emit(ProfileGetUserSuccess(user));
      });
    });
  }
}
