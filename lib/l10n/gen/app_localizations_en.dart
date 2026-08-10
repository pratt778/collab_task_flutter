// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CollabTask';

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
  String get user => 'User';

  @override
  String get member => 'Member';

  @override
  String get members => 'Members';

  @override
  String get workspaces => 'Workspaces';

  @override
  String get taskBoard => 'Task Board';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get delete => 'Delete';

  @override
  String get create => 'Create';

  @override
  String get addMember => 'Add Member';

  @override
  String get addMembers => 'Add Members';

  @override
  String get viewMembers => 'View Members';

  @override
  String get selectUser => 'Select User';

  @override
  String get newWorkspace => 'New Workspace';

  @override
  String get workspaceName => 'Workspace Name';

  @override
  String get moveTaskTo => 'Move task to...';

  @override
  String get inviteMemberDescription =>
      'Select a user to invite to this workspace.';

  @override
  String get waitForWorkspacesToLoad => 'Wait for workspaces to load...';

  @override
  String get pleaseWaitForLoginToComplete =>
      'Please wait for login to complete...';

  @override
  String get stillSettingUpWorkspace =>
      'Still setting up your workspace. Please try in a second.';

  @override
  String deleteWorkspaceTitle(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String invitingUser(Object email) {
    return 'Inviting $email...';
  }

  @override
  String get deleteWorkspace => 'Delete Workspace';

  @override
  String get areYouSureDeleteWorkspace =>
      'This will permanently remove the workspace and all its tasks. This action cannot be undone.';

  @override
  String get workspaceDeleted => 'Workspace deleted';

  @override
  String get noTasksHere => 'No tasks here';

  @override
  String get noMembersHere => 'No members yet';

  @override
  String get noUsersAvailable => 'No users available';

  @override
  String get memberAdded => 'Member added';

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
  String get todo => 'To Do';

  @override
  String get inProgress => 'In Progress';

  @override
  String get done => 'Done';
}
