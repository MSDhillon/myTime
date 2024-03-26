class AuthenticationFailure {
  // Member variable to hold the error message
  final String message;

  // Default constructor - used if no specific message is provided
  const AuthenticationFailure([this.message = 'An error occurred.']);

  // Factory constructor - provides customization based on an error code
  factory AuthenticationFailure.code(String code) {
    switch(code){
      case 'weak-password' :
        return const AuthenticationFailure('Please input a stronger password.');
      case 'invalid-email' :
        return const AuthenticationFailure('Email is not valid');
      case 'existing-email' :
        return const AuthenticationFailure('Email already in use');
      case 'user-disabled' :
        return const AuthenticationFailure('This user has been disabled');
      default: return const AuthenticationFailure(); // Generic error
    }
  }
}
