// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

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

  @override
  String get user => 'प्रयोगकर्ता';

  @override
  String get member => 'सदस्य';

  @override
  String get members => 'सदस्यहरू';

  @override
  String get workspaces => 'कार्यस्थानहरू';

  @override
  String get taskBoard => 'कार्य बोर्ड';

  @override
  String get notifications => 'सूचनाहरू';

  @override
  String get settings => 'सेटिङहरू';

  @override
  String get logout => 'लगआउट';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get create => 'सिर्जना गर्नुहोस्';

  @override
  String get addMember => 'सदस्य थप्नुहोस्';

  @override
  String get addMembers => 'सदस्यहरू थप्नुहोस्';

  @override
  String get viewMembers => 'सदस्यहरू हेर्नुहोस्';

  @override
  String get selectUser => 'प्रयोगकर्ता छान्नुहोस्';

  @override
  String get newWorkspace => 'नयाँ कार्यस्थान';

  @override
  String get workspaceName => 'कार्यस्थानको नाम';

  @override
  String get moveTaskTo => 'कार्य सार्नुहोस्...';

  @override
  String get inviteMemberDescription =>
      'यस कार्यस्थानमा आमन्त्रित गर्न प्रयोगकर्ता छान्नुहोस्।';

  @override
  String get waitForWorkspacesToLoad =>
      'कार्यस्थानहरू लोड हुन प्रतीक्षा गर्नुहोस्...';

  @override
  String get pleaseWaitForLoginToComplete =>
      'कृपया लगइन पूरा हुन प्रतीक्षा गर्नुहोस्...';

  @override
  String get stillSettingUpWorkspace =>
      'तपाईंको कार्यस्थान अझै सेटअप भइरहेको छ। कृपया एकछिनपछि फेरि प्रयास गर्नुहोस्।';

  @override
  String deleteWorkspaceTitle(Object name) {
    return '\"$name\" मेटाउने?';
  }

  @override
  String invitingUser(Object email) {
    return 'प्रयोगकर्ता $email लाई आमन्त्रित गर्दै...';
  }

  @override
  String get deleteWorkspace => 'कार्यस्थान मेटाउनुहोस्';

  @override
  String get areYouSureDeleteWorkspace =>
      'यसले कार्यस्थान र यसका सबै कार्यहरू स्थायी रूपमा हटाउनेछ। यो कार्य फिर्ता गर्न सकिँदैन।';

  @override
  String get workspaceDeleted => 'कार्यस्थान मेटाइयो';

  @override
  String get noTasksHere => 'यहाँ कुनै कार्य छैन';

  @override
  String get noMembersHere => 'अहिलेसम्म कुनै सदस्य छैन';

  @override
  String get noUsersAvailable => 'प्रयोगकर्ता उपलब्ध छैनन्';

  @override
  String get memberAdded => 'सदस्य थपियो';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get updatePersonalInfo => 'Update your personal info';

  @override
  String get security => 'Security';

  @override
  String get passwordAndBiometric => 'Password and biometric';

  @override
  String get notificationsPreferencesAndAlerts => 'Preferences and alerts';

  @override
  String get preferences => 'Preferences';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get nepali => 'Nepali (नेपाली)';

  @override
  String get german => 'German (Deutsch)';

  @override
  String get french => 'French (Français)';

  @override
  String get spanish => 'Spanish (Español)';

  @override
  String get appSettings => 'App Settings';

  @override
  String get autoSync => 'Auto-sync';

  @override
  String get keepDataUpdated => 'Keep data updated in real-time';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get softVibrations => 'Soft vibrations on interactions';

  @override
  String get logoutAccount => 'Logout Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get todo => 'गर्नु पर्ने';

  @override
  String get inProgress => 'प्रगतिमा';

  @override
  String get done => 'समाप्त';
}
