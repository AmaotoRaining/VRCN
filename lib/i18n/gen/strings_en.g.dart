///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	@override late final _TranslationsTermsAgreementEn termsAgreement = _TranslationsTermsAgreementEn._(_root);
	@override late final _TranslationsDrawerEn drawer = _TranslationsDrawerEn._(_root);
	@override late final _TranslationsLoginEn login = _TranslationsLoginEn._(_root);
	@override late final _TranslationsFriendsEn friends = _TranslationsFriendsEn._(_root);
	@override late final _TranslationsFriendDetailEn friendDetail = _TranslationsFriendDetailEn._(_root);
	@override late final _TranslationsSearchEn search = _TranslationsSearchEn._(_root);
	@override late final _TranslationsProfileEn profile = _TranslationsProfileEn._(_root);
	@override late final _TranslationsEngageCardEn engageCard = _TranslationsEngageCardEn._(_root);
	@override late final _TranslationsQrScannerEn qrScanner = _TranslationsQrScannerEn._(_root);
	@override late final _TranslationsFavoritesEn favorites = _TranslationsFavoritesEn._(_root);
	@override late final _TranslationsNotificationsEn notifications = _TranslationsNotificationsEn._(_root);
	@override late final _TranslationsEventCalendarEn eventCalendar = _TranslationsEventCalendarEn._(_root);
	@override late final _TranslationsAvatarsEn avatars = _TranslationsAvatarsEn._(_root);
	@override late final _TranslationsWorldDetailEn worldDetail = _TranslationsWorldDetailEn._(_root);
	@override late final _TranslationsAvatarDetailEn avatarDetail = _TranslationsAvatarDetailEn._(_root);
	@override late final _TranslationsGroupsEn groups = _TranslationsGroupsEn._(_root);
	@override late final _TranslationsGroupDetailEn groupDetail = _TranslationsGroupDetailEn._(_root);
	@override late final _TranslationsInventoryEn inventory = _TranslationsInventoryEn._(_root);
	@override late final _TranslationsVrcnsyncEn vrcnsync = _TranslationsVrcnsyncEn._(_root);
	@override late final _TranslationsFeedbackEn feedback = _TranslationsFeedbackEn._(_root);
	@override late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(_root);
	@override late final _TranslationsCreditsEn credits = _TranslationsCreditsEn._(_root);
	@override late final _TranslationsDownloadEn download = _TranslationsDownloadEn._(_root);
	@override late final _TranslationsInstanceEn instance = _TranslationsInstanceEn._(_root);
	@override late final _TranslationsStatusEn status = _TranslationsStatusEn._(_root);
	@override late final _TranslationsLocationEn location = _TranslationsLocationEn._(_root);
	@override late final _TranslationsReminderEn reminder = _TranslationsReminderEn._(_root);
	@override late final _TranslationsFriendEn friend = _TranslationsFriendEn._(_root);
	@override late final _TranslationsEventCalendarFilterEn eventCalendarFilter = _TranslationsEventCalendarFilterEn._(_root);
}

// Path: common
class _TranslationsCommonEn implements TranslationsCommonJa {
	_TranslationsCommonEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCN';
	@override String get ok => 'OK';
	@override String get cancel => 'Cancel';
	@override String get close => 'Close';
	@override String get save => 'Save';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get yes => 'Yes';
	@override String get no => 'No';
	@override String get loading => 'Loading...';
	@override String error({required Object error}) => 'An error occurred: ${error}';
	@override String get errorNomessage => 'An error occurred';
	@override String get retry => 'Retry';
	@override String get search => 'Search';
	@override String get settings => 'Settings';
	@override String get confirm => 'Confirm';
	@override String get agree => 'Agree';
	@override String get decline => 'Decline';
	@override String get username => 'Username';
	@override String get password => 'Password';
	@override String get login => 'Login';
	@override String get logout => 'Logout';
	@override String get share => 'Share';
}

// Path: termsAgreement
class _TranslationsTermsAgreementEn implements TranslationsTermsAgreementJa {
	_TranslationsTermsAgreementEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'Welcome to VRCN';
	@override String get welcomeMessage => 'Before using the app,\nplease review the Terms of Service and Privacy Policy.';
	@override String get termsTitle => 'Terms of Service';
	@override String get termsSubtitle => 'About the conditions for using the app';
	@override String get privacyTitle => 'Privacy Policy';
	@override String get privacySubtitle => 'About the handling of personal information';
	@override String agreeTerms({required Object title}) => 'I agree to the "${title}"';
	@override String get checkContent => 'Check Content';
	@override String get notice => 'This is an unofficial app for VRChat Inc.\nIt is not affiliated with VRChat Inc. in any way.';
}

// Path: drawer
class _TranslationsDrawerEn implements TranslationsDrawerJa {
	_TranslationsDrawerEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get profile => 'Profile';
	@override String get favorite => 'Favorites';
	@override String get eventCalendar => 'Event Calendar';
	@override String get avatar => 'Avatars';
	@override String get group => 'Groups';
	@override String get inventory => 'Inventory';
	@override String get vrcnsync => 'VRCNSync (β)';
	@override String get review => 'Review';
	@override String get feedback => 'Feedback';
	@override String get settings => 'Settings';
	@override String get userLoading => 'Loading user information...';
	@override String get userError => 'Failed to load user information';
	@override String get retry => 'Retry';
	@override late final _TranslationsDrawerSectionEn section = _TranslationsDrawerSectionEn._(_root);
}

// Path: login
class _TranslationsLoginEn implements TranslationsLoginJa {
	_TranslationsLoginEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get forgotPassword => 'Forgot your password?';
	@override String get createAccount => 'Sign up';
	@override String get subtitle => 'Login with your VRChat account';
	@override String get email => 'Email Address';
	@override String get emailHint => 'Enter email or username';
	@override String get passwordHint => 'Enter password';
	@override String get rememberMe => 'Remember me';
	@override String get loggingIn => 'Logging in...';
	@override String get errorEmptyEmail => 'Please enter your username or email address.';
	@override String get errorEmptyPassword => 'Please enter your password.';
	@override String get errorLoginFailed => 'Login failed. Please check your email and password.';
	@override String get twoFactorTitle => 'Two-Factor Authentication';
	@override String get twoFactorSubtitle => 'Please enter the authentication code.';
	@override String get twoFactorInstruction => 'Enter the 6-digit code from\nyour authenticator app.';
	@override String get twoFactorCodeHint => 'Authentication code';
	@override String get verify => 'Verify';
	@override String get verifying => 'Verifying...';
	@override String get errorEmpty2fa => 'Please enter the authentication code.';
	@override String get error2faFailed => 'Two-factor authentication failed. Please check if the code is correct.';
	@override String get backToLogin => 'Back to login';
	@override String get paste => 'Paste';
}

// Path: friends
class _TranslationsFriendsEn implements TranslationsFriendsJa {
	_TranslationsFriendsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading friends list...';
	@override String error({required Object error}) => 'Failed to load friends list: ${error}';
	@override String get notFound => 'No friends found.';
	@override String get private => 'Private';
	@override String get active => 'Active';
	@override String get offline => 'Offline';
	@override String get online => 'Online';
	@override String get groupTitle => 'Group by World';
	@override String get refresh => 'Refresh';
	@override String get searchHint => 'Search by friend\'s name';
	@override String get noResult => 'No matching friends found.';
}

// Path: friendDetail
class _TranslationsFriendDetailEn implements TranslationsFriendDetailJa {
	_TranslationsFriendDetailEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading user information...';
	@override String error({required Object error}) => 'Failed to load user information: ${error}';
	@override String get currentLocation => 'Current Location';
	@override String get basicInfo => 'Basic Info';
	@override String get userId => 'User ID';
	@override String get dateJoined => 'Date Joined';
	@override String get lastLogin => 'Last Login';
	@override String get bio => 'Bio';
	@override String get links => 'Links';
	@override String get loadingLinks => 'Loading links...';
	@override String get group => 'Groups';
	@override String get groupDetail => 'View Group Details';
	@override String groupCode({required Object code}) => 'Group Code: ${code}';
	@override String memberCount({required Object count}) => 'Members: ${count}';
	@override String get unknownGroup => 'Unknown Group';
	@override String get block => 'Block';
	@override String get mute => 'Mute';
	@override String get openWebsite => 'Open on Website';
	@override String get shareProfile => 'Share Profile';
	@override String confirmBlockTitle({required Object name}) => 'Block ${name}?';
	@override String get confirmBlockMessage => 'If you block this user, you will no longer receive friend requests or messages from them.';
	@override String confirmMuteTitle({required Object name}) => 'Mute ${name}?';
	@override String get confirmMuteMessage => 'If you mute this user, you will no longer hear their voice.';
	@override String get blockSuccess => 'Blocked';
	@override String get muteSuccess => 'Muted';
	@override String operationFailed({required Object error}) => 'Operation failed: ${error}';
}

// Path: search
class _TranslationsSearchEn implements TranslationsSearchJa {
	_TranslationsSearchEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get userTab => 'Users';
	@override String get worldTab => 'Worlds';
	@override String get avatarTab => 'Avatars';
	@override String get groupTab => 'Groups';
	@override late final _TranslationsSearchTabsEn tabs = _TranslationsSearchTabsEn._(_root);
}

// Path: profile
class _TranslationsProfileEn implements TranslationsProfileJa {
	_TranslationsProfileEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Profile';
	@override String get edit => 'Edit';
	@override String get refresh => 'Refresh';
	@override String get loading => 'Loading profile information...';
	@override String get error => 'Failed to load profile information: {error}';
	@override String get displayName => 'Display Name';
	@override String get username => 'Username';
	@override String get userId => 'User ID';
	@override String get engageCard => 'Engage Card';
	@override String get frined => 'Friend';
	@override String get dateJoined => 'Date Joined';
	@override String get userType => 'User Type';
	@override String get status => 'Status';
	@override String get statusMessage => 'Status Message';
	@override String get bio => 'Bio';
	@override String get links => 'Links';
	@override String get group => 'Groups';
	@override String get groupDetail => 'View Group Details';
	@override String get avatar => 'Current Avatar';
	@override String get avatarDetail => 'View Avatar Details';
	@override String get public => 'Public';
	@override String get private => 'Private';
	@override String get hidden => 'Hidden';
	@override String get unknown => 'Unknown';
	@override String get friends => 'Friends';
	@override String get loadingLinks => 'Loading links...';
	@override String get noGroup => 'Not in any groups';
	@override String get noBio => 'No bio available';
	@override String get noLinks => 'No links available';
	@override String get save => 'Save Changes';
	@override String get saved => 'Profile updated successfully.';
	@override String get saveFailed => 'Failed to update: {error}';
	@override String get discardTitle => 'Discard changes?';
	@override String get discardContent => 'Changes made to your profile will not be saved.';
	@override String get discardCancel => 'Cancel';
	@override String get discardOk => 'Discard';
	@override String get basic => 'Basic Info';
	@override String get pronouns => 'Pronouns';
	@override String get addLink => 'Add';
	@override String get removeLink => 'Remove';
	@override String get linkHint => 'Enter link (e.g., https://twitter.com/username)';
	@override String get linksHint => 'Links will be displayed on your profile and can be opened by tapping.';
	@override String get statusMessageHint => 'Enter your current situation or a message.';
	@override String get bioHint => 'Write something about yourself.';
}

