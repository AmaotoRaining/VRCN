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
class TranslationsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhCn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZhCn _root = this; // ignore: unused_field

	@override 
	TranslationsZhCn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhCn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonZhCn common = _TranslationsCommonZhCn._(_root);
	@override late final _TranslationsTermsAgreementZhCn termsAgreement = _TranslationsTermsAgreementZhCn._(_root);
	@override late final _TranslationsDrawerZhCn drawer = _TranslationsDrawerZhCn._(_root);
	@override late final _TranslationsLoginZhCn login = _TranslationsLoginZhCn._(_root);
	@override late final _TranslationsFriendsZhCn friends = _TranslationsFriendsZhCn._(_root);
	@override late final _TranslationsFriendDetailZhCn friendDetail = _TranslationsFriendDetailZhCn._(_root);
	@override late final _TranslationsSearchZhCn search = _TranslationsSearchZhCn._(_root);
	@override late final _TranslationsProfileZhCn profile = _TranslationsProfileZhCn._(_root);
	@override late final _TranslationsEngageCardZhCn engageCard = _TranslationsEngageCardZhCn._(_root);
	@override late final _TranslationsQrScannerZhCn qrScanner = _TranslationsQrScannerZhCn._(_root);
	@override late final _TranslationsFavoritesZhCn favorites = _TranslationsFavoritesZhCn._(_root);
	@override late final _TranslationsNotificationsZhCn notifications = _TranslationsNotificationsZhCn._(_root);
	@override late final _TranslationsEventCalendarZhCn eventCalendar = _TranslationsEventCalendarZhCn._(_root);
	@override late final _TranslationsAvatarsZhCn avatars = _TranslationsAvatarsZhCn._(_root);
	@override late final _TranslationsWorldDetailZhCn worldDetail = _TranslationsWorldDetailZhCn._(_root);
	@override late final _TranslationsAvatarDetailZhCn avatarDetail = _TranslationsAvatarDetailZhCn._(_root);
	@override late final _TranslationsGroupsZhCn groups = _TranslationsGroupsZhCn._(_root);
	@override late final _TranslationsGroupDetailZhCn groupDetail = _TranslationsGroupDetailZhCn._(_root);
	@override late final _TranslationsInventoryZhCn inventory = _TranslationsInventoryZhCn._(_root);
	@override late final _TranslationsVrcnsyncZhCn vrcnsync = _TranslationsVrcnsyncZhCn._(_root);
	@override late final _TranslationsFeedbackZhCn feedback = _TranslationsFeedbackZhCn._(_root);
	@override late final _TranslationsSettingsZhCn settings = _TranslationsSettingsZhCn._(_root);
	@override late final _TranslationsCreditsZhCn credits = _TranslationsCreditsZhCn._(_root);
	@override late final _TranslationsDownloadZhCn download = _TranslationsDownloadZhCn._(_root);
	@override late final _TranslationsInstanceZhCn instance = _TranslationsInstanceZhCn._(_root);
	@override late final _TranslationsStatusZhCn status = _TranslationsStatusZhCn._(_root);
	@override late final _TranslationsLocationZhCn location = _TranslationsLocationZhCn._(_root);
	@override late final _TranslationsReminderZhCn reminder = _TranslationsReminderZhCn._(_root);
	@override late final _TranslationsFriendZhCn friend = _TranslationsFriendZhCn._(_root);
	@override late final _TranslationsEventCalendarFilterZhCn eventCalendarFilter = _TranslationsEventCalendarFilterZhCn._(_root);
}

// Path: common
class _TranslationsCommonZhCn implements TranslationsCommonJa {
	_TranslationsCommonZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCN';
	@override String get ok => '确定';
	@override String get cancel => '取消';
	@override String get close => '关闭';
	@override String get save => '保存';
	@override String get edit => '编辑';
	@override String get delete => '删除';
	@override String get yes => '是';
	@override String get no => '否';
	@override String get loading => '加载中...';
	@override String error({required Object error}) => '发生错误：${error}';
	@override String get errorNomessage => '发生错误';
	@override String get retry => '重试';
	@override String get search => '搜索';
	@override String get settings => '设置';
	@override String get confirm => '确认';
	@override String get agree => '同意';
	@override String get decline => '不同意';
	@override String get username => '用户名';
	@override String get password => '密码';
	@override String get login => '登录';
	@override String get logout => '登出';
	@override String get share => '分享';
}

// Path: termsAgreement
class _TranslationsTermsAgreementZhCn implements TranslationsTermsAgreementJa {
	_TranslationsTermsAgreementZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => '欢迎来到 VRCN';
	@override String get welcomeMessage => '在使用本应用前，\n请阅读服务条款和隐私政策。';
	@override String get termsTitle => '服务条款';
	@override String get termsSubtitle => '关于应用的使用条件';
	@override String get privacyTitle => '隐私政策';
	@override String get privacySubtitle => '关于个人信息的处理';
	@override String agreeTerms({required Object title}) => '我同意“${title}”';
	@override String get checkContent => '查看内容';
	@override String get notice => '本应用是 VRChat Inc. 的非官方应用。\n与 VRChat Inc. 没有任何关系。';
}

// Path: drawer
class _TranslationsDrawerZhCn implements TranslationsDrawerJa {
	_TranslationsDrawerZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get home => '主页';
	@override String get profile => '个人资料';
	@override String get favorite => '收藏';
	@override String get eventCalendar => '活动日历';
	@override String get avatar => '虚拟形象';
	@override String get group => '群组';
	@override String get inventory => '物品栏';
	@override String get vrcnsync => 'VRCNSync (β)';
	@override String get review => '评价';
	@override String get feedback => '反馈';
	@override String get settings => '设置';
	@override String get userLoading => '正在加载用户信息...';
	@override String get userError => '加载用户信息失败';
	@override String get retry => '重试';
	@override late final _TranslationsDrawerSectionZhCn section = _TranslationsDrawerSectionZhCn._(_root);
}

// Path: login
class _TranslationsLoginZhCn implements TranslationsLoginJa {
	_TranslationsLoginZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get forgotPassword => '忘记密码？';
	@override String get createAccount => '注册';
	@override String get subtitle => '使用您的 VRChat 账户登录';
	@override String get email => '邮箱地址';
	@override String get emailHint => '输入邮箱或用户名';
	@override String get passwordHint => '输入密码';
	@override String get rememberMe => '记住登录状态';
	@override String get loggingIn => '登录中...';
	@override String get errorEmptyEmail => '请输入用户名或邮箱地址';
	@override String get errorEmptyPassword => '请输入密码';
	@override String get errorLoginFailed => '登录失败。请检查您的邮箱和密码。';
	@override String get twoFactorTitle => '两步验证';
	@override String get twoFactorSubtitle => '请输入验证码';
	@override String get twoFactorInstruction => '请输入您的验证器应用中显示的\n6位数验证码';
	@override String get twoFactorCodeHint => '验证码';
	@override String get verify => '验证';
	@override String get verifying => '验证中...';
	@override String get errorEmpty2fa => '请输入验证码';
	@override String get error2faFailed => '两步验证失败。请检查验证码是否正确。';
	@override String get backToLogin => '返回登录页面';
	@override String get paste => '粘贴';
}

// Path: friends
class _TranslationsFriendsZhCn implements TranslationsFriendsJa {
	_TranslationsFriendsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载好友信息...';
	@override String error({required Object error}) => '获取好友信息失败：${error}';
	@override String get notFound => '未找到好友';
	@override String get private => '私密';
	@override String get active => '活跃';
	@override String get offline => '离线';
	@override String get online => '在线';
	@override String get groupTitle => '按世界分组';
	@override String get refresh => '刷新';
	@override String get searchHint => '按好友名称搜索';
	@override String get noResult => '没有找到相关的好友';
}

// Path: friendDetail
class _TranslationsFriendDetailZhCn implements TranslationsFriendDetailJa {
	_TranslationsFriendDetailZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载用户信息...';
	@override String error({required Object error}) => '获取用户信息失败：${error}';
	@override String get currentLocation => '当前位置';
	@override String get basicInfo => '基本信息';
	@override String get userId => '用户ID';
	@override String get dateJoined => '注册日期';
	@override String get lastLogin => '最后登录';
	@override String get bio => '个人简介';
	@override String get links => '链接';
	@override String get loadingLinks => '正在加载链接信息...';
	@override String get group => '所属群组';
	@override String get groupDetail => '显示群组详情';
	@override String groupCode({required Object code}) => '群组代码：${code}';
	@override String memberCount({required Object count}) => '成员数：${count}人';
	@override String get unknownGroup => '未知群组';
	@override String get block => '屏蔽';
	@override String get mute => '静音';
	@override String get openWebsite => '在网站上打开';
	@override String get shareProfile => '分享个人资料';
	@override String confirmBlockTitle({required Object name}) => '要屏蔽 ${name} 吗？';
	@override String get confirmBlockMessage => '屏蔽后，您将不会再收到该用户的好友请求和消息。';
	@override String confirmMuteTitle({required Object name}) => '要将 ${name} 静音吗？';
	@override String get confirmMuteMessage => '静音后，您将听不到该用户的声音。';
	@override String get blockSuccess => '已屏蔽';
	@override String get muteSuccess => '已静音';
	@override String operationFailed({required Object error}) => '操作失败：${error}';
}

// Path: search
class _TranslationsSearchZhCn implements TranslationsSearchJa {
	_TranslationsSearchZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get userTab => '用户';
	@override String get worldTab => '世界';
	@override String get avatarTab => '虚拟形象';
	@override String get groupTab => '群组';
	@override late final _TranslationsSearchTabsZhCn tabs = _TranslationsSearchTabsZhCn._(_root);
}

// Path: profile
class _TranslationsProfileZhCn implements TranslationsProfileJa {
	_TranslationsProfileZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '个人资料';
	@override String get edit => '编辑';
	@override String get refresh => '刷新';
	@override String get loading => '正在加载个人资料信息...';
	@override String get error => '获取个人资料信息失败：{error}';
	@override String get displayName => '显示名称';
	@override String get username => '用户名';
	@override String get userId => '用户ID';
	@override String get engageCard => '互动卡片';
	@override String get frined => '好友';
	@override String get dateJoined => '注册日期';
	@override String get userType => '用户类型';
	@override String get status => '状态';
	@override String get statusMessage => '状态消息';
	@override String get bio => '个人简介';
	@override String get links => '链接';
	@override String get group => '所属群组';
	@override String get groupDetail => '显示群组详情';
	@override String get avatar => '当前虚拟形象';
	@override String get avatarDetail => '显示虚拟形象详情';
	@override String get public => '公开';
	@override String get private => '私密';
	@override String get hidden => '隐藏';
	@override String get unknown => '未知';
	@override String get friends => '好友';
	@override String get loadingLinks => '正在加载链接信息...';
	@override String get noGroup => '未加入任何群组';
	@override String get noBio => '无个人简介';
	@override String get noLinks => '无链接';
	@override String get save => '保存更改';
	@override String get saved => '个人资料已更新';
	@override String get saveFailed => '更新失败：{error}';
	@override String get discardTitle => '要放弃更改吗？';
	@override String get discardContent => '您对个人资料所做的更改将不会被保存。';
	@override String get discardCancel => '取消';
	@override String get discardOk => '放弃';
	@override String get basic => '基本信息';
	@override String get pronouns => '代词';
	@override String get addLink => '添加';
	@override String get removeLink => '移除';
	@override String get linkHint => '输入链接（例如：https://twitter.com/username）';
	@override String get linksHint => '链接将显示在您的个人资料上，点击即可打开';
	@override String get statusMessageHint => '输入您当前的状态或消息';
	@override String get bioHint => '写一些关于您自己的介绍吧';
}

