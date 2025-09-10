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
class TranslationsZhTw implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhTw({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZhTw _root = this; // ignore: unused_field

	@override 
	TranslationsZhTw $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhTw(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonZhTw common = _TranslationsCommonZhTw._(_root);
	@override late final _TranslationsTermsAgreementZhTw termsAgreement = _TranslationsTermsAgreementZhTw._(_root);
	@override late final _TranslationsDrawerZhTw drawer = _TranslationsDrawerZhTw._(_root);
	@override late final _TranslationsLoginZhTw login = _TranslationsLoginZhTw._(_root);
	@override late final _TranslationsFriendsZhTw friends = _TranslationsFriendsZhTw._(_root);
	@override late final _TranslationsFriendDetailZhTw friendDetail = _TranslationsFriendDetailZhTw._(_root);
	@override late final _TranslationsSearchZhTw search = _TranslationsSearchZhTw._(_root);
	@override late final _TranslationsProfileZhTw profile = _TranslationsProfileZhTw._(_root);
	@override late final _TranslationsEngageCardZhTw engageCard = _TranslationsEngageCardZhTw._(_root);
	@override late final _TranslationsQrScannerZhTw qrScanner = _TranslationsQrScannerZhTw._(_root);
	@override late final _TranslationsFavoritesZhTw favorites = _TranslationsFavoritesZhTw._(_root);
	@override late final _TranslationsNotificationsZhTw notifications = _TranslationsNotificationsZhTw._(_root);
	@override late final _TranslationsEventCalendarZhTw eventCalendar = _TranslationsEventCalendarZhTw._(_root);
	@override late final _TranslationsAvatarsZhTw avatars = _TranslationsAvatarsZhTw._(_root);
	@override late final _TranslationsWorldDetailZhTw worldDetail = _TranslationsWorldDetailZhTw._(_root);
	@override late final _TranslationsAvatarDetailZhTw avatarDetail = _TranslationsAvatarDetailZhTw._(_root);
	@override late final _TranslationsGroupsZhTw groups = _TranslationsGroupsZhTw._(_root);
	@override late final _TranslationsGroupDetailZhTw groupDetail = _TranslationsGroupDetailZhTw._(_root);
	@override late final _TranslationsInventoryZhTw inventory = _TranslationsInventoryZhTw._(_root);
	@override late final _TranslationsVrcnsyncZhTw vrcnsync = _TranslationsVrcnsyncZhTw._(_root);
	@override late final _TranslationsFeedbackZhTw feedback = _TranslationsFeedbackZhTw._(_root);
	@override late final _TranslationsSettingsZhTw settings = _TranslationsSettingsZhTw._(_root);
	@override late final _TranslationsCreditsZhTw credits = _TranslationsCreditsZhTw._(_root);
	@override late final _TranslationsDownloadZhTw download = _TranslationsDownloadZhTw._(_root);
	@override late final _TranslationsInstanceZhTw instance = _TranslationsInstanceZhTw._(_root);
	@override late final _TranslationsStatusZhTw status = _TranslationsStatusZhTw._(_root);
	@override late final _TranslationsLocationZhTw location = _TranslationsLocationZhTw._(_root);
	@override late final _TranslationsReminderZhTw reminder = _TranslationsReminderZhTw._(_root);
	@override late final _TranslationsFriendZhTw friend = _TranslationsFriendZhTw._(_root);
	@override late final _TranslationsEventCalendarFilterZhTw eventCalendarFilter = _TranslationsEventCalendarFilterZhTw._(_root);
}

// Path: common
class _TranslationsCommonZhTw implements TranslationsCommonJa {
	_TranslationsCommonZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCN';
	@override String get ok => '確定';
	@override String get cancel => '取消';
	@override String get close => '關閉';
	@override String get save => '儲存';
	@override String get edit => '編輯';
	@override String get delete => '刪除';
	@override String get yes => '是';
	@override String get no => '否';
	@override String get loading => '載入中...';
	@override String error({required Object error}) => '發生錯誤：${error}';
	@override String get errorNomessage => '發生錯誤';
	@override String get retry => '重試';
	@override String get search => '搜尋';
	@override String get settings => '設定';
	@override String get confirm => '確認';
	@override String get agree => '同意';
	@override String get decline => '不同意';
	@override String get username => '使用者名稱';
	@override String get password => '密碼';
	@override String get login => '登入';
	@override String get logout => '登出';
	@override String get share => '分享';
}

// Path: termsAgreement
class _TranslationsTermsAgreementZhTw implements TranslationsTermsAgreementJa {
	_TranslationsTermsAgreementZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => '歡迎來到 VRCN';
	@override String get welcomeMessage => '在使用本應用程式前\n請先閱讀服務條款與隱私權政策';
	@override String get termsTitle => '服務條款';
	@override String get termsSubtitle => '關於本應用程式的使用條款';
	@override String get privacyTitle => '隱私權政策';
	@override String get privacySubtitle => '關於個人資訊的處理方式';
	@override String agreeTerms({required Object title}) => '同意「${title}」';
	@override String get checkContent => '查看內容';
	@override String get notice => '本應用程式為 VRChat Inc. 的非官方應用程式。\n與 VRChat Inc. 無任何關聯。';
}

// Path: drawer
class _TranslationsDrawerZhTw implements TranslationsDrawerJa {
	_TranslationsDrawerZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get home => '主頁';
	@override String get profile => '個人資料';
	@override String get favorite => '我的最愛';
	@override String get eventCalendar => '活動日曆';
	@override String get avatar => '虛擬化身';
	@override String get group => '群組';
	@override String get inventory => '物品欄';
	@override String get vrcnsync => 'VRCNSync (β)';
	@override String get review => '評價';
	@override String get feedback => '意見回饋';
	@override String get settings => '設定';
	@override String get userLoading => '正在載入使用者資訊...';
	@override String get userError => '獲取使用者資訊失敗';
	@override String get retry => '重試';
	@override late final _TranslationsDrawerSectionZhTw section = _TranslationsDrawerSectionZhTw._(_root);
}

// Path: login
class _TranslationsLoginZhTw implements TranslationsLoginJa {
	_TranslationsLoginZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get forgotPassword => '忘記密碼？';
	@override String get createAccount => '註冊';
	@override String get subtitle => '使用您的 VRChat 帳號資訊登入';
	@override String get email => '電子郵件地址';
	@override String get emailHint => '輸入電子郵件或使用者名稱';
	@override String get passwordHint => '輸入密碼';
	@override String get rememberMe => '保持登入狀態';
	@override String get loggingIn => '登入中...';
	@override String get errorEmptyEmail => '請輸入使用者名稱或電子郵件地址';
	@override String get errorEmptyPassword => '請輸入密碼';
	@override String get errorLoginFailed => '登入失敗。請檢查您的電子郵件地址和密碼。';
	@override String get twoFactorTitle => '兩步驟驗證';
	@override String get twoFactorSubtitle => '請輸入驗證碼';
	@override String get twoFactorInstruction => '請輸入驗證應用程式中顯示的\n6 位數驗證碼';
	@override String get twoFactorCodeHint => '驗證碼';
	@override String get verify => '驗證';
	@override String get verifying => '驗證中...';
	@override String get errorEmpty2fa => '請輸入驗證碼';
	@override String get error2faFailed => '兩步驟驗證失敗。請確認驗證碼是否正確。';
	@override String get backToLogin => '返回登入畫面';
	@override String get paste => '貼上';
}

// Path: friends
class _TranslationsFriendsZhTw implements TranslationsFriendsJa {
	_TranslationsFriendsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入好友資訊...';
	@override String error({required Object error}) => '獲取好友資訊失敗：${error}';
	@override String get notFound => '找不到好友';
	@override String get private => '私人';
	@override String get active => '在線';
	@override String get offline => '離線';
	@override String get online => '線上';
	@override String get groupTitle => '按世界分組';
	@override String get refresh => '重新整理';
	@override String get searchHint => '按好友名稱搜尋';
	@override String get noResult => '找不到符合的好友';
}

// Path: friendDetail
class _TranslationsFriendDetailZhTw implements TranslationsFriendDetailJa {
	_TranslationsFriendDetailZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入使用者資訊...';
	@override String error({required Object error}) => '獲取使用者資訊失敗：${error}';
	@override String get currentLocation => '目前位置';
	@override String get basicInfo => '基本資訊';
	@override String get userId => '使用者ID';
	@override String get dateJoined => '註冊日期';
	@override String get lastLogin => '最後登入';
	@override String get bio => '個人簡介';
	@override String get links => '連結';
	@override String get loadingLinks => '正在載入連結資訊...';
	@override String get group => '所屬群組';
	@override String get groupDetail => '顯示群組詳細資訊';
	@override String groupCode({required Object code}) => '群組代碼：${code}';
	@override String memberCount({required Object count}) => '成員數：${count}人';
	@override String get unknownGroup => '未知的群組';
	@override String get block => '封鎖';
	@override String get mute => '靜音';
	@override String get openWebsite => '在網站上開啟';
	@override String get shareProfile => '分享個人資料';
	@override String confirmBlockTitle({required Object name}) => '要封鎖 ${name} 嗎？';
	@override String get confirmBlockMessage => '封鎖後，您將不會再收到此使用者的好友邀請或訊息。';
	@override String confirmMuteTitle({required Object name}) => '要將 ${name} 靜音嗎？';
	@override String get confirmMuteMessage => '靜音後，您將聽不到此使用者的聲音。';
	@override String get blockSuccess => '已封鎖';
	@override String get muteSuccess => '已靜音';
	@override String operationFailed({required Object error}) => '操作失敗：${error}';
}

// Path: search
class _TranslationsSearchZhTw implements TranslationsSearchJa {
	_TranslationsSearchZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get userTab => '使用者';
	@override String get worldTab => '世界';
	@override String get avatarTab => '虛擬化身';
	@override String get groupTab => '群組';
	@override late final _TranslationsSearchTabsZhTw tabs = _TranslationsSearchTabsZhTw._(_root);
}

// Path: profile
class _TranslationsProfileZhTw implements TranslationsProfileJa {
	_TranslationsProfileZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '個人資料';
	@override String get edit => '編輯';
	@override String get refresh => '重新整理';
	@override String get loading => '正在載入個人資料...';
	@override String get error => '獲取個人資料失敗：{error}';
	@override String get displayName => '顯示名稱';
	@override String get username => '使用者名稱';
	@override String get userId => '使用者ID';
	@override String get engageCard => '互動名片';
	@override String get frined => '好友';
	@override String get dateJoined => '註冊日期';
	@override String get userType => '使用者類型';
	@override String get status => '狀態';
	@override String get statusMessage => '狀態訊息';
	@override String get bio => '個人簡介';
	@override String get links => '連結';
	@override String get group => '所屬群組';
	@override String get groupDetail => '顯示群組詳細資訊';
	@override String get avatar => '目前的虛擬化身';
	@override String get avatarDetail => '顯示虛擬化身詳細資訊';
	@override String get public => '公開';
	@override String get private => '私人';
	@override String get hidden => '隱藏';
	@override String get unknown => '未知';
	@override String get friends => '好友';
	@override String get loadingLinks => '正在載入連結資訊...';
	@override String get noGroup => '沒有所屬群組';
	@override String get noBio => '沒有個人簡介';
	@override String get noLinks => '沒有連結';
	@override String get save => '儲存變更';
	@override String get saved => '個人資料已更新';
	@override String get saveFailed => '更新失敗：{error}';
	@override String get discardTitle => '要捨棄變更嗎？';
	@override String get discardContent => '您對個人資料所做的變更將不會被儲存。';
	@override String get discardCancel => '取消';
	@override String get discardOk => '捨棄';
	@override String get basic => '基本資訊';
	@override String get pronouns => '代名詞';
	@override String get addLink => '新增';
	@override String get removeLink => '移除';
	@override String get linkHint => '輸入連結（例如：https://twitter.com/username）';
	@override String get linksHint => '連結將顯示在您的個人資料上，點擊即可開啟';
	@override String get statusMessageHint => '輸入您目前的狀況或訊息';
	@override String get bioHint => '寫一些關於您自己的事吧';
}

// Path: engageCard
class _TranslationsEngageCardZhTw implements TranslationsEngageCardJa {
	_TranslationsEngageCardZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get pickBackground => '選擇背景圖片';
	@override String get removeBackground => '移除背景圖片';
	@override String get scanQr => '掃描 QR Code';
	@override String get showAvatar => '顯示虛擬化身';
	@override String get hideAvatar => '隱藏虛擬化身';
	@override String get noBackground => '尚未選擇背景圖片\n可從右上角按鈕進行設定';
	@override String get loading => '載入中...';
	@override String error({required Object error}) => '獲取互動名片資訊失敗：${error}';
	@override String get copyUserId => '複製使用者ID';
	@override String get copied => '已複製';
}

// Path: qrScanner
class _TranslationsQrScannerZhTw implements TranslationsQrScannerJa {
	_TranslationsQrScannerZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '掃描 QR Code';
	@override String get guide => '請將 QR Code 對準框內';
	@override String get loading => '正在初始化相機...';
	@override String error({required Object error}) => '讀取 QR Code 失敗：${error}';
	@override String get notFound => '找不到有效的使用者 QR Code';
}

// Path: favorites
class _TranslationsFavoritesZhTw implements TranslationsFavoritesJa {
	_TranslationsFavoritesZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '我的最愛';
	@override String get frined => '好友';
	@override String get friendsTab => '好友';
	@override String get worldsTab => '世界';
	@override String get avatarsTab => '虛擬化身';
	@override String get emptyFolderTitle => '沒有最愛資料夾';
	@override String get emptyFolderDescription => '請在 VRChat 內建立最愛資料夾';
	@override String get emptyFriends => '此資料夾中沒有好友';
	@override String get emptyWorlds => '此資料夾中沒有世界';
	@override String get emptyAvatars => '此資料夾中沒有虛擬化身';
	@override String get emptyWorldsTabTitle => '沒有最愛的世界';
	@override String get emptyWorldsTabDescription => '您可以從世界詳細資訊畫面將世界加入最愛';
	@override String get emptyAvatarsTabTitle => '沒有最愛的虛擬化身';
	@override String get emptyAvatarsTabDescription => '您可以從虛擬化身詳細資訊畫面將其加入最愛';
	@override String get loading => '正在載入最愛項目...';
	@override String get loadingFolder => '正在載入資料夾資訊...';
	@override String error({required Object error}) => '載入最愛項目失敗：${error}';
	@override String get errorFolder => '獲取資訊失敗';
	@override String get remove => '從最愛中移除';
	@override String removeSuccess({required Object name}) => '已將 ${name} 從最愛中移除';
	@override String removeFailed({required Object error}) => '移除失敗：${error}';
	@override String itemsCount({required Object count}) => '${count} 個項目';
	@override String get public => '公開';
	@override String get private => '私人';
	@override String get hidden => '隱藏';
	@override String get unknown => '未知';
	@override String get loadingError => '載入錯誤';
}

// Path: notifications
class _TranslationsNotificationsZhTw implements TranslationsNotificationsJa {
	_TranslationsNotificationsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '沒有通知';
	@override String get emptyDescription => '好友請求、邀請等\n新通知將會顯示在此處';
	@override String friendRequest({required Object userName}) => '您收到了來自 ${userName} 的好友請求';
	@override String invite({required Object userName, required Object worldName}) => '您收到了 ${userName} 邀請您前往 ${worldName} 的邀請';
	@override String friendOnline({required Object userName}) => '${userName} 已上線';
	@override String friendOffline({required Object userName}) => '${userName} 已離線';
	@override String friendActive({required Object userName}) => '${userName} 變為在線';
	@override String friendAdd({required Object userName}) => '${userName} 已被加為好友';
	@override String friendRemove({required Object userName}) => '${userName} 已被從好友中移除';
	@override String statusUpdate({required Object userName, required Object status, required Object world}) => '${userName} 的狀態已更新：${status}${world}';
	@override String locationChange({required Object userName, required Object worldName}) => '${userName} 已移動至 ${worldName}';
	@override String userUpdate({required Object world}) => '您的資訊已更新${world}';
	@override String myLocationChange({required Object worldName}) => '您的移動：${worldName}';
	@override String requestInvite({required Object userName}) => '您收到了來自 ${userName} 的加入請求';
	@override String votekick({required Object userName}) => '來自 ${userName} 的投票踢除';
	@override String responseReceived({required Object userName}) => '已收到通知ID:${userName}的回應';
	@override String error({required Object worldName}) => '錯誤：${worldName}';
	@override String system({required Object extraData}) => '系統通知：${extraData}';
	@override String secondsAgo({required Object seconds}) => '${seconds}秒前';
	@override String minutesAgo({required Object minutes}) => '${minutes}分鐘前';
	@override String hoursAgo({required Object hours}) => '${hours}小時前';
}

// Path: eventCalendar
class _TranslationsEventCalendarZhTw implements TranslationsEventCalendarJa {
	_TranslationsEventCalendarZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '活動日曆';
	@override String get filter => '篩選活動';
	@override String get refresh => '更新活動資訊';
	@override String get loading => '正在獲取活動資訊...';
	@override String error({required Object error}) => '獲取活動資訊失敗：${error}';
	@override String filterActive({required Object count}) => '篩選條件已啟用（${count}筆）';
	@override String get clear => '清除';
	@override String get noEvents => '沒有符合條件的活動';
	@override String get clearFilter => '清除篩選';
	@override String get today => '今天';
	@override String get reminderSet => '設定提醒';
	@override String get reminderSetDone => '已設定提醒';
	@override String get reminderDeleted => '已刪除提醒';
	@override String get organizer => '主辦方';
	@override String get description => '說明';
	@override String get genre => '類型';
	@override String get condition => '參加條件';
	@override String get way => '參加方法';
	@override String get note => '備註';
	@override String get quest => '支援 Quest';
	@override String reminderCount({required Object count}) => '${count}筆';
	@override String startToEnd({required Object start, required Object end}) => '${start}～${end}';
}

// Path: avatars
class _TranslationsAvatarsZhTw implements TranslationsAvatarsJa {
	_TranslationsAvatarsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '虛擬化身';
	@override String get searchHint => '按虛擬化身名稱等搜尋';
	@override String get searchTooltip => '搜尋';
	@override String get searchEmptyTitle => '找不到搜尋結果';
	@override String get searchEmptyDescription => '請嘗試其他搜尋關鍵字';
	@override String get emptyTitle => '沒有虛擬化身';
	@override String get emptyDescription => '請新增虛擬化身或稍後再試';
	@override String get refresh => '重新整理';
	@override String get loading => '正在載入虛擬化身...';
	@override String error({required Object error}) => '獲取虛擬化身資訊失敗：${error}';
	@override String get current => '使用中';
	@override String get public => '公開';
	@override String get private => '私人';
	@override String get hidden => '隱藏';
	@override String get author => '作者';
	@override String get sortUpdated => '按更新時間';
	@override String get sortName => '按名稱';
	@override String get sortTooltip => '排序';
	@override String get viewModeTooltip => '切換顯示模式';
}

// Path: worldDetail
class _TranslationsWorldDetailZhTw implements TranslationsWorldDetailJa {
	_TranslationsWorldDetailZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入世界資訊...';
	@override String error({required Object error}) => '獲取世界資訊失敗：${error}';
	@override String get share => '分享這個世界';
	@override String get openInVRChat => '在 VRChat 官網開啟';
	@override String get report => '檢舉這個世界';
	@override String get creator => '建立者';
	@override String get created => '建立時間';
	@override String get updated => '更新時間';
	@override String get favorites => '最愛數';
	@override String get visits => '訪問次數';
	@override String get occupants => '目前人數';
	@override String get popularity => '評價';
	@override String get description => '說明';
	@override String get noDescription => '沒有說明';
	@override String get tags => '標籤';
	@override String get joinPublic => '以公開方式傳送邀請';
	@override String get favoriteAdded => '已加入最愛';
	@override String get favoriteRemoved => '已從最愛中移除';
	@override String get unknown => '未知';
}

// Path: avatarDetail
class _TranslationsAvatarDetailZhTw implements TranslationsAvatarDetailJa {
	_TranslationsAvatarDetailZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String changeSuccess({required Object name}) => '已變更為虛擬化身「${name}」';
	@override String changeFailed({required Object error}) => '變更虛擬化身失敗：${error}';
	@override String get changing => '變更中...';
	@override String get useThisAvatar => '使用此虛擬化身';
	@override String get creator => '建立者';
	@override String get created => '建立時間';
	@override String get updated => '更新時間';
	@override String get description => '說明';
	@override String get noDescription => '沒有說明';
	@override String get tags => '標籤';
	@override String get addToFavorites => '加入最愛';
	@override String get public => '公開';
	@override String get private => '私人';
	@override String get hidden => '隱藏';
	@override String get unknown => '未知';
	@override String get share => '分享';
	@override String get loading => '正在載入虛擬化身資訊...';
	@override String error({required Object error}) => '獲取虛擬化身資訊失敗：${error}';
}

// Path: groups
class _TranslationsGroupsZhTw implements TranslationsGroupsJa {
	_TranslationsGroupsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '群組';
	@override String get loadingUser => '正在載入使用者資訊...';
	@override String errorUser({required Object error}) => '獲取使用者資訊失敗：${error}';
	@override String get loadingGroups => '正在載入群組資訊...';
	@override String errorGroups({required Object error}) => '獲取群組資訊失敗：${error}';
	@override String get emptyTitle => '您尚未加入任何群組';
	@override String get emptyDescription => '您可以從 VRChat 應用程式或網站加入群組';
	@override String get searchGroups => '尋找群組';
	@override String members({required Object count}) => '${count} 位成員';
	@override String get showDetails => '顯示詳細資訊';
	@override String get unknownName => '名稱不明';
}

// Path: groupDetail
class _TranslationsGroupDetailZhTw implements TranslationsGroupDetailJa {
	_TranslationsGroupDetailZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入群組資訊...';
	@override String error({required Object error}) => '獲取群組資訊失敗：${error}';
	@override String get share => '分享群組資訊';
	@override String get description => '說明';
	@override String get roles => '角色';
	@override String get basicInfo => '基本資訊';
	@override String get createdAt => '建立日期';
	@override String get owner => '擁有者';
	@override String get rules => '規則';
	@override String get languages => '語言';
	@override String memberCount({required Object count}) => '${count} 位成員';
	@override late final _TranslationsGroupDetailPrivacyZhTw privacy = _TranslationsGroupDetailPrivacyZhTw._(_root);
	@override late final _TranslationsGroupDetailRoleZhTw role = _TranslationsGroupDetailRoleZhTw._(_root);
}

// Path: inventory
class _TranslationsInventoryZhTw implements TranslationsInventoryJa {
	_TranslationsInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '物品欄';
	@override String get gallery => '圖片庫';
	@override String get icon => '圖示';
	@override String get emoji => '表情符號';
	@override String get sticker => '貼圖';
	@override String get print => '列印圖';
	@override String get upload => '上傳檔案';
	@override String get uploadGallery => '正在上傳圖片庫圖片...';
	@override String get uploadIcon => '正在上傳圖示...';
	@override String get uploadEmoji => '正在上傳表情符號...';
	@override String get uploadSticker => '正在上傳貼圖...';
	@override String get uploadPrint => '正在上傳列印圖...';
	@override String get selectImage => '選擇圖片';
	@override String get selectFromGallery => '從圖片庫選擇';
	@override String get takePhoto => '使用相機拍攝';
	@override String get uploadSuccess => '上傳完成';
	@override String get uploadFailed => '上傳失敗';
	@override String get uploadFailedFormat => '檔案格式或大小有問題。請選擇 PNG 格式且小於 1MB 的圖片。';
	@override String get uploadFailedAuth => '驗證失敗。請重新登入。';
	@override String get uploadFailedSize => '檔案大小過大。請選擇較小的圖片。';
	@override String uploadFailedServer({required Object code}) => '發生伺服器錯誤 (${code})';
	@override String pickImageFailed({required Object error}) => '選擇圖片失敗：${error}';
	@override late final _TranslationsInventoryTabsZhTw tabs = _TranslationsInventoryTabsZhTw._(_root);
}

// Path: vrcnsync
class _TranslationsVrcnsyncZhTw implements TranslationsVrcnsyncJa {
	_TranslationsVrcnsyncZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCNSync (β)';
	@override String get betaTitle => 'Beta 版功能';
	@override String get betaDescription => '此功能為開發中的 Beta 版，可能會發生非預期的問題。\n目前僅實作本機版本，若有雲端版需求將會實作。';
	@override String get githubLink => 'VRCNSync 的 GitHub 頁面';
	@override String get openGithub => '開啟 GitHub 頁面';
	@override String get serverRunning => '伺服器執行中';
	@override String get serverStopped => '伺服器已停止';
	@override String get serverRunningDesc => '將來自 PC 的照片儲存到 VRCN 相簿';
	@override String get serverStoppedDesc => '伺服器已停止';
	@override String get photoSaved => '照片已儲存至 VRCN 相簿';
	@override String get photoReceived => '已接收照片（儲存至相簿失敗）';
	@override String get openAlbum => '開啟相簿';
	@override String get permissionErrorIos => '需要存取照片圖庫的權限';
	@override String get permissionErrorAndroid => '需要存取儲存空間的權限';
	@override String get openSettings => '開啟設定';
	@override String initError({required Object error}) => '初始化失敗：${error}';
	@override String get openPhotoAppError => '無法開啟相簿應用程式';
	@override String get serverInfo => '伺服器資訊';
	@override String ip({required Object ip}) => 'IP: ${ip}';
	@override String port({required Object port}) => '連接埠: ${port}';
	@override String address({required Object ip, required Object port}) => '${ip}:${port}';
	@override String get autoSave => '接收到的照片將自動儲存到「VRCN」相簿';
	@override String get usage => '使用方法';
	@override List<dynamic> get usageSteps => [
		_TranslationsVrcnsync$usageSteps$0i0$ZhTw._(_root),
		_TranslationsVrcnsync$usageSteps$0i1$ZhTw._(_root),
		_TranslationsVrcnsync$usageSteps$0i2$ZhTw._(_root),
		_TranslationsVrcnsync$usageSteps$0i3$ZhTw._(_root),
	];
	@override String get stats => '連線狀態';
	@override String get statServer => '伺服器狀態';
	@override String get statServerRunning => '執行中';
	@override String get statServerStopped => '已停止';
	@override String get statNetwork => '網路';
	@override String get statNetworkConnected => '已連線';
	@override String get statNetworkDisconnected => '未連線';
}

// Path: feedback
class _TranslationsFeedbackZhTw implements TranslationsFeedbackJa {
	_TranslationsFeedbackZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '意見回饋';
	@override String get type => '回饋類型';
	@override Map<String, String> get types => {
		'bug': '錯誤回報',
		'feature': '功能請求',
		'improvement': '改善建議',
		'other': '其他',
	};
	@override String get inputTitle => '標題 *';
	@override String get inputTitleHint => '請簡潔地描述';
	@override String get inputDescription => '詳細說明 *';
	@override String get inputDescriptionHint => '請提供詳細說明...';
	@override String get cancel => '取消';
	@override String get send => '傳送';
	@override String get sending => '傳送中...';
	@override String get required => '標題和詳細說明為必填項目';
	@override String get success => '意見回饋已成功傳送，感謝您！';
	@override String get fail => '傳送意見回饋失敗';
}

// Path: settings
class _TranslationsSettingsZhTw implements TranslationsSettingsJa {
	_TranslationsSettingsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外觀';
	@override String get language => '語言';
	@override String get languageDescription => '您可以選擇應用程式的顯示語言';
	@override String get appIcon => '應用程式圖示';
	@override String get appIconDescription => '變更顯示在主畫面的應用程式圖示';
	@override String get contentSettings => '內容設定';
	@override String get searchEnabled => '搜尋功能已啟用';
	@override String get searchDisabled => '搜尋功能已停用';
	@override String get enableSearch => '啟用搜尋功能';
	@override String get enableSearchDescription => '搜尋結果中可能包含色情或暴力內容。';
	@override String get apiSetting => '虛擬化身搜尋 API';
	@override String get apiSettingDescription => '設定虛擬化身搜尋功能的 API';
	@override String get apiSettingSaveUrl => 'URL 已儲存';
	@override String get notSet => '未設定（虛擬化身搜尋功能無法使用）';
	@override String get notifications => '通知設定';
	@override String get eventReminder => '活動提醒';
	@override String get eventReminderDescription => '在設定的活動開始前接收通知';
	@override String get manageReminders => '管理已設定的提醒';
	@override String get manageRemindersDescription => '可以取消或確認通知';
	@override String get dataStorage => '資料與儲存空間';
	@override String get clearCache => '清除快取';
	@override String get clearCacheSuccess => '已清除快取';
	@override String get clearCacheError => '清除快取時發生錯誤';
	@override String cacheSize({required Object size}) => '快取大小：${size}';
	@override String get calculatingCache => '正在計算快取大小...';
	@override String get cacheError => '無法取得快取大小';
	@override String get confirmClearCache => '清除快取將會刪除暫時儲存的圖片和資料。\n\n帳號資訊和應用程式設定不會被刪除。';
	@override String get appInfo => '應用程式資訊';
	@override String get version => '版本';
	@override String get packageName => '套件名稱';
	@override String get credit => '製作群';
	@override String get creditDescription => '開發者與貢獻者資訊';
	@override String get contact => '聯絡我們';
	@override String get contactDescription => '問題回報與意見';
	@override String get privacyPolicy => '隱私權政策';
	@override String get privacyPolicyDescription => '關於個人資訊的處理方式';
	@override String get termsOfService => '服務條款';
	@override String get termsOfServiceDescription => '應用程式的使用條款';
	@override String get openSource => '開源軟體資訊';
	@override String get openSourceDescription => '所使用函式庫等的授權';
	@override String get github => 'GitHub 儲存庫';
	@override String get githubDescription => '查看原始碼';
	@override String get logoutConfirm => '確定要登出嗎？';
	@override String logoutError({required Object error}) => '登出時發生錯誤：${error}';
	@override String get iconChangeNotSupported => '您的裝置不支援變更應用程式圖示';
	@override String get iconChangeFailed => '變更圖示失敗';
	@override String get themeMode => '主題模式';
	@override String get themeModeDescription => '選擇應用程式的顯示主題';
	@override String get themeLight => '淺色';
	@override String get themeSystem => '系統';
	@override String get themeDark => '深色';
	@override String get appIconDefault => '預設';
	@override String get appIconIcon => '圖示';
	@override String get appIconLogo => '標誌';
	@override String get delete => '刪除';
}

// Path: credits
class _TranslationsCreditsZhTw implements TranslationsCreditsJa {
	_TranslationsCreditsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '製作群';
	@override late final _TranslationsCreditsSectionZhTw section = _TranslationsCreditsSectionZhTw._(_root);
}

// Path: download
class _TranslationsDownloadZhTw implements TranslationsDownloadJa {
	_TranslationsDownloadZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get success => '下載完成';
	@override String failure({required Object error}) => '下載失敗：${error}';
	@override String shareFailure({required Object error}) => '分享失敗：${error}';
	@override String get permissionTitle => '需要權限';
	@override String permissionDenied({required Object permissionType}) => '已拒絕存取 ${permissionType} 的權限。\n請從設定應用程式中啟用權限。';
	@override String get permissionCancel => '取消';
	@override String get permissionOpenSettings => '開啟設定';
	@override String get permissionPhoto => '照片';
	@override String get permissionPhotoLibrary => '照片圖庫';
	@override String get permissionStorage => '儲存空間';
	@override String get permissionPhotoRequired => '需要存取照片的權限';
	@override String get permissionPhotoLibraryRequired => '需要存取照片圖庫的權限';
	@override String get permissionStorageRequired => '需要存取儲存空間的權限';
	@override String permissionError({required Object error}) => '檢查權限時發生錯誤：${error}';
	@override String downloading({required Object fileName}) => '正在下載 ${fileName}...';
	@override String sharing({required Object fileName}) => '正在準備分享 ${fileName}...';
}

// Path: instance
class _TranslationsInstanceZhTw implements TranslationsInstanceJa {
	_TranslationsInstanceZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInstanceTypeZhTw type = _TranslationsInstanceTypeZhTw._(_root);
}

// Path: status
class _TranslationsStatusZhTw implements TranslationsStatusJa {
	_TranslationsStatusZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get active => '線上';
	@override String get joinMe => '歡迎加入';
	@override String get askMe => '歡迎詢問';
	@override String get busy => '忙碌中';
	@override String get offline => '離線';
	@override String get unknown => '狀態不明';
}

// Path: location
class _TranslationsLocationZhTw implements TranslationsLocationJa {
	_TranslationsLocationZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get private => '私人';
	@override String playerCount({required Object userCount, required Object capacity}) => '玩家數：${userCount} / ${capacity}';
	@override String instanceType({required Object type}) => '房間類型：${type}';
	@override String get noInfo => '沒有位置資訊';
	@override String get fetchError => '獲取位置資訊失敗';
	@override String get privateLocation => '正在私人場所';
	@override String get inviteSending => '正在傳送邀請...';
	@override String get inviteSent => '已傳送邀請。您可以從通知加入';
	@override String inviteFailed({required Object error}) => '傳送邀請失敗：${error}';
	@override String get inviteButton => '向自己傳送邀請';
	@override String isPrivate({required Object number}) => '${number}人私密';
	@override String isActive({required Object number}) => '${number}人線上';
	@override String isOffline({required Object number}) => '${number}人離線';
	@override String isTraveling({required Object number}) => '${number}人移動中';
	@override String isStaying({required Object number}) => '${number}人停留中';
}

// Path: reminder
class _TranslationsReminderZhTw implements TranslationsReminderJa {
	_TranslationsReminderZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => '設定提醒';
	@override String get alreadySet => '已設定';
	@override String get set => '設定';
	@override String get cancel => '取消';
	@override String get delete => '刪除';
	@override String get deleteAll => '刪除所有提醒';
	@override String get deleteAllConfirm => '您確定要刪除所有已設定的活動提醒嗎？此操作無法復原。';
	@override String get deleted => '已刪除提醒';
	@override String get deletedAll => '已刪除所有提醒';
	@override String get noReminders => '沒有已設定的提醒';
	@override String get setFromEvent => '您可以從活動頁面設定通知';
	@override String eventStart({required Object time}) => '${time} 開始';
	@override String notifyAt({required Object time, required Object label}) => '${time} (${label})';
	@override String get receiveNotification => '您想在何時收到通知？';
}

// Path: friend
class _TranslationsFriendZhTw implements TranslationsFriendJa {
	_TranslationsFriendZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get sortFilter => '排序與篩選';
	@override String get filter => '篩選';
	@override String get filterAll => '顯示全部';
	@override String get filterOnline => '僅線上';
	@override String get filterOffline => '僅離線';
	@override String get filterFavorite => '僅最愛';
	@override String get sort => '排序';
	@override String get sortStatus => '按上線狀態';
	@override String get sortName => '按名稱';
	@override String get sortLastLogin => '按最後登入時間';
	@override String get sortAsc => '遞增';
	@override String get sortDesc => '遞減';
	@override String get close => '關閉';
}

// Path: eventCalendarFilter
class _TranslationsEventCalendarFilterZhTw implements TranslationsEventCalendarFilterJa {
	_TranslationsEventCalendarFilterZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get filterTitle => '篩選活動';
	@override String get clear => '清除';
	@override String get keyword => '關鍵字搜尋';
	@override String get keywordHint => '活動名稱、說明、主辦方等';
	@override String get date => '按日期篩選';
	@override String get dateHint => '可顯示特定日期範圍的活動';
	@override String get startDate => '開始日期';
	@override String get endDate => '結束日期';
	@override String get select => '請選擇';
	@override String get time => '按時段篩選';
	@override String get timeHint => '可顯示在特定時段舉行的活動';
	@override String get startTime => '開始時間';
	@override String get endTime => '結束時間';
	@override String get genre => '按類型篩選';
	@override String genreSelected({required Object count}) => '已選擇 ${count} 個類型';
	@override String get apply => '套用';
	@override String get filterSummary => '篩選條件';
	@override String get filterNone => '未設定篩選條件';
}

// Path: drawer.section
class _TranslationsDrawerSectionZhTw implements TranslationsDrawerSectionJa {
	_TranslationsDrawerSectionZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get content => '內容';
	@override String get other => '其他';
}

// Path: search.tabs
class _TranslationsSearchTabsZhTw implements TranslationsSearchTabsJa {
	_TranslationsSearchTabsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSearchTabsUserSearchZhTw userSearch = _TranslationsSearchTabsUserSearchZhTw._(_root);
	@override late final _TranslationsSearchTabsWorldSearchZhTw worldSearch = _TranslationsSearchTabsWorldSearchZhTw._(_root);
	@override late final _TranslationsSearchTabsGroupSearchZhTw groupSearch = _TranslationsSearchTabsGroupSearchZhTw._(_root);
	@override late final _TranslationsSearchTabsAvatarSearchZhTw avatarSearch = _TranslationsSearchTabsAvatarSearchZhTw._(_root);
}

// Path: groupDetail.privacy
class _TranslationsGroupDetailPrivacyZhTw implements TranslationsGroupDetailPrivacyJa {
	_TranslationsGroupDetailPrivacyZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get public => '公開';
	@override String get private => '私人';
	@override String get friends => '好友';
	@override String get invite => '邀請制';
	@override String get unknown => '未知';
}

// Path: groupDetail.role
class _TranslationsGroupDetailRoleZhTw implements TranslationsGroupDetailRoleJa {
	_TranslationsGroupDetailRoleZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get admin => '管理員';
	@override String get moderator => '版主';
	@override String get member => '成員';
	@override String get unknown => '未知';
}

// Path: inventory.tabs
class _TranslationsInventoryTabsZhTw implements TranslationsInventoryTabsJa {
	_TranslationsInventoryTabsZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInventoryTabsEmojiInventoryZhTw emojiInventory = _TranslationsInventoryTabsEmojiInventoryZhTw._(_root);
	@override late final _TranslationsInventoryTabsGalleryInventoryZhTw galleryInventory = _TranslationsInventoryTabsGalleryInventoryZhTw._(_root);
	@override late final _TranslationsInventoryTabsIconInventoryZhTw iconInventory = _TranslationsInventoryTabsIconInventoryZhTw._(_root);
	@override late final _TranslationsInventoryTabsPrintInventoryZhTw printInventory = _TranslationsInventoryTabsPrintInventoryZhTw._(_root);
	@override late final _TranslationsInventoryTabsStickerInventoryZhTw stickerInventory = _TranslationsInventoryTabsStickerInventoryZhTw._(_root);
}

// Path: vrcnsync.usageSteps.0
class _TranslationsVrcnsync$usageSteps$0i0$ZhTw implements TranslationsVrcnsync$usageSteps$0i0$Ja {
	_TranslationsVrcnsync$usageSteps$0i0$ZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '在 PC 上啟動 VRCNSync 應用程式';
	@override String get desc => '請在您的 PC 上啟動 VRCNSync 應用程式';
}

// Path: vrcnsync.usageSteps.1
class _TranslationsVrcnsync$usageSteps$0i1$ZhTw implements TranslationsVrcnsync$usageSteps$0i1$Ja {
	_TranslationsVrcnsync$usageSteps$0i1$ZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '連接到相同的 WiFi 網路';
	@override String get desc => '請將您的 PC 和行動裝置連接到相同的 WiFi 網路';
}

// Path: vrcnsync.usageSteps.2
class _TranslationsVrcnsync$usageSteps$0i2$ZhTw implements TranslationsVrcnsync$usageSteps$0i2$Ja {
	_TranslationsVrcnsync$usageSteps$0i2$ZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '指定行動裝置為連線目標';
	@override String get desc => '請在 PC 應用程式中指定上述的 IP 位址和連接埠';
}

// Path: vrcnsync.usageSteps.3
class _TranslationsVrcnsync$usageSteps$0i3$ZhTw implements TranslationsVrcnsync$usageSteps$0i3$Ja {
	_TranslationsVrcnsync$usageSteps$0i3$ZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '傳送照片';
	@override String get desc => '從 PC 傳送照片後，將自動儲存到 VRCN 相簿';
}

// Path: credits.section
class _TranslationsCreditsSectionZhTw implements TranslationsCreditsSectionJa {
	_TranslationsCreditsSectionZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get development => '開發';
	@override String get iconPeople => '有趣的圖示貢獻者們';
	@override String get testFeedback => '測試與意見回饋';
	@override String get specialThanks => '特別感謝';
}

// Path: instance.type
class _TranslationsInstanceTypeZhTw implements TranslationsInstanceTypeJa {
	_TranslationsInstanceTypeZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get public => '公開';
	@override String get hidden => '好友+';
	@override String get friends => '好友';
	@override String get private => '邀請+';
	@override String get unknown => '未知';
}

// Path: search.tabs.userSearch
class _TranslationsSearchTabsUserSearchZhTw implements TranslationsSearchTabsUserSearchJa {
	_TranslationsSearchTabsUserSearchZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '搜尋使用者';
	@override String get emptyDescription => '您可以使用使用者名稱或ID進行搜尋';
	@override String get searching => '搜尋中...';
	@override String get noResults => '找不到符合的使用者';
	@override String error({required Object error}) => '搜尋使用者時發生錯誤：${error}';
	@override String get inputPlaceholder => '輸入使用者名稱或ID';
}

// Path: search.tabs.worldSearch
class _TranslationsSearchTabsWorldSearchZhTw implements TranslationsSearchTabsWorldSearchJa {
	_TranslationsSearchTabsWorldSearchZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '探索世界';
	@override String get emptyDescription => '請輸入關鍵字進行搜尋';
	@override String get searching => '搜尋中...';
	@override String get noResults => '找不到符合的世界';
	@override String noResultsWithQuery({required Object query}) => '找不到與「${query}」相符的世界';
	@override String get noResultsHint => '試試更換搜尋關鍵字吧';
	@override String error({required Object error}) => '搜尋世界時發生錯誤：${error}';
	@override String resultCount({required Object count}) => '找到了 ${count} 個世界';
	@override String authorPrefix({required Object authorName}) => '作者 ${authorName}';
	@override String get listView => '列表視圖';
	@override String get gridView => '網格視圖';
}

// Path: search.tabs.groupSearch
class _TranslationsSearchTabsGroupSearchZhTw implements TranslationsSearchTabsGroupSearchJa {
	_TranslationsSearchTabsGroupSearchZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '搜尋群組';
	@override String get emptyDescription => '請輸入關鍵字進行搜尋';
	@override String get searching => '搜尋中...';
	@override String get noResults => '找不到符合的群組';
	@override String noResultsWithQuery({required Object query}) => '找不到與「${query}」相符的群組';
	@override String get noResultsHint => '試試更換搜尋關鍵字吧';
	@override String error({required Object error}) => '搜尋群組時發生錯誤：${error}';
	@override String resultCount({required Object count}) => '找到了 ${count} 個群組';
	@override String get listView => '列表視圖';
	@override String get gridView => '網格視圖';
	@override String memberCount({required Object count}) => '${count} 位成員';
}

// Path: search.tabs.avatarSearch
class _TranslationsSearchTabsAvatarSearchZhTw implements TranslationsSearchTabsAvatarSearchJa {
	_TranslationsSearchTabsAvatarSearchZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get avatar => '虛擬化身';
	@override String get emptyTitle => '搜尋虛擬化身';
	@override String get emptyDescription => '請輸入關鍵字進行搜尋';
	@override String get searching => '正在搜尋虛擬化身...';
	@override String get noResults => '找不到搜尋結果';
	@override String get noResultsHint => '試試用其他關鍵字搜尋';
	@override String error({required Object error}) => '搜尋虛擬化身時發生錯誤：${error}';
}

// Path: inventory.tabs.emojiInventory
class _TranslationsInventoryTabsEmojiInventoryZhTw implements TranslationsInventoryTabsEmojiInventoryJa {
	_TranslationsInventoryTabsEmojiInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入表情符號...';
	@override String error({required Object error}) => '獲取表情符號失敗：${error}';
	@override String get emptyTitle => '沒有表情符號';
	@override String get emptyDescription => '在 VRChat 上傳的表情符號會顯示在這裡';
	@override String get zoomHint => '雙擊放大';
}

// Path: inventory.tabs.galleryInventory
class _TranslationsInventoryTabsGalleryInventoryZhTw implements TranslationsInventoryTabsGalleryInventoryJa {
	_TranslationsInventoryTabsGalleryInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入圖片庫...';
	@override String error({required Object error}) => '獲取圖片庫失敗：${error}';
	@override String get emptyTitle => '沒有圖片庫';
	@override String get emptyDescription => '在 VRChat 上傳的圖片庫會顯示在這裡';
	@override String get zoomHint => '雙擊放大';
}

// Path: inventory.tabs.iconInventory
class _TranslationsInventoryTabsIconInventoryZhTw implements TranslationsInventoryTabsIconInventoryJa {
	_TranslationsInventoryTabsIconInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入圖示...';
	@override String error({required Object error}) => '獲取圖示失敗：${error}';
	@override String get emptyTitle => '沒有圖示';
	@override String get emptyDescription => '在 VRChat 上傳的圖示會顯示在這裡';
	@override String get zoomHint => '雙擊放大';
}

// Path: inventory.tabs.printInventory
class _TranslationsInventoryTabsPrintInventoryZhTw implements TranslationsInventoryTabsPrintInventoryJa {
	_TranslationsInventoryTabsPrintInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入列印圖...';
	@override String error({required Object error}) => '獲取列印圖失敗：${error}';
	@override String get emptyTitle => '沒有列印圖';
	@override String get emptyDescription => '在 VRChat 上傳的列印圖會顯示在這裡';
	@override String get zoomHint => '雙擊放大';
}

// Path: inventory.tabs.stickerInventory
class _TranslationsInventoryTabsStickerInventoryZhTw implements TranslationsInventoryTabsStickerInventoryJa {
	_TranslationsInventoryTabsStickerInventoryZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入貼圖...';
	@override String error({required Object error}) => '獲取貼圖失敗：${error}';
	@override String get emptyTitle => '沒有貼圖';
	@override String get emptyDescription => '在 VRChat 上傳的貼圖會顯示在這裡';
	@override String get zoomHint => '雙擊放大';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsZhTw {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'common.title': return 'VRCN';
			case 'common.ok': return '確定';
			case 'common.cancel': return '取消';
			case 'common.close': return '關閉';
			case 'common.save': return '儲存';
			case 'common.edit': return '編輯';
			case 'common.delete': return '刪除';
			case 'common.yes': return '是';
			case 'common.no': return '否';
			case 'common.loading': return '載入中...';
			case 'common.error': return ({required Object error}) => '發生錯誤：${error}';
			case 'common.errorNomessage': return '發生錯誤';
			case 'common.retry': return '重試';
			case 'common.search': return '搜尋';
			case 'common.settings': return '設定';
			case 'common.confirm': return '確認';
			case 'common.agree': return '同意';
			case 'common.decline': return '不同意';
			case 'common.username': return '使用者名稱';
			case 'common.password': return '密碼';
			case 'common.login': return '登入';
			case 'common.logout': return '登出';
			case 'common.share': return '分享';
			case 'termsAgreement.welcomeTitle': return '歡迎來到 VRCN';
			case 'termsAgreement.welcomeMessage': return '在使用本應用程式前\n請先閱讀服務條款與隱私權政策';
			case 'termsAgreement.termsTitle': return '服務條款';
			case 'termsAgreement.termsSubtitle': return '關於本應用程式的使用條款';
			case 'termsAgreement.privacyTitle': return '隱私權政策';
			case 'termsAgreement.privacySubtitle': return '關於個人資訊的處理方式';
			case 'termsAgreement.agreeTerms': return ({required Object title}) => '同意「${title}」';
			case 'termsAgreement.checkContent': return '查看內容';
			case 'termsAgreement.notice': return '本應用程式為 VRChat Inc. 的非官方應用程式。\n與 VRChat Inc. 無任何關聯。';
			case 'drawer.home': return '主頁';
			case 'drawer.profile': return '個人資料';
			case 'drawer.favorite': return '我的最愛';
			case 'drawer.eventCalendar': return '活動日曆';
			case 'drawer.avatar': return '虛擬化身';
			case 'drawer.group': return '群組';
			case 'drawer.inventory': return '物品欄';
			case 'drawer.vrcnsync': return 'VRCNSync (β)';
			case 'drawer.review': return '評價';
			case 'drawer.feedback': return '意見回饋';
			case 'drawer.settings': return '設定';
			case 'drawer.userLoading': return '正在載入使用者資訊...';
			case 'drawer.userError': return '獲取使用者資訊失敗';
			case 'drawer.retry': return '重試';
			case 'drawer.section.content': return '內容';
			case 'drawer.section.other': return '其他';
			case 'login.forgotPassword': return '忘記密碼？';
			case 'login.createAccount': return '註冊';
			case 'login.subtitle': return '使用您的 VRChat 帳號資訊登入';
			case 'login.email': return '電子郵件地址';
			case 'login.emailHint': return '輸入電子郵件或使用者名稱';
			case 'login.passwordHint': return '輸入密碼';
			case 'login.rememberMe': return '保持登入狀態';
			case 'login.loggingIn': return '登入中...';
			case 'login.errorEmptyEmail': return '請輸入使用者名稱或電子郵件地址';
			case 'login.errorEmptyPassword': return '請輸入密碼';
			case 'login.errorLoginFailed': return '登入失敗。請檢查您的電子郵件地址和密碼。';
			case 'login.twoFactorTitle': return '兩步驟驗證';
			case 'login.twoFactorSubtitle': return '請輸入驗證碼';
			case 'login.twoFactorInstruction': return '請輸入驗證應用程式中顯示的\n6 位數驗證碼';
			case 'login.twoFactorCodeHint': return '驗證碼';
			case 'login.verify': return '驗證';
			case 'login.verifying': return '驗證中...';
			case 'login.errorEmpty2fa': return '請輸入驗證碼';
			case 'login.error2faFailed': return '兩步驟驗證失敗。請確認驗證碼是否正確。';
			case 'login.backToLogin': return '返回登入畫面';
			case 'login.paste': return '貼上';
			case 'friends.loading': return '正在載入好友資訊...';
			case 'friends.error': return ({required Object error}) => '獲取好友資訊失敗：${error}';
			case 'friends.notFound': return '找不到好友';
			case 'friends.private': return '私人';
			case 'friends.active': return '在線';
			case 'friends.offline': return '離線';
			case 'friends.online': return '線上';
			case 'friends.groupTitle': return '按世界分組';
			case 'friends.refresh': return '重新整理';
			case 'friends.searchHint': return '按好友名稱搜尋';
			case 'friends.noResult': return '找不到符合的好友';
			case 'friendDetail.loading': return '正在載入使用者資訊...';
			case 'friendDetail.error': return ({required Object error}) => '獲取使用者資訊失敗：${error}';
			case 'friendDetail.currentLocation': return '目前位置';
			case 'friendDetail.basicInfo': return '基本資訊';
			case 'friendDetail.userId': return '使用者ID';
			case 'friendDetail.dateJoined': return '註冊日期';
			case 'friendDetail.lastLogin': return '最後登入';
			case 'friendDetail.bio': return '個人簡介';
			case 'friendDetail.links': return '連結';
			case 'friendDetail.loadingLinks': return '正在載入連結資訊...';
			case 'friendDetail.group': return '所屬群組';
			case 'friendDetail.groupDetail': return '顯示群組詳細資訊';
			case 'friendDetail.groupCode': return ({required Object code}) => '群組代碼：${code}';
			case 'friendDetail.memberCount': return ({required Object count}) => '成員數：${count}人';
			case 'friendDetail.unknownGroup': return '未知的群組';
			case 'friendDetail.block': return '封鎖';
			case 'friendDetail.mute': return '靜音';
			case 'friendDetail.openWebsite': return '在網站上開啟';
			case 'friendDetail.shareProfile': return '分享個人資料';
			case 'friendDetail.confirmBlockTitle': return ({required Object name}) => '要封鎖 ${name} 嗎？';
			case 'friendDetail.confirmBlockMessage': return '封鎖後，您將不會再收到此使用者的好友邀請或訊息。';
			case 'friendDetail.confirmMuteTitle': return ({required Object name}) => '要將 ${name} 靜音嗎？';
			case 'friendDetail.confirmMuteMessage': return '靜音後，您將聽不到此使用者的聲音。';
			case 'friendDetail.blockSuccess': return '已封鎖';
			case 'friendDetail.muteSuccess': return '已靜音';
			case 'friendDetail.operationFailed': return ({required Object error}) => '操作失敗：${error}';
			case 'search.userTab': return '使用者';
			case 'search.worldTab': return '世界';
			case 'search.avatarTab': return '虛擬化身';
			case 'search.groupTab': return '群組';
			case 'search.tabs.userSearch.emptyTitle': return '搜尋使用者';
			case 'search.tabs.userSearch.emptyDescription': return '您可以使用使用者名稱或ID進行搜尋';
			case 'search.tabs.userSearch.searching': return '搜尋中...';
			case 'search.tabs.userSearch.noResults': return '找不到符合的使用者';
			case 'search.tabs.userSearch.error': return ({required Object error}) => '搜尋使用者時發生錯誤：${error}';
			case 'search.tabs.userSearch.inputPlaceholder': return '輸入使用者名稱或ID';
			case 'search.tabs.worldSearch.emptyTitle': return '探索世界';
			case 'search.tabs.worldSearch.emptyDescription': return '請輸入關鍵字進行搜尋';
			case 'search.tabs.worldSearch.searching': return '搜尋中...';
			case 'search.tabs.worldSearch.noResults': return '找不到符合的世界';
			case 'search.tabs.worldSearch.noResultsWithQuery': return ({required Object query}) => '找不到與「${query}」相符的世界';
			case 'search.tabs.worldSearch.noResultsHint': return '試試更換搜尋關鍵字吧';
			case 'search.tabs.worldSearch.error': return ({required Object error}) => '搜尋世界時發生錯誤：${error}';
			case 'search.tabs.worldSearch.resultCount': return ({required Object count}) => '找到了 ${count} 個世界';
			case 'search.tabs.worldSearch.authorPrefix': return ({required Object authorName}) => '作者 ${authorName}';
			case 'search.tabs.worldSearch.listView': return '列表視圖';
			case 'search.tabs.worldSearch.gridView': return '網格視圖';
			case 'search.tabs.groupSearch.emptyTitle': return '搜尋群組';
			case 'search.tabs.groupSearch.emptyDescription': return '請輸入關鍵字進行搜尋';
			case 'search.tabs.groupSearch.searching': return '搜尋中...';
			case 'search.tabs.groupSearch.noResults': return '找不到符合的群組';
			case 'search.tabs.groupSearch.noResultsWithQuery': return ({required Object query}) => '找不到與「${query}」相符的群組';
			case 'search.tabs.groupSearch.noResultsHint': return '試試更換搜尋關鍵字吧';
			case 'search.tabs.groupSearch.error': return ({required Object error}) => '搜尋群組時發生錯誤：${error}';
			case 'search.tabs.groupSearch.resultCount': return ({required Object count}) => '找到了 ${count} 個群組';
			case 'search.tabs.groupSearch.listView': return '列表視圖';
			case 'search.tabs.groupSearch.gridView': return '網格視圖';
			case 'search.tabs.groupSearch.memberCount': return ({required Object count}) => '${count} 位成員';
			case 'search.tabs.avatarSearch.avatar': return '虛擬化身';
			case 'search.tabs.avatarSearch.emptyTitle': return '搜尋虛擬化身';
			case 'search.tabs.avatarSearch.emptyDescription': return '請輸入關鍵字進行搜尋';
			case 'search.tabs.avatarSearch.searching': return '正在搜尋虛擬化身...';
			case 'search.tabs.avatarSearch.noResults': return '找不到搜尋結果';
			case 'search.tabs.avatarSearch.noResultsHint': return '試試用其他關鍵字搜尋';
			case 'search.tabs.avatarSearch.error': return ({required Object error}) => '搜尋虛擬化身時發生錯誤：${error}';
			case 'profile.title': return '個人資料';
			case 'profile.edit': return '編輯';
			case 'profile.refresh': return '重新整理';
			case 'profile.loading': return '正在載入個人資料...';
			case 'profile.error': return '獲取個人資料失敗：{error}';
			case 'profile.displayName': return '顯示名稱';
			case 'profile.username': return '使用者名稱';
			case 'profile.userId': return '使用者ID';
			case 'profile.engageCard': return '互動名片';
			case 'profile.frined': return '好友';
			case 'profile.dateJoined': return '註冊日期';
			case 'profile.userType': return '使用者類型';
			case 'profile.status': return '狀態';
			case 'profile.statusMessage': return '狀態訊息';
			case 'profile.bio': return '個人簡介';
			case 'profile.links': return '連結';
			case 'profile.group': return '所屬群組';
			case 'profile.groupDetail': return '顯示群組詳細資訊';
			case 'profile.avatar': return '目前的虛擬化身';
			case 'profile.avatarDetail': return '顯示虛擬化身詳細資訊';
			case 'profile.public': return '公開';
			case 'profile.private': return '私人';
			case 'profile.hidden': return '隱藏';
			case 'profile.unknown': return '未知';
			case 'profile.friends': return '好友';
			case 'profile.loadingLinks': return '正在載入連結資訊...';
			case 'profile.noGroup': return '沒有所屬群組';
			case 'profile.noBio': return '沒有個人簡介';
			case 'profile.noLinks': return '沒有連結';
			case 'profile.save': return '儲存變更';
			case 'profile.saved': return '個人資料已更新';
			case 'profile.saveFailed': return '更新失敗：{error}';
			case 'profile.discardTitle': return '要捨棄變更嗎？';
			case 'profile.discardContent': return '您對個人資料所做的變更將不會被儲存。';
			case 'profile.discardCancel': return '取消';
			case 'profile.discardOk': return '捨棄';
			case 'profile.basic': return '基本資訊';
			case 'profile.pronouns': return '代名詞';
			case 'profile.addLink': return '新增';
			case 'profile.removeLink': return '移除';
			case 'profile.linkHint': return '輸入連結（例如：https://twitter.com/username）';
			case 'profile.linksHint': return '連結將顯示在您的個人資料上，點擊即可開啟';
			case 'profile.statusMessageHint': return '輸入您目前的狀況或訊息';
			case 'profile.bioHint': return '寫一些關於您自己的事吧';
			case 'engageCard.pickBackground': return '選擇背景圖片';
			case 'engageCard.removeBackground': return '移除背景圖片';
			case 'engageCard.scanQr': return '掃描 QR Code';
			case 'engageCard.showAvatar': return '顯示虛擬化身';
			case 'engageCard.hideAvatar': return '隱藏虛擬化身';
			case 'engageCard.noBackground': return '尚未選擇背景圖片\n可從右上角按鈕進行設定';
			case 'engageCard.loading': return '載入中...';
			case 'engageCard.error': return ({required Object error}) => '獲取互動名片資訊失敗：${error}';
			case 'engageCard.copyUserId': return '複製使用者ID';
			case 'engageCard.copied': return '已複製';
			case 'qrScanner.title': return '掃描 QR Code';
			case 'qrScanner.guide': return '請將 QR Code 對準框內';
			case 'qrScanner.loading': return '正在初始化相機...';
			case 'qrScanner.error': return ({required Object error}) => '讀取 QR Code 失敗：${error}';
			case 'qrScanner.notFound': return '找不到有效的使用者 QR Code';
			case 'favorites.title': return '我的最愛';
			case 'favorites.frined': return '好友';
			case 'favorites.friendsTab': return '好友';
			case 'favorites.worldsTab': return '世界';
			case 'favorites.avatarsTab': return '虛擬化身';
			case 'favorites.emptyFolderTitle': return '沒有最愛資料夾';
			case 'favorites.emptyFolderDescription': return '請在 VRChat 內建立最愛資料夾';
			case 'favorites.emptyFriends': return '此資料夾中沒有好友';
			case 'favorites.emptyWorlds': return '此資料夾中沒有世界';
			case 'favorites.emptyAvatars': return '此資料夾中沒有虛擬化身';
			case 'favorites.emptyWorldsTabTitle': return '沒有最愛的世界';
			case 'favorites.emptyWorldsTabDescription': return '您可以從世界詳細資訊畫面將世界加入最愛';
			case 'favorites.emptyAvatarsTabTitle': return '沒有最愛的虛擬化身';
			case 'favorites.emptyAvatarsTabDescription': return '您可以從虛擬化身詳細資訊畫面將其加入最愛';
			case 'favorites.loading': return '正在載入最愛項目...';
			case 'favorites.loadingFolder': return '正在載入資料夾資訊...';
			case 'favorites.error': return ({required Object error}) => '載入最愛項目失敗：${error}';
			case 'favorites.errorFolder': return '獲取資訊失敗';
			case 'favorites.remove': return '從最愛中移除';
			case 'favorites.removeSuccess': return ({required Object name}) => '已將 ${name} 從最愛中移除';
			case 'favorites.removeFailed': return ({required Object error}) => '移除失敗：${error}';
			case 'favorites.itemsCount': return ({required Object count}) => '${count} 個項目';
			case 'favorites.public': return '公開';
			case 'favorites.private': return '私人';
			case 'favorites.hidden': return '隱藏';
			case 'favorites.unknown': return '未知';
			case 'favorites.loadingError': return '載入錯誤';
			case 'notifications.emptyTitle': return '沒有通知';
			case 'notifications.emptyDescription': return '好友請求、邀請等\n新通知將會顯示在此處';
			case 'notifications.friendRequest': return ({required Object userName}) => '您收到了來自 ${userName} 的好友請求';
			case 'notifications.invite': return ({required Object userName, required Object worldName}) => '您收到了 ${userName} 邀請您前往 ${worldName} 的邀請';
			case 'notifications.friendOnline': return ({required Object userName}) => '${userName} 已上線';
			case 'notifications.friendOffline': return ({required Object userName}) => '${userName} 已離線';
			case 'notifications.friendActive': return ({required Object userName}) => '${userName} 變為在線';
			case 'notifications.friendAdd': return ({required Object userName}) => '${userName} 已被加為好友';
			case 'notifications.friendRemove': return ({required Object userName}) => '${userName} 已被從好友中移除';
			case 'notifications.statusUpdate': return ({required Object userName, required Object status, required Object world}) => '${userName} 的狀態已更新：${status}${world}';
			case 'notifications.locationChange': return ({required Object userName, required Object worldName}) => '${userName} 已移動至 ${worldName}';
			case 'notifications.userUpdate': return ({required Object world}) => '您的資訊已更新${world}';
			case 'notifications.myLocationChange': return ({required Object worldName}) => '您的移動：${worldName}';
			case 'notifications.requestInvite': return ({required Object userName}) => '您收到了來自 ${userName} 的加入請求';
			case 'notifications.votekick': return ({required Object userName}) => '來自 ${userName} 的投票踢除';
			case 'notifications.responseReceived': return ({required Object userName}) => '已收到通知ID:${userName}的回應';
			case 'notifications.error': return ({required Object worldName}) => '錯誤：${worldName}';
			case 'notifications.system': return ({required Object extraData}) => '系統通知：${extraData}';
			case 'notifications.secondsAgo': return ({required Object seconds}) => '${seconds}秒前';
			case 'notifications.minutesAgo': return ({required Object minutes}) => '${minutes}分鐘前';
			case 'notifications.hoursAgo': return ({required Object hours}) => '${hours}小時前';
			case 'eventCalendar.title': return '活動日曆';
			case 'eventCalendar.filter': return '篩選活動';
			case 'eventCalendar.refresh': return '更新活動資訊';
			case 'eventCalendar.loading': return '正在獲取活動資訊...';
			case 'eventCalendar.error': return ({required Object error}) => '獲取活動資訊失敗：${error}';
			case 'eventCalendar.filterActive': return ({required Object count}) => '篩選條件已啟用（${count}筆）';
			case 'eventCalendar.clear': return '清除';
			case 'eventCalendar.noEvents': return '沒有符合條件的活動';
			case 'eventCalendar.clearFilter': return '清除篩選';
			case 'eventCalendar.today': return '今天';
			case 'eventCalendar.reminderSet': return '設定提醒';
			case 'eventCalendar.reminderSetDone': return '已設定提醒';
			case 'eventCalendar.reminderDeleted': return '已刪除提醒';
			case 'eventCalendar.organizer': return '主辦方';
			case 'eventCalendar.description': return '說明';
			case 'eventCalendar.genre': return '類型';
			case 'eventCalendar.condition': return '參加條件';
			case 'eventCalendar.way': return '參加方法';
			case 'eventCalendar.note': return '備註';
			case 'eventCalendar.quest': return '支援 Quest';
			case 'eventCalendar.reminderCount': return ({required Object count}) => '${count}筆';
			case 'eventCalendar.startToEnd': return ({required Object start, required Object end}) => '${start}～${end}';
			case 'avatars.title': return '虛擬化身';
			case 'avatars.searchHint': return '按虛擬化身名稱等搜尋';
			case 'avatars.searchTooltip': return '搜尋';
			case 'avatars.searchEmptyTitle': return '找不到搜尋結果';
			case 'avatars.searchEmptyDescription': return '請嘗試其他搜尋關鍵字';
			case 'avatars.emptyTitle': return '沒有虛擬化身';
			case 'avatars.emptyDescription': return '請新增虛擬化身或稍後再試';
			case 'avatars.refresh': return '重新整理';
			case 'avatars.loading': return '正在載入虛擬化身...';
			case 'avatars.error': return ({required Object error}) => '獲取虛擬化身資訊失敗：${error}';
			case 'avatars.current': return '使用中';
			case 'avatars.public': return '公開';
			case 'avatars.private': return '私人';
			case 'avatars.hidden': return '隱藏';
			case 'avatars.author': return '作者';
			case 'avatars.sortUpdated': return '按更新時間';
			case 'avatars.sortName': return '按名稱';
			case 'avatars.sortTooltip': return '排序';
			case 'avatars.viewModeTooltip': return '切換顯示模式';
			case 'worldDetail.loading': return '正在載入世界資訊...';
			case 'worldDetail.error': return ({required Object error}) => '獲取世界資訊失敗：${error}';
			case 'worldDetail.share': return '分享這個世界';
			case 'worldDetail.openInVRChat': return '在 VRChat 官網開啟';
			case 'worldDetail.report': return '檢舉這個世界';
			case 'worldDetail.creator': return '建立者';
			case 'worldDetail.created': return '建立時間';
			case 'worldDetail.updated': return '更新時間';
			case 'worldDetail.favorites': return '最愛數';
			case 'worldDetail.visits': return '訪問次數';
			case 'worldDetail.occupants': return '目前人數';
			case 'worldDetail.popularity': return '評價';
			case 'worldDetail.description': return '說明';
			case 'worldDetail.noDescription': return '沒有說明';
			case 'worldDetail.tags': return '標籤';
			case 'worldDetail.joinPublic': return '以公開方式傳送邀請';
			case 'worldDetail.favoriteAdded': return '已加入最愛';
			case 'worldDetail.favoriteRemoved': return '已從最愛中移除';
			case 'worldDetail.unknown': return '未知';
			case 'avatarDetail.changeSuccess': return ({required Object name}) => '已變更為虛擬化身「${name}」';
			case 'avatarDetail.changeFailed': return ({required Object error}) => '變更虛擬化身失敗：${error}';
			case 'avatarDetail.changing': return '變更中...';
			case 'avatarDetail.useThisAvatar': return '使用此虛擬化身';
			case 'avatarDetail.creator': return '建立者';
			case 'avatarDetail.created': return '建立時間';
			case 'avatarDetail.updated': return '更新時間';
			case 'avatarDetail.description': return '說明';
			case 'avatarDetail.noDescription': return '沒有說明';
			case 'avatarDetail.tags': return '標籤';
			case 'avatarDetail.addToFavorites': return '加入最愛';
			case 'avatarDetail.public': return '公開';
			case 'avatarDetail.private': return '私人';
			case 'avatarDetail.hidden': return '隱藏';
			case 'avatarDetail.unknown': return '未知';
			case 'avatarDetail.share': return '分享';
			case 'avatarDetail.loading': return '正在載入虛擬化身資訊...';
			case 'avatarDetail.error': return ({required Object error}) => '獲取虛擬化身資訊失敗：${error}';
			case 'groups.title': return '群組';
			case 'groups.loadingUser': return '正在載入使用者資訊...';
			case 'groups.errorUser': return ({required Object error}) => '獲取使用者資訊失敗：${error}';
			case 'groups.loadingGroups': return '正在載入群組資訊...';
			case 'groups.errorGroups': return ({required Object error}) => '獲取群組資訊失敗：${error}';
			case 'groups.emptyTitle': return '您尚未加入任何群組';
			case 'groups.emptyDescription': return '您可以從 VRChat 應用程式或網站加入群組';
			case 'groups.searchGroups': return '尋找群組';
			case 'groups.members': return ({required Object count}) => '${count} 位成員';
			case 'groups.showDetails': return '顯示詳細資訊';
			case 'groups.unknownName': return '名稱不明';
			case 'groupDetail.loading': return '正在載入群組資訊...';
			case 'groupDetail.error': return ({required Object error}) => '獲取群組資訊失敗：${error}';
			case 'groupDetail.share': return '分享群組資訊';
			case 'groupDetail.description': return '說明';
			case 'groupDetail.roles': return '角色';
			case 'groupDetail.basicInfo': return '基本資訊';
			case 'groupDetail.createdAt': return '建立日期';
			case 'groupDetail.owner': return '擁有者';
			case 'groupDetail.rules': return '規則';
			case 'groupDetail.languages': return '語言';
			case 'groupDetail.memberCount': return ({required Object count}) => '${count} 位成員';
			case 'groupDetail.privacy.public': return '公開';
			case 'groupDetail.privacy.private': return '私人';
			case 'groupDetail.privacy.friends': return '好友';
			case 'groupDetail.privacy.invite': return '邀請制';
			case 'groupDetail.privacy.unknown': return '未知';
			case 'groupDetail.role.admin': return '管理員';
			case 'groupDetail.role.moderator': return '版主';
			case 'groupDetail.role.member': return '成員';
			case 'groupDetail.role.unknown': return '未知';
			case 'inventory.title': return '物品欄';
			case 'inventory.gallery': return '圖片庫';
			case 'inventory.icon': return '圖示';
			case 'inventory.emoji': return '表情符號';
			case 'inventory.sticker': return '貼圖';
			case 'inventory.print': return '列印圖';
			case 'inventory.upload': return '上傳檔案';
			case 'inventory.uploadGallery': return '正在上傳圖片庫圖片...';
			case 'inventory.uploadIcon': return '正在上傳圖示...';
			case 'inventory.uploadEmoji': return '正在上傳表情符號...';
			case 'inventory.uploadSticker': return '正在上傳貼圖...';
			case 'inventory.uploadPrint': return '正在上傳列印圖...';
			case 'inventory.selectImage': return '選擇圖片';
			case 'inventory.selectFromGallery': return '從圖片庫選擇';
			case 'inventory.takePhoto': return '使用相機拍攝';
			case 'inventory.uploadSuccess': return '上傳完成';
			case 'inventory.uploadFailed': return '上傳失敗';
			case 'inventory.uploadFailedFormat': return '檔案格式或大小有問題。請選擇 PNG 格式且小於 1MB 的圖片。';
			case 'inventory.uploadFailedAuth': return '驗證失敗。請重新登入。';
			case 'inventory.uploadFailedSize': return '檔案大小過大。請選擇較小的圖片。';
			case 'inventory.uploadFailedServer': return ({required Object code}) => '發生伺服器錯誤 (${code})';
			case 'inventory.pickImageFailed': return ({required Object error}) => '選擇圖片失敗：${error}';
			case 'inventory.tabs.emojiInventory.loading': return '正在載入表情符號...';
			case 'inventory.tabs.emojiInventory.error': return ({required Object error}) => '獲取表情符號失敗：${error}';
			case 'inventory.tabs.emojiInventory.emptyTitle': return '沒有表情符號';
			case 'inventory.tabs.emojiInventory.emptyDescription': return '在 VRChat 上傳的表情符號會顯示在這裡';
			case 'inventory.tabs.emojiInventory.zoomHint': return '雙擊放大';
			case 'inventory.tabs.galleryInventory.loading': return '正在載入圖片庫...';
			case 'inventory.tabs.galleryInventory.error': return ({required Object error}) => '獲取圖片庫失敗：${error}';
			case 'inventory.tabs.galleryInventory.emptyTitle': return '沒有圖片庫';
			case 'inventory.tabs.galleryInventory.emptyDescription': return '在 VRChat 上傳的圖片庫會顯示在這裡';
			case 'inventory.tabs.galleryInventory.zoomHint': return '雙擊放大';
			case 'inventory.tabs.iconInventory.loading': return '正在載入圖示...';
			case 'inventory.tabs.iconInventory.error': return ({required Object error}) => '獲取圖示失敗：${error}';
			case 'inventory.tabs.iconInventory.emptyTitle': return '沒有圖示';
			case 'inventory.tabs.iconInventory.emptyDescription': return '在 VRChat 上傳的圖示會顯示在這裡';
			case 'inventory.tabs.iconInventory.zoomHint': return '雙擊放大';
			case 'inventory.tabs.printInventory.loading': return '正在載入列印圖...';
			case 'inventory.tabs.printInventory.error': return ({required Object error}) => '獲取列印圖失敗：${error}';
			case 'inventory.tabs.printInventory.emptyTitle': return '沒有列印圖';
			case 'inventory.tabs.printInventory.emptyDescription': return '在 VRChat 上傳的列印圖會顯示在這裡';
			case 'inventory.tabs.printInventory.zoomHint': return '雙擊放大';
			case 'inventory.tabs.stickerInventory.loading': return '正在載入貼圖...';
			case 'inventory.tabs.stickerInventory.error': return ({required Object error}) => '獲取貼圖失敗：${error}';
			case 'inventory.tabs.stickerInventory.emptyTitle': return '沒有貼圖';
			case 'inventory.tabs.stickerInventory.emptyDescription': return '在 VRChat 上傳的貼圖會顯示在這裡';
			case 'inventory.tabs.stickerInventory.zoomHint': return '雙擊放大';
			case 'vrcnsync.title': return 'VRCNSync (β)';
			case 'vrcnsync.betaTitle': return 'Beta 版功能';
			case 'vrcnsync.betaDescription': return '此功能為開發中的 Beta 版，可能會發生非預期的問題。\n目前僅實作本機版本，若有雲端版需求將會實作。';
			case 'vrcnsync.githubLink': return 'VRCNSync 的 GitHub 頁面';
			case 'vrcnsync.openGithub': return '開啟 GitHub 頁面';
			case 'vrcnsync.serverRunning': return '伺服器執行中';
			case 'vrcnsync.serverStopped': return '伺服器已停止';
			case 'vrcnsync.serverRunningDesc': return '將來自 PC 的照片儲存到 VRCN 相簿';
			case 'vrcnsync.serverStoppedDesc': return '伺服器已停止';
			case 'vrcnsync.photoSaved': return '照片已儲存至 VRCN 相簿';
			case 'vrcnsync.photoReceived': return '已接收照片（儲存至相簿失敗）';
			case 'vrcnsync.openAlbum': return '開啟相簿';
			case 'vrcnsync.permissionErrorIos': return '需要存取照片圖庫的權限';
			case 'vrcnsync.permissionErrorAndroid': return '需要存取儲存空間的權限';
			case 'vrcnsync.openSettings': return '開啟設定';
			case 'vrcnsync.initError': return ({required Object error}) => '初始化失敗：${error}';
			case 'vrcnsync.openPhotoAppError': return '無法開啟相簿應用程式';
			case 'vrcnsync.serverInfo': return '伺服器資訊';
			case 'vrcnsync.ip': return ({required Object ip}) => 'IP: ${ip}';
			case 'vrcnsync.port': return ({required Object port}) => '連接埠: ${port}';
			case 'vrcnsync.address': return ({required Object ip, required Object port}) => '${ip}:${port}';
			case 'vrcnsync.autoSave': return '接收到的照片將自動儲存到「VRCN」相簿';
			case 'vrcnsync.usage': return '使用方法';
			case 'vrcnsync.usageSteps.0.title': return '在 PC 上啟動 VRCNSync 應用程式';
			case 'vrcnsync.usageSteps.0.desc': return '請在您的 PC 上啟動 VRCNSync 應用程式';
			case 'vrcnsync.usageSteps.1.title': return '連接到相同的 WiFi 網路';
			case 'vrcnsync.usageSteps.1.desc': return '請將您的 PC 和行動裝置連接到相同的 WiFi 網路';
			case 'vrcnsync.usageSteps.2.title': return '指定行動裝置為連線目標';
			case 'vrcnsync.usageSteps.2.desc': return '請在 PC 應用程式中指定上述的 IP 位址和連接埠';
			case 'vrcnsync.usageSteps.3.title': return '傳送照片';
			case 'vrcnsync.usageSteps.3.desc': return '從 PC 傳送照片後，將自動儲存到 VRCN 相簿';
			case 'vrcnsync.stats': return '連線狀態';
			case 'vrcnsync.statServer': return '伺服器狀態';
			case 'vrcnsync.statServerRunning': return '執行中';
			case 'vrcnsync.statServerStopped': return '已停止';
			case 'vrcnsync.statNetwork': return '網路';
			case 'vrcnsync.statNetworkConnected': return '已連線';
			case 'vrcnsync.statNetworkDisconnected': return '未連線';
			case 'feedback.title': return '意見回饋';
			case 'feedback.type': return '回饋類型';
			case 'feedback.types.bug': return '錯誤回報';
			case 'feedback.types.feature': return '功能請求';
			case 'feedback.types.improvement': return '改善建議';
			case 'feedback.types.other': return '其他';
			case 'feedback.inputTitle': return '標題 *';
			case 'feedback.inputTitleHint': return '請簡潔地描述';
			case 'feedback.inputDescription': return '詳細說明 *';
			case 'feedback.inputDescriptionHint': return '請提供詳細說明...';
			case 'feedback.cancel': return '取消';
			case 'feedback.send': return '傳送';
			case 'feedback.sending': return '傳送中...';
			case 'feedback.required': return '標題和詳細說明為必填項目';
			case 'feedback.success': return '意見回饋已成功傳送，感謝您！';
			case 'feedback.fail': return '傳送意見回饋失敗';
			case 'settings.appearance': return '外觀';
			case 'settings.language': return '語言';
			case 'settings.languageDescription': return '您可以選擇應用程式的顯示語言';
			case 'settings.appIcon': return '應用程式圖示';
			case 'settings.appIconDescription': return '變更顯示在主畫面的應用程式圖示';
			case 'settings.contentSettings': return '內容設定';
			case 'settings.searchEnabled': return '搜尋功能已啟用';
			case 'settings.searchDisabled': return '搜尋功能已停用';
			case 'settings.enableSearch': return '啟用搜尋功能';
			case 'settings.enableSearchDescription': return '搜尋結果中可能包含色情或暴力內容。';
			case 'settings.apiSetting': return '虛擬化身搜尋 API';
			case 'settings.apiSettingDescription': return '設定虛擬化身搜尋功能的 API';
			case 'settings.apiSettingSaveUrl': return 'URL 已儲存';
			case 'settings.notSet': return '未設定（虛擬化身搜尋功能無法使用）';
			case 'settings.notifications': return '通知設定';
			case 'settings.eventReminder': return '活動提醒';
			case 'settings.eventReminderDescription': return '在設定的活動開始前接收通知';
			case 'settings.manageReminders': return '管理已設定的提醒';
			case 'settings.manageRemindersDescription': return '可以取消或確認通知';
			case 'settings.dataStorage': return '資料與儲存空間';
			case 'settings.clearCache': return '清除快取';
			case 'settings.clearCacheSuccess': return '已清除快取';
			case 'settings.clearCacheError': return '清除快取時發生錯誤';
			case 'settings.cacheSize': return ({required Object size}) => '快取大小：${size}';
			case 'settings.calculatingCache': return '正在計算快取大小...';
			case 'settings.cacheError': return '無法取得快取大小';
			case 'settings.confirmClearCache': return '清除快取將會刪除暫時儲存的圖片和資料。\n\n帳號資訊和應用程式設定不會被刪除。';
			case 'settings.appInfo': return '應用程式資訊';
			case 'settings.version': return '版本';
			case 'settings.packageName': return '套件名稱';
			case 'settings.credit': return '製作群';
			case 'settings.creditDescription': return '開發者與貢獻者資訊';
			case 'settings.contact': return '聯絡我們';
			case 'settings.contactDescription': return '問題回報與意見';
			case 'settings.privacyPolicy': return '隱私權政策';
			case 'settings.privacyPolicyDescription': return '關於個人資訊的處理方式';
			case 'settings.termsOfService': return '服務條款';
			case 'settings.termsOfServiceDescription': return '應用程式的使用條款';
			case 'settings.openSource': return '開源軟體資訊';
			case 'settings.openSourceDescription': return '所使用函式庫等的授權';
			case 'settings.github': return 'GitHub 儲存庫';
			case 'settings.githubDescription': return '查看原始碼';
			case 'settings.logoutConfirm': return '確定要登出嗎？';
			case 'settings.logoutError': return ({required Object error}) => '登出時發生錯誤：${error}';
			case 'settings.iconChangeNotSupported': return '您的裝置不支援變更應用程式圖示';
			case 'settings.iconChangeFailed': return '變更圖示失敗';
			case 'settings.themeMode': return '主題模式';
			case 'settings.themeModeDescription': return '選擇應用程式的顯示主題';
			case 'settings.themeLight': return '淺色';
			case 'settings.themeSystem': return '系統';
			case 'settings.themeDark': return '深色';
			case 'settings.appIconDefault': return '預設';
			case 'settings.appIconIcon': return '圖示';
			case 'settings.appIconLogo': return '標誌';
			case 'settings.delete': return '刪除';
			case 'credits.title': return '製作群';
			case 'credits.section.development': return '開發';
			case 'credits.section.iconPeople': return '有趣的圖示貢獻者們';
			case 'credits.section.testFeedback': return '測試與意見回饋';
			case 'credits.section.specialThanks': return '特別感謝';
			case 'download.success': return '下載完成';
			case 'download.failure': return ({required Object error}) => '下載失敗：${error}';
			case 'download.shareFailure': return ({required Object error}) => '分享失敗：${error}';
			case 'download.permissionTitle': return '需要權限';
			case 'download.permissionDenied': return ({required Object permissionType}) => '已拒絕存取 ${permissionType} 的權限。\n請從設定應用程式中啟用權限。';
			case 'download.permissionCancel': return '取消';
			case 'download.permissionOpenSettings': return '開啟設定';
			case 'download.permissionPhoto': return '照片';
			case 'download.permissionPhotoLibrary': return '照片圖庫';
			case 'download.permissionStorage': return '儲存空間';
			case 'download.permissionPhotoRequired': return '需要存取照片的權限';
			case 'download.permissionPhotoLibraryRequired': return '需要存取照片圖庫的權限';
			case 'download.permissionStorageRequired': return '需要存取儲存空間的權限';
			case 'download.permissionError': return ({required Object error}) => '檢查權限時發生錯誤：${error}';
			case 'download.downloading': return ({required Object fileName}) => '正在下載 ${fileName}...';
			case 'download.sharing': return ({required Object fileName}) => '正在準備分享 ${fileName}...';
			case 'instance.type.public': return '公開';
			case 'instance.type.hidden': return '好友+';
			case 'instance.type.friends': return '好友';
			case 'instance.type.private': return '邀請+';
			case 'instance.type.unknown': return '未知';
			case 'status.active': return '線上';
			case 'status.joinMe': return '歡迎加入';
			case 'status.askMe': return '歡迎詢問';
			case 'status.busy': return '忙碌中';
			case 'status.offline': return '離線';
			case 'status.unknown': return '狀態不明';
			case 'location.private': return '私人';
			case 'location.playerCount': return ({required Object userCount, required Object capacity}) => '玩家數：${userCount} / ${capacity}';
			case 'location.instanceType': return ({required Object type}) => '房間類型：${type}';
			case 'location.noInfo': return '沒有位置資訊';
			case 'location.fetchError': return '獲取位置資訊失敗';
			case 'location.privateLocation': return '正在私人場所';
			case 'location.inviteSending': return '正在傳送邀請...';
			case 'location.inviteSent': return '已傳送邀請。您可以從通知加入';
			case 'location.inviteFailed': return ({required Object error}) => '傳送邀請失敗：${error}';
			case 'location.inviteButton': return '向自己傳送邀請';
			case 'location.isPrivate': return ({required Object number}) => '${number}人私密';
			case 'location.isActive': return ({required Object number}) => '${number}人線上';
			case 'location.isOffline': return ({required Object number}) => '${number}人離線';
			case 'location.isTraveling': return ({required Object number}) => '${number}人移動中';
			case 'location.isStaying': return ({required Object number}) => '${number}人停留中';
			case 'reminder.dialogTitle': return '設定提醒';
			case 'reminder.alreadySet': return '已設定';
			case 'reminder.set': return '設定';
			case 'reminder.cancel': return '取消';
			case 'reminder.delete': return '刪除';
			case 'reminder.deleteAll': return '刪除所有提醒';
			case 'reminder.deleteAllConfirm': return '您確定要刪除所有已設定的活動提醒嗎？此操作無法復原。';
			case 'reminder.deleted': return '已刪除提醒';
			case 'reminder.deletedAll': return '已刪除所有提醒';
			case 'reminder.noReminders': return '沒有已設定的提醒';
			case 'reminder.setFromEvent': return '您可以從活動頁面設定通知';
			case 'reminder.eventStart': return ({required Object time}) => '${time} 開始';
			case 'reminder.notifyAt': return ({required Object time, required Object label}) => '${time} (${label})';
			case 'reminder.receiveNotification': return '您想在何時收到通知？';
			case 'friend.sortFilter': return '排序與篩選';
			case 'friend.filter': return '篩選';
			case 'friend.filterAll': return '顯示全部';
			case 'friend.filterOnline': return '僅線上';
			case 'friend.filterOffline': return '僅離線';
			case 'friend.filterFavorite': return '僅最愛';
			case 'friend.sort': return '排序';
			case 'friend.sortStatus': return '按上線狀態';
			case 'friend.sortName': return '按名稱';
			case 'friend.sortLastLogin': return '按最後登入時間';
			case 'friend.sortAsc': return '遞增';
			case 'friend.sortDesc': return '遞減';
			case 'friend.close': return '關閉';
			case 'eventCalendarFilter.filterTitle': return '篩選活動';
			case 'eventCalendarFilter.clear': return '清除';
			case 'eventCalendarFilter.keyword': return '關鍵字搜尋';
			case 'eventCalendarFilter.keywordHint': return '活動名稱、說明、主辦方等';
			case 'eventCalendarFilter.date': return '按日期篩選';
			case 'eventCalendarFilter.dateHint': return '可顯示特定日期範圍的活動';
			case 'eventCalendarFilter.startDate': return '開始日期';
			case 'eventCalendarFilter.endDate': return '結束日期';
			case 'eventCalendarFilter.select': return '請選擇';
			case 'eventCalendarFilter.time': return '按時段篩選';
			case 'eventCalendarFilter.timeHint': return '可顯示在特定時段舉行的活動';
			case 'eventCalendarFilter.startTime': return '開始時間';
			case 'eventCalendarFilter.endTime': return '結束時間';
			case 'eventCalendarFilter.genre': return '按類型篩選';
			case 'eventCalendarFilter.genreSelected': return ({required Object count}) => '已選擇 ${count} 個類型';
			case 'eventCalendarFilter.apply': return '套用';
			case 'eventCalendarFilter.filterSummary': return '篩選條件';
			case 'eventCalendarFilter.filterNone': return '未設定篩選條件';
			default: return null;
		}
	}
}