// Path: engageCard
class _TranslationsEngageCardEn implements TranslationsEngageCardJa {
	_TranslationsEngageCardEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get pickBackground => 'Select Background Image';
	@override String get removeBackground => 'Remove Background Image';
	@override String get scanQr => 'Scan QR Code';
	@override String get showAvatar => 'Show Avatar';
	@override String get hideAvatar => 'Hide Avatar';
	@override String get noBackground => 'No background image selected.\nYou can set one from the top right button.';
	@override String get loading => 'Loading...';
	@override String error({required Object error}) => 'Failed to load engage card information: ${error}';
	@override String get copyUserId => 'Copy User ID';
	@override String get copied => 'Copied';
}

// Path: qrScanner
class _TranslationsQrScannerEn implements TranslationsQrScannerJa {
	_TranslationsQrScannerEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'QR Code Scan';
	@override String get guide => 'Align the QR code within the frame.';
	@override String get loading => 'Initializing camera...';
	@override String error({required Object error}) => 'Failed to read QR code: ${error}';
	@override String get notFound => 'No valid user QR code found.';
}

// Path: favorites
class _TranslationsFavoritesEn implements TranslationsFavoritesJa {
	_TranslationsFavoritesEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Favorites';
	@override String get frined => 'Friend';
	@override String get friendsTab => 'Friends';
	@override String get worldsTab => 'Worlds';
	@override String get avatarsTab => 'Avatars';
	@override String get emptyFolderTitle => 'No favorite folders';
	@override String get emptyFolderDescription => 'Please create a favorite folder in VRChat.';
	@override String get emptyFriends => 'No friends in this folder.';
	@override String get emptyWorlds => 'No worlds in this folder.';
	@override String get emptyAvatars => 'No avatars in this folder.';
	@override String get emptyWorldsTabTitle => 'No favorite worlds';
	@override String get emptyWorldsTabDescription => 'You can add worlds to favorites from the world details screen.';
	@override String get emptyAvatarsTabTitle => 'No favorite avatars';
	@override String get emptyAvatarsTabDescription => 'You can add avatars to favorites from the avatar details screen.';
	@override String get loading => 'Loading favorites...';
	@override String get loadingFolder => 'Loading folder information...';
	@override String error({required Object error}) => 'Failed to load favorites: ${error}';
	@override String get errorFolder => 'Failed to get information.';
	@override String get remove => 'Remove from Favorites';
	@override String removeSuccess({required Object name}) => 'Removed ${name} from favorites.';
	@override String removeFailed({required Object error}) => 'Failed to remove: ${error}';
	@override String itemsCount({required Object count}) => '${count} items';
	@override String get public => 'Public';
	@override String get private => 'Private';
	@override String get hidden => 'Hidden';
	@override String get unknown => 'Unknown';
	@override String get loadingError => 'Loading Error';
}

// Path: notifications
class _TranslationsNotificationsEn implements TranslationsNotificationsJa {
	_TranslationsNotificationsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => 'No Notifications';
	@override String get emptyDescription => 'New notifications, like friend requests and invites,\nwill appear here.';
	@override String friendRequest({required Object userName}) => 'You have a friend request from ${userName}.';
	@override String invite({required Object worldName, required Object userName}) => 'You have an invite to ${worldName} from ${userName}.';
	@override String friendOnline({required Object userName}) => '${userName} is now online.';
	@override String friendOffline({required Object userName}) => '${userName} is now offline.';
	@override String friendActive({required Object userName}) => '${userName} is now active.';
	@override String friendAdd({required Object userName}) => '${userName} has been added to your friends.';
	@override String friendRemove({required Object userName}) => '${userName} has been removed from your friends.';
	@override String statusUpdate({required Object userName, required Object status, required Object world}) => '${userName}\'s status updated: ${status}${world}';
	@override String locationChange({required Object userName, required Object worldName}) => '${userName} moved to ${worldName}.';
	@override String userUpdate({required Object world}) => 'Your information has been updated${world}.';
	@override String myLocationChange({required Object worldName}) => 'You moved to: ${worldName}';
	@override String requestInvite({required Object userName}) => 'You have a request to join from ${userName}.';
	@override String votekick({required Object userName}) => 'There was a votekick from ${userName}.';
	@override String responseReceived({required Object userName}) => 'Received response for notification ID: ${userName}';
	@override String error({required Object worldName}) => 'Error: ${worldName}';
	@override String system({required Object extraData}) => 'System notification: ${extraData}';
	@override String secondsAgo({required Object seconds}) => '${seconds}s ago';
	@override String minutesAgo({required Object minutes}) => '${minutes}m ago';
	@override String hoursAgo({required Object hours}) => '${hours}h ago';
}

// Path: eventCalendar
class _TranslationsEventCalendarEn implements TranslationsEventCalendarJa {
	_TranslationsEventCalendarEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Event Calendar';
	@override String get filter => 'Filter Events';
	@override String get refresh => 'Refresh Events';
	@override String get loading => 'Loading events...';
	@override String error({required Object error}) => 'Failed to load events: ${error}';
	@override String filterActive({required Object count}) => 'Filter applied (${count} results)';
	@override String get clear => 'Clear';
	@override String get noEvents => 'No events match the criteria.';
	@override String get clearFilter => 'Clear Filter';
	@override String get today => 'Today';
	@override String get reminderSet => 'Set Reminder';
	@override String get reminderSetDone => 'Reminder Set';
	@override String get reminderDeleted => 'Reminder deleted.';
	@override String get eventName => 'Event Name';
	@override String get organizer => 'Organizer';
	@override String get description => 'Description';
	@override String get genre => 'Genre';
	@override String get condition => 'Participation Conditions';
	@override String get way => 'How to Join';
	@override String get note => 'Notes';
	@override String get quest => 'Quest Compatible';
	@override String reminderCount({required Object count}) => '${count}';
	@override String startToEnd({required Object start, required Object end}) => '${start} - ${end}';
}

// Path: avatars
class _TranslationsAvatarsEn implements TranslationsAvatarsJa {
	_TranslationsAvatarsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Avatars';
	@override String get searchHint => 'Search by avatar name, etc.';
	@override String get searchTooltip => 'Search';
	@override String get searchEmptyTitle => 'No search results found.';
	@override String get searchEmptyDescription => 'Please try a different search term.';
	@override String get emptyTitle => 'No avatars';
	@override String get emptyDescription => 'Please add an avatar or try again later.';
	@override String get refresh => 'Refresh';
	@override String get loading => 'Loading avatars...';
	@override String error({required Object error}) => 'Failed to load avatars: ${error}';
	@override String get current => 'In Use';
	@override String get public => 'Public';
	@override String get private => 'Private';
	@override String get hidden => 'Hidden';
	@override String get author => 'Author';
	@override String get sortUpdated => 'By Update Date';
	@override String get sortName => 'By Name';
	@override String get sortTooltip => 'Sort';
	@override String get viewModeTooltip => 'Toggle View Mode';
}

// Path: worldDetail
class _TranslationsWorldDetailEn implements TranslationsWorldDetailJa {
	_TranslationsWorldDetailEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading world information...';
	@override String error({required Object error}) => 'Failed to load world information: ${error}';
	@override String get share => 'Share This World';
	@override String get openInVRChat => 'Open on VRChat Official Website';
	@override String get report => 'Report This World';
	@override String get creator => 'Creator';
	@override String get created => 'Created';
	@override String get updated => 'Updated';
	@override String get favorites => 'Favorites';
	@override String get visits => 'Visits';
	@override String get occupants => 'Current Occupants';
	@override String get popularity => 'Popularity';
	@override String get description => 'Description';
	@override String get noDescription => 'No description available.';
	@override String get tags => 'Tags';
	@override String get joinPublic => 'Send Invite to Public Instance';
	@override String get favoriteAdded => 'Added to favorites.';
	@override String get favoriteRemoved => 'Removed from favorites.';
	@override String get unknown => 'Unknown';
}

// Path: avatarDetail
class _TranslationsAvatarDetailEn implements TranslationsAvatarDetailJa {
	_TranslationsAvatarDetailEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String changeSuccess({required Object name}) => 'Changed to avatar "${name}".';
	@override String changeFailed({required Object error}) => 'Failed to change avatar: ${error}';
	@override String get changing => 'Changing...';
	@override String get useThisAvatar => 'Use This Avatar';
	@override String get creator => 'Creator';
	@override String get created => 'Created';
	@override String get updated => 'Updated';
	@override String get description => 'Description';
	@override String get noDescription => 'No description available.';
	@override String get tags => 'Tags';
	@override String get addToFavorites => 'Add to Favorites';
	@override String get public => 'Public';
	@override String get private => 'Private';
	@override String get hidden => 'Hidden';
	@override String get unknown => 'Unknown';
	@override String get share => 'Share';
	@override String get loading => 'Loading avatar information...';
	@override String error({required Object error}) => 'Failed to load avatar information: ${error}';
}

// Path: groups
class _TranslationsGroupsEn implements TranslationsGroupsJa {
	_TranslationsGroupsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Groups';
	@override String get loadingUser => 'Loading user information...';
	@override String errorUser({required Object error}) => 'Failed to load user information: ${error}';
	@override String get loadingGroups => 'Loading group information...';
	@override String errorGroups({required Object error}) => 'Failed to load group information: ${error}';
	@override String get emptyTitle => 'You are not in any groups.';
	@override String get emptyDescription => 'You can join groups from the VRChat app or website.';
	@override String get searchGroups => 'Find Groups';
	@override String members({required Object count}) => '${count} members';
	@override String get showDetails => 'Show Details';
	@override String get unknownName => 'Unknown Name';
}

// Path: groupDetail
class _TranslationsGroupDetailEn implements TranslationsGroupDetailJa {
	_TranslationsGroupDetailEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading group information...';
	@override String error({required Object error}) => 'Failed to load group information: ${error}';
	@override String get share => 'Share Group Info';
	@override String get description => 'Description';
	@override String get roles => 'Roles';
	@override String get basicInfo => 'Basic Info';
	@override String get createdAt => 'Created At';
	@override String get owner => 'Owner';
	@override String get rules => 'Rules';
	@override String get languages => 'Languages';
	@override String memberCount({required Object count}) => '${count} Members';
	@override late final _TranslationsGroupDetailPrivacyEn privacy = _TranslationsGroupDetailPrivacyEn._(_root);
	@override late final _TranslationsGroupDetailRoleEn role = _TranslationsGroupDetailRoleEn._(_root);
}