// Path: engageCard
class _TranslationsEngageCardZhCn implements TranslationsEngageCardJa {
	_TranslationsEngageCardZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get pickBackground => '选择背景图片';
	@override String get removeBackground => '移除背景图片';
	@override String get scanQr => '扫描二维码';
	@override String get showAvatar => '显示虚拟形象';
	@override String get hideAvatar => '隐藏虚拟形象';
	@override String get noBackground => '未选择背景图片\n您可以通过右上角的按钮进行设置';
	@override String get loading => '加载中...';
	@override String error({required Object error}) => '获取互动卡片信息失败：${error}';
	@override String get copyUserId => '复制用户ID';
	@override String get copied => '已复制';
}

// Path: qrScanner
class _TranslationsQrScannerZhCn implements TranslationsQrScannerJa {
	_TranslationsQrScannerZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '扫描二维码';
	@override String get guide => '请将二维码对准框内';
	@override String get loading => '正在初始化相机...';
	@override String error({required Object error}) => '读取二维码失败：${error}';
	@override String get notFound => '未找到有效的用户二维码';
}

// Path: favorites
class _TranslationsFavoritesZhCn implements TranslationsFavoritesJa {
	_TranslationsFavoritesZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '收藏';
	@override String get frined => '好友';
	@override String get friendsTab => '好友';
	@override String get worldsTab => '世界';
	@override String get avatarsTab => '虚拟形象';
	@override String get emptyFolderTitle => '没有收藏文件夹';
	@override String get emptyFolderDescription => '请在VRChat内创建收藏文件夹';
	@override String get emptyFriends => '此文件夹中没有好友';
	@override String get emptyWorlds => '此文件夹中没有世界';
	@override String get emptyAvatars => '此文件夹中没有虚拟形象';
	@override String get emptyWorldsTabTitle => '没有收藏的世界';
	@override String get emptyWorldsTabDescription => '您可以从世界详情页面将世界添加到收藏';
	@override String get emptyAvatarsTabTitle => '没有收藏的虚拟形象';
	@override String get emptyAvatarsTabDescription => '您可以从虚拟形象详情页面将形象添加到收藏';
	@override String get loading => '正在加载收藏...';
	@override String get loadingFolder => '正在加载文件夹信息...';
	@override String error({required Object error}) => '加载收藏失败：${error}';
	@override String get errorFolder => '获取信息失败';
	@override String get remove => '从收藏中移除';
	@override String removeSuccess({required Object name}) => '已将 ${name} 从收藏中移除';
	@override String removeFailed({required Object error}) => '移除失败：${error}';
	@override String itemsCount({required Object count}) => '${count} 个项目';
	@override String get public => '公开';
	@override String get private => '私密';
	@override String get hidden => '隐藏';
	@override String get unknown => '未知';
	@override String get loadingError => '加载错误';
}

// Path: notifications
class _TranslationsNotificationsZhCn implements TranslationsNotificationsJa {
	_TranslationsNotificationsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '没有通知';
	@override String get emptyDescription => '好友请求、邀请等新通知\n将会显示在这里';
	@override String friendRequest({required Object userName}) => '您收到了来自 ${userName} 的好友请求';
	@override String invite({required Object userName, required Object worldName}) => '您收到了来自 ${userName} 前往 ${worldName} 的邀请';
	@override String friendOnline({required Object userName}) => '${userName} 已上线';
	@override String friendOffline({required Object userName}) => '${userName} 已离线';
	@override String friendActive({required Object userName}) => '${userName} 变为活跃状态';
	@override String friendAdd({required Object userName}) => '${userName} 已被添加为好友';
	@override String friendRemove({required Object userName}) => '${userName} 已从好友中移除';
	@override String statusUpdate({required Object userName, required Object status, required Object world}) => '${userName} 的状态已更新：${status}${world}';
	@override String locationChange({required Object userName, required Object worldName}) => '${userName} 已移动到 ${worldName}';
	@override String userUpdate({required Object world}) => '您的信息已更新${world}';
	@override String myLocationChange({required Object worldName}) => '您的移动：${worldName}';
	@override String requestInvite({required Object userName}) => '您收到了来自 ${userName} 的加入请求';
	@override String votekick({required Object userName}) => '收到了来自 ${userName} 的投票踢出';
	@override String responseReceived({required Object userName}) => '已收到通知ID:${userName}的响应';
	@override String error({required Object worldName}) => '错误：${worldName}';
	@override String system({required Object extraData}) => '系统通知：${extraData}';
	@override String secondsAgo({required Object seconds}) => '${seconds}秒前';
	@override String minutesAgo({required Object minutes}) => '${minutes}分钟前';
	@override String hoursAgo({required Object hours}) => '${hours}小时前';
}

// Path: eventCalendar
class _TranslationsEventCalendarZhCn implements TranslationsEventCalendarJa {
	_TranslationsEventCalendarZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '活动日历';
	@override String get filter => '筛选活动';
	@override String get refresh => '刷新活动信息';
	@override String get loading => '正在获取活动信息...';
	@override String error({required Object error}) => '获取活动信息失败：${error}';
	@override String filterActive({required Object count}) => '筛选已应用（${count}条）';
	@override String get clear => '清除';
	@override String get noEvents => '没有符合条件的活动';
	@override String get clearFilter => '清除筛选';
	@override String get today => '今天';
	@override String get reminderSet => '设置提醒';
	@override String get reminderSetDone => '已设置提醒';
	@override String get reminderDeleted => '已删除提醒';
	@override String get organizer => '主办方';
	@override String get description => '说明';
	@override String get genre => '类型';
	@override String get condition => '参加条件';
	@override String get way => '参加方法';
	@override String get note => '备注';
	@override String get quest => '支持Quest';
	@override String reminderCount({required Object count}) => '${count}条';
	@override String startToEnd({required Object start, required Object end}) => '${start} ~ ${end}';
}

// Path: avatars
class _TranslationsAvatarsZhCn implements TranslationsAvatarsJa {
	_TranslationsAvatarsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '虚拟形象';
	@override String get searchHint => '按虚拟形象名称等搜索';
	@override String get searchTooltip => '搜索';
	@override String get searchEmptyTitle => '未找到搜索结果';
	@override String get searchEmptyDescription => '请尝试其他搜索词';
	@override String get emptyTitle => '没有虚拟形象';
	@override String get emptyDescription => '请添加虚拟形象或稍后重试';
	@override String get refresh => '刷新';
	@override String get loading => '正在加载虚拟形象...';
	@override String error({required Object error}) => '获取虚拟形象信息失败：${error}';
	@override String get current => '使用中';
	@override String get public => '公开';
	@override String get private => '私密';
	@override String get hidden => '隐藏';
	@override String get author => '作者';
	@override String get sortUpdated => '按更新时间';
	@override String get sortName => '按名称';
	@override String get sortTooltip => '排序';
	@override String get viewModeTooltip => '切换视图模式';
}

// Path: worldDetail
class _TranslationsWorldDetailZhCn implements TranslationsWorldDetailJa {
	_TranslationsWorldDetailZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载世界信息...';
	@override String error({required Object error}) => '获取世界信息失败：${error}';
	@override String get share => '分享这个世界';
	@override String get openInVRChat => '在VRChat官网打开';
	@override String get report => '举报这个世界';
	@override String get creator => '创建者';
	@override String get created => '创建于';
	@override String get updated => '更新于';
	@override String get favorites => '收藏数';
	@override String get visits => '访问数';
	@override String get occupants => '当前人数';
	@override String get popularity => '评价';
	@override String get description => '说明';
	@override String get noDescription => '没有说明';
	@override String get tags => '标签';
	@override String get joinPublic => '发送公开邀请';
	@override String get favoriteAdded => '已添加到收藏';
	@override String get favoriteRemoved => '已从收藏中移除';
	@override String get unknown => '未知';
}

// Path: avatarDetail
class _TranslationsAvatarDetailZhCn implements TranslationsAvatarDetailJa {
	_TranslationsAvatarDetailZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String changeSuccess({required Object name}) => '已更换为虚拟形象“${name}”';
	@override String changeFailed({required Object error}) => '更换虚拟形象失败：${error}';
	@override String get changing => '更换中...';
	@override String get useThisAvatar => '使用此虚拟形象';
	@override String get creator => '创建者';
	@override String get created => '创建于';
	@override String get updated => '更新于';
	@override String get description => '说明';
	@override String get noDescription => '没有说明';
	@override String get tags => '标签';
	@override String get addToFavorites => '添加到收藏';
	@override String get public => '公开';
	@override String get private => '私密';
	@override String get hidden => '隐藏';
	@override String get unknown => '未知';
	@override String get share => '分享';
	@override String get loading => '正在加载虚拟形象信息...';
	@override String error({required Object error}) => '获取虚拟形象信息失败：${error}';
}

// Path: groups
class _TranslationsGroupsZhCn implements TranslationsGroupsJa {
	_TranslationsGroupsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '群组';
	@override String get loadingUser => '正在加载用户信息...';
	@override String errorUser({required Object error}) => '获取用户信息失败：${error}';
	@override String get loadingGroups => '正在加载群组信息...';
	@override String errorGroups({required Object error}) => '获取群组信息失败：${error}';
	@override String get emptyTitle => '您尚未加入任何群组';
	@override String get emptyDescription => '您可以从VRChat应用或网站加入群组';
	@override String get searchGroups => '查找群组';
	@override String members({required Object count}) => '${count}名成员';
	@override String get showDetails => '显示详情';
	@override String get unknownName => '名称未知';
}

