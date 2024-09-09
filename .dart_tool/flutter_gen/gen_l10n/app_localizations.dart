import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ChatAPP'**
  String get welcome;

  /// No description provided for @login_content.
  ///
  /// In en, this message translates to:
  /// **'Log in now to explore features and connect with friends.'**
  String get login_content;

  /// No description provided for @forgotpass.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotpass;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get login_error;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @chatApp.
  ///
  /// In en, this message translates to:
  /// **'ChatApp'**
  String get chatApp;

  /// No description provided for @my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get my_account;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friend;

  /// No description provided for @invite_friend.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get invite_friend;

  /// No description provided for @night_mode.
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get night_mode;

  /// No description provided for @chat_setting.
  ///
  /// In en, this message translates to:
  /// **'Chat Settings'**
  String get chat_setting;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @welcome_chat.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ChatApp'**
  String get welcome_chat;

  /// No description provided for @welcome_content.
  ///
  /// In en, this message translates to:
  /// **'A messaging app that helps you protect your privacy with friends and organizations. Start chatting with your friends and organizations.'**
  String get welcome_content;

  /// No description provided for @create_chat.
  ///
  /// In en, this message translates to:
  /// **'Create Chat'**
  String get create_chat;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get delete_chat;

  /// No description provided for @selct_chat.
  ///
  /// In en, this message translates to:
  /// **'Select Multiple Chats'**
  String get selct_chat;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @auto_mode.
  ///
  /// In en, this message translates to:
  /// **'Auto Mode'**
  String get auto_mode;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get select;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @chat_delete.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete the chat with'**
  String get chat_delete;

  /// No description provided for @search_chat.
  ///
  /// In en, this message translates to:
  /// **'Search for chats, groups'**
  String get search_chat;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get recent;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @new_group.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get new_group;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @choose_member.
  ///
  /// In en, this message translates to:
  /// **'Choose Members'**
  String get choose_member;

  /// No description provided for @auto_delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Auto Delete Messages'**
  String get auto_delete_chat;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @auto_delete_chat_content.
  ///
  /// In en, this message translates to:
  /// **'Auto delete messages in this group for everyone after a period of time'**
  String get auto_delete_chat_content;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @auto_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Auto delete messages'**
  String get auto_delete_title;

  /// No description provided for @auto_delete_content.
  ///
  /// In en, this message translates to:
  /// **'Auto delete enabled for your convenience'**
  String get auto_delete_content;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @update_profile_content.
  ///
  /// In en, this message translates to:
  /// **'Updating your profile helps friends recognize you better.'**
  String get update_profile_content;

  /// No description provided for @person_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get person_information;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search_friend.
  ///
  /// In en, this message translates to:
  /// **'Search Friends'**
  String get search_friend;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @prieview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get prieview;

  /// No description provided for @mesage_text_size.
  ///
  /// In en, this message translates to:
  /// **'Message Text Size'**
  String get mesage_text_size;

  /// No description provided for @color_theme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get color_theme;

  /// No description provided for @chat_notification.
  ///
  /// In en, this message translates to:
  /// **'Chat Notifications'**
  String get chat_notification;

  /// No description provided for @notification_content.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications for new alerts'**
  String get notification_content;

  /// No description provided for @translate_mesages.
  ///
  /// In en, this message translates to:
  /// **'Translate Messages'**
  String get translate_mesages;

  /// No description provided for @translate_content.
  ///
  /// In en, this message translates to:
  /// **'Select the language you want to translate messages to'**
  String get translate_content;

  /// No description provided for @laguage_systems.
  ///
  /// In en, this message translates to:
  /// **'Language Systems'**
  String get laguage_systems;

  /// No description provided for @language_translate.
  ///
  /// In en, this message translates to:
  /// **'Language Translation'**
  String get language_translate;

  /// No description provided for @language_conttent.
  ///
  /// In en, this message translates to:
  /// **'Select the language you want to translate messages to'**
  String get language_conttent;

  /// No description provided for @type_a_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_a_message;

  /// No description provided for @no_message.
  ///
  /// In en, this message translates to:
  /// **'No messages in this chat.'**
  String get no_message;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Photos and Videos'**
  String get media;

  /// No description provided for @sharelink.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get sharelink;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @atuto_delete.
  ///
  /// In en, this message translates to:
  /// **'Auto Delete'**
  String get atuto_delete;

  /// No description provided for @clear_history.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clear_history;

  /// No description provided for @leave_group.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leave_group;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @recall.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get recall;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @multiple_select.
  ///
  /// In en, this message translates to:
  /// **'Multiple Select'**
  String get multiple_select;

  /// No description provided for @error_name.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get error_name;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Message list error notification'**
  String get error_message;

  /// No description provided for @error_file.
  ///
  /// In en, this message translates to:
  /// **'File error notification'**
  String get error_file;

  /// No description provided for @error_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Delete message error notification'**
  String get error_delete_message;

  /// No description provided for @error_login.
  ///
  /// In en, this message translates to:
  /// **'Login error notification'**
  String get error_login;

  /// No description provided for @file_notification.
  ///
  /// In en, this message translates to:
  /// **'File notification'**
  String get file_notification;

  /// No description provided for @error_image_video.
  ///
  /// In en, this message translates to:
  /// **'Only images or videos can be added separately'**
  String get error_image_video;

  /// No description provided for @error_update.
  ///
  /// In en, this message translates to:
  /// **'Only one video can be added'**
  String get error_update;

  /// No description provided for @add_friend_ss.
  ///
  /// In en, this message translates to:
  /// **'Became friends with!'**
  String get add_friend_ss;

  /// No description provided for @no_add_friend.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined!'**
  String get no_add_friend;

  /// No description provided for @no_access.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get no_access;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @enter_message.
  ///
  /// In en, this message translates to:
  /// **'Enter message'**
  String get enter_message;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @choose_mode.
  ///
  /// In en, this message translates to:
  /// **'Choose the interface mode that suits you'**
  String get choose_mode;

  /// No description provided for @delete_message.
  ///
  /// In en, this message translates to:
  /// **'Deleted the chat!'**
  String get delete_message;

  /// No description provided for @group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get group_name;

  /// No description provided for @error_api_no_connect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server, please check again.'**
  String get error_api_no_connect;

  /// No description provided for @unlock_friend.
  ///
  /// In en, this message translates to:
  /// **'Unlock sending\nfriend request'**
  String get unlock_friend;

  /// No description provided for @translater.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translater;

  /// No description provided for @admin_create.
  ///
  /// In en, this message translates to:
  /// **'Created the group'**
  String get admin_create;

  /// No description provided for @cancel_friend.
  ///
  /// In en, this message translates to:
  /// **'Cancel Friend'**
  String get cancel_friend;

  /// No description provided for @cancal_friend_with.
  ///
  /// In en, this message translates to:
  /// **'Cancel friend with'**
  String get cancal_friend_with;

  /// No description provided for @cancal_friend_ss.
  ///
  /// In en, this message translates to:
  /// **'Unfriended'**
  String get cancal_friend_ss;

  /// No description provided for @add_friend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get add_friend;

  /// No description provided for @leader.
  ///
  /// In en, this message translates to:
  /// **'Group Leader'**
  String get leader;

  /// No description provided for @add_member.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get add_member;

  /// No description provided for @friend_sent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friend_sent;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete_group.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get delete_group;

  /// No description provided for @leave_group_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave and delete this group chat on your side?'**
  String get leave_group_confirm;

  /// No description provided for @delete_group_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group chat?'**
  String get delete_group_confirm;

  /// No description provided for @add_account.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get add_account;

  /// No description provided for @you_sure_loguot.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get you_sure_loguot;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @user_name_empty.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get user_name_empty;

  /// No description provided for @email_empty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get email_empty;

  /// No description provided for @last_name_empty.
  ///
  /// In en, this message translates to:
  /// **'Last name cannot be empty'**
  String get last_name_empty;

  /// No description provided for @name_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get name_empty;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @select_filter.
  ///
  /// In en, this message translates to:
  /// **'Choose the job title you want to filter'**
  String get select_filter;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get status_active;

  /// No description provided for @status_deactive.
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get status_deactive;

  /// No description provided for @list_account.
  ///
  /// In en, this message translates to:
  /// **'Account List'**
  String get list_account;

  /// No description provided for @account_detail.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get account_detail;

  /// No description provided for @email_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get email_format;

  /// No description provided for @permission_successfully.
  ///
  /// In en, this message translates to:
  /// **'Permission changed successfully'**
  String get permission_successfully;

  /// No description provided for @status_successfully.
  ///
  /// In en, this message translates to:
  /// **'Status changed successfully'**
  String get status_successfully;

  /// No description provided for @lock_account.
  ///
  /// In en, this message translates to:
  /// **'Lock Account'**
  String get lock_account;

  /// No description provided for @unlock_account.
  ///
  /// In en, this message translates to:
  /// **'Unlock Account'**
  String get unlock_account;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @change_pass.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_pass;

  /// No description provided for @pass_old.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get pass_old;

  /// No description provided for @pass_new.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get pass_new;

  /// No description provided for @pass_new_en.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get pass_new_en;

  /// No description provided for @pass_validate.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters!'**
  String get pass_validate;

  /// No description provided for @pass_ss.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get pass_ss;

  /// No description provided for @pass_valiate_distinctive.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from old password!'**
  String get pass_valiate_distinctive;

  /// No description provided for @pass_valiate_overlap.
  ///
  /// In en, this message translates to:
  /// **'Re-entered password does not match the new password!'**
  String get pass_valiate_overlap;

  /// No description provided for @name_ss.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully!'**
  String get name_ss;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @photo_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Photo successfully saved to gallery!'**
  String get photo_saved_successfully;

  /// No description provided for @photo_saved_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the photo to the gallery.'**
  String get photo_saved_error;

  /// No description provided for @cancel_friend_send.
  ///
  /// In en, this message translates to:
  /// **'Friend request canceled with'**
  String get cancel_friend_send;

  /// No description provided for @is_typing.
  ///
  /// In en, this message translates to:
  /// **'is typing'**
  String get is_typing;

  /// No description provided for @file_size.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds 20 MB'**
  String get file_size;

  /// No description provided for @un_pin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get un_pin;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_nation.
  ///
  /// In en, this message translates to:
  /// **'Enter country name or code'**
  String get search_nation;

  /// No description provided for @pinned_message.
  ///
  /// In en, this message translates to:
  /// **'Pinned Message'**
  String get pinned_message;

  /// No description provided for @pin_list.
  ///
  /// In en, this message translates to:
  /// **'Pin List'**
  String get pin_list;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @back_login.
  ///
  /// In en, this message translates to:
  /// **'Account logged in on another device'**
  String get back_login;

  /// No description provided for @dont_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dont_account;

  /// No description provided for @sign_up_here.
  ///
  /// In en, this message translates to:
  /// **'Sign up here'**
  String get sign_up_here;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @we_code_phone.
  ///
  /// In en, this message translates to:
  /// **'We have sent you the phone code'**
  String get we_code_phone;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @information_join.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to join us'**
  String get information_join;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get enter_password;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @label_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get label_continue;

  /// No description provided for @phone_empty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phone_empty;

  /// No description provided for @password_empty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get password_empty;

  /// No description provided for @confirm_password_empty.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirm_password_empty;

  /// No description provided for @phone_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get phone_format;

  /// No description provided for @auto_delete.
  ///
  /// In en, this message translates to:
  /// **'Auto Delete'**
  String get auto_delete;

  /// No description provided for @otp_no_valid.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get otp_no_valid;

  /// No description provided for @enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enter_otp;

  /// No description provided for @phone_no_valid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number!'**
  String get phone_no_valid;

  /// No description provided for @forgot_pass.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_pass;

  /// No description provided for @forgot_pass_ct.
  ///
  /// In en, this message translates to:
  /// **'We will send you a link to the phone number you provided before.'**
  String get forgot_pass_ct;

  /// No description provided for @forgot_pas_phone.
  ///
  /// In en, this message translates to:
  /// **'We have sent you the code to the phone number'**
  String get forgot_pas_phone;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @phone_null.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phone_null;

  /// No description provided for @phone_valid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get phone_valid;

  /// No description provided for @pass_null.
  ///
  /// In en, this message translates to:
  /// **'Please enter password!'**
  String get pass_null;

  /// No description provided for @pass_re_null.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter password!'**
  String get pass_re_null;

  /// No description provided for @pass_reset_ss.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get pass_reset_ss;

  /// No description provided for @resgiter_ss.
  ///
  /// In en, this message translates to:
  /// **'Account registration successful!'**
  String get resgiter_ss;

  /// No description provided for @pass_no_joint.
  ///
  /// In en, this message translates to:
  /// **'Re-entered password does not match!'**
  String get pass_no_joint;

  /// No description provided for @last_seen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get last_seen;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @forward_from.
  ///
  /// In en, this message translates to:
  /// **'Forwarded from'**
  String get forward_from;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get edited;

  /// No description provided for @reset_pass.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_pass;

  /// No description provided for @reset_pass_ss.
  ///
  /// In en, this message translates to:
  /// **'Password reset to 123'**
  String get reset_pass_ss;

  /// No description provided for @file_not_supported.
  ///
  /// In en, this message translates to:
  /// **'File not supported'**
  String get file_not_supported;

  /// No description provided for @only_photo_video_file.
  ///
  /// In en, this message translates to:
  /// **'Only images or videos or files can be added separately'**
  String get only_photo_video_file;

  /// No description provided for @only_video.
  ///
  /// In en, this message translates to:
  /// **'Only one video can be added'**
  String get only_video;

  /// No description provided for @only_file.
  ///
  /// In en, this message translates to:
  /// **'Only one file can be added'**
  String get only_file;

  /// No description provided for @message_been_deleted.
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get message_been_deleted;

  /// No description provided for @back_lg.
  ///
  /// In en, this message translates to:
  /// **'Account logged in on another device'**
  String get back_lg;

  /// No description provided for @clear_history_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat history?'**
  String get clear_history_confirm;

  /// No description provided for @reset_password_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset this password?'**
  String get reset_password_confirm;

  /// No description provided for @unable_send.
  ///
  /// In en, this message translates to:
  /// **'Unable to send'**
  String get unable_send;

  /// No description provided for @label_welcome_web.
  ///
  /// In en, this message translates to:
  /// **'Login to ChatWEB'**
  String get label_welcome_web;

  /// No description provided for @label_des_scan_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code below to log in quickly and securely.'**
  String get label_des_scan_qr;

  /// No description provided for @label_use_app_scanning.
  ///
  /// In en, this message translates to:
  /// **'Use ChatAPP application to scan QR code'**
  String get label_use_app_scanning;

  /// No description provided for @label_welcome_web_2.
  ///
  /// In en, this message translates to:
  /// **'Log in now to use the explorer function and connect\nwith your friends.'**
  String get label_welcome_web_2;

  /// No description provided for @label_login_by_qr.
  ///
  /// In en, this message translates to:
  /// **'Login by QR-Code'**
  String get label_login_by_qr;

  /// No description provided for @label_error_username.
  ///
  /// In en, this message translates to:
  /// **'The account does not exist on the system.'**
  String get label_error_username;

  /// No description provided for @label_sent_link.
  ///
  /// In en, this message translates to:
  /// **'We’’ll send you a link to the phone number address you provided earlier.'**
  String get label_sent_link;

  /// No description provided for @label_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get label_back_to_login;

  /// No description provided for @label_verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get label_verify_otp;

  /// No description provided for @label_have_sent_code.
  ///
  /// In en, this message translates to:
  /// **'We have sent you a code to phone number '**
  String get label_have_sent_code;

  /// No description provided for @label_enter_otp_code.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code'**
  String get label_enter_otp_code;

  /// No description provided for @label_reset_password_des.
  ///
  /// In en, this message translates to:
  /// **'Ensure your password includes both uppercase and \nlowercase letters as well as numbers to protect your \naccount.'**
  String get label_reset_password_des;

  /// No description provided for @label_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get label_register;

  /// No description provided for @label_login_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Login By Phone Number'**
  String get label_login_phone_number;

  /// No description provided for @label_preview_chat_setting.
  ///
  /// In en, this message translates to:
  /// **'Choose the interface mode that suits you'**
  String get label_preview_chat_setting;

  /// No description provided for @label_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get label_apply;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