// Path: inventory
class _TranslationsInventoryEn implements TranslationsInventoryJa {
	_TranslationsInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inventory';
	@override String get gallery => 'Gallery';
	@override String get icon => 'Icon';
	@override String get emoji => 'Emoji';
	@override String get sticker => 'Sticker';
	@override String get print => 'Print';
	@override String get upload => 'Upload File';
	@override String get uploadGallery => 'Uploading gallery image...';
	@override String get uploadIcon => 'Uploading icon...';
	@override String get uploadEmoji => 'Uploading emoji...';
	@override String get uploadSticker => 'Uploading sticker...';
	@override String get uploadPrint => 'Uploading print image...';
	@override String get selectImage => 'Select Image';
	@override String get selectFromGallery => 'Select from Gallery';
	@override String get takePhoto => 'Take Photo with Camera';
	@override String get uploadSuccess => 'Upload complete.';
	@override String get uploadFailed => 'Upload failed.';
	@override String get uploadFailedFormat => 'There is a problem with the file format or size. Please select a PNG image under 1MB.';
	@override String get uploadFailedAuth => 'Authentication failed. Please log in again.';
	@override String get uploadFailedSize => 'File size is too large. Please select a smaller image.';
	@override String uploadFailedServer({required Object code}) => 'Server error occurred (${code})';
	@override String pickImageFailed({required Object error}) => 'Failed to select image: ${error}';
	@override late final _TranslationsInventoryTabsEn tabs = _TranslationsInventoryTabsEn._(_root);
}

// Path: vrcnsync
class _TranslationsVrcnsyncEn implements TranslationsVrcnsyncJa {
	_TranslationsVrcnsyncEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCNSync (β)';
	@override String get betaTitle => 'Beta Feature';
	@override String get betaDescription => 'This feature is a beta version under development. Unexpected issues may occur.\nCurrently, it is only implemented locally, but a cloud version will be implemented if there is demand.';
	@override String get githubLink => 'VRCNSync GitHub Page';
	@override String get openGithub => 'Open GitHub Page';
	@override String get serverRunning => 'Server Running';
	@override String get serverStopped => 'Server Stopped';
	@override String get serverRunningDesc => 'Saves photos from your PC to the VRCN album.';
	@override String get serverStoppedDesc => 'The server is stopped.';
	@override String get photoSaved => 'Photo saved to VRCN album.';
	@override String get photoReceived => 'Photo received (failed to save to album).';
	@override String get openAlbum => 'Open Album';
	@override String get permissionErrorIos => 'Access to the photo library is required.';
	@override String get permissionErrorAndroid => 'Access to storage is required.';
	@override String get openSettings => 'Open Settings';
	@override String initError({required Object error}) => 'Initialization failed: ${error}';
	@override String get openPhotoAppError => 'Could not open the photo app.';
	@override String get serverInfo => 'Server Information';
	@override String ip({required Object ip}) => 'IP: ${ip}';
	@override String port({required Object port}) => 'Port: ${port}';
	@override String address({required Object ip, required Object port}) => '${ip}:${port}';
	@override String get autoSave => 'Received photos are automatically saved to the "VRCN" album.';
	@override String get usage => 'How to Use';
	@override List<dynamic> get usageSteps => [
		_TranslationsVrcnsync$usageSteps$0i0$En._(_root),
		_TranslationsVrcnsync$usageSteps$0i1$En._(_root),
		_TranslationsVrcnsync$usageSteps$0i2$En._(_root),
		_TranslationsVrcnsync$usageSteps$0i3$En._(_root),
	];
	@override String get stats => 'Connection Status';
	@override String get statServer => 'Server Status';
	@override String get statServerRunning => 'Running';
	@override String get statServerStopped => 'Stopped';
	@override String get statNetwork => 'Network';
	@override String get statNetworkConnected => 'Connected';
	@override String get statNetworkDisconnected => 'Disconnected';
}

// Path: feedback
class _TranslationsFeedbackEn implements TranslationsFeedbackJa {
	_TranslationsFeedbackEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Feedback';
	@override String get type => 'Feedback Type';
	@override Map<String, String> get types => {
		'bug': 'Bug Report',
		'feature': 'Feature Request',
		'improvement': 'Suggestion for Improvement',
		'other': 'Other',
	};
	@override String get inputTitle => 'Title *';
	@override String get inputTitleHint => 'Please be concise.';
	@override String get inputDescription => 'Description *';
	@override String get inputDescriptionHint => 'Please provide a detailed description...';
	@override String get cancel => 'Cancel';
	@override String get send => 'Send';
	@override String get sending => 'Sending...';
	@override String get required => 'Title and description are required.';
	@override String get success => 'Feedback sent. Thank you!';
	@override String get fail => 'Failed to send feedback.';
}

// Path: settings
class _TranslationsSettingsEn implements TranslationsSettingsJa {
	_TranslationsSettingsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Appearance';
	@override String get language => 'Language';
	@override String get languageDescription => 'You can select the display language for the app.';
	@override String get appIcon => 'App Icon';
	@override String get appIconDescription => 'Change the app icon displayed on the home screen.';
	@override String get contentSettings => 'Content Settings';
	@override String get searchEnabled => 'Search feature enabled.';
	@override String get searchDisabled => 'Search feature disabled.';
	@override String get enableSearch => 'Enable Search';
	@override String get enableSearchDescription => 'Search results may include sexual or violent content.';
	@override String get apiSetting => 'Avatar Search API';
	@override String get apiSettingDescription => 'Set the API for the avatar search feature.';
	@override String get apiSettingSaveUrl => 'URL saved.';
	@override String get notSet => 'Not set (Avatar search feature cannot be used).';
	@override String get notifications => 'Notification Settings';
	@override String get eventReminder => 'Event Reminders';
	@override String get eventReminderDescription => 'Receive notifications before your scheduled events start.';
	@override String get manageReminders => 'Manage Set Reminders';
	@override String get manageRemindersDescription => 'Cancel or check your notifications.';
	@override String get dataStorage => 'Data and Storage';
	@override String get clearCache => 'Clear Cache';
	@override String get clearCacheSuccess => 'Cache cleared.';
	@override String get clearCacheError => 'An error occurred while clearing the cache.';
	@override String cacheSize({required Object size}) => 'Cache size: ${size}';
	@override String get calculatingCache => 'Calculating cache size...';
	@override String get cacheError => 'Could not get cache size.';
	@override String get confirmClearCache => 'Clearing the cache will delete temporarily saved images and data.\n\nYour account information and app settings will not be deleted.';
	@override String get appInfo => 'App Information';
	@override String get version => 'Version';
	@override String get packageName => 'Package Name';
	@override String get credit => 'Credits';
	@override String get creditDescription => 'Developer and contributor information.';
	@override String get contact => 'Contact';
	@override String get contactDescription => 'For bug reports and suggestions.';
	@override String get privacyPolicy => 'Privacy Policy';
	@override String get privacyPolicyDescription => 'About the handling of personal information.';
	@override String get termsOfService => 'Terms of Service';
	@override String get termsOfServiceDescription => 'Conditions for using the app.';
	@override String get openSource => 'Open Source Information';
	@override String get openSourceDescription => 'Licenses for libraries used.';
	@override String get github => 'GitHub Repository';
	@override String get githubDescription => 'View source code.';
	@override String get logoutConfirm => 'Are you sure you want to log out?';
	@override String logoutError({required Object error}) => 'An error occurred during logout: ${error}';
	@override String get iconChangeNotSupported => 'Changing the app icon is not supported on your device.';
	@override String get iconChangeFailed => 'Failed to change icon.';
	@override String get themeMode => 'Theme Mode';
	@override String get themeModeDescription => 'You can select the display theme of the app.';
	@override String get themeLight => 'Light';
	@override String get themeSystem => 'System';
	@override String get themeDark => 'Dark';
	@override String get appIconDefault => 'Default';
	@override String get appIconIcon => 'Icon';
	@override String get appIconLogo => 'Logo';
	@override String get delete => 'Delete';
}

// Path: credits
class _TranslationsCreditsEn implements TranslationsCreditsJa {
	_TranslationsCreditsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Credits';
	@override late final _TranslationsCreditsSectionEn section = _TranslationsCreditsSectionEn._(_root);
}

// Path: download
class _TranslationsDownloadEn implements TranslationsDownloadJa {
	_TranslationsDownloadEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get success => 'Download complete.';
	@override String failure({required Object error}) => 'Download failed: ${error}';
	@override String shareFailure({required Object error}) => 'Sharing failed: ${error}';
	@override String get permissionTitle => 'Permission Required';
	@override String permissionDenied({required Object permissionType}) => 'Permission to save to ${permissionType} has been denied.\nPlease enable the permission from the settings app.';
	@override String get permissionCancel => 'Cancel';
	@override String get permissionOpenSettings => 'Open Settings';
	@override String get permissionPhoto => 'Photos';
	@override String get permissionPhotoLibrary => 'Photo Library';
	@override String get permissionStorage => 'Storage';
	@override String get permissionPhotoRequired => 'Permission to save to photos is required.';
	@override String get permissionPhotoLibraryRequired => 'Permission to save to photo library is required.';
	@override String get permissionStorageRequired => 'Permission to access storage is required.';
	@override String permissionError({required Object error}) => 'An error occurred while checking permissions: ${error}';
	@override String downloading({required Object fileName}) => 'Downloading ${fileName}...';
	@override String sharing({required Object fileName}) => 'Preparing to share ${fileName}...';
}

// Path: instance
class _TranslationsInstanceEn implements TranslationsInstanceJa {
	_TranslationsInstanceEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInstanceTypeEn type = _TranslationsInstanceTypeEn._(_root);
}

// Path: status
class _TranslationsStatusEn implements TranslationsStatusJa {
	_TranslationsStatusEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get active => 'Online';
	@override String get joinMe => 'Join Me';
	@override String get askMe => 'Ask Me';
	@override String get busy => 'Busy';
	@override String get offline => 'Offline';
	@override String get unknown => 'Unknown Status';
}

// Path: location
class _TranslationsLocationEn implements TranslationsLocationJa {
	_TranslationsLocationEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get private => 'Private';
	@override String playerCount({required Object userCount, required Object capacity}) => 'Players: ${userCount} / ${capacity}';
	@override String instanceType({required Object type}) => 'Instance Type: ${type}';
	@override String get noInfo => 'No location information available.';
	@override String get fetchError => 'Failed to get location information.';
	@override String get privateLocation => 'You are in a private location.';
	@override String get inviteSending => 'Sending invite...';
	@override String get inviteSent => 'Invite sent. You can join from your notifications.';
	@override String inviteFailed({required Object error}) => 'Failed to send invite: ${error}';
	@override String get inviteButton => 'Send Invite to Myself';
	@override String isPrivate({required Object number}) => '${number} in private';
	@override String isActive({required Object number}) => '${number} active';
	@override String isOffline({required Object number}) => '${number} offline';
	@override String isTraveling({required Object number}) => '${number} traveling';
	@override String isStaying({required Object number}) => '${number} staying';
}