// Path: groupDetail
class _TranslationsGroupDetailZhCn implements TranslationsGroupDetailJa {
	_TranslationsGroupDetailZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载群组信息...';
	@override String error({required Object error}) => '获取群组信息失败：${error}';
	@override String get share => '分享群组信息';
	@override String get description => '说明';
	@override String get roles => '角色';
	@override String get basicInfo => '基本信息';
	@override String get createdAt => '创建日期';
	@override String get owner => '所有者';
	@override String get rules => '规则';
	@override String get languages => '语言';
	@override String memberCount({required Object count}) => '${count} 成员';
	@override late final _TranslationsGroupDetailPrivacyZhCn privacy = _TranslationsGroupDetailPrivacyZhCn._(_root);
	@override late final _TranslationsGroupDetailRoleZhCn role = _TranslationsGroupDetailRoleZhCn._(_root);
}

// Path: inventory
class _TranslationsInventoryZhCn implements TranslationsInventoryJa {
	_TranslationsInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '物品栏';
	@override String get gallery => '画廊';
	@override String get icon => '图标';
	@override String get emoji => '表情';
	@override String get sticker => '贴纸';
	@override String get print => '打印图';
	@override String get upload => '上传文件';
	@override String get uploadGallery => '正在上传画廊图片...';
	@override String get uploadIcon => '正在上传图标...';
	@override String get uploadEmoji => '正在上传表情...';
	@override String get uploadSticker => '正在上传贴纸...';
	@override String get uploadPrint => '正在上传打印图...';
	@override String get selectImage => '选择图片';
	@override String get selectFromGallery => '从相册选择';
	@override String get takePhoto => '使用相机拍摄';
	@override String get uploadSuccess => '上传成功';
	@override String get uploadFailed => '上传失败';
	@override String get uploadFailedFormat => '文件格式或大小有问题。请选择小于1MB的PNG格式图片。';
	@override String get uploadFailedAuth => '认证失败。请重新登录。';
	@override String get uploadFailedSize => '文件太大。请选择更小的图片。';
	@override String uploadFailedServer({required Object code}) => '发生服务器错误 (${code})';
	@override String pickImageFailed({required Object error}) => '选择图片失败：${error}';
	@override late final _TranslationsInventoryTabsZhCn tabs = _TranslationsInventoryTabsZhCn._(_root);
}

// Path: vrcnsync
class _TranslationsVrcnsyncZhCn implements TranslationsVrcnsyncJa {
	_TranslationsVrcnsyncZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCNSync (β)';
	@override String get betaTitle => '测试版功能';
	@override String get betaDescription => '此功能为开发中的测试版，可能会出现意外问题。\n目前仅为本地实现，如果需求量大，将会实现云端版本。';
	@override String get githubLink => 'VRCNSync的GitHub页面';
	@override String get openGithub => '打开GitHub页面';
	@override String get serverRunning => '服务器运行中';
	@override String get serverStopped => '服务器已停止';
	@override String get serverRunningDesc => '将PC上的照片保存到VRCN相册';
	@override String get serverStoppedDesc => '服务器已停止';
	@override String get photoSaved => '照片已保存到VRCN相册';
	@override String get photoReceived => '已接收照片（保存到相册失败）';
	@override String get openAlbum => '打开相册';
	@override String get permissionErrorIos => '需要照片库的访问权限';
	@override String get permissionErrorAndroid => '需要存储空间的访问权限';
	@override String get openSettings => '打开设置';
	@override String initError({required Object error}) => '初始化失败：${error}';
	@override String get openPhotoAppError => '无法打开照片应用';
	@override String get serverInfo => '服务器信息';
	@override String ip({required Object ip}) => 'IP: ${ip}';
	@override String port({required Object port}) => '端口: ${port}';
	@override String address({required Object ip, required Object port}) => '${ip}:${port}';
	@override String get autoSave => '接收到的照片将自动保存到“VRCN”相册';
	@override String get usage => '使用方法';
	@override List<dynamic> get usageSteps => [
		_TranslationsVrcnsync$usageSteps$0i0$ZhCn._(_root),
		_TranslationsVrcnsync$usageSteps$0i1$ZhCn._(_root),
		_TranslationsVrcnsync$usageSteps$0i2$ZhCn._(_root),
		_TranslationsVrcnsync$usageSteps$0i3$ZhCn._(_root),
	];
	@override String get stats => '连接状态';
	@override String get statServer => '服务器状态';
	@override String get statServerRunning => '运行中';
	@override String get statServerStopped => '已停止';
	@override String get statNetwork => '网络';
	@override String get statNetworkConnected => '已连接';
	@override String get statNetworkDisconnected => '未连接';
}

// Path: feedback
class _TranslationsFeedbackZhCn implements TranslationsFeedbackJa {
	_TranslationsFeedbackZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '反馈';
	@override String get type => '反馈类型';
	@override Map<String, String> get types => {
		'bug': '错误报告',
		'feature': '功能请求',
		'improvement': '改进建议',
		'other': '其他',
	};
	@override String get inputTitle => '标题 *';
	@override String get inputTitleHint => '请简要说明';
	@override String get inputDescription => '详细说明 *';
	@override String get inputDescriptionHint => '请提供详细说明...';
	@override String get cancel => '取消';
	@override String get send => '发送';
	@override String get sending => '发送中...';
	@override String get required => '标题和详细说明为必填项';
	@override String get success => '反馈已发送。谢谢！';
	@override String get fail => '反馈发送失败';
}

// Path: settings
class _TranslationsSettingsZhCn implements TranslationsSettingsJa {
	_TranslationsSettingsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外观';
	@override String get language => '语言';
	@override String get languageDescription => '您可以选择应用程序的显示语言';
	@override String get appIcon => '应用图标';
	@override String get appIconDescription => '更改主屏幕上显示的应用图标';
	@override String get contentSettings => '内容设置';
	@override String get searchEnabled => '搜索功能已启用';
	@override String get searchDisabled => '搜索功能已禁用';
	@override String get enableSearch => '启用搜索功能';
	@override String get enableSearchDescription => '搜索结果可能包含成人或暴力内容。';
	@override String get apiSetting => '虚拟形象搜索API';
	@override String get apiSettingDescription => '设置虚拟形象搜索功能的API';
	@override String get apiSettingSaveUrl => 'URL已保存';
	@override String get notSet => '未设置（虚拟形象搜索功能无法使用）';
	@override String get notifications => '通知设置';
	@override String get eventReminder => '活动提醒';
	@override String get eventReminderDescription => '在您设定的活动开始前接收通知';
	@override String get manageReminders => '管理已设置的提醒';
	@override String get manageRemindersDescription => '可以取消或确认通知';
	@override String get dataStorage => '数据与存储';
	@override String get clearCache => '清除缓存';
	@override String get clearCacheSuccess => '缓存已清除';
	@override String get clearCacheError => '清除缓存时发生错误';
	@override String cacheSize({required Object size}) => '缓存大小: ${size}';
	@override String get calculatingCache => '正在计算缓存大小...';
	@override String get cacheError => '无法获取缓存大小';
	@override String get confirmClearCache => '清除缓存将删除临时保存的图片和数据。\n\n您的账户信息和应用设置不会被删除。';
	@override String get appInfo => '应用信息';
	@override String get version => '版本';
	@override String get packageName => '包名';
	@override String get credit => '鸣谢';
	@override String get creditDescription => '开发者和贡献者信息';
	@override String get contact => '联系我们';
	@override String get contactDescription => 'BUG报告和建议请点此';
	@override String get privacyPolicy => '隐私政策';
	@override String get privacyPolicyDescription => '关于个人信息的处理';
	@override String get termsOfService => '服务条款';
	@override String get termsOfServiceDescription => '应用使用条件';
	@override String get openSource => '开源信息';
	@override String get openSourceDescription => '所使用的库等许可证信息';
	@override String get github => 'GitHub仓库';
	@override String get githubDescription => '查看源代码';
	@override String get logoutConfirm => '确定要登出吗？';
	@override String logoutError({required Object error}) => '登出时发生错误：${error}';
	@override String get iconChangeNotSupported => '您的设备不支持更改应用图标';
	@override String get iconChangeFailed => '更改图标失败';
	@override String get themeMode => '主题模式';
	@override String get themeModeDescription => '您可以选择应用的显示主题';
	@override String get themeLight => '浅色';
	@override String get themeSystem => '系统';
	@override String get themeDark => '深色';
	@override String get appIconDefault => '默认';
	@override String get appIconIcon => '图标';
	@override String get appIconLogo => '标志';
	@override String get delete => '删除';
}

// Path: credits
class _TranslationsCreditsZhCn implements TranslationsCreditsJa {
	_TranslationsCreditsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '鸣谢';
	@override late final _TranslationsCreditsSectionZhCn section = _TranslationsCreditsSectionZhCn._(_root);
}

// Path: download
class _TranslationsDownloadZhCn implements TranslationsDownloadJa {
	_TranslationsDownloadZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get success => '下载完成';
	@override String failure({required Object error}) => '下载失败：${error}';
	@override String shareFailure({required Object error}) => '分享失败：${error}';
	@override String get permissionTitle => '需要权限';
	@override String permissionDenied({required Object permissionType}) => '保存到${permissionType}的权限已被拒绝。\n请从设置应用中启用权限。';
	@override String get permissionCancel => '取消';
	@override String get permissionOpenSettings => '打开设置';
	@override String get permissionPhoto => '照片';
	@override String get permissionPhotoLibrary => '照片库';
	@override String get permissionStorage => '存储';
	@override String get permissionPhotoRequired => '需要保存到照片的权限';
	@override String get permissionPhotoLibraryRequired => '需要保存到照片库的权限';
	@override String get permissionStorageRequired => '需要访问存储空间的权限';
	@override String permissionError({required Object error}) => '检查权限时发生错误：${error}';
	@override String downloading({required Object fileName}) => '正在下载 ${fileName}...';
	@override String sharing({required Object fileName}) => '正在准备分享 ${fileName}...';
}

// Path: instance
class _TranslationsInstanceZhCn implements TranslationsInstanceJa {
	_TranslationsInstanceZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInstanceTypeZhCn type = _TranslationsInstanceTypeZhCn._(_root);
}

// Path: status
class _TranslationsStatusZhCn implements TranslationsStatusJa {
	_TranslationsStatusZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get active => '在线';
	@override String get joinMe => '欢迎加入';
	@override String get askMe => '请问我';
	@override String get busy => '忙碌';
	@override String get offline => '离线';
	@override String get unknown => '状态未知';
}

