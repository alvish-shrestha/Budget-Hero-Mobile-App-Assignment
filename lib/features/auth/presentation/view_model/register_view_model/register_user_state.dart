class RegisterUserState {
  final bool isLoading;
  final bool isSuccess;

  const RegisterUserState({required this.isLoading, required this.isSuccess});

  const RegisterUserState.initial() : isLoading = false, isSuccess = false;

  RegisterUserState copyWith({bool? isLoading, bool? isSuccess}) {
    return RegisterUserState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