// Path: reminder
class _TranslationsReminderEn implements TranslationsReminderJa {
	_TranslationsReminderEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Set Reminder';
	@override String get alreadySet => 'Already Set';
	@override String get set => 'Set';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get deleteAll => 'Delete All Reminders';
	@override String get deleteAllConfirm => 'This will delete all set event reminders. This action cannot be undone.';
	@override String get deleted => 'Reminder deleted.';
	@override String get deletedAll => 'All reminders deleted.';
	@override String get noReminders => 'No reminders set.';
	@override String get setFromEvent => 'You can set notifications from the event page.';
	@override String eventStart({required Object time}) => 'Starts at ${time}';
	@override String notifyAt({required Object time, required Object label}) => '${time} (${label})';
	@override String get receiveNotification => 'When do you want to be notified?';
}

// Path: friend
class _TranslationsFriendEn implements TranslationsFriendJa {
	_TranslationsFriendEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get sortFilter => 'Sort & Filter';
	@override String get filter => 'Filter';
	@override String get filterAll => 'Show All';
	@override String get filterOnline => 'Online Only';
	@override String get filterOffline => 'Offline Only';
	@override String get filterFavorite => 'Favorites Only';
	@override String get sort => 'Sort';
	@override String get sortStatus => 'By Status';
	@override String get sortName => 'By Name';
	@override String get sortLastLogin => 'By Last Login';
	@override String get sortAsc => 'Ascending';
	@override String get sortDesc => 'Descending';
	@override String get close => 'Close';
}

// Path: eventCalendarFilter
class _TranslationsEventCalendarFilterEn implements TranslationsEventCalendarFilterJa {
	_TranslationsEventCalendarFilterEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get filterTitle => 'Filter Events';
	@override String get clear => 'Clear';
	@override String get keyword => 'Keyword Search';
	@override String get keywordHint => 'Event name, description, organizer, etc.';
	@override String get date => 'Filter by Date';
	@override String get dateHint => 'You can display events for a specific date range.';
	@override String get startDate => 'Start Date';
	@override String get endDate => 'End Date';
	@override String get select => 'Please select';
	@override String get time => 'Filter by Time';
	@override String get timeHint => 'You can display events held during a specific time frame.';
	@override String get startTime => 'Start Time';
	@override String get endTime => 'End Time';
	@override String get genre => 'Filter by Genre';
	@override String genreSelected({required Object count}) => '${count} genres selected';
	@override String get apply => 'Apply';
	@override String get filterSummary => 'Filters';
	@override String get filterNone => 'No filters are set.';
}

// Path: drawer.section
class _TranslationsDrawerSectionEn implements TranslationsDrawerSectionJa {
	_TranslationsDrawerSectionEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get content => 'Content';
	@override String get other => 'Other';
}

// Path: search.tabs
class _TranslationsSearchTabsEn implements TranslationsSearchTabsJa {
	_TranslationsSearchTabsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSearchTabsUserSearchEn userSearch = _TranslationsSearchTabsUserSearchEn._(_root);
	@override late final _TranslationsSearchTabsWorldSearchEn worldSearch = _TranslationsSearchTabsWorldSearchEn._(_root);
	@override late final _TranslationsSearchTabsGroupSearchEn groupSearch = _TranslationsSearchTabsGroupSearchEn._(_root);
	@override late final _TranslationsSearchTabsAvatarSearchEn avatarSearch = _TranslationsSearchTabsAvatarSearchEn._(_root);
}

// Path: groupDetail.privacy
class _TranslationsGroupDetailPrivacyEn implements TranslationsGroupDetailPrivacyJa {
	_TranslationsGroupDetailPrivacyEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get public => 'Public';
	@override String get private => 'Private';
	@override String get friends => 'Friends';
	@override String get invite => 'Invite';
	@override String get unknown => 'Unknown';
}

// Path: groupDetail.role
class _TranslationsGroupDetailRoleEn implements TranslationsGroupDetailRoleJa {
	_TranslationsGroupDetailRoleEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get admin => 'Admin';
	@override String get moderator => 'Moderator';
	@override String get member => 'Member';
	@override String get unknown => 'Unknown';
}

// Path: inventory.tabs
class _TranslationsInventoryTabsEn implements TranslationsInventoryTabsJa {
	_TranslationsInventoryTabsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInventoryTabsEmojiInventoryEn emojiInventory = _TranslationsInventoryTabsEmojiInventoryEn._(_root);
	@override late final _TranslationsInventoryTabsGalleryInventoryEn galleryInventory = _TranslationsInventoryTabsGalleryInventoryEn._(_root);
	@override late final _TranslationsInventoryTabsIconInventoryEn iconInventory = _TranslationsInventoryTabsIconInventoryEn._(_root);
	@override late final _TranslationsInventoryTabsPrintInventoryEn printInventory = _TranslationsInventoryTabsPrintInventoryEn._(_root);
	@override late final _TranslationsInventoryTabsStickerInventoryEn stickerInventory = _TranslationsInventoryTabsStickerInventoryEn._(_root);
}

// Path: vrcnsync.usageSteps.0
class _TranslationsVrcnsync$usageSteps$0i0$En implements TranslationsVrcnsync$usageSteps$0i0$Ja {
	_TranslationsVrcnsync$usageSteps$0i0$En._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Launch the VRCNSync app on your PC';
	@override String get desc => 'Please launch the VRCNSync app on your PC.';
}

// Path: vrcnsync.usageSteps.1
class _TranslationsVrcnsync$usageSteps$0i1$En implements TranslationsVrcnsync$usageSteps$0i1$Ja {
	_TranslationsVrcnsync$usageSteps$0i1$En._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Connect to the same WiFi network';
	@override String get desc => 'Please connect your PC and mobile device to the same WiFi network.';
}

// Path: vrcnsync.usageSteps.2
class _TranslationsVrcnsync$usageSteps$0i2$En implements TranslationsVrcnsync$usageSteps$0i2$Ja {
	_TranslationsVrcnsync$usageSteps$0i2$En._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Specify the mobile device as the destination';
	@override String get desc => 'Please specify the IP address and port above in the PC app.';
}

// Path: vrcnsync.usageSteps.3
class _TranslationsVrcnsync$usageSteps$0i3$En implements TranslationsVrcnsync$usageSteps$0i3$Ja {
	_TranslationsVrcnsync$usageSteps$0i3$En._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Send photos';
	@override String get desc => 'When you send photos from your PC, they will be automatically saved to the VRCN album.';
}

// Path: credits.section
class _TranslationsCreditsSectionEn implements TranslationsCreditsSectionJa {
	_TranslationsCreditsSectionEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get development => 'Development';
	@override String get iconPeople => 'The Fun Icon People';
	@override String get testFeedback => 'Testing & Feedback';
	@override String get specialThanks => 'Special Thanks';
}

// Path: instance.type
class _TranslationsInstanceTypeEn implements TranslationsInstanceTypeJa {
	_TranslationsInstanceTypeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get public => 'Public';
	@override String get hidden => 'Friend+';
	@override String get friends => 'Friends';
	@override String get private => 'Invite+';
	@override String get unknown => 'Unknown';
}

// Path: search.tabs.userSearch
class _TranslationsSearchTabsUserSearchEn implements TranslationsSearchTabsUserSearchJa {
	_TranslationsSearchTabsUserSearchEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => 'User Search';
	@override String get emptyDescription => 'You can search by username or ID.';
	@override String get searching => 'Searching...';
	@override String get noResults => 'No matching users found.';
	@override String error({required Object error}) => 'An error occurred during user search: ${error}';
	@override String get inputPlaceholder => 'Enter username or ID';
}

// Path: search.tabs.worldSearch
class _TranslationsSearchTabsWorldSearchEn implements TranslationsSearchTabsWorldSearchJa {
	_TranslationsSearchTabsWorldSearchEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => 'Explore Worlds';
	@override String get emptyDescription => 'Please enter a keyword to search.';
	@override String get searching => 'Searching...';
	@override String get noResults => 'No matching worlds found.';
	@override String noResultsWithQuery({required Object query}) => 'No worlds found matching "${query}"';
	@override String get noResultsHint => 'Try changing your search keywords.';
	@override String error({required Object error}) => 'An error occurred during world search: ${error}';
	@override String resultCount({required Object count}) => '${count} worlds found';
	@override String authorPrefix({required Object authorName}) => 'by ${authorName}';
	@override String get listView => 'List View';
	@override String get gridView => 'Grid View';
}

// Path: search.tabs.groupSearch
class _TranslationsSearchTabsGroupSearchEn implements TranslationsSearchTabsGroupSearchJa {
	_TranslationsSearchTabsGroupSearchEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => 'Search Groups';
	@override String get emptyDescription => 'Please enter a keyword to search.';
	@override String get searching => 'Searching...';
	@override String get noResults => 'No matching groups found.';
	@override String noResultsWithQuery({required Object query}) => 'No groups found matching "${query}"';
	@override String get noResultsHint => 'Try changing your search keywords.';
	@override String error({required Object error}) => 'An error occurred during group search: ${error}';
	@override String resultCount({required Object count}) => '${count} groups found';
	@override String get listView => 'List View';
	@override String get gridView => 'Grid View';
	@override String memberCount({required Object count}) => '${count} members';
}

// Path: search.tabs.avatarSearch
class _TranslationsSearchTabsAvatarSearchEn implements TranslationsSearchTabsAvatarSearchJa {
	_TranslationsSearchTabsAvatarSearchEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get avatar => 'Avatar';
	@override String get emptyTitle => 'Search Avatars';
	@override String get emptyDescription => 'Please enter a keyword to search.';
	@override String get searching => 'Searching for avatars...';
	@override String get noResults => 'No search results found.';
	@override String get noResultsHint => 'Try another keyword.';
	@override String error({required Object error}) => 'An error occurred during avatar search: ${error}';
}

// Path: inventory.tabs.emojiInventory
class _TranslationsInventoryTabsEmojiInventoryEn implements TranslationsInventoryTabsEmojiInventoryJa {
	_TranslationsInventoryTabsEmojiInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading emojis...';
	@override String error({required Object error}) => 'Failed to load emojis: ${error}';
	@override String get emptyTitle => 'No emojis';
	@override String get emptyDescription => 'Emojis you upload in VRChat will appear here.';
	@override String get zoomHint => 'Double-tap to zoom';
}

// Path: inventory.tabs.galleryInventory
class _TranslationsInventoryTabsGalleryInventoryEn implements TranslationsInventoryTabsGalleryInventoryJa {
	_TranslationsInventoryTabsGalleryInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading gallery...';
	@override String error({required Object error}) => 'Failed to load gallery: ${error}';
	@override String get emptyTitle => 'No gallery';
	@override String get emptyDescription => 'Galleries you upload in VRChat will appear here.';
	@override String get zoomHint => 'Double-tap to zoom';
}

