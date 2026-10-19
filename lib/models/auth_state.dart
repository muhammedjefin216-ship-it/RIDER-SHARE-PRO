class AuthState {
  final bool isRegistering;
  final bool isVerifying;
  final bool isResending;
  final bool isLoggingIn;
  final bool isGoogleSigningIn;
  final bool isCheckingSession;

  final bool isSendingForgotOtp;
  final bool isVerifyingForgotOtp;
  final bool isResettingPassword;
  final bool forgotOtpVerified;

  final bool isLoadingUser;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhoto;
  final double? userRating;
  final int? userTotalRatings;

  // Added to match User.js schema — used by the Profile screen
  final String? userPhone;
  final String? userGender;
  final String? userLocation;
  final String? userEmergencyContact;
  final bool? userIsVerified;
  final bool? userIsEmailVerified;
  final String? userAuthProvider;

  final String? errorMessage;

  const AuthState({
    this.isRegistering = false,
    this.isVerifying = false,
    this.isResending = false,
    this.isLoggingIn = false,
    this.isGoogleSigningIn = false,
    this.isCheckingSession = false,
    this.isSendingForgotOtp = false,
    this.isVerifyingForgotOtp = false,
    this.isResettingPassword = false,
    this.forgotOtpVerified = false,
    this.isLoadingUser = false,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhoto,
    this.userRating,
    this.userTotalRatings,
    this.userPhone,
    this.userGender,
    this.userLocation,
    this.userEmergencyContact,
    this.userIsVerified,
    this.userIsEmailVerified,
    this.userAuthProvider,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isRegistering,
    bool? isVerifying,
    bool? isResending,
    bool? isLoggingIn,
    bool? isGoogleSigningIn,
    bool? isCheckingSession,
    bool? isSendingForgotOtp,
    bool? isVerifyingForgotOtp,
    bool? isResettingPassword,
    bool? forgotOtpVerified,
    bool? isLoadingUser,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhoto,
    double? userRating,
    int? userTotalRatings,
    String? userPhone,
    String? userGender,
    String? userLocation,
    String? userEmergencyContact,
    bool? userIsVerified,
    bool? userIsEmailVerified,
    String? userAuthProvider,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isRegistering: isRegistering ?? this.isRegistering,
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      isGoogleSigningIn: isGoogleSigningIn ?? this.isGoogleSigningIn,
      isCheckingSession: isCheckingSession ?? this.isCheckingSession,
      isSendingForgotOtp: isSendingForgotOtp ?? this.isSendingForgotOtp,
      isVerifyingForgotOtp:
          isVerifyingForgotOtp ?? this.isVerifyingForgotOtp,
      isResettingPassword:
          isResettingPassword ?? this.isResettingPassword,
      forgotOtpVerified: forgotOtpVerified ?? this.forgotOtpVerified,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhoto: userPhoto ?? this.userPhoto,
      userRating: userRating ?? this.userRating,
      userTotalRatings: userTotalRatings ?? this.userTotalRatings,
      userPhone: userPhone ?? this.userPhone,
      userGender: userGender ?? this.userGender,
      userLocation: userLocation ?? this.userLocation,
      userEmergencyContact: userEmergencyContact ?? this.userEmergencyContact,
      userIsVerified: userIsVerified ?? this.userIsVerified,
      userIsEmailVerified: userIsEmailVerified ?? this.userIsEmailVerified,
      userAuthProvider: userAuthProvider ?? this.userAuthProvider,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}