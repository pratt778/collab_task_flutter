// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'CollabTask';

  @override
  String get hello => 'Hallo';

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get enterToYourAccount => 'Melden Sie sich an Ihrem Konto an';

  @override
  String get logIn => 'Anmelden';

  @override
  String get logOut => 'Abmelden';

  @override
  String get login => 'Anmeldung';

  @override
  String get loginSuccessful => 'Anmeldung erfolgreich';

  @override
  String get loggedOutSuccessfully => 'Erfolgreich abgemeldet';

  @override
  String get customerId => 'Kunden-ID';

  @override
  String get customerIdHint => 'customer-1@example';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get phoneNumberHint => '98XXXXXXXX';

  @override
  String get pleaseEnterCustomerId => 'Bitte geben Sie die Kunden-ID ein';

  @override
  String get pleaseEnterValidCustomerId =>
      'Bitte geben Sie eine gültige Kunden-ID ein';

  @override
  String get pleaseEnterPhoneNumber => 'Bitte geben Sie die Telefonnummer ein';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Bitte geben Sie eine gültige Telefonnummer ein';

  @override
  String get networkRestored =>
      'Netzwerk wiederhergestellt. Daten werden aktualisiert...';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get errNoInternet =>
      'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get errTimeout =>
      'Der Server benötigt länger als gewöhnlich. Bitte versuchen Sie es erneut.';

  @override
  String get errServer =>
      'Auf unserer Seite ist ein Fehler aufgetreten. Bitte versuchen Sie es in einem Moment erneut.';

  @override
  String get errAuth =>
      'Anmeldung fehlgeschlagen. Bitte überprüfen Sie Ihre Daten und versuchen Sie es erneut.';

  @override
  String get errSessionExpired =>
      'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.';

  @override
  String get errCache =>
      'Gespeicherte Daten konnten nicht geladen werden. Versuchen Sie zu aktualisieren.';

  @override
  String get errUnexpected =>
      'Etwas Unerwartetes ist passiert. Bitte versuchen Sie es erneut.';

  @override
  String get retry => 'Wiederholen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get goToHome => 'Zur Startseite';

  @override
  String get goToLogin => 'Zur Anmeldung';

  @override
  String get errorPageAppBar => 'Fehler';

  @override
  String get pageNotFoundAppBar => 'Seite nicht gefunden';

  @override
  String get notFoundDescription =>
      'Die Seite, die Sie suchen, existiert nicht.';

  @override
  String get unauthorizedAppBar => 'Nicht autorisiert';

  @override
  String get accessDenied => 'Zugriff verweigert';

  @override
  String get unauthorizedMessage =>
      'Sie sind nicht autorisiert, auf diese Seite zuzugreifen. Bitte melden Sie sich erneut an.';

  @override
  String get a11yBack => 'Zurück';

  @override
  String get user => 'Benutzer';

  @override
  String get member => 'Mitglied';

  @override
  String get members => 'Mitglieder';

  @override
  String get workspaces => 'Arbeitsbereiche';

  @override
  String get taskBoard => 'Aufgaben-Board';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get delete => 'Löschen';

  @override
  String get create => 'Erstellen';

  @override
  String get addMember => 'Mitglied hinzufügen';

  @override
  String get addMembers => 'Mitglieder hinzufügen';

  @override
  String get viewMembers => 'Mitglieder anzeigen';

  @override
  String get selectUser => 'Benutzer auswählen';

  @override
  String get newWorkspace => 'Neuer Arbeitsbereich';

  @override
  String get workspaceName => 'Name des Arbeitsbereichs';

  @override
  String get moveTaskTo => 'Aufgabe verschieben zu...';

  @override
  String get inviteMemberDescription =>
      'Wählen Sie einen Benutzer aus, den Sie zu diesem Arbeitsbereich einladen möchten.';

  @override
  String get waitForWorkspacesToLoad =>
      'Warten Sie, bis die Arbeitsbereiche geladen sind...';

  @override
  String get pleaseWaitForLoginToComplete =>
      'Bitte warten Sie, bis die Anmeldung abgeschlossen ist...';

  @override
  String get stillSettingUpWorkspace =>
      'Ihr Arbeitsbereich wird noch eingerichtet. Bitte versuchen Sie es in einer Sekunde erneut.';

  @override
  String deleteWorkspaceTitle(Object name) {
    return '\"$name\" löschen?';
  }

  @override
  String invitingUser(Object email) {
    return 'Lade $email ein...';
  }

  @override
  String get deleteWorkspace => 'Arbeitsbereich löschen';

  @override
  String get areYouSureDeleteWorkspace =>
      'Dies löscht den Arbeitsbereich und alle Aufgaben dauerhaft. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get workspaceDeleted => 'Arbeitsbereich gelöscht';

  @override
  String get noTasksHere => 'Keine Aufgaben hier';

  @override
  String get noMembersHere => 'Noch keine Mitglieder';

  @override
  String get noUsersAvailable => 'Keine Benutzer verfügbar';

  @override
  String get memberAdded => 'Mitglied hinzugefügt';

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
  String get notificationsPreferencesAndAlerts =>
      'Einstellungen und Benachrichtigungen';

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
  String get todo => 'Zu erledigen';

  @override
  String get inProgress => 'In Bearbeitung';

  @override
  String get done => 'Erledigt';
}