// Path: location
class _TranslationsLocationZhCn implements TranslationsLocationJa {
	_TranslationsLocationZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get private => '私密';
	@override String playerCount({required Object userCount, required Object capacity}) => '玩家数：${userCount} / ${capacity}';
	@override String instanceType({required Object type}) => '实例类型：${type}';
	@override String get noInfo => '没有位置信息';
	@override String get fetchError => '获取位置信息失败';
	@override String get privateLocation => '您在一个私密地点';
	@override String get inviteSending => '发送邀请中...';
	@override String get inviteSent => '邀请已发送。您可以从通知中加入';
	@override String inviteFailed({required Object error}) => '发送邀请失败：${error}';
	@override String get inviteButton => '向自己发送邀请';
	@override String isPrivate({required Object number}) => '${number}人私密';
	@override String isActive({required Object number}) => '${number}人在线';
	@override String isOffline({required Object number}) => '${number}人离线';
	@override String isTraveling({required Object number}) => '${number}人移动中';
	@override String isStaying({required Object number}) => '${number}人停留中';
}

// Path: reminder
class _TranslationsReminderZhCn implements TranslationsReminderJa {
	_TranslationsReminderZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => '设置提醒';
	@override String get alreadySet => '已设置';
	@override String get set => '设置';
	@override String get cancel => '取消';
	@override String get delete => '删除';
	@override String get deleteAll => '删除所有提醒';
	@override String get deleteAllConfirm => '这将删除所有已设置的活动提醒。此操作无法撤销。';
	@override String get deleted => '提醒已删除';
	@override String get deletedAll => '所有提醒已删除';
	@override String get noReminders => '没有已设置的提醒';
	@override String get setFromEvent => '您可以从活动页面设置通知';
	@override String eventStart({required Object time}) => '${time} 开始';
	@override String notifyAt({required Object time, required Object label}) => '${time} (${label})';
	@override String get receiveNotification => '您想在何时收到通知？';
}

// Path: friend
class _TranslationsFriendZhCn implements TranslationsFriendJa {
	_TranslationsFriendZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get sortFilter => '排序和筛选';
	@override String get filter => '筛选';
	@override String get filterAll => '显示全部';
	@override String get filterOnline => '仅在线';
	@override String get filterOffline => '仅离线';
	@override String get filterFavorite => '仅收藏';
	@override String get sort => '排序';
	@override String get sortStatus => '按在线状态';
	@override String get sortName => '按名称';
	@override String get sortLastLogin => '按最后登录时间';
	@override String get sortAsc => '升序';
	@override String get sortDesc => '降序';
	@override String get close => '关闭';
}

// Path: eventCalendarFilter
class _TranslationsEventCalendarFilterZhCn implements TranslationsEventCalendarFilterJa {
	_TranslationsEventCalendarFilterZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get filterTitle => '筛选活动';
	@override String get clear => '清除';
	@override String get keyword => '关键词搜索';
	@override String get keywordHint => '活动名称、说明、主办方等';
	@override String get date => '按日期筛选';
	@override String get dateHint => '可以显示特定日期范围的活动';
	@override String get startDate => '开始日期';
	@override String get endDate => '结束日期';
	@override String get select => '请选择';
	@override String get time => '按时间段筛选';
	@override String get timeHint => '可以显示特定时间段举办的活动';
	@override String get startTime => '开始时间';
	@override String get endTime => '结束时间';
	@override String get genre => '按类型筛选';
	@override String genreSelected({required Object count}) => '已选择 ${count} 个类型';
	@override String get apply => '应用';
	@override String get filterSummary => '筛选器';
	@override String get filterNone => '未设置筛选器';
}

// Path: drawer.section
class _TranslationsDrawerSectionZhCn implements TranslationsDrawerSectionJa {
	_TranslationsDrawerSectionZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get content => '内容';
	@override String get other => '其他';
}

// Path: search.tabs
class _TranslationsSearchTabsZhCn implements TranslationsSearchTabsJa {
	_TranslationsSearchTabsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSearchTabsUserSearchZhCn userSearch = _TranslationsSearchTabsUserSearchZhCn._(_root);
	@override late final _TranslationsSearchTabsWorldSearchZhCn worldSearch = _TranslationsSearchTabsWorldSearchZhCn._(_root);
	@override late final _TranslationsSearchTabsGroupSearchZhCn groupSearch = _TranslationsSearchTabsGroupSearchZhCn._(_root);
	@override late final _TranslationsSearchTabsAvatarSearchZhCn avatarSearch = _TranslationsSearchTabsAvatarSearchZhCn._(_root);
}

// Path: groupDetail.privacy
class _TranslationsGroupDetailPrivacyZhCn implements TranslationsGroupDetailPrivacyJa {
	_TranslationsGroupDetailPrivacyZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get public => '公开';
	@override String get private => '私密';
	@override String get friends => '好友';
	@override String get invite => '邀请制';
	@override String get unknown => '未知';
}

// Path: groupDetail.role
class _TranslationsGroupDetailRoleZhCn implements TranslationsGroupDetailRoleJa {
	_TranslationsGroupDetailRoleZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get admin => '管理员';
	@override String get moderator => '版主';
	@override String get member => '成员';
	@override String get unknown => '未知';
}

// Path: inventory.tabs
class _TranslationsInventoryTabsZhCn implements TranslationsInventoryTabsJa {
	_TranslationsInventoryTabsZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInventoryTabsEmojiInventoryZhCn emojiInventory = _TranslationsInventoryTabsEmojiInventoryZhCn._(_root);
	@override late final _TranslationsInventoryTabsGalleryInventoryZhCn galleryInventory = _TranslationsInventoryTabsGalleryInventoryZhCn._(_root);
	@override late final _TranslationsInventoryTabsIconInventoryZhCn iconInventory = _TranslationsInventoryTabsIconInventoryZhCn._(_root);
	@override late final _TranslationsInventoryTabsPrintInventoryZhCn printInventory = _TranslationsInventoryTabsPrintInventoryZhCn._(_root);
	@override late final _TranslationsInventoryTabsStickerInventoryZhCn stickerInventory = _TranslationsInventoryTabsStickerInventoryZhCn._(_root);
}

// Path: vrcnsync.usageSteps.0
class _TranslationsVrcnsync$usageSteps$0i0$ZhCn implements TranslationsVrcnsync$usageSteps$0i0$Ja {
	_TranslationsVrcnsync$usageSteps$0i0$ZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '在PC上启动VRCNSync应用';
	@override String get desc => '请在您的PC上启动VRCNSync应用';
}

// Path: vrcnsync.usageSteps.1
class _TranslationsVrcnsync$usageSteps$0i1$ZhCn implements TranslationsVrcnsync$usageSteps$0i1$Ja {
	_TranslationsVrcnsync$usageSteps$0i1$ZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '连接到同一WiFi网络';
	@override String get desc => '请将您的PC和移动设备连接到同一个WiFi网络';
}

// Path: vrcnsync.usageSteps.2
class _TranslationsVrcnsync$usageSteps$0i2$ZhCn implements TranslationsVrcnsync$usageSteps$0i2$Ja {
	_TranslationsVrcnsync$usageSteps$0i2$ZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '将移动设备指定为连接目标';
	@override String get desc => '请在PC应用中指定上述IP地址和端口';
}

// Path: vrcnsync.usageSteps.3
class _TranslationsVrcnsync$usageSteps$0i3$ZhCn implements TranslationsVrcnsync$usageSteps$0i3$Ja {
	_TranslationsVrcnsync$usageSteps$0i3$ZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '发送照片';
	@override String get desc => '从PC发送照片后，将自动保存到VRCN相册';
}

// Path: credits.section
class _TranslationsCreditsSectionZhCn implements TranslationsCreditsSectionJa {
	_TranslationsCreditsSectionZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get development => '开发';
	@override String get iconPeople => '有趣的图标制作者们';
	@override String get testFeedback => '测试与反馈';
	@override String get specialThanks => '特别感谢';
}

// Path: instance.type
class _TranslationsInstanceTypeZhCn implements TranslationsInstanceTypeJa {
	_TranslationsInstanceTypeZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get public => '公开';
	@override String get hidden => '好友+';
	@override String get friends => '好友';
	@override String get private => '邀请+';
	@override String get unknown => '未知';
}

// Path: search.tabs.userSearch
class _TranslationsSearchTabsUserSearchZhCn implements TranslationsSearchTabsUserSearchJa {
	_TranslationsSearchTabsUserSearchZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '用户搜索';
	@override String get emptyDescription => '您可以通过用户名或ID进行搜索';
	@override String get searching => '搜索中...';
	@override String get noResults => '未找到相关用户';
	@override String error({required Object error}) => '用户搜索时发生错误：${error}';
	@override String get inputPlaceholder => '输入用户名或ID';
}

// Path: search.tabs.worldSearch
class _TranslationsSearchTabsWorldSearchZhCn implements TranslationsSearchTabsWorldSearchJa {
	_TranslationsSearchTabsWorldSearchZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '探索世界';
	@override String get emptyDescription => '请输入关键词进行搜索';
	@override String get searching => '搜索中...';
	@override String get noResults => '未找到相关世界';
	@override String noResultsWithQuery({required Object query}) => '未找到与“${query}”匹配的世界';
	@override String get noResultsHint => '尝试更换搜索关键词吧';
	@override String error({required Object error}) => '世界搜索时发生错误：${error}';
	@override String resultCount({required Object count}) => '找到了 ${count} 个世界';
	@override String authorPrefix({required Object authorName}) => 'by ${authorName}';
	@override String get listView => '列表视图';
	@override String get gridView => '网格视图';
}

// Path: search.tabs.groupSearch
class _TranslationsSearchTabsGroupSearchZhCn implements TranslationsSearchTabsGroupSearchJa {
	_TranslationsSearchTabsGroupSearchZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '搜索群组';
	@override String get emptyDescription => '请输入关键词进行搜索';
	@override String get searching => '搜索中...';
	@override String get noResults => '未找到相关群组';
	@override String noResultsWithQuery({required Object query}) => '未找到与“${query}”匹配的群组';
	@override String get noResultsHint => '尝试更换搜索关键词吧';
	@override String error({required Object error}) => '群组搜索时发生错误：${error}';
	@override String resultCount({required Object count}) => '找到了 ${count} 个群组';
	@override String get listView => '列表视图';
	@override String get gridView => '网格视图';
	@override String memberCount({required Object count}) => '${count} 成员';
}

// Path: search.tabs.avatarSearch
class _TranslationsSearchTabsAvatarSearchZhCn implements TranslationsSearchTabsAvatarSearchJa {
	_TranslationsSearchTabsAvatarSearchZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get avatar => '虚拟形象';
	@override String get emptyTitle => '搜索虚拟形象';
	@override String get emptyDescription => '请输入关键词进行搜索';
	@override String get searching => '正在搜索虚拟形象...';
	@override String get noResults => '未找到搜索结果';
	@override String get noResultsHint => '试试其他关键词吧';
	@override String error({required Object error}) => '虚拟形象搜索时发生错误：${error}';
}

