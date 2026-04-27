// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter Clean Starter';

  @override
  String get hello => 'Hello';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get enterToYourAccount => 'Enter to your account';

  @override
  String get logIn => 'Log in';

  @override
  String get logOut => 'Log out';

  @override
  String get login => 'Login';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get customerId => 'Customer Id';

  @override
  String get customerIdHint => 'customer-1@example';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '98XXXXXXXX';

  @override
  String get pleaseEnterCustomerId => 'Please enter customer id';

  @override
  String get pleaseEnterValidCustomerId => 'Please enter valid customer id';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter valid phone number';

  @override
  String get networkRestored => 'Network restored. Refreshing data...';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get errNoInternet =>
      'Please check your internet connection and try again.';

  @override
  String get errTimeout =>
      'The server is taking longer than usual. Please try again.';

  @override
  String get errServer =>
      'Something went wrong on our end. Please try again in a moment.';

  @override
  String get errAuth =>
      'Sign-in failed. Please check your details and try again.';

  @override
  String get errSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errCache => 'Couldn\'t load saved data. Try refreshing.';

  @override
  String get errUnexpected =>
      'Something unexpected happened. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get errorPageAppBar => 'Error';

  @override
  String get pageNotFoundAppBar => 'Page Not Found';

  @override
  String get notFoundDescription =>
      'The page you are looking for does not exist.';

  @override
  String get unauthorizedAppBar => 'Unauthorized';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get unauthorizedMessage =>
      'You are not authorized to access this page. Please log in again.';

  @override
  String get a11yBack => 'Back';
}