// Path: inventory.tabs.iconInventory
class _TranslationsInventoryTabsIconInventoryEn implements TranslationsInventoryTabsIconInventoryJa {
	_TranslationsInventoryTabsIconInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading icons...';
	@override String error({required Object error}) => 'Failed to load icons: ${error}';
	@override String get emptyTitle => 'No icons';
	@override String get emptyDescription => 'Icons you upload in VRChat will appear here.';
	@override String get zoomHint => 'Double-tap to zoom';
}

// Path: inventory.tabs.printInventory
class _TranslationsInventoryTabsPrintInventoryEn implements TranslationsInventoryTabsPrintInventoryJa {
	_TranslationsInventoryTabsPrintInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading prints...';
	@override String error({required Object error}) => 'Failed to load prints: ${error}';
	@override String get emptyTitle => 'No prints';
	@override String get emptyDescription => 'Prints you upload in VRChat will appear here.';
	@override String get zoomHint => 'Double-tap to zoom';
}

// Path: inventory.tabs.stickerInventory
class _TranslationsInventoryTabsStickerInventoryEn implements TranslationsInventoryTabsStickerInventoryJa {
	_TranslationsInventoryTabsStickerInventoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading stickers...';
	@override String error({required Object error}) => 'Failed to load stickers: ${error}';
	@override String get emptyTitle => 'No stickers';
	@override String get emptyDescription => 'Stickers you upload in VRChat will appear here.';
	@override String get zoomHint => 'Double-tap to zoom';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'common.title': return 'VRCN';
			case 'common.ok': return 'OK';
			case 'common.cancel': return 'Cancel';
			case 'common.close': return 'Close';
			case 'common.save': return 'Save';
			case 'common.edit': return 'Edit';
			case 'common.delete': return 'Delete';
			case 'common.yes': return 'Yes';
			case 'common.no': return 'No';
			case 'common.loading': return 'Loading...';
			case 'common.error': return ({required Object error}) => 'An error occurred: ${error}';
			case 'common.errorNomessage': return 'An error occurred';
			case 'common.retry': return 'Retry';
			case 'common.search': return 'Search';
			case 'common.settings': return 'Settings';
			case 'common.confirm': return 'Confirm';
			case 'common.agree': return 'Agree';
			case 'common.decline': return 'Decline';
			case 'common.username': return 'Username';
			case 'common.password': return 'Password';
			case 'common.login': return 'Login';
			case 'common.logout': return 'Logout';
			case 'common.share': return 'Share';
			case 'termsAgreement.welcomeTitle': return 'Welcome to VRCN';
			case 'termsAgreement.welcomeMessage': return 'Before using the app,\nplease review the Terms of Service and Privacy Policy.';
			case 'termsAgreement.termsTitle': return 'Terms of Service';
			case 'termsAgreement.termsSubtitle': return 'About the conditions for using the app';
			case 'termsAgreement.privacyTitle': return 'Privacy Policy';
			case 'termsAgreement.privacySubtitle': return 'About the handling of personal information';
			case 'termsAgreement.agreeTerms': return ({required Object title}) => 'I agree to the "${title}"';
			case 'termsAgreement.checkContent': return 'Check Content';
			case 'termsAgreement.notice': return 'This is an unofficial app for VRChat Inc.\nIt is not affiliated with VRChat Inc. in any way.';
			case 'drawer.home': return 'Home';
			case 'drawer.profile': return 'Profile';
			case 'drawer.favorite': return 'Favorites';
			case 'drawer.eventCalendar': return 'Event Calendar';
			case 'drawer.avatar': return 'Avatars';
			case 'drawer.group': return 'Groups';
			case 'drawer.inventory': return 'Inventory';
			case 'drawer.vrcnsync': return 'VRCNSync (β)';
			case 'drawer.review': return 'Review';
			case 'drawer.feedback': return 'Feedback';
			case 'drawer.settings': return 'Settings';
			case 'drawer.userLoading': return 'Loading user information...';
			case 'drawer.userError': return 'Failed to load user information';
			case 'drawer.retry': return 'Retry';
			case 'drawer.section.content': return 'Content';
			case 'drawer.section.other': return 'Other';
			case 'login.forgotPassword': return 'Forgot your password?';
			case 'login.createAccount': return 'Sign up';
			case 'login.subtitle': return 'Login with your VRChat account';
			case 'login.email': return 'Email Address';
			case 'login.emailHint': return 'Enter email or username';
			case 'login.passwordHint': return 'Enter password';
			case 'login.rememberMe': return 'Remember me';
			case 'login.loggingIn': return 'Logging in...';
			case 'login.errorEmptyEmail': return 'Please enter your username or email address.';
			case 'login.errorEmptyPassword': return 'Please enter your password.';
			case 'login.errorLoginFailed': return 'Login failed. Please check your email and password.';
			case 'login.twoFactorTitle': return 'Two-Factor Authentication';
			case 'login.twoFactorSubtitle': return 'Please enter the authentication code.';
			case 'login.twoFactorInstruction': return 'Enter the 6-digit code from\nyour authenticator app.';
			case 'login.twoFactorCodeHint': return 'Authentication code';
			case 'login.verify': return 'Verify';
			case 'login.verifying': return 'Verifying...';
			case 'login.errorEmpty2fa': return 'Please enter the authentication code.';
			case 'login.error2faFailed': return 'Two-factor authentication failed. Please check if the code is correct.';
			case 'login.backToLogin': return 'Back to login';
			case 'login.paste': return 'Paste';
			case 'friends.loading': return 'Loading friends list...';
			case 'friends.error': return ({required Object error}) => 'Failed to load friends list: ${error}';
			case 'friends.notFound': return 'No friends found.';
			case 'friends.private': return 'Private';
			case 'friends.active': return 'Active';
			case 'friends.offline': return 'Offline';
			case 'friends.online': return 'Online';
			case 'friends.groupTitle': return 'Group by World';
			case 'friends.refresh': return 'Refresh';
			case 'friends.searchHint': return 'Search by friend\'s name';
			case 'friends.noResult': return 'No matching friends found.';
			case 'friendDetail.loading': return 'Loading user information...';
			case 'friendDetail.error': return ({required Object error}) => 'Failed to load user information: ${error}';
			case 'friendDetail.currentLocation': return 'Current Location';
			case 'friendDetail.basicInfo': return 'Basic Info';
			case 'friendDetail.userId': return 'User ID';
			case 'friendDetail.dateJoined': return 'Date Joined';
			case 'friendDetail.lastLogin': return 'Last Login';
			case 'friendDetail.bio': return 'Bio';
			case 'friendDetail.links': return 'Links';
			case 'friendDetail.loadingLinks': return 'Loading links...';
			case 'friendDetail.group': return 'Groups';
			case 'friendDetail.groupDetail': return 'View Group Details';
			case 'friendDetail.groupCode': return ({required Object code}) => 'Group Code: ${code}';
			case 'friendDetail.memberCount': return ({required Object count}) => 'Members: ${count}';
			case 'friendDetail.unknownGroup': return 'Unknown Group';
			case 'friendDetail.block': return 'Block';
			case 'friendDetail.mute': return 'Mute';
			case 'friendDetail.openWebsite': return 'Open on Website';
			case 'friendDetail.shareProfile': return 'Share Profile';
			case 'friendDetail.confirmBlockTitle': return ({required Object name}) => 'Block ${name}?';
			case 'friendDetail.confirmBlockMessage': return 'If you block this user, you will no longer receive friend requests or messages from them.';
			case 'friendDetail.confirmMuteTitle': return ({required Object name}) => 'Mute ${name}?';
			case 'friendDetail.confirmMuteMessage': return 'If you mute this user, you will no longer hear their voice.';
			case 'friendDetail.blockSuccess': return 'Blocked';
			case 'friendDetail.muteSuccess': return 'Muted';
			case 'friendDetail.operationFailed': return ({required Object error}) => 'Operation failed: ${error}';
			case 'search.userTab': return 'Users';
			case 'search.worldTab': return 'Worlds';
			case 'search.avatarTab': return 'Avatars';
			case 'search.groupTab': return 'Groups';
			case 'search.tabs.userSearch.emptyTitle': return 'User Search';
			case 'search.tabs.userSearch.emptyDescription': return 'You can search by username or ID.';
			case 'search.tabs.userSearch.searching': return 'Searching...';
			case 'search.tabs.userSearch.noResults': return 'No matching users found.';
			case 'search.tabs.userSearch.error': return ({required Object error}) => 'An error occurred during user search: ${error}';
			case 'search.tabs.userSearch.inputPlaceholder': return 'Enter username or ID';
			case 'search.tabs.worldSearch.emptyTitle': return 'Explore Worlds';
			case 'search.tabs.worldSearch.emptyDescription': return 'Please enter a keyword to search.';
			case 'search.tabs.worldSearch.searching': return 'Searching...';
			case 'search.tabs.worldSearch.noResults': return 'No matching worlds found.';
			case 'search.tabs.worldSearch.noResultsWithQuery': return ({required Object query}) => 'No worlds found matching "${query}"';
			case 'search.tabs.worldSearch.noResultsHint': return 'Try changing your search keywords.';
			case 'search.tabs.worldSearch.error': return ({required Object error}) => 'An error occurred during world search: ${error}';
			case 'search.tabs.worldSearch.resultCount': return ({required Object count}) => '${count} worlds found';
			case 'search.tabs.worldSearch.authorPrefix': return ({required Object authorName}) => 'by ${authorName}';
			case 'search.tabs.worldSearch.listView': return 'List View';
			case 'search.tabs.worldSearch.gridView': return 'Grid View';
			case 'search.tabs.groupSearch.emptyTitle': return 'Search Groups';
			case 'search.tabs.groupSearch.emptyDescription': return 'Please enter a keyword to search.';
			case 'search.tabs.groupSearch.searching': return 'Searching...';
			case 'search.tabs.groupSearch.noResults': return 'No matching groups found.';
			case 'search.tabs.groupSearch.noResultsWithQuery': return ({required Object query}) => 'No groups found matching "${query}"';
			case 'search.tabs.groupSearch.noResultsHint': return 'Try changing your search keywords.';
			case 'search.tabs.groupSearch.error': return ({required Object error}) => 'An error occurred during group search: ${error}';
			case 'search.tabs.groupSearch.resultCount': return ({required Object count}) => '${count} groups found';
			case 'search.tabs.groupSearch.listView': return 'List View';
			case 'search.tabs.groupSearch.gridView': return 'Grid View';
			case 'search.tabs.groupSearch.memberCount': return ({required Object count}) => '${count} members';
			case 'search.tabs.avatarSearch.avatar': return 'Avatar';
			case 'search.tabs.avatarSearch.emptyTitle': return 'Search Avatars';
			case 'search.tabs.avatarSearch.emptyDescription': return 'Please enter a keyword to search.';
			case 'search.tabs.avatarSearch.searching': return 'Searching for avatars...';
			case 'search.tabs.avatarSearch.noResults': return 'No search results found.';
			case 'search.tabs.avatarSearch.noResultsHint': return 'Try another keyword.';
			case 'search.tabs.avatarSearch.error': return ({required Object error}) => 'An error occurred during avatar search: ${error}';
			case 'profile.title': return 'Profile';
			case 'profile.edit': return 'Edit';
			case 'profile.refresh': return 'Refresh';
			case 'profile.loading': return 'Loading profile information...';
			case 'profile.error': return 'Failed to load profile information: {error}';
			case 'profile.displayName': return 'Display Name';
			case 'profile.username': return 'Username';
			case 'profile.userId': return 'User ID';
			case 'profile.engageCard': return 'Engage Card';
			case 'profile.frined': return 'Friend';
			case 'profile.dateJoined': return 'Date Joined';
			case 'profile.userType': return 'User Type';
			case 'profile.status': return 'Status';
			case 'profile.statusMessage': return 'Status Message';
			case 'profile.bio': return 'Bio';
			case 'profile.links': return 'Links';
			case 'profile.group': return 'Groups';
			case 'profile.groupDetail': return 'View Group Details';
			case 'profile.avatar': return 'Current Avatar';
			case 'profile.avatarDetail': return 'View Avatar Details';
			case 'profile.public': return 'Public';
			case 'profile.private': return 'Private';
			case 'profile.hidden': return 'Hidden';
			case 'profile.unknown': return 'Unknown';
			case 'profile.friends': return 'Friends';
			case 'profile.loadingLinks': return 'Loading links...';
			case 'profile.noGroup': return 'Not in any groups';
			case 'profile.noBio': return 'No bio available';
			case 'profile.noLinks': return 'No links available';
			case 'profile.save': return 'Save Changes';
			case 'profile.saved': return 'Profile updated successfully.';
			case 'profile.saveFailed': return 'Failed to update: {error}';
			case 'profile.discardTitle': return 'Discard changes?';
			case 'profile.discardContent': return 'Changes made to your profile will not be saved.';
			case 'profile.discardCancel': return 'Cancel';
			case 'profile.discardOk': return 'Discard';
			case 'profile.basic': return 'Basic Info';
			case 'profile.pronouns': return 'Pronouns';
			case 'profile.addLink': return 'Add';
			case 'profile.removeLink': return 'Remove';
			case 'profile.linkHint': return 'Enter link (e.g., https://twitter.com/username)';
			case 'profile.linksHint': return 'Links will be displayed on your profile and can be opened by tapping.';
			case 'profile.statusMessageHint': return 'Enter your current situation or a message.';
			case 'profile.bioHint': return 'Write something about yourself.';
			case 'engageCard.pickBackground': return 'Select Background Image';
			case 'engageCard.removeBackground': return 'Remove Background Image';
			case 'engageCard.scanQr': return 'Scan QR Code';
			case 'engageCard.showAvatar': return 'Show Avatar';
			case 'engageCard.hideAvatar': return 'Hide Avatar';
			case 'engageCard.noBackground': return 'No background image selected.\nYou can set one from the top right button.';
			case 'engageCard.loading': return 'Loading...';
			case 'engageCard.error': return ({required Object error}) => 'Failed to load engage card information: ${error}';
			case 'engageCard.copyUserId': return 'Copy User ID';
			case 'engageCard.copied': return 'Copied';
			case 'qrScanner.title': return 'QR Code Scan';
			case 'qrScanner.guide': return 'Align the QR code within the frame.';
			case 'qrScanner.loading': return 'Initializing camera...';
			case 'qrScanner.error': return ({required Object error}) => 'Failed to read QR code: ${error}';
			case 'qrScanner.notFound': return 'No valid user QR code found.';
			case 'favorites.title': return 'Favorites';
			case 'favorites.frined': return 'Friend';
			case 'favorites.friendsTab': return 'Friends';
			case 'favorites.worldsTab': return 'Worlds';
			case 'favorites.avatarsTab': return 'Avatars';
			case 'favorites.emptyFolderTitle': return 'No favorite folders';
			case 'favorites.emptyFolderDescription': return 'Please create a favorite folder in VRChat.';
			case 'favorites.emptyFriends': return 'No friends in this folder.';
			case 'favorites.emptyWorlds': return 'No worlds in this folder.';
			case 'favorites.emptyAvatars': return 'No avatars in this folder.';
			case 'favorites.emptyWorldsTabTitle': return 'No favorite worlds';
			case 'favorites.emptyWorldsTabDescription': return 'You can add worlds to favorites from the world details screen.';
			case 'favorites.emptyAvatarsTabTitle': return 'No favorite avatars';
			case 'favorites.emptyAvatarsTabDescription': return 'You can add avatars to favorites from the avatar details screen.';
			case 'favorites.loading': return 'Loading favorites...';
			case 'favorites.loadingFolder': return 'Loading folder information...';
			case 'favorites.error': return ({required Object error}) => 'Failed to load favorites: ${error}';
			case 'favorites.errorFolder': return 'Failed to get information.';
			case 'favorites.remove': return 'Remove from Favorites';
			case 'favorites.removeSuccess': return ({required Object name}) => 'Removed ${name} from favorites.';
			case 'favorites.removeFailed': return ({required Object error}) => 'Failed to remove: ${error}';
			case 'favorites.itemsCount': return ({required Object count}) => '${count} items';
			case 'favorites.public': return 'Public';
			case 'favorites.private': return 'Private';
			case 'favorites.hidden': return 'Hidden';
			case 'favorites.unknown': return 'Unknown';
			case 'favorites.loadingError': return 'Loading Error';
			case 'notifications.emptyTitle': return 'No Notifications';
			case 'notifications.emptyDescription': return 'New notifications, like friend requests and invites,\nwill appear here.';
			case 'notifications.friendRequest': return ({required Object userName}) => 'You have a friend request from ${userName}.';
			case 'notifications.invite': return ({required Object worldName, required Object userName}) => 'You have an invite to ${worldName} from ${userName}.';
			case 'notifications.friendOnline': return ({required Object userName}) => '${userName} is now online.';
			case 'notifications.friendOffline': return ({required Object userName}) => '${userName} is now offline.';
			case 'notifications.friendActive': return ({required Object userName}) => '${userName} is now active.';
			case 'notifications.friendAdd': return ({required Object userName}) => '${userName} has been added to your friends.';
			case 'notifications.friendRemove': return ({required Object userName}) => '${userName} has been removed from your friends.';
			case 'notifications.statusUpdate': return ({required Object userName, required Object status, required Object world}) => '${userName}\'s status updated: ${status}${world}';
			case 'notifications.locationChange': return ({required Object userName, required Object worldName}) => '${userName} moved to ${worldName}.';
			case 'notifications.userUpdate': return ({required Object world}) => 'Your information has been updated${world}.';
			case 'notifications.myLocationChange': return ({required Object worldName}) => 'You moved to: ${worldName}';
			case 'notifications.requestInvite': return ({required Object userName}) => 'You have a request to join from ${userName}.';
			case 'notifications.votekick': return ({required Object userName}) => 'There was a votekick from ${userName}.';
			case 'notifications.responseReceived': return ({required Object userName}) => 'Received response for notification ID: ${userName}';
			case 'notifications.error': return ({required Object worldName}) => 'Error: ${worldName}';
			case 'notifications.system': return ({required Object extraData}) => 'System notification: ${extraData}';
			case 'notifications.secondsAgo': return ({required Object seconds}) => '${seconds}s ago';
			case 'notifications.minutesAgo': return ({required Object minutes}) => '${minutes}m ago';
			case 'notifications.hoursAgo': return ({required Object hours}) => '${hours}h ago';
			case 'eventCalendar.title': return 'Event Calendar';
			case 'eventCalendar.filter': return 'Filter Events';
			case 'eventCalendar.refresh': return 'Refresh Events';
			case 'eventCalendar.loading': return 'Loading events...';
			case 'eventCalendar.error': return ({required Object error}) => 'Failed to load events: ${error}';
			case 'eventCalendar.filterActive': return ({required Object count}) => 'Filter applied (${count} results)';
			case 'eventCalendar.clear': return 'Clear';
			case 'eventCalendar.noEvents': return 'No events match the criteria.';
			case 'eventCalendar.clearFilter': return 'Clear Filter';
			case 'eventCalendar.today': return 'Today';
			case 'eventCalendar.reminderSet': return 'Set Reminder';
			case 'eventCalendar.reminderSetDone': return 'Reminder Set';
			case 'eventCalendar.reminderDeleted': return 'Reminder deleted.';
			case 'eventCalendar.eventName': return 'Event Name';
			case 'eventCalendar.organizer': return 'Organizer';
			case 'eventCalendar.description': return 'Description';
			case 'eventCalendar.genre': return 'Genre';
			case 'eventCalendar.condition': return 'Participation Conditions';
			case 'eventCalendar.way': return 'How to Join';
			case 'eventCalendar.note': return 'Notes';
			case 'eventCalendar.quest': return 'Quest Compatible';
			case 'eventCalendar.reminderCount': return ({required Object count}) => '${count}';
			case 'eventCalendar.startToEnd': return ({required Object start, required Object end}) => '${start} - ${end}';
			case 'avatars.title': return 'Avatars';
			case 'avatars.searchHint': return 'Search by avatar name, etc.';
			case 'avatars.searchTooltip': return 'Search';
			case 'avatars.searchEmptyTitle': return 'No search results found.';
			case 'avatars.searchEmptyDescription': return 'Please try a different search term.';
			case 'avatars.emptyTitle': return 'No avatars';
			case 'avatars.emptyDescription': return 'Please add an avatar or try again later.';
			case 'avatars.refresh': return 'Refresh';
			case 'avatars.loading': return 'Loading avatars...';
			case 'avatars.error': return ({required Object error}) => 'Failed to load avatars: ${error}';
			case 'avatars.current': return 'In Use';
			case 'avatars.public': return 'Public';
			case 'avatars.private': return 'Private';
			case 'avatars.hidden': return 'Hidden';
			case 'avatars.author': return 'Author';
			case 'avatars.sortUpdated': return 'By Update Date';
			case 'avatars.sortName': return 'By Name';
			case 'avatars.sortTooltip': return 'Sort';
			case 'avatars.viewModeTooltip': return 'Toggle View Mode';
			case 'worldDetail.loading': return 'Loading world information...';
			case 'worldDetail.error': return ({required Object error}) => 'Failed to load world information: ${error}';
			case 'worldDetail.share': return 'Share This World';
			case 'worldDetail.openInVRChat': return 'Open on VRChat Official Website';
			case 'worldDetail.report': return 'Report This World';
			case 'worldDetail.creator': return 'Creator';
			case 'worldDetail.created': return 'Created';
			case 'worldDetail.updated': return 'Updated';
			case 'worldDetail.favorites': return 'Favorites';
			case 'worldDetail.visits': return 'Visits';
			case 'worldDetail.occupants': return 'Current Occupants';
			case 'worldDetail.popularity': return 'Popularity';
			case 'worldDetail.description': return 'Description';
			case 'worldDetail.noDescription': return 'No description available.';
			case 'worldDetail.tags': return 'Tags';
			case 'worldDetail.joinPublic': return 'Send Invite to Public Instance';
			case 'worldDetail.favoriteAdded': return 'Added to favorites.';
			case 'worldDetail.favoriteRemoved': return 'Removed from favorites.';
			case 'worldDetail.unknown': return 'Unknown';
			case 'avatarDetail.changeSuccess': return ({required Object name}) => 'Changed to avatar "${name}".';
			case 'avatarDetail.changeFailed': return ({required Object error}) => 'Failed to change avatar: ${error}';
			case 'avatarDetail.changing': return 'Changing...';
			case 'avatarDetail.useThisAvatar': return 'Use This Avatar';
			case 'avatarDetail.creator': return 'Creator';
			case 'avatarDetail.created': return 'Created';
			case 'avatarDetail.updated': return 'Updated';
			case 'avatarDetail.description': return 'Description';
			case 'avatarDetail.noDescription': return 'No description available.';
			case 'avatarDetail.tags': return 'Tags';
			case 'avatarDetail.addToFavorites': return 'Add to Favorites';
			case 'avatarDetail.public': return 'Public';
			case 'avatarDetail.private': return 'Private';
			case 'avatarDetail.hidden': return 'Hidden';
			case 'avatarDetail.unknown': return 'Unknown';
			case 'avatarDetail.share': return 'Share';
			case 'avatarDetail.loading': return 'Loading avatar information...';
			case 'avatarDetail.error': return ({required Object error}) => 'Failed to load avatar information: ${error}';
			case 'groups.title': return 'Groups';
			case 'groups.loadingUser': return 'Loading user information...';
			case 'groups.errorUser': return ({required Object error}) => 'Failed to load user information: ${error}';
			case 'groups.loadingGroups': return 'Loading group information...';
			case 'groups.errorGroups': return ({required Object error}) => 'Failed to load group information: ${error}';
			case 'groups.emptyTitle': return 'You are not in any groups.';
			case 'groups.emptyDescription': return 'You can join groups from the VRChat app or website.';
			case 'groups.searchGroups': return 'Find Groups';
			case 'groups.members': return ({required Object count}) => '${count} members';
			case 'groups.showDetails': return 'Show Details';
			case 'groups.unknownName': return 'Unknown Name';
			case 'groupDetail.loading': return 'Loading group information...';
			case 'groupDetail.error': return ({required Object error}) => 'Failed to load group information: ${error}';
			case 'groupDetail.share': return 'Share Group Info';
			case 'groupDetail.description': return 'Description';
			case 'groupDetail.roles': return 'Roles';
			case 'groupDetail.basicInfo': return 'Basic Info';
			case 'groupDetail.createdAt': return 'Created At';
			case 'groupDetail.owner': return 'Owner';
			case 'groupDetail.rules': return 'Rules';
			case 'groupDetail.languages': return 'Languages';
			case 'groupDetail.memberCount': return ({required Object count}) => '${count} Members';
			case 'groupDetail.privacy.public': return 'Public';
			case 'groupDetail.privacy.private': return 'Private';
			case 'groupDetail.privacy.friends': return 'Friends';
			case 'groupDetail.privacy.invite': return 'Invite';
			case 'groupDetail.privacy.unknown': return 'Unknown';
			case 'groupDetail.role.admin': return 'Admin';
			case 'groupDetail.role.moderator': return 'Moderator';
			case 'groupDetail.role.member': return 'Member';
			case 'groupDetail.role.unknown': return 'Unknown';
			case 'inventory.title': return 'Inventory';
			case 'inventory.gallery': return 'Gallery';
			case 'inventory.icon': return 'Icon';
			case 'inventory.emoji': return 'Emoji';
			case 'inventory.sticker': return 'Sticker';
			case 'inventory.print': return 'Print';
			case 'inventory.upload': return 'Upload File';
			case 'inventory.uploadGallery': return 'Uploading gallery image...';
			case 'inventory.uploadIcon': return 'Uploading icon...';
			case 'inventory.uploadEmoji': return 'Uploading emoji...';
			case 'inventory.uploadSticker': return 'Uploading sticker...';
			case 'inventory.uploadPrint': return 'Uploading print image...';
			case 'inventory.selectImage': return 'Select Image';
			case 'inventory.selectFromGallery': return 'Select from Gallery';
			case 'inventory.takePhoto': return 'Take Photo with Camera';
			case 'inventory.uploadSuccess': return 'Upload complete.';
			case 'inventory.uploadFailed': return 'Upload failed.';
			case 'inventory.uploadFailedFormat': return 'There is a problem with the file format or size. Please select a PNG image under 1MB.';
			case 'inventory.uploadFailedAuth': return 'Authentication failed. Please log in again.';
			case 'inventory.uploadFailedSize': return 'File size is too large. Please select a smaller image.';
			case 'inventory.uploadFailedServer': return ({required Object code}) => 'Server error occurred (${code})';
			case 'inventory.pickImageFailed': return ({required Object error}) => 'Failed to select image: ${error}';
			case 'inventory.tabs.emojiInventory.loading': return 'Loading emojis...';
			case 'inventory.tabs.emojiInventory.error': return ({required Object error}) => 'Failed to load emojis: ${error}';
			case 'inventory.tabs.emojiInventory.emptyTitle': return 'No emojis';
			case 'inventory.tabs.emojiInventory.emptyDescription': return 'Emojis you upload in VRChat will appear here.';
			case 'inventory.tabs.emojiInventory.zoomHint': return 'Double-tap to zoom';
			case 'inventory.tabs.galleryInventory.loading': return 'Loading gallery...';
			case 'inventory.tabs.galleryInventory.error': return ({required Object error}) => 'Failed to load gallery: ${error}';
			case 'inventory.tabs.galleryInventory.emptyTitle': return 'No gallery';
			case 'inventory.tabs.galleryInventory.emptyDescription': return 'Galleries you upload in VRChat will appear here.';
			case 'inventory.tabs.galleryInventory.zoomHint': return 'Double-tap to zoom';
			case 'inventory.tabs.iconInventory.loading': return 'Loading icons...';
			case 'inventory.tabs.iconInventory.error': return ({required Object error}) => 'Failed to load icons: ${error}';
			case 'inventory.tabs.iconInventory.emptyTitle': return 'No icons';
			case 'inventory.tabs.iconInventory.emptyDescription': return 'Icons you upload in VRChat will appear here.';
			case 'inventory.tabs.iconInventory.zoomHint': return 'Double-tap to zoom';
			case 'inventory.tabs.printInventory.loading': return 'Loading prints...';
			case 'inventory.tabs.printInventory.error': return ({required Object error}) => 'Failed to load prints: ${error}';
			case 'inventory.tabs.printInventory.emptyTitle': return 'No prints';
			case 'inventory.tabs.printInventory.emptyDescription': return 'Prints you upload in VRChat will appear here.';
			case 'inventory.tabs.printInventory.zoomHint': return 'Double-tap to zoom';
			case 'inventory.tabs.stickerInventory.loading': return 'Loading stickers...';
			case 'inventory.tabs.stickerInventory.error': return ({required Object error}) => 'Failed to load stickers: ${error}';
			case 'inventory.tabs.stickerInventory.emptyTitle': return 'No stickers';
			case 'inventory.tabs.stickerInventory.emptyDescription': return 'Stickers you upload in VRChat will appear here.';
			case 'inventory.tabs.stickerInventory.zoomHint': return 'Double-tap to zoom';
			case 'vrcnsync.title': return 'VRCNSync (β)';
			case 'vrcnsync.betaTitle': return 'Beta Feature';
			case 'vrcnsync.betaDescription': return 'This feature is a beta version under development. Unexpected issues may occur.\nCurrently, it is only implemented locally, but a cloud version will be implemented if there is demand.';
			case 'vrcnsync.githubLink': return 'VRCNSync GitHub Page';
			case 'vrcnsync.openGithub': return 'Open GitHub Page';
			case 'vrcnsync.serverRunning': return 'Server Running';
			case 'vrcnsync.serverStopped': return 'Server Stopped';
			case 'vrcnsync.serverRunningDesc': return 'Saves photos from your PC to the VRCN album.';
			case 'vrcnsync.serverStoppedDesc': return 'The server is stopped.';
			case 'vrcnsync.photoSaved': return 'Photo saved to VRCN album.';
			case 'vrcnsync.photoReceived': return 'Photo received (failed to save to album).';
			case 'vrcnsync.openAlbum': return 'Open Album';
			case 'vrcnsync.permissionErrorIos': return 'Access to the photo library is required.';
			case 'vrcnsync.permissionErrorAndroid': return 'Access to storage is required.';
			case 'vrcnsync.openSettings': return 'Open Settings';
			case 'vrcnsync.initError': return ({required Object error}) => 'Initialization failed: ${error}';
			case 'vrcnsync.openPhotoAppError': return 'Could not open the photo app.';
			case 'vrcnsync.serverInfo': return 'Server Information';
			case 'vrcnsync.ip': return ({required Object ip}) => 'IP: ${ip}';
			case 'vrcnsync.port': return ({required Object port}) => 'Port: ${port}';
			case 'vrcnsync.address': return ({required Object ip, required Object port}) => '${ip}:${port}';
			case 'vrcnsync.autoSave': return 'Received photos are automatically saved to the "VRCN" album.';
			case 'vrcnsync.usage': return 'How to Use';
			case 'vrcnsync.usageSteps.0.title': return 'Launch the VRCNSync app on your PC';
			case 'vrcnsync.usageSteps.0.desc': return 'Please launch the VRCNSync app on your PC.';
			case 'vrcnsync.usageSteps.1.title': return 'Connect to the same WiFi network';
			case 'vrcnsync.usageSteps.1.desc': return 'Please connect your PC and mobile device to the same WiFi network.';
			case 'vrcnsync.usageSteps.2.title': return 'Specify the mobile device as the destination';
			case 'vrcnsync.usageSteps.2.desc': return 'Please specify the IP address and port above in the PC app.';
			case 'vrcnsync.usageSteps.3.title': return 'Send photos';
			case 'vrcnsync.usageSteps.3.desc': return 'When you send photos from your PC, they will be automatically saved to the VRCN album.';
			case 'vrcnsync.stats': return 'Connection Status';
			case 'vrcnsync.statServer': return 'Server Status';
			case 'vrcnsync.statServerRunning': return 'Running';
			case 'vrcnsync.statServerStopped': return 'Stopped';
			case 'vrcnsync.statNetwork': return 'Network';
			case 'vrcnsync.statNetworkConnected': return 'Connected';
			case 'vrcnsync.statNetworkDisconnected': return 'Disconnected';
			case 'feedback.title': return 'Feedback';
			case 'feedback.type': return 'Feedback Type';
			case 'feedback.types.bug': return 'Bug Report';
			case 'feedback.types.feature': return 'Feature Request';
			case 'feedback.types.improvement': return 'Suggestion for Improvement';
			case 'feedback.types.other': return 'Other';
			case 'feedback.inputTitle': return 'Title *';
			case 'feedback.inputTitleHint': return 'Please be concise.';
			case 'feedback.inputDescription': return 'Description *';
			case 'feedback.inputDescriptionHint': return 'Please provide a detailed description...';
			case 'feedback.cancel': return 'Cancel';
			case 'feedback.send': return 'Send';
			case 'feedback.sending': return 'Sending...';
			case 'feedback.required': return 'Title and description are required.';
			case 'feedback.success': return 'Feedback sent. Thank you!';
			case 'feedback.fail': return 'Failed to send feedback.';
			case 'settings.appearance': return 'Appearance';
			case 'settings.language': return 'Language';
			case 'settings.languageDescription': return 'You can select the display language for the app.';
			case 'settings.appIcon': return 'App Icon';
			case 'settings.appIconDescription': return 'Change the app icon displayed on the home screen.';
			case 'settings.contentSettings': return 'Content Settings';
			case 'settings.searchEnabled': return 'Search feature enabled.';
			case 'settings.searchDisabled': return 'Search feature disabled.';
			case 'settings.enableSearch': return 'Enable Search';
			case 'settings.enableSearchDescription': return 'Search results may include sexual or violent content.';
			case 'settings.apiSetting': return 'Avatar Search API';
			case 'settings.apiSettingDescription': return 'Set the API for the avatar search feature.';
			case 'settings.apiSettingSaveUrl': return 'URL saved.';
			case 'settings.notSet': return 'Not set (Avatar search feature cannot be used).';
			case 'settings.notifications': return 'Notification Settings';
			case 'settings.eventReminder': return 'Event Reminders';
			case 'settings.eventReminderDescription': return 'Receive notifications before your scheduled events start.';
			case 'settings.manageReminders': return 'Manage Set Reminders';
			case 'settings.manageRemindersDescription': return 'Cancel or check your notifications.';
			case 'settings.dataStorage': return 'Data and Storage';
			case 'settings.clearCache': return 'Clear Cache';
			case 'settings.clearCacheSuccess': return 'Cache cleared.';
			case 'settings.clearCacheError': return 'An error occurred while clearing the cache.';
			case 'settings.cacheSize': return ({required Object size}) => 'Cache size: ${size}';
			case 'settings.calculatingCache': return 'Calculating cache size...';
			case 'settings.cacheError': return 'Could not get cache size.';
			case 'settings.confirmClearCache': return 'Clearing the cache will delete temporarily saved images and data.\n\nYour account information and app settings will not be deleted.';
			case 'settings.appInfo': return 'App Information';
			case 'settings.version': return 'Version';
			case 'settings.packageName': return 'Package Name';
			case 'settings.credit': return 'Credits';
			case 'settings.creditDescription': return 'Developer and contributor information.';
			case 'settings.contact': return 'Contact';
			case 'settings.contactDescription': return 'For bug reports and suggestions.';
			case 'settings.privacyPolicy': return 'Privacy Policy';
			case 'settings.privacyPolicyDescription': return 'About the handling of personal information.';
			case 'settings.termsOfService': return 'Terms of Service';
			case 'settings.termsOfServiceDescription': return 'Conditions for using the app.';
			case 'settings.openSource': return 'Open Source Information';
			case 'settings.openSourceDescription': return 'Licenses for libraries used.';
			case 'settings.github': return 'GitHub Repository';
			case 'settings.githubDescription': return 'View source code.';
			case 'settings.logoutConfirm': return 'Are you sure you want to log out?';
			case 'settings.logoutError': return ({required Object error}) => 'An error occurred during logout: ${error}';
			case 'settings.iconChangeNotSupported': return 'Changing the app icon is not supported on your device.';
			case 'settings.iconChangeFailed': return 'Failed to change icon.';
			case 'settings.themeMode': return 'Theme Mode';
			case 'settings.themeModeDescription': return 'You can select the display theme of the app.';
			case 'settings.themeLight': return 'Light';
			case 'settings.themeSystem': return 'System';
			case 'settings.themeDark': return 'Dark';
			case 'settings.appIconDefault': return 'Default';
			case 'settings.appIconIcon': return 'Icon';
			case 'settings.appIconLogo': return 'Logo';
			case 'settings.delete': return 'Delete';
			case 'credits.title': return 'Credits';
			case 'credits.section.development': return 'Development';
			case 'credits.section.iconPeople': return 'The Fun Icon People';
			case 'credits.section.testFeedback': return 'Testing & Feedback';
			case 'credits.section.specialThanks': return 'Special Thanks';
			case 'download.success': return 'Download complete.';
			case 'download.failure': return ({required Object error}) => 'Download failed: ${error}';
			case 'download.shareFailure': return ({required Object error}) => 'Sharing failed: ${error}';
			case 'download.permissionTitle': return 'Permission Required';
			case 'download.permissionDenied': return ({required Object permissionType}) => 'Permission to save to ${permissionType} has been denied.\nPlease enable the permission from the settings app.';
			case 'download.permissionCancel': return 'Cancel';
			case 'download.permissionOpenSettings': return 'Open Settings';
			case 'download.permissionPhoto': return 'Photos';
			case 'download.permissionPhotoLibrary': return 'Photo Library';
			case 'download.permissionStorage': return 'Storage';
			case 'download.permissionPhotoRequired': return 'Permission to save to photos is required.';
			case 'download.permissionPhotoLibraryRequired': return 'Permission to save to photo library is required.';
			case 'download.permissionStorageRequired': return 'Permission to access storage is required.';
			case 'download.permissionError': return ({required Object error}) => 'An error occurred while checking permissions: ${error}';
			case 'download.downloading': return ({required Object fileName}) => 'Downloading ${fileName}...';
			case 'download.sharing': return ({required Object fileName}) => 'Preparing to share ${fileName}...';
			case 'instance.type.public': return 'Public';
			case 'instance.type.hidden': return 'Friend+';
			case 'instance.type.friends': return 'Friends';
			case 'instance.type.private': return 'Invite+';
			case 'instance.type.unknown': return 'Unknown';
			case 'status.active': return 'Online';
			case 'status.joinMe': return 'Join Me';
			case 'status.askMe': return 'Ask Me';
			case 'status.busy': return 'Busy';
			case 'status.offline': return 'Offline';
			case 'status.unknown': return 'Unknown Status';
			case 'location.private': return 'Private';
			case 'location.playerCount': return ({required Object userCount, required Object capacity}) => 'Players: ${userCount} / ${capacity}';
			case 'location.instanceType': return ({required Object type}) => 'Instance Type: ${type}';
			case 'location.noInfo': return 'No location information available.';
			case 'location.fetchError': return 'Failed to get location information.';
			case 'location.privateLocation': return 'You are in a private location.';
			case 'location.inviteSending': return 'Sending invite...';
			case 'location.inviteSent': return 'Invite sent. You can join from your notifications.';
			case 'location.inviteFailed': return ({required Object error}) => 'Failed to send invite: ${error}';
			case 'location.inviteButton': return 'Send Invite to Myself';
			case 'location.isPrivate': return ({required Object number}) => '${number} in private';
			case 'location.isActive': return ({required Object number}) => '${number} active';
			case 'location.isOffline': return ({required Object number}) => '${number} offline';
			case 'location.isTraveling': return ({required Object number}) => '${number} traveling';
			case 'location.isStaying': return ({required Object number}) => '${number} staying';
			case 'reminder.dialogTitle': return 'Set Reminder';
			case 'reminder.alreadySet': return 'Already Set';
			case 'reminder.set': return 'Set';
			case 'reminder.cancel': return 'Cancel';
			case 'reminder.delete': return 'Delete';
			case 'reminder.deleteAll': return 'Delete All Reminders';
			case 'reminder.deleteAllConfirm': return 'This will delete all set event reminders. This action cannot be undone.';
			case 'reminder.deleted': return 'Reminder deleted.';
			case 'reminder.deletedAll': return 'All reminders deleted.';
			case 'reminder.noReminders': return 'No reminders set.';
			case 'reminder.setFromEvent': return 'You can set notifications from the event page.';
			case 'reminder.eventStart': return ({required Object time}) => 'Starts at ${time}';
			case 'reminder.notifyAt': return ({required Object time, required Object label}) => '${time} (${label})';
			case 'reminder.receiveNotification': return 'When do you want to be notified?';
			case 'friend.sortFilter': return 'Sort & Filter';
			case 'friend.filter': return 'Filter';
			case 'friend.filterAll': return 'Show All';
			case 'friend.filterOnline': return 'Online Only';
			case 'friend.filterOffline': return 'Offline Only';
			case 'friend.filterFavorite': return 'Favorites Only';
			case 'friend.sort': return 'Sort';
			case 'friend.sortStatus': return 'By Status';
			case 'friend.sortName': return 'By Name';
			case 'friend.sortLastLogin': return 'By Last Login';
			case 'friend.sortAsc': return 'Ascending';
			case 'friend.sortDesc': return 'Descending';
			case 'friend.close': return 'Close';
			case 'eventCalendarFilter.filterTitle': return 'Filter Events';
			case 'eventCalendarFilter.clear': return 'Clear';
			case 'eventCalendarFilter.keyword': return 'Keyword Search';
			case 'eventCalendarFilter.keywordHint': return 'Event name, description, organizer, etc.';
			case 'eventCalendarFilter.date': return 'Filter by Date';
			case 'eventCalendarFilter.dateHint': return 'You can display events for a specific date range.';
			case 'eventCalendarFilter.startDate': return 'Start Date';
			case 'eventCalendarFilter.endDate': return 'End Date';
			case 'eventCalendarFilter.select': return 'Please select';
			case 'eventCalendarFilter.time': return 'Filter by Time';
			case 'eventCalendarFilter.timeHint': return 'You can display events held during a specific time frame.';
			case 'eventCalendarFilter.startTime': return 'Start Time';
			case 'eventCalendarFilter.endTime': return 'End Time';
			case 'eventCalendarFilter.genre': return 'Filter by Genre';
			case 'eventCalendarFilter.genreSelected': return ({required Object count}) => '${count} genres selected';
			case 'eventCalendarFilter.apply': return 'Apply';
			case 'eventCalendarFilter.filterSummary': return 'Filters';
			case 'eventCalendarFilter.filterNone': return 'No filters are set.';
			default: return null;
		}
	}
}