// Path: inventory.tabs.emojiInventory
class _TranslationsInventoryTabsEmojiInventoryZhCn implements TranslationsInventoryTabsEmojiInventoryJa {
	_TranslationsInventoryTabsEmojiInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载表情...';
	@override String error({required Object error}) => '获取表情失败：${error}';
	@override String get emptyTitle => '没有表情';
	@override String get emptyDescription => '您在VRChat中上传的表情将显示在这里';
	@override String get zoomHint => '双击缩放';
}

// Path: inventory.tabs.galleryInventory
class _TranslationsInventoryTabsGalleryInventoryZhCn implements TranslationsInventoryTabsGalleryInventoryJa {
	_TranslationsInventoryTabsGalleryInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载画廊...';
	@override String error({required Object error}) => '获取画廊失败：${error}';
	@override String get emptyTitle => '没有画廊';
	@override String get emptyDescription => '您在VRChat中上传的画廊将显示在这里';
	@override String get zoomHint => '双击缩放';
}

// Path: inventory.tabs.iconInventory
class _TranslationsInventoryTabsIconInventoryZhCn implements TranslationsInventoryTabsIconInventoryJa {
	_TranslationsInventoryTabsIconInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载图标...';
	@override String error({required Object error}) => '获取图标失败：${error}';
	@override String get emptyTitle => '没有图标';
	@override String get emptyDescription => '您在VRChat中上传的图标将显示在这里';
	@override String get zoomHint => '双击缩放';
}

// Path: inventory.tabs.printInventory
class _TranslationsInventoryTabsPrintInventoryZhCn implements TranslationsInventoryTabsPrintInventoryJa {
	_TranslationsInventoryTabsPrintInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载打印图...';
	@override String error({required Object error}) => '获取打印图失败：${error}';
	@override String get emptyTitle => '没有打印图';
	@override String get emptyDescription => '您在VRChat中上传的打印图将显示在这里';
	@override String get zoomHint => '双击缩放';
}

// Path: inventory.tabs.stickerInventory
class _TranslationsInventoryTabsStickerInventoryZhCn implements TranslationsInventoryTabsStickerInventoryJa {
	_TranslationsInventoryTabsStickerInventoryZhCn._(this._root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载贴纸...';
	@override String error({required Object error}) => '获取贴纸失败：${error}';
	@override String get emptyTitle => '没有贴纸';
	@override String get emptyDescription => '您在VRChat中上传的贴纸将显示在这里';
	@override String get zoomHint => '双击缩放';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'common.title': return 'VRCN';
			case 'common.ok': return '确定';
			case 'common.cancel': return '取消';
			case 'common.close': return '关闭';
			case 'common.save': return '保存';
			case 'common.edit': return '编辑';
			case 'common.delete': return '删除';
			case 'common.yes': return '是';
			case 'common.no': return '否';
			case 'common.loading': return '加载中...';
			case 'common.error': return ({required Object error}) => '发生错误：${error}';
			case 'common.errorNomessage': return '发生错误';
			case 'common.retry': return '重试';
			case 'common.search': return '搜索';
			case 'common.settings': return '设置';
			case 'common.confirm': return '确认';
			case 'common.agree': return '同意';
			case 'common.decline': return '不同意';
			case 'common.username': return '用户名';
			case 'common.password': return '密码';
			case 'common.login': return '登录';
			case 'common.logout': return '登出';
			case 'common.share': return '分享';
			case 'termsAgreement.welcomeTitle': return '欢迎来到 VRCN';
			case 'termsAgreement.welcomeMessage': return '在使用本应用前，\n请阅读服务条款和隐私政策。';
			case 'termsAgreement.termsTitle': return '服务条款';
			case 'termsAgreement.termsSubtitle': return '关于应用的使用条件';
			case 'termsAgreement.privacyTitle': return '隐私政策';
			case 'termsAgreement.privacySubtitle': return '关于个人信息的处理';
			case 'termsAgreement.agreeTerms': return ({required Object title}) => '我同意“${title}”';
			case 'termsAgreement.checkContent': return '查看内容';
			case 'termsAgreement.notice': return '本应用是 VRChat Inc. 的非官方应用。\n与 VRChat Inc. 没有任何关系。';
			case 'drawer.home': return '主页';
			case 'drawer.profile': return '个人资料';
			case 'drawer.favorite': return '收藏';
			case 'drawer.eventCalendar': return '活动日历';
			case 'drawer.avatar': return '虚拟形象';
			case 'drawer.group': return '群组';
			case 'drawer.inventory': return '物品栏';
			case 'drawer.vrcnsync': return 'VRCNSync (β)';
			case 'drawer.review': return '评价';
			case 'drawer.feedback': return '反馈';
			case 'drawer.settings': return '设置';
			case 'drawer.userLoading': return '正在加载用户信息...';
			case 'drawer.userError': return '加载用户信息失败';
			case 'drawer.retry': return '重试';
			case 'drawer.section.content': return '内容';
			case 'drawer.section.other': return '其他';
			case 'login.forgotPassword': return '忘记密码？';
			case 'login.createAccount': return '注册';
			case 'login.subtitle': return '使用您的 VRChat 账户登录';
			case 'login.email': return '邮箱地址';
			case 'login.emailHint': return '输入邮箱或用户名';
			case 'login.passwordHint': return '输入密码';
			case 'login.rememberMe': return '记住登录状态';
			case 'login.loggingIn': return '登录中...';
			case 'login.errorEmptyEmail': return '请输入用户名或邮箱地址';
			case 'login.errorEmptyPassword': return '请输入密码';
			case 'login.errorLoginFailed': return '登录失败。请检查您的邮箱和密码。';
			case 'login.twoFactorTitle': return '两步验证';
			case 'login.twoFactorSubtitle': return '请输入验证码';
			case 'login.twoFactorInstruction': return '请输入您的验证器应用中显示的\n6位数验证码';
			case 'login.twoFactorCodeHint': return '验证码';
			case 'login.verify': return '验证';
			case 'login.verifying': return '验证中...';
			case 'login.errorEmpty2fa': return '请输入验证码';
			case 'login.error2faFailed': return '两步验证失败。请检查验证码是否正确。';
			case 'login.backToLogin': return '返回登录页面';
			case 'login.paste': return '粘贴';
			case 'friends.loading': return '正在加载好友信息...';
			case 'friends.error': return ({required Object error}) => '获取好友信息失败：${error}';
			case 'friends.notFound': return '未找到好友';
			case 'friends.private': return '私密';
			case 'friends.active': return '活跃';
			case 'friends.offline': return '离线';
			case 'friends.online': return '在线';
			case 'friends.groupTitle': return '按世界分组';
			case 'friends.refresh': return '刷新';
			case 'friends.searchHint': return '按好友名称搜索';
			case 'friends.noResult': return '没有找到相关的好友';
			case 'friendDetail.loading': return '正在加载用户信息...';
			case 'friendDetail.error': return ({required Object error}) => '获取用户信息失败：${error}';
			case 'friendDetail.currentLocation': return '当前位置';
			case 'friendDetail.basicInfo': return '基本信息';
			case 'friendDetail.userId': return '用户ID';
			case 'friendDetail.dateJoined': return '注册日期';
			case 'friendDetail.lastLogin': return '最后登录';
			case 'friendDetail.bio': return '个人简介';
			case 'friendDetail.links': return '链接';
			case 'friendDetail.loadingLinks': return '正在加载链接信息...';
			case 'friendDetail.group': return '所属群组';
			case 'friendDetail.groupDetail': return '显示群组详情';
			case 'friendDetail.groupCode': return ({required Object code}) => '群组代码：${code}';
			case 'friendDetail.memberCount': return ({required Object count}) => '成员数：${count}人';
			case 'friendDetail.unknownGroup': return '未知群组';
			case 'friendDetail.block': return '屏蔽';
			case 'friendDetail.mute': return '静音';
			case 'friendDetail.openWebsite': return '在网站上打开';
			case 'friendDetail.shareProfile': return '分享个人资料';
			case 'friendDetail.confirmBlockTitle': return ({required Object name}) => '要屏蔽 ${name} 吗？';
			case 'friendDetail.confirmBlockMessage': return '屏蔽后，您将不会再收到该用户的好友请求和消息。';
			case 'friendDetail.confirmMuteTitle': return ({required Object name}) => '要将 ${name} 静音吗？';
			case 'friendDetail.confirmMuteMessage': return '静音后，您将听不到该用户的声音。';
			case 'friendDetail.blockSuccess': return '已屏蔽';
			case 'friendDetail.muteSuccess': return '已静音';
			case 'friendDetail.operationFailed': return ({required Object error}) => '操作失败：${error}';
			case 'search.userTab': return '用户';
			case 'search.worldTab': return '世界';
			case 'search.avatarTab': return '虚拟形象';
			case 'search.groupTab': return '群组';
			case 'search.tabs.userSearch.emptyTitle': return '用户搜索';
			case 'search.tabs.userSearch.emptyDescription': return '您可以通过用户名或ID进行搜索';
			case 'search.tabs.userSearch.searching': return '搜索中...';
			case 'search.tabs.userSearch.noResults': return '未找到相关用户';
			case 'search.tabs.userSearch.error': return ({required Object error}) => '用户搜索时发生错误：${error}';
			case 'search.tabs.userSearch.inputPlaceholder': return '输入用户名或ID';
			case 'search.tabs.worldSearch.emptyTitle': return '探索世界';
			case 'search.tabs.worldSearch.emptyDescription': return '请输入关键词进行搜索';
			case 'search.tabs.worldSearch.searching': return '搜索中...';
			case 'search.tabs.worldSearch.noResults': return '未找到相关世界';
			case 'search.tabs.worldSearch.noResultsWithQuery': return ({required Object query}) => '未找到与“${query}”匹配的世界';
			case 'search.tabs.worldSearch.noResultsHint': return '尝试更换搜索关键词吧';
			case 'search.tabs.worldSearch.error': return ({required Object error}) => '世界搜索时发生错误：${error}';
			case 'search.tabs.worldSearch.resultCount': return ({required Object count}) => '找到了 ${count} 个世界';
			case 'search.tabs.worldSearch.authorPrefix': return ({required Object authorName}) => 'by ${authorName}';
			case 'search.tabs.worldSearch.listView': return '列表视图';
			case 'search.tabs.worldSearch.gridView': return '网格视图';
			case 'search.tabs.groupSearch.emptyTitle': return '搜索群组';
			case 'search.tabs.groupSearch.emptyDescription': return '请输入关键词进行搜索';
			case 'search.tabs.groupSearch.searching': return '搜索中...';
			case 'search.tabs.groupSearch.noResults': return '未找到相关群组';
			case 'search.tabs.groupSearch.noResultsWithQuery': return ({required Object query}) => '未找到与“${query}”匹配的群组';
			case 'search.tabs.groupSearch.noResultsHint': return '尝试更换搜索关键词吧';
			case 'search.tabs.groupSearch.error': return ({required Object error}) => '群组搜索时发生错误：${error}';
			case 'search.tabs.groupSearch.resultCount': return ({required Object count}) => '找到了 ${count} 个群组';
			case 'search.tabs.groupSearch.listView': return '列表视图';
			case 'search.tabs.groupSearch.gridView': return '网格视图';
			case 'search.tabs.groupSearch.memberCount': return ({required Object count}) => '${count} 成员';
			case 'search.tabs.avatarSearch.avatar': return '虚拟形象';
			case 'search.tabs.avatarSearch.emptyTitle': return '搜索虚拟形象';
			case 'search.tabs.avatarSearch.emptyDescription': return '请输入关键词进行搜索';
			case 'search.tabs.avatarSearch.searching': return '正在搜索虚拟形象...';
			case 'search.tabs.avatarSearch.noResults': return '未找到搜索结果';
			case 'search.tabs.avatarSearch.noResultsHint': return '试试其他关键词吧';
			case 'search.tabs.avatarSearch.error': return ({required Object error}) => '虚拟形象搜索时发生错误：${error}';
			case 'profile.title': return '个人资料';
			case 'profile.edit': return '编辑';
			case 'profile.refresh': return '刷新';
			case 'profile.loading': return '正在加载个人资料信息...';
			case 'profile.error': return '获取个人资料信息失败：{error}';
			case 'profile.displayName': return '显示名称';
			case 'profile.username': return '用户名';
			case 'profile.userId': return '用户ID';
			case 'profile.engageCard': return '互动卡片';
			case 'profile.frined': return '好友';
			case 'profile.dateJoined': return '注册日期';
			case 'profile.userType': return '用户类型';
			case 'profile.status': return '状态';
			case 'profile.statusMessage': return '状态消息';
			case 'profile.bio': return '个人简介';
			case 'profile.links': return '链接';
			case 'profile.group': return '所属群组';
			case 'profile.groupDetail': return '显示群组详情';
			case 'profile.avatar': return '当前虚拟形象';
			case 'profile.avatarDetail': return '显示虚拟形象详情';
			case 'profile.public': return '公开';
			case 'profile.private': return '私密';
			case 'profile.hidden': return '隐藏';
			case 'profile.unknown': return '未知';
			case 'profile.friends': return '好友';
			case 'profile.loadingLinks': return '正在加载链接信息...';
			case 'profile.noGroup': return '未加入任何群组';
			case 'profile.noBio': return '无个人简介';
			case 'profile.noLinks': return '无链接';
			case 'profile.save': return '保存更改';
			case 'profile.saved': return '个人资料已更新';
			case 'profile.saveFailed': return '更新失败：{error}';
			case 'profile.discardTitle': return '要放弃更改吗？';
			case 'profile.discardContent': return '您对个人资料所做的更改将不会被保存。';
			case 'profile.discardCancel': return '取消';
			case 'profile.discardOk': return '放弃';
			case 'profile.basic': return '基本信息';
			case 'profile.pronouns': return '代词';
			case 'profile.addLink': return '添加';
			case 'profile.removeLink': return '移除';
			case 'profile.linkHint': return '输入链接（例如：https://twitter.com/username）';
			case 'profile.linksHint': return '链接将显示在您的个人资料上，点击即可打开';
			case 'profile.statusMessageHint': return '输入您当前的状态或消息';
			case 'profile.bioHint': return '写一些关于您自己的介绍吧';
			case 'engageCard.pickBackground': return '选择背景图片';
			case 'engageCard.removeBackground': return '移除背景图片';
			case 'engageCard.scanQr': return '扫描二维码';
			case 'engageCard.showAvatar': return '显示虚拟形象';
			case 'engageCard.hideAvatar': return '隐藏虚拟形象';
			case 'engageCard.noBackground': return '未选择背景图片\n您可以通过右上角的按钮进行设置';
			case 'engageCard.loading': return '加载中...';
			case 'engageCard.error': return ({required Object error}) => '获取互动卡片信息失败：${error}';
			case 'engageCard.copyUserId': return '复制用户ID';
			case 'engageCard.copied': return '已复制';
			case 'qrScanner.title': return '扫描二维码';
			case 'qrScanner.guide': return '请将二维码对准框内';
			case 'qrScanner.loading': return '正在初始化相机...';
			case 'qrScanner.error': return ({required Object error}) => '读取二维码失败：${error}';
			case 'qrScanner.notFound': return '未找到有效的用户二维码';
			case 'favorites.title': return '收藏';
			case 'favorites.frined': return '好友';
			case 'favorites.friendsTab': return '好友';
			case 'favorites.worldsTab': return '世界';
			case 'favorites.avatarsTab': return '虚拟形象';
			case 'favorites.emptyFolderTitle': return '没有收藏文件夹';
			case 'favorites.emptyFolderDescription': return '请在VRChat内创建收藏文件夹';
			case 'favorites.emptyFriends': return '此文件夹中没有好友';
			case 'favorites.emptyWorlds': return '此文件夹中没有世界';
			case 'favorites.emptyAvatars': return '此文件夹中没有虚拟形象';
			case 'favorites.emptyWorldsTabTitle': return '没有收藏的世界';
			case 'favorites.emptyWorldsTabDescription': return '您可以从世界详情页面将世界添加到收藏';
			case 'favorites.emptyAvatarsTabTitle': return '没有收藏的虚拟形象';
			case 'favorites.emptyAvatarsTabDescription': return '您可以从虚拟形象详情页面将形象添加到收藏';
			case 'favorites.loading': return '正在加载收藏...';
			case 'favorites.loadingFolder': return '正在加载文件夹信息...';
			case 'favorites.error': return ({required Object error}) => '加载收藏失败：${error}';
			case 'favorites.errorFolder': return '获取信息失败';
			case 'favorites.remove': return '从收藏中移除';
			case 'favorites.removeSuccess': return ({required Object name}) => '已将 ${name} 从收藏中移除';
			case 'favorites.removeFailed': return ({required Object error}) => '移除失败：${error}';
			case 'favorites.itemsCount': return ({required Object count}) => '${count} 个项目';
			case 'favorites.public': return '公开';
			case 'favorites.private': return '私密';
			case 'favorites.hidden': return '隐藏';
			case 'favorites.unknown': return '未知';
			case 'favorites.loadingError': return '加载错误';
			case 'notifications.emptyTitle': return '没有通知';
			case 'notifications.emptyDescription': return '好友请求、邀请等新通知\n将会显示在这里';
			case 'notifications.friendRequest': return ({required Object userName}) => '您收到了来自 ${userName} 的好友请求';
			case 'notifications.invite': return ({required Object userName, required Object worldName}) => '您收到了来自 ${userName} 前往 ${worldName} 的邀请';
			case 'notifications.friendOnline': return ({required Object userName}) => '${userName} 已上线';
			case 'notifications.friendOffline': return ({required Object userName}) => '${userName} 已离线';
			case 'notifications.friendActive': return ({required Object userName}) => '${userName} 变为活跃状态';
			case 'notifications.friendAdd': return ({required Object userName}) => '${userName} 已被添加为好友';
			case 'notifications.friendRemove': return ({required Object userName}) => '${userName} 已从好友中移除';
			case 'notifications.statusUpdate': return ({required Object userName, required Object status, required Object world}) => '${userName} 的状态已更新：${status}${world}';
			case 'notifications.locationChange': return ({required Object userName, required Object worldName}) => '${userName} 已移动到 ${worldName}';
			case 'notifications.userUpdate': return ({required Object world}) => '您的信息已更新${world}';
			case 'notifications.myLocationChange': return ({required Object worldName}) => '您的移动：${worldName}';
			case 'notifications.requestInvite': return ({required Object userName}) => '您收到了来自 ${userName} 的加入请求';
			case 'notifications.votekick': return ({required Object userName}) => '收到了来自 ${userName} 的投票踢出';
			case 'notifications.responseReceived': return ({required Object userName}) => '已收到通知ID:${userName}的响应';
			case 'notifications.error': return ({required Object worldName}) => '错误：${worldName}';
			case 'notifications.system': return ({required Object extraData}) => '系统通知：${extraData}';
			case 'notifications.secondsAgo': return ({required Object seconds}) => '${seconds}秒前';
			case 'notifications.minutesAgo': return ({required Object minutes}) => '${minutes}分钟前';
			case 'notifications.hoursAgo': return ({required Object hours}) => '${hours}小时前';
			case 'eventCalendar.title': return '活动日历';
			case 'eventCalendar.filter': return '筛选活动';
			case 'eventCalendar.refresh': return '刷新活动信息';
			case 'eventCalendar.loading': return '正在获取活动信息...';
			case 'eventCalendar.error': return ({required Object error}) => '获取活动信息失败：${error}';
			case 'eventCalendar.filterActive': return ({required Object count}) => '筛选已应用（${count}条）';
			case 'eventCalendar.clear': return '清除';
			case 'eventCalendar.noEvents': return '没有符合条件的活动';
			case 'eventCalendar.clearFilter': return '清除筛选';
			case 'eventCalendar.today': return '今天';
			case 'eventCalendar.reminderSet': return '设置提醒';
			case 'eventCalendar.reminderSetDone': return '已设置提醒';
			case 'eventCalendar.reminderDeleted': return '已删除提醒';
			case 'eventCalendar.organizer': return '主办方';
			case 'eventCalendar.description': return '说明';
			case 'eventCalendar.genre': return '类型';
			case 'eventCalendar.condition': return '参加条件';
			case 'eventCalendar.way': return '参加方法';
			case 'eventCalendar.note': return '备注';
			case 'eventCalendar.quest': return '支持Quest';
			case 'eventCalendar.reminderCount': return ({required Object count}) => '${count}条';
			case 'eventCalendar.startToEnd': return ({required Object start, required Object end}) => '${start} ~ ${end}';
			case 'avatars.title': return '虚拟形象';
			case 'avatars.searchHint': return '按虚拟形象名称等搜索';
			case 'avatars.searchTooltip': return '搜索';
			case 'avatars.searchEmptyTitle': return '未找到搜索结果';
			case 'avatars.searchEmptyDescription': return '请尝试其他搜索词';
			case 'avatars.emptyTitle': return '没有虚拟形象';
			case 'avatars.emptyDescription': return '请添加虚拟形象或稍后重试';
			case 'avatars.refresh': return '刷新';
			case 'avatars.loading': return '正在加载虚拟形象...';
			case 'avatars.error': return ({required Object error}) => '获取虚拟形象信息失败：${error}';
			case 'avatars.current': return '使用中';
			case 'avatars.public': return '公开';
			case 'avatars.private': return '私密';
			case 'avatars.hidden': return '隐藏';
			case 'avatars.author': return '作者';
			case 'avatars.sortUpdated': return '按更新时间';
			case 'avatars.sortName': return '按名称';
			case 'avatars.sortTooltip': return '排序';
			case 'avatars.viewModeTooltip': return '切换视图模式';
			case 'worldDetail.loading': return '正在加载世界信息...';
			case 'worldDetail.error': return ({required Object error}) => '获取世界信息失败：${error}';
			case 'worldDetail.share': return '分享这个世界';
			case 'worldDetail.openInVRChat': return '在VRChat官网打开';
			case 'worldDetail.report': return '举报这个世界';
			case 'worldDetail.creator': return '创建者';
			case 'worldDetail.created': return '创建于';
			case 'worldDetail.updated': return '更新于';
			case 'worldDetail.favorites': return '收藏数';
			case 'worldDetail.visits': return '访问数';
			case 'worldDetail.occupants': return '当前人数';
			case 'worldDetail.popularity': return '评价';
			case 'worldDetail.description': return '说明';
			case 'worldDetail.noDescription': return '没有说明';
			case 'worldDetail.tags': return '标签';
			case 'worldDetail.joinPublic': return '发送公开邀请';
			case 'worldDetail.favoriteAdded': return '已添加到收藏';
			case 'worldDetail.favoriteRemoved': return '已从收藏中移除';
			case 'worldDetail.unknown': return '未知';
			case 'avatarDetail.changeSuccess': return ({required Object name}) => '已更换为虚拟形象“${name}”';
			case 'avatarDetail.changeFailed': return ({required Object error}) => '更换虚拟形象失败：${error}';
			case 'avatarDetail.changing': return '更换中...';
			case 'avatarDetail.useThisAvatar': return '使用此虚拟形象';
			case 'avatarDetail.creator': return '创建者';
			case 'avatarDetail.created': return '创建于';
			case 'avatarDetail.updated': return '更新于';
			case 'avatarDetail.description': return '说明';
			case 'avatarDetail.noDescription': return '没有说明';
			case 'avatarDetail.tags': return '标签';
			case 'avatarDetail.addToFavorites': return '添加到收藏';
			case 'avatarDetail.public': return '公开';
			case 'avatarDetail.private': return '私密';
			case 'avatarDetail.hidden': return '隐藏';
			case 'avatarDetail.unknown': return '未知';
			case 'avatarDetail.share': return '分享';
			case 'avatarDetail.loading': return '正在加载虚拟形象信息...';
			case 'avatarDetail.error': return ({required Object error}) => '获取虚拟形象信息失败：${error}';
			case 'groups.title': return '群组';
			case 'groups.loadingUser': return '正在加载用户信息...';
			case 'groups.errorUser': return ({required Object error}) => '获取用户信息失败：${error}';
			case 'groups.loadingGroups': return '正在加载群组信息...';
			case 'groups.errorGroups': return ({required Object error}) => '获取群组信息失败：${error}';
			case 'groups.emptyTitle': return '您尚未加入任何群组';
			case 'groups.emptyDescription': return '您可以从VRChat应用或网站加入群组';
			case 'groups.searchGroups': return '查找群组';
			case 'groups.members': return ({required Object count}) => '${count}名成员';
			case 'groups.showDetails': return '显示详情';
			case 'groups.unknownName': return '名称未知';
			case 'groupDetail.loading': return '正在加载群组信息...';
			case 'groupDetail.error': return ({required Object error}) => '获取群组信息失败：${error}';
			case 'groupDetail.share': return '分享群组信息';
			case 'groupDetail.description': return '说明';
			case 'groupDetail.roles': return '角色';
			case 'groupDetail.basicInfo': return '基本信息';
			case 'groupDetail.createdAt': return '创建日期';
			case 'groupDetail.owner': return '所有者';
			case 'groupDetail.rules': return '规则';
			case 'groupDetail.languages': return '语言';
			case 'groupDetail.memberCount': return ({required Object count}) => '${count} 成员';
			case 'groupDetail.privacy.public': return '公开';
			case 'groupDetail.privacy.private': return '私密';
			case 'groupDetail.privacy.friends': return '好友';
			case 'groupDetail.privacy.invite': return '邀请制';
			case 'groupDetail.privacy.unknown': return '未知';
			case 'groupDetail.role.admin': return '管理员';
			case 'groupDetail.role.moderator': return '版主';
			case 'groupDetail.role.member': return '成员';
			case 'groupDetail.role.unknown': return '未知';
			case 'inventory.title': return '物品栏';
			case 'inventory.gallery': return '画廊';
			case 'inventory.icon': return '图标';
			case 'inventory.emoji': return '表情';
			case 'inventory.sticker': return '贴纸';
			case 'inventory.print': return '打印图';
			case 'inventory.upload': return '上传文件';
			case 'inventory.uploadGallery': return '正在上传画廊图片...';
			case 'inventory.uploadIcon': return '正在上传图标...';
			case 'inventory.uploadEmoji': return '正在上传表情...';
			case 'inventory.uploadSticker': return '正在上传贴纸...';
			case 'inventory.uploadPrint': return '正在上传打印图...';
			case 'inventory.selectImage': return '选择图片';
			case 'inventory.selectFromGallery': return '从相册选择';
			case 'inventory.takePhoto': return '使用相机拍摄';
			case 'inventory.uploadSuccess': return '上传成功';
			case 'inventory.uploadFailed': return '上传失败';
			case 'inventory.uploadFailedFormat': return '文件格式或大小有问题。请选择小于1MB的PNG格式图片。';
			case 'inventory.uploadFailedAuth': return '认证失败。请重新登录。';
			case 'inventory.uploadFailedSize': return '文件太大。请选择更小的图片。';
			case 'inventory.uploadFailedServer': return ({required Object code}) => '发生服务器错误 (${code})';
			case 'inventory.pickImageFailed': return ({required Object error}) => '选择图片失败：${error}';
			case 'inventory.tabs.emojiInventory.loading': return '正在加载表情...';
			case 'inventory.tabs.emojiInventory.error': return ({required Object error}) => '获取表情失败：${error}';
			case 'inventory.tabs.emojiInventory.emptyTitle': return '没有表情';
			case 'inventory.tabs.emojiInventory.emptyDescription': return '您在VRChat中上传的表情将显示在这里';
			case 'inventory.tabs.emojiInventory.zoomHint': return '双击缩放';
			case 'inventory.tabs.galleryInventory.loading': return '正在加载画廊...';
			case 'inventory.tabs.galleryInventory.error': return ({required Object error}) => '获取画廊失败：${error}';
			case 'inventory.tabs.galleryInventory.emptyTitle': return '没有画廊';
			case 'inventory.tabs.galleryInventory.emptyDescription': return '您在VRChat中上传的画廊将显示在这里';
			case 'inventory.tabs.galleryInventory.zoomHint': return '双击缩放';
			case 'inventory.tabs.iconInventory.loading': return '正在加载图标...';
			case 'inventory.tabs.iconInventory.error': return ({required Object error}) => '获取图标失败：${error}';
			case 'inventory.tabs.iconInventory.emptyTitle': return '没有图标';
			case 'inventory.tabs.iconInventory.emptyDescription': return '您在VRChat中上传的图标将显示在这里';
			case 'inventory.tabs.iconInventory.zoomHint': return '双击缩放';
			case 'inventory.tabs.printInventory.loading': return '正在加载打印图...';
			case 'inventory.tabs.printInventory.error': return ({required Object error}) => '获取打印图失败：${error}';
			case 'inventory.tabs.printInventory.emptyTitle': return '没有打印图';
			case 'inventory.tabs.printInventory.emptyDescription': return '您在VRChat中上传的打印图将显示在这里';
			case 'inventory.tabs.printInventory.zoomHint': return '双击缩放';
			case 'inventory.tabs.stickerInventory.loading': return '正在加载贴纸...';
			case 'inventory.tabs.stickerInventory.error': return ({required Object error}) => '获取贴纸失败：${error}';
			case 'inventory.tabs.stickerInventory.emptyTitle': return '没有贴纸';
			case 'inventory.tabs.stickerInventory.emptyDescription': return '您在VRChat中上传的贴纸将显示在这里';
			case 'inventory.tabs.stickerInventory.zoomHint': return '双击缩放';
			case 'vrcnsync.title': return 'VRCNSync (β)';
			case 'vrcnsync.betaTitle': return '测试版功能';
			case 'vrcnsync.betaDescription': return '此功能为开发中的测试版，可能会出现意外问题。\n目前仅为本地实现，如果需求量大，将会实现云端版本。';
			case 'vrcnsync.githubLink': return 'VRCNSync的GitHub页面';
			case 'vrcnsync.openGithub': return '打开GitHub页面';
			case 'vrcnsync.serverRunning': return '服务器运行中';
			case 'vrcnsync.serverStopped': return '服务器已停止';
			case 'vrcnsync.serverRunningDesc': return '将PC上的照片保存到VRCN相册';
			case 'vrcnsync.serverStoppedDesc': return '服务器已停止';
			case 'vrcnsync.photoSaved': return '照片已保存到VRCN相册';
			case 'vrcnsync.photoReceived': return '已接收照片（保存到相册失败）';
			case 'vrcnsync.openAlbum': return '打开相册';
			case 'vrcnsync.permissionErrorIos': return '需要照片库的访问权限';
			case 'vrcnsync.permissionErrorAndroid': return '需要存储空间的访问权限';
			case 'vrcnsync.openSettings': return '打开设置';
			case 'vrcnsync.initError': return ({required Object error}) => '初始化失败：${error}';
			case 'vrcnsync.openPhotoAppError': return '无法打开照片应用';
			case 'vrcnsync.serverInfo': return '服务器信息';
			case 'vrcnsync.ip': return ({required Object ip}) => 'IP: ${ip}';
			case 'vrcnsync.port': return ({required Object port}) => '端口: ${port}';
			case 'vrcnsync.address': return ({required Object ip, required Object port}) => '${ip}:${port}';
			case 'vrcnsync.autoSave': return '接收到的照片将自动保存到“VRCN”相册';
			case 'vrcnsync.usage': return '使用方法';
			case 'vrcnsync.usageSteps.0.title': return '在PC上启动VRCNSync应用';
			case 'vrcnsync.usageSteps.0.desc': return '请在您的PC上启动VRCNSync应用';
			case 'vrcnsync.usageSteps.1.title': return '连接到同一WiFi网络';
			case 'vrcnsync.usageSteps.1.desc': return '请将您的PC和移动设备连接到同一个WiFi网络';
			case 'vrcnsync.usageSteps.2.title': return '将移动设备指定为连接目标';
			case 'vrcnsync.usageSteps.2.desc': return '请在PC应用中指定上述IP地址和端口';
			case 'vrcnsync.usageSteps.3.title': return '发送照片';
			case 'vrcnsync.usageSteps.3.desc': return '从PC发送照片后，将自动保存到VRCN相册';
			case 'vrcnsync.stats': return '连接状态';
			case 'vrcnsync.statServer': return '服务器状态';
			case 'vrcnsync.statServerRunning': return '运行中';
			case 'vrcnsync.statServerStopped': return '已停止';
			case 'vrcnsync.statNetwork': return '网络';
			case 'vrcnsync.statNetworkConnected': return '已连接';
			case 'vrcnsync.statNetworkDisconnected': return '未连接';
			case 'feedback.title': return '反馈';
			case 'feedback.type': return '反馈类型';
			case 'feedback.types.bug': return '错误报告';
			case 'feedback.types.feature': return '功能请求';
			case 'feedback.types.improvement': return '改进建议';
			case 'feedback.types.other': return '其他';
			case 'feedback.inputTitle': return '标题 *';
			case 'feedback.inputTitleHint': return '请简要说明';
			case 'feedback.inputDescription': return '详细说明 *';
			case 'feedback.inputDescriptionHint': return '请提供详细说明...';
			case 'feedback.cancel': return '取消';
			case 'feedback.send': return '发送';
			case 'feedback.sending': return '发送中...';
			case 'feedback.required': return '标题和详细说明为必填项';
			case 'feedback.success': return '反馈已发送。谢谢！';
			case 'feedback.fail': return '反馈发送失败';
			case 'settings.appearance': return '外观';
			case 'settings.language': return '语言';
			case 'settings.languageDescription': return '您可以选择应用程序的显示语言';
			case 'settings.appIcon': return '应用图标';
			case 'settings.appIconDescription': return '更改主屏幕上显示的应用图标';
			case 'settings.contentSettings': return '内容设置';
			case 'settings.searchEnabled': return '搜索功能已启用';
			case 'settings.searchDisabled': return '搜索功能已禁用';
			case 'settings.enableSearch': return '启用搜索功能';
			case 'settings.enableSearchDescription': return '搜索结果可能包含成人或暴力内容。';
			case 'settings.apiSetting': return '虚拟形象搜索API';
			case 'settings.apiSettingDescription': return '设置虚拟形象搜索功能的API';
			case 'settings.apiSettingSaveUrl': return 'URL已保存';
			case 'settings.notSet': return '未设置（虚拟形象搜索功能无法使用）';
			case 'settings.notifications': return '通知设置';
			case 'settings.eventReminder': return '活动提醒';
			case 'settings.eventReminderDescription': return '在您设定的活动开始前接收通知';
			case 'settings.manageReminders': return '管理已设置的提醒';
			case 'settings.manageRemindersDescription': return '可以取消或确认通知';
			case 'settings.dataStorage': return '数据与存储';
			case 'settings.clearCache': return '清除缓存';
			case 'settings.clearCacheSuccess': return '缓存已清除';
			case 'settings.clearCacheError': return '清除缓存时发生错误';
			case 'settings.cacheSize': return ({required Object size}) => '缓存大小: ${size}';
			case 'settings.calculatingCache': return '正在计算缓存大小...';
			case 'settings.cacheError': return '无法获取缓存大小';
			case 'settings.confirmClearCache': return '清除缓存将删除临时保存的图片和数据。\n\n您的账户信息和应用设置不会被删除。';
			case 'settings.appInfo': return '应用信息';
			case 'settings.version': return '版本';
			case 'settings.packageName': return '包名';
			case 'settings.credit': return '鸣谢';
			case 'settings.creditDescription': return '开发者和贡献者信息';
			case 'settings.contact': return '联系我们';
			case 'settings.contactDescription': return 'BUG报告和建议请点此';
			case 'settings.privacyPolicy': return '隐私政策';
			case 'settings.privacyPolicyDescription': return '关于个人信息的处理';
			case 'settings.termsOfService': return '服务条款';
			case 'settings.termsOfServiceDescription': return '应用使用条件';
			case 'settings.openSource': return '开源信息';
			case 'settings.openSourceDescription': return '所使用的库等许可证信息';
			case 'settings.github': return 'GitHub仓库';
			case 'settings.githubDescription': return '查看源代码';
			case 'settings.logoutConfirm': return '确定要登出吗？';
			case 'settings.logoutError': return ({required Object error}) => '登出时发生错误：${error}';
			case 'settings.iconChangeNotSupported': return '您的设备不支持更改应用图标';
			case 'settings.iconChangeFailed': return '更改图标失败';
			case 'settings.themeMode': return '主题模式';
			case 'settings.themeModeDescription': return '您可以选择应用的显示主题';
			case 'settings.themeLight': return '浅色';
			case 'settings.themeSystem': return '系统';
			case 'settings.themeDark': return '深色';
			case 'settings.appIconDefault': return '默认';
			case 'settings.appIconIcon': return '图标';
			case 'settings.appIconLogo': return '标志';
			case 'settings.delete': return '删除';
			case 'credits.title': return '鸣谢';
			case 'credits.section.development': return '开发';
			case 'credits.section.iconPeople': return '有趣的图标制作者们';
			case 'credits.section.testFeedback': return '测试与反馈';
			case 'credits.section.specialThanks': return '特别感谢';
			case 'download.success': return '下载完成';
			case 'download.failure': return ({required Object error}) => '下载失败：${error}';
			case 'download.shareFailure': return ({required Object error}) => '分享失败：${error}';
			case 'download.permissionTitle': return '需要权限';
			case 'download.permissionDenied': return ({required Object permissionType}) => '保存到${permissionType}的权限已被拒绝。\n请从设置应用中启用权限。';
			case 'download.permissionCancel': return '取消';
			case 'download.permissionOpenSettings': return '打开设置';
			case 'download.permissionPhoto': return '照片';
			case 'download.permissionPhotoLibrary': return '照片库';
			case 'download.permissionStorage': return '存储';
			case 'download.permissionPhotoRequired': return '需要保存到照片的权限';
			case 'download.permissionPhotoLibraryRequired': return '需要保存到照片库的权限';
			case 'download.permissionStorageRequired': return '需要访问存储空间的权限';
			case 'download.permissionError': return ({required Object error}) => '检查权限时发生错误：${error}';
			case 'download.downloading': return ({required Object fileName}) => '正在下载 ${fileName}...';
			case 'download.sharing': return ({required Object fileName}) => '正在准备分享 ${fileName}...';
			case 'instance.type.public': return '公开';
			case 'instance.type.hidden': return '好友+';
			case 'instance.type.friends': return '好友';
			case 'instance.type.private': return '邀请+';
			case 'instance.type.unknown': return '未知';
			case 'status.active': return '在线';
			case 'status.joinMe': return '欢迎加入';
			case 'status.askMe': return '请问我';
			case 'status.busy': return '忙碌';
			case 'status.offline': return '离线';
			case 'status.unknown': return '状态未知';
			case 'location.private': return '私密';
			case 'location.playerCount': return ({required Object userCount, required Object capacity}) => '玩家数：${userCount} / ${capacity}';
			case 'location.instanceType': return ({required Object type}) => '实例类型：${type}';
			case 'location.noInfo': return '没有位置信息';
			case 'location.fetchError': return '获取位置信息失败';
			case 'location.privateLocation': return '您在一个私密地点';
			case 'location.inviteSending': return '发送邀请中...';
			case 'location.inviteSent': return '邀请已发送。您可以从通知中加入';
			case 'location.inviteFailed': return ({required Object error}) => '发送邀请失败：${error}';
			case 'location.inviteButton': return '向自己发送邀请';
			case 'location.isPrivate': return ({required Object number}) => '${number}人私密';
			case 'location.isActive': return ({required Object number}) => '${number}人在线';
			case 'location.isOffline': return ({required Object number}) => '${number}人离线';
			case 'location.isTraveling': return ({required Object number}) => '${number}人移动中';
			case 'location.isStaying': return ({required Object number}) => '${number}人停留中';
			case 'reminder.dialogTitle': return '设置提醒';
			case 'reminder.alreadySet': return '已设置';
			case 'reminder.set': return '设置';
			case 'reminder.cancel': return '取消';
			case 'reminder.delete': return '删除';
			case 'reminder.deleteAll': return '删除所有提醒';
			case 'reminder.deleteAllConfirm': return '这将删除所有已设置的活动提醒。此操作无法撤销。';
			case 'reminder.deleted': return '提醒已删除';
			case 'reminder.deletedAll': return '所有提醒已删除';
			case 'reminder.noReminders': return '没有已设置的提醒';
			case 'reminder.setFromEvent': return '您可以从活动页面设置通知';
			case 'reminder.eventStart': return ({required Object time}) => '${time} 开始';
			case 'reminder.notifyAt': return ({required Object time, required Object label}) => '${time} (${label})';
			case 'reminder.receiveNotification': return '您想在何时收到通知？';
			case 'friend.sortFilter': return '排序和筛选';
			case 'friend.filter': return '筛选';
			case 'friend.filterAll': return '显示全部';
			case 'friend.filterOnline': return '仅在线';
			case 'friend.filterOffline': return '仅离线';
			case 'friend.filterFavorite': return '仅收藏';
			case 'friend.sort': return '排序';
			case 'friend.sortStatus': return '按在线状态';
			case 'friend.sortName': return '按名称';
			case 'friend.sortLastLogin': return '按最后登录时间';
			case 'friend.sortAsc': return '升序';
			case 'friend.sortDesc': return '降序';
			case 'friend.close': return '关闭';
			case 'eventCalendarFilter.filterTitle': return '筛选活动';
			case 'eventCalendarFilter.clear': return '清除';
			case 'eventCalendarFilter.keyword': return '关键词搜索';
			case 'eventCalendarFilter.keywordHint': return '活动名称、说明、主办方等';
			case 'eventCalendarFilter.date': return '按日期筛选';
			case 'eventCalendarFilter.dateHint': return '可以显示特定日期范围的活动';
			case 'eventCalendarFilter.startDate': return '开始日期';
			case 'eventCalendarFilter.endDate': return '结束日期';
			case 'eventCalendarFilter.select': return '请选择';
			case 'eventCalendarFilter.time': return '按时间段筛选';
			case 'eventCalendarFilter.timeHint': return '可以显示特定时间段举办的活动';
			case 'eventCalendarFilter.startTime': return '开始时间';
			case 'eventCalendarFilter.endTime': return '结束时间';
			case 'eventCalendarFilter.genre': return '按类型筛选';
			case 'eventCalendarFilter.genreSelected': return ({required Object count}) => '已选择 ${count} 个类型';
			case 'eventCalendarFilter.apply': return '应用';
			case 'eventCalendarFilter.filterSummary': return '筛选器';
			case 'eventCalendarFilter.filterNone': return '未设置筛选器';
			default: return null;
		}
	}
}

