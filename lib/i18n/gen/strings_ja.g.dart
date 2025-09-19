///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonJa common = TranslationsCommonJa._(_root);
	late final TranslationsTermsAgreementJa termsAgreement = TranslationsTermsAgreementJa._(_root);
	late final TranslationsDrawerJa drawer = TranslationsDrawerJa._(_root);
	late final TranslationsLoginJa login = TranslationsLoginJa._(_root);
	late final TranslationsFriendsJa friends = TranslationsFriendsJa._(_root);
	late final TranslationsFriendDetailJa friendDetail = TranslationsFriendDetailJa._(_root);
	late final TranslationsSearchJa search = TranslationsSearchJa._(_root);
	late final TranslationsProfileJa profile = TranslationsProfileJa._(_root);
	late final TranslationsEngageCardJa engageCard = TranslationsEngageCardJa._(_root);
	late final TranslationsQrScannerJa qrScanner = TranslationsQrScannerJa._(_root);
	late final TranslationsFavoritesJa favorites = TranslationsFavoritesJa._(_root);
	late final TranslationsNotificationsJa notifications = TranslationsNotificationsJa._(_root);
	late final TranslationsEventCalendarJa eventCalendar = TranslationsEventCalendarJa._(_root);
	late final TranslationsAvatarsJa avatars = TranslationsAvatarsJa._(_root);
	late final TranslationsWorldDetailJa worldDetail = TranslationsWorldDetailJa._(_root);
	late final TranslationsAvatarDetailJa avatarDetail = TranslationsAvatarDetailJa._(_root);
	late final TranslationsGroupsJa groups = TranslationsGroupsJa._(_root);
	late final TranslationsGroupDetailJa groupDetail = TranslationsGroupDetailJa._(_root);
	late final TranslationsInventoryJa inventory = TranslationsInventoryJa._(_root);
	late final TranslationsVrcnsyncJa vrcnsync = TranslationsVrcnsyncJa._(_root);
	late final TranslationsFeedbackJa feedback = TranslationsFeedbackJa._(_root);
	late final TranslationsSettingsJa settings = TranslationsSettingsJa._(_root);
	late final TranslationsCreditsJa credits = TranslationsCreditsJa._(_root);
	late final TranslationsDownloadJa download = TranslationsDownloadJa._(_root);
	late final TranslationsInstanceJa instance = TranslationsInstanceJa._(_root);
	late final TranslationsStatusJa status = TranslationsStatusJa._(_root);
	late final TranslationsLocationJa location = TranslationsLocationJa._(_root);
	late final TranslationsReminderJa reminder = TranslationsReminderJa._(_root);
	late final TranslationsFriendJa friend = TranslationsFriendJa._(_root);
	late final TranslationsEventCalendarFilterJa eventCalendarFilter = TranslationsEventCalendarFilterJa._(_root);
}

// Path: common
class TranslationsCommonJa {
	TranslationsCommonJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'VRCN';
	String get ok => 'OK';
	String get cancel => 'キャンセル';
	String get close => '閉じる';
	String get save => '保存';
	String get edit => '編集';
	String get delete => '削除';
	String get yes => 'はい';
	String get no => 'いいえ';
	String get loading => '読み込み中...';
	String error({required Object error}) => 'エラーが発生しました: ${error}';
	String get errorNomessage => 'エラーが発生しました';
	String get retry => '再試行';
	String get search => '検索';
	String get settings => '設定';
	String get confirm => '確認';
	String get agree => '同意する';
	String get decline => '同意しない';
	String get username => 'ユーザー名';
	String get password => 'パスワード';
	String get login => 'ログイン';
	String get logout => 'ログアウト';
	String get share => '共有';
}

// Path: termsAgreement
class TranslationsTermsAgreementJa {
	TranslationsTermsAgreementJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get welcomeTitle => 'VRCN へようこそ';
	String get welcomeMessage => 'アプリをご利用いただく前に\n利用規約とプライバシーポリシーをご確認ください';
	String get termsTitle => '利用規約';
	String get termsSubtitle => 'アプリのご利用条件について';
	String get privacyTitle => 'プライバシーポリシー';
	String get privacySubtitle => '個人情報の取り扱いについて';
	String agreeTerms({required Object title}) => '「${title}」に同意する';
	String get checkContent => '内容を確認';
	String get notice => 'このアプリはVRChat Inc.の非公式アプリです。\nVRChat Inc.とは一切関係ありません。';
}

// Path: drawer
class TranslationsDrawerJa {
	TranslationsDrawerJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'ホーム';
	String get profile => 'プロフィール';
	String get favorite => 'お気に入り';
	String get eventCalendar => 'イベントカレンダー';
	String get avatar => 'アバター';
	String get group => 'グループ';
	String get inventory => 'インベントリ';
	String get vrcnsync => 'VRCNSync (β)';
	String get review => 'レビュー';
	String get feedback => 'フィードバック';
	String get settings => '設定';
	String get userLoading => 'ユーザー情報を読み込み中...';
	String get userError => 'ユーザー情報の取得に失敗しました';
	String get retry => '再試行';
	late final TranslationsDrawerSectionJa section = TranslationsDrawerSectionJa._(_root);
}

// Path: login
class TranslationsLoginJa {
	TranslationsLoginJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get forgotPassword => 'パスワードを忘れた場合';
	String get createAccount => 'アカウントを作成';
	String get subtitle => 'VRChatのアカウント情報でログイン';
	String get email => 'メールアドレス';
	String get emailHint => 'メールまたはユーザー名を入力';
	String get passwordHint => 'パスワードを入力';
	String get rememberMe => 'ログイン状態を保存';
	String get loggingIn => 'ログイン中...';
	String get errorEmptyEmail => 'ユーザー名またはメールアドレスを入力してください';
	String get errorEmptyPassword => 'パスワードを入力してください';
	String get errorLoginFailed => 'ログインに失敗しました。メールアドレスとパスワードを確認してください。';
	String get twoFactorTitle => '二段階認証';
	String get twoFactorSubtitle => '認証コードを入力してください';
	String get twoFactorInstruction => '認証アプリに表示されている\n6桁のコードを入力してください';
	String get twoFactorCodeHint => '認証コード';
	String get verify => '認証';
	String get verifying => '認証中...';
	String get errorEmpty2fa => '認証コードを入力してください';
	String get error2faFailed => '二段階認証に失敗しました。コードが正しいか確認してください。';
	String get backToLogin => 'ログイン画面に戻る';
	String get paste => 'ペースト';
}

// Path: friends
class TranslationsFriendsJa {
	TranslationsFriendsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'フレンド情報を読み込み中...';
	String error({required Object error}) => 'フレンドの情報の取得に失敗しました: ${error}';
	String get notFound => 'フレンドが見つかりませんでした';
	String get private => 'プライベート';
	String get active => 'アクティブ';
	String get offline => 'オフライン';
	String get online => 'オンライン';
	String get groupTitle => 'ワールドごとにグループ化';
	String get refresh => '更新';
	String get searchHint => 'フレンド名で検索';
	String get noResult => '該当するフレンドはいません';
}

// Path: friendDetail
class TranslationsFriendDetailJa {
	TranslationsFriendDetailJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'ユーザー情報を読み込み中...';
	String error({required Object error}) => 'ユーザー情報の取得に失敗しました: ${error}';
	String get currentLocation => '現在の場所';
	String get basicInfo => '基本情報';
	String get userId => 'ユーザーID';
	String get dateJoined => '登録日';
	String get lastLogin => '最終ログイン';
	String get bio => '自己紹介';
	String get links => 'リンク';
	String get loadingLinks => 'リンク情報を読み込み中...';
	String get group => '所属グループ';
	String get groupDetail => 'グループ詳細を表示';
	String groupCode({required Object code}) => 'グループコード: ${code}';
	String memberCount({required Object count}) => 'メンバー数: ${count}人';
	String get unknownGroup => '不明なグループ';
	String get block => 'ブロック';
	String get mute => 'ミュート';
	String get openWebsite => 'ウェブサイトで開く';
	String get shareProfile => 'プロフィールを共有';
	String confirmBlockTitle({required Object name}) => '${name}をブロックしますか？';
	String get confirmBlockMessage => 'ブロックすると、このユーザーからのフレンド申請やメッセージを受け取らなくなります。';
	String confirmMuteTitle({required Object name}) => '${name}をミュートしますか？';
	String get confirmMuteMessage => 'ミュートすると、このユーザーの音声が聞こえなくなります。';
	String get blockSuccess => 'ブロックしました';
	String get muteSuccess => 'ミュートしました';
	String operationFailed({required Object error}) => '操作に失敗しました: ${error}';
}

// Path: search
class TranslationsSearchJa {
	TranslationsSearchJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get userTab => 'ユーザー';
	String get worldTab => 'ワールド';
	String get avatarTab => 'アバター';
	String get groupTab => 'グループ';
	late final TranslationsSearchTabsJa tabs = TranslationsSearchTabsJa._(_root);
}

// Path: profile
class TranslationsProfileJa {
	TranslationsProfileJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'プロフィール';
	String get edit => '編集';
	String get refresh => '更新';
	String get loading => 'プロフィール情報を読み込み中...';
	String get error => 'プロフィール情報の取得に失敗しました: {error}';
	String get displayName => '表示名';
	String get username => 'ユーザー名';
	String get userId => 'ユーザーID';
	String get engageCard => 'エンゲージカード';
	String get frined => 'フレンド';
	String get dateJoined => '登録日';
	String get userType => 'ユーザータイプ';
	String get status => 'ステータス';
	String get statusMessage => 'ステータスメッセージ';
	String get bio => '自己紹介';
	String get links => 'リンク';
	String get group => '所属グループ';
	String get groupDetail => 'グループ詳細を表示';
	String get avatar => '現在のアバター';
	String get avatarDetail => 'アバター詳細を表示';
	String get public => '公開';
	String get private => '非公開';
	String get hidden => '非表示';
	String get unknown => '不明';
	String get friends => 'フレンド';
	String get loadingLinks => 'リンク情報を読み込み中...';
	String get noGroup => '所属グループはありません';
	String get noBio => '自己紹介はありません';
	String get noLinks => 'リンクはありません';
	String get save => '変更を保存';
	String get saved => 'プロフィールを更新しました';
	String get saveFailed => '更新に失敗しました: {error}';
	String get discardTitle => '変更を破棄しますか？';
	String get discardContent => 'プロフィールに加えた変更は保存されません。';
	String get discardCancel => 'キャンセル';
	String get discardOk => '破棄する';
	String get basic => '基本情報';
	String get pronouns => '代名詞';
	String get addLink => '追加';
	String get removeLink => '削除';
	String get linkHint => 'リンクを入力 (例: https://twitter.com/username)';
	String get linksHint => 'リンクはプロフィールに表示され、タップすると開くことができます';
	String get statusMessageHint => 'あなたの今の状況やメッセージを入力';
	String get bioHint => 'あなた自身について書いてみましょう';
}

// Path: engageCard
class TranslationsEngageCardJa {
	TranslationsEngageCardJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pickBackground => '背景画像を選択';
	String get removeBackground => '背景画像を削除';
	String get scanQr => 'QRコードをスキャン';
	String get showAvatar => 'アバターを表示';
	String get hideAvatar => 'アバターを非表示';
	String get noBackground => '背景画像が選択されていません\n右上のボタンから設定できます';
	String get loading => '読み込み中...';
	String error({required Object error}) => 'エンゲージカード情報の取得に失敗しました: ${error}';
	String get copyUserId => 'ユーザーIDをコピー';
	String get copied => 'コピーしました';
}

// Path: qrScanner
class TranslationsQrScannerJa {
	TranslationsQrScannerJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'QRコードスキャン';
	String get guide => 'QRコードを枠内に合わせてください';
	String get loading => 'カメラを初期化中...';
	String error({required Object error}) => 'QRコードの読み取りに失敗しました: ${error}';
	String get notFound => '有効なユーザーQRコードが見つかりません';
}

// Path: favorites
class TranslationsFavoritesJa {
	TranslationsFavoritesJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'お気に入り';
	String get frined => 'フレンド';
	String get friendsTab => 'フレンド';
	String get worldsTab => 'ワールド';
	String get avatarsTab => 'アバター';
	String get emptyFolderTitle => 'お気に入りフォルダがありません';
	String get emptyFolderDescription => 'VRChat内でお気に入りフォルダを作成してください';
	String get emptyFriends => 'このフォルダにはフレンドがいません';
	String get emptyWorlds => 'このフォルダにはワールドがありません';
	String get emptyAvatars => 'このフォルダにはアバターがありません';
	String get emptyWorldsTabTitle => 'お気に入りのワールドがありません';
	String get emptyWorldsTabDescription => 'ワールド詳細画面からお気に入りに登録できます';
	String get emptyAvatarsTabTitle => 'お気に入りのアバターがありません';
	String get emptyAvatarsTabDescription => 'アバター詳細画面からお気に入りに登録できます';
	String get loading => 'お気に入りを読み込み中...';
	String get loadingFolder => 'フォルダ情報を読み込み中...';
	String error({required Object error}) => 'お気に入りの読み込みに失敗しました: ${error}';
	String get errorFolder => '情報の取得に失敗しました';
	String get remove => 'お気に入りから削除';
	String removeSuccess({required Object name}) => '${name}をお気に入りから削除しました';
	String removeFailed({required Object error}) => '削除に失敗しました: ${error}';
	String itemsCount({required Object count}) => '${count} アイテム';
	String get public => '公開';
	String get private => '非公開';
	String get hidden => '非表示';
	String get unknown => '不明';
	String get loadingError => '読み込みエラー';
}

// Path: notifications
class TranslationsNotificationsJa {
	TranslationsNotificationsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get emptyTitle => '通知はありません';
	String get emptyDescription => 'フレンドリクエストや招待など\n新しい通知がここに表示されます';
	String friendRequest({required Object userName}) => '${userName}さんからフレンドリクエストが届いています';
	String invite({required Object userName, required Object worldName}) => '${userName}さんから${worldName}への招待が届いています';
	String friendOnline({required Object userName}) => '${userName}さんがオンラインになりました';
	String friendOffline({required Object userName}) => '${userName}さんがオフラインになりました';
	String friendActive({required Object userName}) => '${userName}さんがアクティブになりました';
	String friendAdd({required Object userName}) => '${userName}さんがフレンドに追加されました';
	String friendRemove({required Object userName}) => '${userName}さんがフレンドから削除されました';
	String statusUpdate({required Object userName, required Object status, required Object world}) => '${userName}さんのステータスが更新されました: ${status}${world}';
	String locationChange({required Object userName, required Object worldName}) => '${userName}さんが${worldName}に移動しました';
	String userUpdate({required Object world}) => 'あなたの情報が更新されました${world}';
	String myLocationChange({required Object worldName}) => 'あなたの移動: ${worldName}';
	String requestInvite({required Object userName}) => '${userName}さんから参加リクエストが届いています';
	String votekick({required Object userName}) => '${userName}さんから投票キックがありました';
	String responseReceived({required Object userName}) => '通知ID:${userName}の応答を受信しました';
	String error({required Object worldName}) => 'エラー: ${worldName}';
	String system({required Object extraData}) => 'システム通知: ${extraData}';
	String secondsAgo({required Object seconds}) => '${seconds}秒前';
	String minutesAgo({required Object minutes}) => '${minutes}分前';
	String hoursAgo({required Object hours}) => '${hours}時間前';
}

// Path: eventCalendar
class TranslationsEventCalendarJa {
	TranslationsEventCalendarJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'イベントカレンダー';
	String get filter => 'イベントを絞り込む';
	String get refresh => 'イベント情報を更新';
	String get loading => 'イベント情報を取得中...';
	String error({required Object error}) => 'イベント情報の取得に失敗しました: ${error}';
	String filterActive({required Object count}) => 'フィルター適用中（${count}件）';
	String get clear => 'クリア';
	String get noEvents => '条件に一致するイベントがありません';
	String get clearFilter => 'フィルターをクリア';
	String get today => '今日';
	String get reminderSet => 'リマインダーを設定';
	String get reminderSetDone => '設定済みリマインダー';
	String get reminderDeleted => 'リマインダーを削除しました';
	String get eventName => 'イベント名';
	String get organizer => '主催者';
	String get description => '説明';
	String get genre => 'ジャンル';
	String get condition => '参加条件';
	String get way => '参加方法';
	String get note => '備考';
	String get quest => 'Quest対応';
	String reminderCount({required Object count}) => '${count}件';
	String startToEnd({required Object start, required Object end}) => '${start}〜${end}';
}

// Path: avatars
class TranslationsAvatarsJa {
	TranslationsAvatarsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'アバター';
	String get searchHint => 'アバター名などで検索';
	String get searchTooltip => '検索';
	String get searchEmptyTitle => '検索結果が見つかりませんでした';
	String get searchEmptyDescription => '別の検索ワードをお試しください';
	String get emptyTitle => 'アバターがありません';
	String get emptyDescription => 'アバターを追加するか、後でもう一度お試しください';
	String get refresh => '更新する';
	String get loading => 'アバターを読み込み中...';
	String error({required Object error}) => 'アバター情報の取得に失敗しました: ${error}';
	String get current => '使用中';
	String get public => '公開';
	String get private => '非公開';
	String get hidden => '非表示';
	String get author => '作者';
	String get sortUpdated => '更新順';
	String get sortName => '名前順';
	String get sortTooltip => '並び替え';
	String get viewModeTooltip => '表示モード切替';
}

// Path: worldDetail
class TranslationsWorldDetailJa {
	TranslationsWorldDetailJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'ワールド情報を読み込み中...';
	String error({required Object error}) => 'ワールド情報の取得に失敗しました: ${error}';
	String get share => 'このワールドを共有';
	String get openInVRChat => 'VRChat公式サイトで開く';
	String get report => 'このワールドを通報';
	String get creator => '作成者';
	String get created => '作成';
	String get updated => '更新';
	String get favorites => 'お気に入り';
	String get visits => '訪問数';
	String get occupants => '現在の人数';
	String get popularity => '評価';
	String get description => '説明';
	String get noDescription => '説明はありません';
	String get tags => 'タグ';
	String get joinPublic => 'パブリックで招待を送信';
	String get favoriteAdded => 'お気に入りに追加しました';
	String get favoriteRemoved => 'お気に入りから削除しました';
	String get unknown => '不明';
}

// Path: avatarDetail
class TranslationsAvatarDetailJa {
	TranslationsAvatarDetailJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String changeSuccess({required Object name}) => 'アバター「${name}」に変更しました';
	String changeFailed({required Object error}) => 'アバターの変更に失敗しました: ${error}';
	String get changing => '変更中...';
	String get useThisAvatar => 'このアバターを使用';
	String get creator => '作成者';
	String get created => '作成';
	String get updated => '更新';
	String get description => '説明';
	String get noDescription => '説明はありません';
	String get tags => 'タグ';
	String get addToFavorites => 'お気に入りに追加';
	String get public => '公開';
	String get private => '非公開';
	String get hidden => '非表示';
	String get unknown => '不明';
	String get share => '共有';
	String get loading => 'アバター情報を読み込み中...';
	String error({required Object error}) => 'アバター情報の取得に失敗しました: ${error}';
}

// Path: groups
class TranslationsGroupsJa {
	TranslationsGroupsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'グループ';
	String get loadingUser => 'ユーザー情報を読み込み中...';
	String errorUser({required Object error}) => 'ユーザー情報の取得に失敗しました: ${error}';
	String get loadingGroups => 'グループ情報を読み込み中...';
	String errorGroups({required Object error}) => 'グループ情報の取得に失敗しました: ${error}';
	String get emptyTitle => 'グループに参加していません';
	String get emptyDescription => 'VRChatアプリやウェブサイトからグループに参加できます';
	String get searchGroups => 'グループを探す';
	String members({required Object count}) => '${count}人のメンバー';
	String get showDetails => '詳細を表示';
	String get unknownName => '名称不明';
}

// Path: groupDetail
class TranslationsGroupDetailJa {
	TranslationsGroupDetailJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'グループ情報を読み込み中...';
	String error({required Object error}) => 'グループ情報の取得に失敗しました: ${error}';
	String get share => 'グループ情報を共有';
	String get description => '説明';
	String get roles => 'ロール';
	String get basicInfo => '基本情報';
	String get createdAt => '作成日';
	String get owner => 'オーナー';
	String get rules => 'ルール';
	String get languages => '言語';
	String memberCount({required Object count}) => '${count} メンバー';
	late final TranslationsGroupDetailPrivacyJa privacy = TranslationsGroupDetailPrivacyJa._(_root);
	late final TranslationsGroupDetailRoleJa role = TranslationsGroupDetailRoleJa._(_root);
}

// Path: inventory
class TranslationsInventoryJa {
	TranslationsInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'インベントリ';
	String get gallery => 'ギャラリー';
	String get icon => 'アイコン';
	String get emoji => '絵文字';
	String get sticker => 'ステッカー';
	String get print => 'プリント';
	String get upload => 'ファイルをアップロード';
	String get uploadGallery => 'ギャラリー画像をアップロード中...';
	String get uploadIcon => 'アイコンをアップロード中...';
	String get uploadEmoji => '絵文字をアップロード中...';
	String get uploadSticker => 'ステッカーをアップロード中...';
	String get uploadPrint => 'プリント画像をアップロード中...';
	String get selectImage => '画像を選択';
	String get selectFromGallery => 'ギャラリーから選択';
	String get takePhoto => 'カメラで撮影';
	String get uploadSuccess => 'アップロードが完了しました';
	String get uploadFailed => 'アップロードに失敗しました';
	String get uploadFailedFormat => 'ファイル形式またはサイズに問題があります。PNG形式で1MB以下の画像を選択してください。';
	String get uploadFailedAuth => '認証に失敗しました。再度ログインしてください。';
	String get uploadFailedSize => 'ファイルサイズが大きすぎます。より小さな画像を選択してください。';
	String uploadFailedServer({required Object code}) => 'サーバーエラーが発生しました (${code})';
	String pickImageFailed({required Object error}) => '画像の選択に失敗しました: ${error}';
	late final TranslationsInventoryTabsJa tabs = TranslationsInventoryTabsJa._(_root);
}

// Path: vrcnsync
class TranslationsVrcnsyncJa {
	TranslationsVrcnsyncJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'VRCNSync (β)';
	String get betaTitle => 'ベータ版機能';
	String get betaDescription => 'この機能は開発中のベータ版です。予期せぬ問題が発生する可能性があります。\n現在はローカルのみの実装ですが、クラウド版が需要があれば実装します。';
	String get githubLink => 'VRCNSyncのGitHubページ';
	String get openGithub => 'GitHubページを開く';
	String get serverRunning => 'サーバー実行中';
	String get serverStopped => 'サーバー停止中';
	String get serverRunningDesc => 'PCからの写真をVRCNアルバムに保存します';
	String get serverStoppedDesc => 'サーバーが停止しています';
	String get photoSaved => '写真をVRCNアルバムに保存しました';
	String get photoReceived => '写真を受信しました（アルバム保存に失敗）';
	String get openAlbum => 'アルバムを開く';
	String get permissionErrorIos => 'フォトライブラリへのアクセス権限が必要です';
	String get permissionErrorAndroid => 'ストレージへのアクセス権限が必要です';
	String get openSettings => '設定を開く';
	String initError({required Object error}) => '初期化に失敗しました: ${error}';
	String get openPhotoAppError => 'フォトアプリを開けませんでした';
	String get serverInfo => 'サーバー情報';
	String ip({required Object ip}) => 'IP: ${ip}';
	String port({required Object port}) => 'ポート: ${port}';
	String address({required Object ip, required Object port}) => '${ip}:${port}';
	String get autoSave => '受信した写真は「VRCN」アルバムに自動保存されます';
	String get usage => '使用方法';
	List<dynamic> get usageSteps => [
		TranslationsVrcnsync$usageSteps$0i0$Ja._(_root),
		TranslationsVrcnsync$usageSteps$0i1$Ja._(_root),
		TranslationsVrcnsync$usageSteps$0i2$Ja._(_root),
		TranslationsVrcnsync$usageSteps$0i3$Ja._(_root),
	];
	String get stats => '接続状況';
	String get statServer => 'サーバー状態';
	String get statServerRunning => '実行中';
	String get statServerStopped => '停止中';
	String get statNetwork => 'ネットワーク';
	String get statNetworkConnected => '接続済み';
	String get statNetworkDisconnected => '未接続';
}

// Path: feedback
class TranslationsFeedbackJa {
	TranslationsFeedbackJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'フィードバック';
	String get type => 'フィードバックタイプ';
	Map<String, String> get types => {
		'bug': 'バグ報告',
		'feature': '機能要望',
		'improvement': '改善提案',
		'other': 'その他',
	};
	String get inputTitle => 'タイトル *';
	String get inputTitleHint => '簡潔にお聞かせください';
	String get inputDescription => '詳細説明 *';
	String get inputDescriptionHint => '詳細な説明をお聞かせください...';
	String get cancel => 'キャンセル';
	String get send => '送信';
	String get sending => '送信中...';
	String get required => 'タイトルと詳細説明は必須項目です';
	String get success => 'フィードバックを送信しました。ありがとうございます！';
	String get fail => 'フィードバックの送信に失敗しました';
}

// Path: settings
class TranslationsSettingsJa {
	TranslationsSettingsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get appearance => '外観';
	String get language => '言語';
	String get languageDescription => 'アプリの表示言語を選択できます';
	String get appIcon => 'アプリアイコン';
	String get appIconDescription => 'ホーム画面に表示されるアプリのアイコンを変更します';
	String get contentSettings => 'コンテンツ設定';
	String get searchEnabled => '検索機能が有効になりました';
	String get searchDisabled => '検索機能が無効になりました';
	String get enableSearch => '検索機能を有効';
	String get enableSearchDescription => '検索結果に性的なコンテンツや暴力的なコンテンツが表示される可能性があります。';
	String get apiSetting => 'アバター検索API';
	String get apiSettingDescription => 'アバター検索機能のAPIを設定します';
	String get apiSettingSaveUrl => 'URLを保存しました';
	String get notSet => '未設定 (アバター検索機能が使用できません)';
	String get notifications => '通知設定';
	String get eventReminder => 'イベントリマインダー';
	String get eventReminderDescription => '設定したイベントの開始前に通知を受け取ります';
	String get manageReminders => '設定済みリマインダーの管理';
	String get manageRemindersDescription => '通知のキャンセルや確認ができます';
	String get dataStorage => 'データとストレージ';
	String get clearCache => 'キャッシュを削除';
	String get clearCacheSuccess => 'キャッシュを削除しました';
	String get clearCacheError => 'キャッシュの削除中にエラーが発生しました';
	String cacheSize({required Object size}) => 'キャッシュサイズ: ${size}';
	String get calculatingCache => 'キャッシュサイズを計算中...';
	String get cacheError => 'キャッシュサイズを取得できませんでした';
	String get confirmClearCache => 'キャッシュを削除すると、一時的に保存された画像やデータが削除されます。\n\nアカウント情報やアプリの設定は削除されません。';
	String get appInfo => 'アプリ情報';
	String get version => 'バージョン';
	String get packageName => 'パッケージ名';
	String get credit => 'クレジット';
	String get creditDescription => '開発者・貢献者情報';
	String get contact => 'お問い合わせ';
	String get contactDescription => '不具合報告・ご意見はこちら';
	String get privacyPolicy => 'プライバシーポリシー';
	String get privacyPolicyDescription => '個人情報の取り扱いについて';
	String get termsOfService => '利用規約';
	String get termsOfServiceDescription => 'アプリのご利用条件';
	String get openSource => 'オープンソース情報';
	String get openSourceDescription => '使用しているライブラリ等のライセンス';
	String get github => 'GitHubリポジトリ';
	String get githubDescription => 'ソースコードを見る';
	String get logoutConfirm => 'ログアウトしますか？';
	String logoutError({required Object error}) => 'ログアウト中にエラーが発生しました: ${error}';
	String get iconChangeNotSupported => 'お使いのデバイスではアプリアイコンの変更がサポートされていません';
	String get iconChangeFailed => 'アイコンの変更に失敗しました';
	String get themeMode => 'テーマモード';
	String get themeModeDescription => 'アプリの表示テーマを選択できます';
	String get themeLight => '明るい';
	String get themeSystem => 'システム';
	String get themeDark => '暗い';
	String get appIconDefault => 'デフォルト';
	String get appIconIcon => 'アイコン';
	String get appIconLogo => 'ロゴ';
	String get delete => '削除する';
}

// Path: credits
class TranslationsCreditsJa {
	TranslationsCreditsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'クレジット';
	late final TranslationsCreditsSectionJa section = TranslationsCreditsSectionJa._(_root);
}

// Path: download
class TranslationsDownloadJa {
	TranslationsDownloadJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get success => 'ダウンロードが完了しました';
	String failure({required Object error}) => 'ダウンロードに失敗しました: ${error}';
	String shareFailure({required Object error}) => '共有に失敗しました: ${error}';
	String get permissionTitle => '権限が必要です';
	String permissionDenied({required Object permissionType}) => '${permissionType}への保存権限が拒否されています。\n設定アプリから権限を有効にしてください。';
	String get permissionCancel => 'キャンセル';
	String get permissionOpenSettings => '設定を開く';
	String get permissionPhoto => 'フォト';
	String get permissionPhotoLibrary => 'フォトライブラリ';
	String get permissionStorage => 'ストレージ';
	String get permissionPhotoRequired => '写真への保存権限が必要です';
	String get permissionPhotoLibraryRequired => 'フォトライブラリへの保存権限が必要です';
	String get permissionStorageRequired => 'ストレージへのアクセス権限が必要です';
	String permissionError({required Object error}) => '権限チェック中にエラーが発生しました: ${error}';
	String downloading({required Object fileName}) => '${fileName} をダウンロード中...';
	String sharing({required Object fileName}) => '${fileName} を共有準備中...';
}

// Path: instance
class TranslationsInstanceJa {
	TranslationsInstanceJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsInstanceTypeJa type = TranslationsInstanceTypeJa._(_root);
}

// Path: status
class TranslationsStatusJa {
	TranslationsStatusJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get active => 'オンライン';
	String get joinMe => 'だれでもおいで';
	String get askMe => 'きいてみてね';
	String get busy => '取り込み中';
	String get offline => 'オフライン';
	String get unknown => 'ステータス不明';
}

// Path: location
class TranslationsLocationJa {
	TranslationsLocationJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get private => 'プライベート';
	String playerCount({required Object userCount, required Object capacity}) => 'プレイヤー数: ${userCount} / ${capacity}';
	String instanceType({required Object type}) => 'インスタンスタイプ: ${type}';
	String get noInfo => 'ロケーション情報はありません';
	String get fetchError => 'ロケーション情報の取得に失敗しました';
	String get privateLocation => 'プライベートな場所にいます';
	String get inviteSending => '招待を送信中...';
	String get inviteSent => '招待を送信しました。通知から参加できます';
	String inviteFailed({required Object error}) => '招待の送信に失敗しました: ${error}';
	String get inviteButton => '自分に招待を送信';
	String isPrivate({required Object number}) => '${number}人がプライベート';
	String isActive({required Object number}) => '${number}人がアクティブ';
	String isOffline({required Object number}) => '${number}人がオフライン';
	String isTraveling({required Object number}) => '${number}人が移動中';
	String isStaying({required Object number}) => '${number}人が滞在中';
}

// Path: reminder
class TranslationsReminderJa {
	TranslationsReminderJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get dialogTitle => 'リマインダーを設定';
	String get alreadySet => '設定済み';
	String get set => '設定する';
	String get cancel => 'キャンセル';
	String get delete => '削除する';
	String get deleteAll => 'すべてのリマインダーを削除';
	String get deleteAllConfirm => '設定したすべてのイベントリマインダーを削除します。この操作は元に戻せません。';
	String get deleted => 'リマインダーを削除しました';
	String get deletedAll => 'すべてのリマインダーを削除しました';
	String get noReminders => '設定済みのリマインダーはありません';
	String get setFromEvent => 'イベントページから通知を設定できます';
	String eventStart({required Object time}) => '${time} 開始';
	String notifyAt({required Object time, required Object label}) => '${time} (${label})';
	String get receiveNotification => 'いつ通知を受け取りますか？';
}

// Path: friend
class TranslationsFriendJa {
	TranslationsFriendJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get sortFilter => '並び替え・フィルター';
	String get filter => 'フィルター';
	String get filterAll => 'すべて表示';
	String get filterOnline => 'オンラインのみ';
	String get filterOffline => 'オフラインのみ';
	String get filterFavorite => 'お気に入りのみ';
	String get sort => '並び替え';
	String get sortStatus => 'オンライン状態順';
	String get sortName => '名前順';
	String get sortLastLogin => '最終ログイン順';
	String get sortAsc => '昇順';
	String get sortDesc => '降順';
	String get close => '閉じる';
}

// Path: eventCalendarFilter
class TranslationsEventCalendarFilterJa {
	TranslationsEventCalendarFilterJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get filterTitle => 'イベントを絞り込む';
	String get clear => 'クリア';
	String get keyword => 'キーワード検索';
	String get keywordHint => 'イベント名、説明、主催者など';
	String get date => '日付で絞り込み';
	String get dateHint => '特定の日付範囲のイベントを表示できます';
	String get startDate => '開始日';
	String get endDate => '終了日';
	String get select => '選択してください';
	String get time => '時間帯で絞り込み';
	String get timeHint => '特定の時間帯に開催されるイベントを表示できます';
	String get startTime => '開始時間';
	String get endTime => '終了時間';
	String get genre => 'ジャンルで絞り込み';
	String genreSelected({required Object count}) => '${count}個のジャンルを選択中';
	String get apply => '適用する';
	String get filterSummary => 'フィルター';
	String get filterNone => 'フィルターは設定されていません';
}

// Path: drawer.section
class TranslationsDrawerSectionJa {
	TranslationsDrawerSectionJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get content => 'コンテンツ';
	String get other => 'その他';
}

// Path: search.tabs
class TranslationsSearchTabsJa {
	TranslationsSearchTabsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSearchTabsUserSearchJa userSearch = TranslationsSearchTabsUserSearchJa._(_root);
	late final TranslationsSearchTabsWorldSearchJa worldSearch = TranslationsSearchTabsWorldSearchJa._(_root);
	late final TranslationsSearchTabsGroupSearchJa groupSearch = TranslationsSearchTabsGroupSearchJa._(_root);
	late final TranslationsSearchTabsAvatarSearchJa avatarSearch = TranslationsSearchTabsAvatarSearchJa._(_root);
}

// Path: groupDetail.privacy
class TranslationsGroupDetailPrivacyJa {
	TranslationsGroupDetailPrivacyJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get public => '公開';
	String get private => '非公開';
	String get friends => 'フレンド';
	String get invite => '招待制';
	String get unknown => '不明';
}

// Path: groupDetail.role
class TranslationsGroupDetailRoleJa {
	TranslationsGroupDetailRoleJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get admin => '管理者';
	String get moderator => 'モデレーター';
	String get member => 'メンバー';
	String get unknown => '不明';
}

// Path: inventory.tabs
class TranslationsInventoryTabsJa {
	TranslationsInventoryTabsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsInventoryTabsEmojiInventoryJa emojiInventory = TranslationsInventoryTabsEmojiInventoryJa._(_root);
	late final TranslationsInventoryTabsGalleryInventoryJa galleryInventory = TranslationsInventoryTabsGalleryInventoryJa._(_root);
	late final TranslationsInventoryTabsIconInventoryJa iconInventory = TranslationsInventoryTabsIconInventoryJa._(_root);
	late final TranslationsInventoryTabsPrintInventoryJa printInventory = TranslationsInventoryTabsPrintInventoryJa._(_root);
	late final TranslationsInventoryTabsStickerInventoryJa stickerInventory = TranslationsInventoryTabsStickerInventoryJa._(_root);
}

// Path: vrcnsync.usageSteps.0
class TranslationsVrcnsync$usageSteps$0i0$Ja {
	TranslationsVrcnsync$usageSteps$0i0$Ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'PCでVRCNSyncアプリを起動';
	String get desc => 'PCでVRCNSyncアプリを起動してください';
}

// Path: vrcnsync.usageSteps.1
class TranslationsVrcnsync$usageSteps$0i1$Ja {
	TranslationsVrcnsync$usageSteps$0i1$Ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '同じWiFiネットワークに接続';
	String get desc => 'PC・モバイル端末を同じWiFiネットワークに接続してください';
}

// Path: vrcnsync.usageSteps.2
class TranslationsVrcnsync$usageSteps$0i2$Ja {
	TranslationsVrcnsync$usageSteps$0i2$Ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '接続先にモバイル端末を指定';
	String get desc => 'PCアプリで上記のIPアドレスとポートを指定してください';
}

// Path: vrcnsync.usageSteps.3
class TranslationsVrcnsync$usageSteps$0i3$Ja {
	TranslationsVrcnsync$usageSteps$0i3$Ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '写真を送信';
	String get desc => 'PCから写真を送信すると、自動的にVRCNアルバムに保存されます';
}

// Path: credits.section
class TranslationsCreditsSectionJa {
	TranslationsCreditsSectionJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get development => '開発';
	String get iconPeople => '愉快なアイコンの人たち';
	String get testFeedback => 'テスト・フィードバック';
	String get specialThanks => 'スペシャルサンクス';
}

// Path: instance.type
class TranslationsInstanceTypeJa {
	TranslationsInstanceTypeJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get public => 'パブリック';
	String get hidden => 'フレンド+';
	String get friends => 'フレンド';
	String get private => 'インバイト+';
	String get unknown => '不明';
}

// Path: search.tabs.userSearch
class TranslationsSearchTabsUserSearchJa {
	TranslationsSearchTabsUserSearchJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get emptyTitle => 'ユーザー検索';
	String get emptyDescription => 'ユーザー名やIDで検索できます';
	String get searching => '検索中...';
	String get noResults => '該当するユーザーが見つかりません';
	String error({required Object error}) => 'ユーザー検索中にエラーが発生しました: ${error}';
	String get inputPlaceholder => 'ユーザー名またはIDを入力';
}

// Path: search.tabs.worldSearch
class TranslationsSearchTabsWorldSearchJa {
	TranslationsSearchTabsWorldSearchJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get emptyTitle => 'ワールドを探索';
	String get emptyDescription => 'キーワードを入力して検索してください';
	String get searching => '検索中...';
	String get noResults => '該当するワールドが見つかりませんでした';
	String noResultsWithQuery({required Object query}) => '「${query}」に一致するワールドが\n見つかりませんでした';
	String get noResultsHint => '検索キーワードを変えてみましょう';
	String error({required Object error}) => 'ワールド検索中にエラーが発生しました: ${error}';
	String resultCount({required Object count}) => '${count}件のワールドが見つかりました';
	String authorPrefix({required Object authorName}) => 'by ${authorName}';
	String get listView => 'リストビュー';
	String get gridView => 'グリッドビュー';
}

// Path: search.tabs.groupSearch
class TranslationsSearchTabsGroupSearchJa {
	TranslationsSearchTabsGroupSearchJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get emptyTitle => 'グループを検索';
	String get emptyDescription => 'キーワードを入力して検索してください';
	String get searching => '検索中...';
	String get noResults => '該当するグループが見つかりませんでした';
	String noResultsWithQuery({required Object query}) => '「${query}」に一致するグループが\n見つかりませんでした';
	String get noResultsHint => '検索キーワードを変えてみましょう';
	String error({required Object error}) => 'グループ検索中にエラーが発生しました: ${error}';
	String resultCount({required Object count}) => '${count}件のグループが見つかりました';
	String get listView => 'リストビュー';
	String get gridView => 'グリッドビュー';
	String memberCount({required Object count}) => '${count} メンバー';
}

// Path: search.tabs.avatarSearch
class TranslationsSearchTabsAvatarSearchJa {
	TranslationsSearchTabsAvatarSearchJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get avatar => 'アバター';
	String get emptyTitle => 'アバターを検索';
	String get emptyDescription => 'キーワードを入力して検索してください';
	String get searching => 'アバターを検索中...';
	String get noResults => '検索結果が見つかりませんでした';
	String get noResultsHint => '別のキーワードで試してみましょう';
	String error({required Object error}) => 'アバター検索中にエラーが発生しました: ${error}';
}

// Path: inventory.tabs.emojiInventory
class TranslationsInventoryTabsEmojiInventoryJa {
	TranslationsInventoryTabsEmojiInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => '絵文字を読み込み中...';
	String error({required Object error}) => '絵文字の取得に失敗しました: ${error}';
	String get emptyTitle => '絵文字がありません';
	String get emptyDescription => 'VRChatでアップロードした絵文字がここに表示されます';
	String get zoomHint => 'ダブルタップでズーム';
}

// Path: inventory.tabs.galleryInventory
class TranslationsInventoryTabsGalleryInventoryJa {
	TranslationsInventoryTabsGalleryInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'ギャラリーを読み込み中...';
	String error({required Object error}) => 'ギャラリーの取得に失敗しました: ${error}';
	String get emptyTitle => 'ギャラリーがありません';
	String get emptyDescription => 'VRChatでアップロードしたギャラリーがここに表示されます';
	String get zoomHint => 'ダブルタップでズーム';
}

// Path: inventory.tabs.iconInventory
class TranslationsInventoryTabsIconInventoryJa {
	TranslationsInventoryTabsIconInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'アイコンを読み込み中...';
	String error({required Object error}) => 'アイコンの取得に失敗しました: ${error}';
	String get emptyTitle => 'アイコンがありません';
	String get emptyDescription => 'VRChatでアップロードしたアイコンがここに表示されます';
	String get zoomHint => 'ダブルタップでズーム';
}

// Path: inventory.tabs.printInventory
class TranslationsInventoryTabsPrintInventoryJa {
	TranslationsInventoryTabsPrintInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'プリントを読み込み中...';
	String error({required Object error}) => 'プリントの取得に失敗しました: ${error}';
	String get emptyTitle => 'プリントがありません';
	String get emptyDescription => 'VRChatでアップロードしたプリントがここに表示されます';
	String get zoomHint => 'ダブルタップでズーム';
}

// Path: inventory.tabs.stickerInventory
class TranslationsInventoryTabsStickerInventoryJa {
	TranslationsInventoryTabsStickerInventoryJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'ステッカーを読み込み中...';
	String error({required Object error}) => 'ステッカーの取得に失敗しました: ${error}';
	String get emptyTitle => 'ステッカーがありません';
	String get emptyDescription => 'VRChatでアップロードしたステッカーがここに表示されます';
	String get zoomHint => 'ダブルタップでズーム';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'common.title': return 'VRCN';
			case 'common.ok': return 'OK';
			case 'common.cancel': return 'キャンセル';
			case 'common.close': return '閉じる';
			case 'common.save': return '保存';
			case 'common.edit': return '編集';
			case 'common.delete': return '削除';
			case 'common.yes': return 'はい';
			case 'common.no': return 'いいえ';
			case 'common.loading': return '読み込み中...';
			case 'common.error': return ({required Object error}) => 'エラーが発生しました: ${error}';
			case 'common.errorNomessage': return 'エラーが発生しました';
			case 'common.retry': return '再試行';
			case 'common.search': return '検索';
			case 'common.settings': return '設定';
			case 'common.confirm': return '確認';
			case 'common.agree': return '同意する';
			case 'common.decline': return '同意しない';
			case 'common.username': return 'ユーザー名';
			case 'common.password': return 'パスワード';
			case 'common.login': return 'ログイン';
			case 'common.logout': return 'ログアウト';
			case 'common.share': return '共有';
			case 'termsAgreement.welcomeTitle': return 'VRCN へようこそ';
			case 'termsAgreement.welcomeMessage': return 'アプリをご利用いただく前に\n利用規約とプライバシーポリシーをご確認ください';
			case 'termsAgreement.termsTitle': return '利用規約';
			case 'termsAgreement.termsSubtitle': return 'アプリのご利用条件について';
			case 'termsAgreement.privacyTitle': return 'プライバシーポリシー';
			case 'termsAgreement.privacySubtitle': return '個人情報の取り扱いについて';
			case 'termsAgreement.agreeTerms': return ({required Object title}) => '「${title}」に同意する';
			case 'termsAgreement.checkContent': return '内容を確認';
			case 'termsAgreement.notice': return 'このアプリはVRChat Inc.の非公式アプリです。\nVRChat Inc.とは一切関係ありません。';
			case 'drawer.home': return 'ホーム';
			case 'drawer.profile': return 'プロフィール';
			case 'drawer.favorite': return 'お気に入り';
			case 'drawer.eventCalendar': return 'イベントカレンダー';
			case 'drawer.avatar': return 'アバター';
			case 'drawer.group': return 'グループ';
			case 'drawer.inventory': return 'インベントリ';
			case 'drawer.vrcnsync': return 'VRCNSync (β)';
			case 'drawer.review': return 'レビュー';
			case 'drawer.feedback': return 'フィードバック';
			case 'drawer.settings': return '設定';
			case 'drawer.userLoading': return 'ユーザー情報を読み込み中...';
			case 'drawer.userError': return 'ユーザー情報の取得に失敗しました';
			case 'drawer.retry': return '再試行';
			case 'drawer.section.content': return 'コンテンツ';
			case 'drawer.section.other': return 'その他';
			case 'login.forgotPassword': return 'パスワードを忘れた場合';
			case 'login.createAccount': return 'アカウントを作成';
			case 'login.subtitle': return 'VRChatのアカウント情報でログイン';
			case 'login.email': return 'メールアドレス';
			case 'login.emailHint': return 'メールまたはユーザー名を入力';
			case 'login.passwordHint': return 'パスワードを入力';
			case 'login.rememberMe': return 'ログイン状態を保存';
			case 'login.loggingIn': return 'ログイン中...';
			case 'login.errorEmptyEmail': return 'ユーザー名またはメールアドレスを入力してください';
			case 'login.errorEmptyPassword': return 'パスワードを入力してください';
			case 'login.errorLoginFailed': return 'ログインに失敗しました。メールアドレスとパスワードを確認してください。';
			case 'login.twoFactorTitle': return '二段階認証';
			case 'login.twoFactorSubtitle': return '認証コードを入力してください';
			case 'login.twoFactorInstruction': return '認証アプリに表示されている\n6桁のコードを入力してください';
			case 'login.twoFactorCodeHint': return '認証コード';
			case 'login.verify': return '認証';
			case 'login.verifying': return '認証中...';
			case 'login.errorEmpty2fa': return '認証コードを入力してください';
			case 'login.error2faFailed': return '二段階認証に失敗しました。コードが正しいか確認してください。';
			case 'login.backToLogin': return 'ログイン画面に戻る';
			case 'login.paste': return 'ペースト';
			case 'friends.loading': return 'フレンド情報を読み込み中...';
			case 'friends.error': return ({required Object error}) => 'フレンドの情報の取得に失敗しました: ${error}';
			case 'friends.notFound': return 'フレンドが見つかりませんでした';
			case 'friends.private': return 'プライベート';
			case 'friends.active': return 'アクティブ';
			case 'friends.offline': return 'オフライン';
			case 'friends.online': return 'オンライン';
			case 'friends.groupTitle': return 'ワールドごとにグループ化';
			case 'friends.refresh': return '更新';
			case 'friends.searchHint': return 'フレンド名で検索';
			case 'friends.noResult': return '該当するフレンドはいません';
			case 'friendDetail.loading': return 'ユーザー情報を読み込み中...';
			case 'friendDetail.error': return ({required Object error}) => 'ユーザー情報の取得に失敗しました: ${error}';
			case 'friendDetail.currentLocation': return '現在の場所';
			case 'friendDetail.basicInfo': return '基本情報';
			case 'friendDetail.userId': return 'ユーザーID';
			case 'friendDetail.dateJoined': return '登録日';
			case 'friendDetail.lastLogin': return '最終ログイン';
			case 'friendDetail.bio': return '自己紹介';
			case 'friendDetail.links': return 'リンク';
			case 'friendDetail.loadingLinks': return 'リンク情報を読み込み中...';
			case 'friendDetail.group': return '所属グループ';
			case 'friendDetail.groupDetail': return 'グループ詳細を表示';
			case 'friendDetail.groupCode': return ({required Object code}) => 'グループコード: ${code}';
			case 'friendDetail.memberCount': return ({required Object count}) => 'メンバー数: ${count}人';
			case 'friendDetail.unknownGroup': return '不明なグループ';
			case 'friendDetail.block': return 'ブロック';
			case 'friendDetail.mute': return 'ミュート';
			case 'friendDetail.openWebsite': return 'ウェブサイトで開く';
			case 'friendDetail.shareProfile': return 'プロフィールを共有';
			case 'friendDetail.confirmBlockTitle': return ({required Object name}) => '${name}をブロックしますか？';
			case 'friendDetail.confirmBlockMessage': return 'ブロックすると、このユーザーからのフレンド申請やメッセージを受け取らなくなります。';
			case 'friendDetail.confirmMuteTitle': return ({required Object name}) => '${name}をミュートしますか？';
			case 'friendDetail.confirmMuteMessage': return 'ミュートすると、このユーザーの音声が聞こえなくなります。';
			case 'friendDetail.blockSuccess': return 'ブロックしました';
			case 'friendDetail.muteSuccess': return 'ミュートしました';
			case 'friendDetail.operationFailed': return ({required Object error}) => '操作に失敗しました: ${error}';
			case 'search.userTab': return 'ユーザー';
			case 'search.worldTab': return 'ワールド';
			case 'search.avatarTab': return 'アバター';
			case 'search.groupTab': return 'グループ';
			case 'search.tabs.userSearch.emptyTitle': return 'ユーザー検索';
			case 'search.tabs.userSearch.emptyDescription': return 'ユーザー名やIDで検索できます';
			case 'search.tabs.userSearch.searching': return '検索中...';
			case 'search.tabs.userSearch.noResults': return '該当するユーザーが見つかりません';
			case 'search.tabs.userSearch.error': return ({required Object error}) => 'ユーザー検索中にエラーが発生しました: ${error}';
			case 'search.tabs.userSearch.inputPlaceholder': return 'ユーザー名またはIDを入力';
			case 'search.tabs.worldSearch.emptyTitle': return 'ワールドを探索';
			case 'search.tabs.worldSearch.emptyDescription': return 'キーワードを入力して検索してください';
			case 'search.tabs.worldSearch.searching': return '検索中...';
			case 'search.tabs.worldSearch.noResults': return '該当するワールドが見つかりませんでした';
			case 'search.tabs.worldSearch.noResultsWithQuery': return ({required Object query}) => '「${query}」に一致するワールドが\n見つかりませんでした';
			case 'search.tabs.worldSearch.noResultsHint': return '検索キーワードを変えてみましょう';
			case 'search.tabs.worldSearch.error': return ({required Object error}) => 'ワールド検索中にエラーが発生しました: ${error}';
			case 'search.tabs.worldSearch.resultCount': return ({required Object count}) => '${count}件のワールドが見つかりました';
			case 'search.tabs.worldSearch.authorPrefix': return ({required Object authorName}) => 'by ${authorName}';
			case 'search.tabs.worldSearch.listView': return 'リストビュー';
			case 'search.tabs.worldSearch.gridView': return 'グリッドビュー';
			case 'search.tabs.groupSearch.emptyTitle': return 'グループを検索';
			case 'search.tabs.groupSearch.emptyDescription': return 'キーワードを入力して検索してください';
			case 'search.tabs.groupSearch.searching': return '検索中...';
			case 'search.tabs.groupSearch.noResults': return '該当するグループが見つかりませんでした';
			case 'search.tabs.groupSearch.noResultsWithQuery': return ({required Object query}) => '「${query}」に一致するグループが\n見つかりませんでした';
			case 'search.tabs.groupSearch.noResultsHint': return '検索キーワードを変えてみましょう';
			case 'search.tabs.groupSearch.error': return ({required Object error}) => 'グループ検索中にエラーが発生しました: ${error}';
			case 'search.tabs.groupSearch.resultCount': return ({required Object count}) => '${count}件のグループが見つかりました';
			case 'search.tabs.groupSearch.listView': return 'リストビュー';
			case 'search.tabs.groupSearch.gridView': return 'グリッドビュー';
			case 'search.tabs.groupSearch.memberCount': return ({required Object count}) => '${count} メンバー';
			case 'search.tabs.avatarSearch.avatar': return 'アバター';
			case 'search.tabs.avatarSearch.emptyTitle': return 'アバターを検索';
			case 'search.tabs.avatarSearch.emptyDescription': return 'キーワードを入力して検索してください';
			case 'search.tabs.avatarSearch.searching': return 'アバターを検索中...';
			case 'search.tabs.avatarSearch.noResults': return '検索結果が見つかりませんでした';
			case 'search.tabs.avatarSearch.noResultsHint': return '別のキーワードで試してみましょう';
			case 'search.tabs.avatarSearch.error': return ({required Object error}) => 'アバター検索中にエラーが発生しました: ${error}';
			case 'profile.title': return 'プロフィール';
			case 'profile.edit': return '編集';
			case 'profile.refresh': return '更新';
			case 'profile.loading': return 'プロフィール情報を読み込み中...';
			case 'profile.error': return 'プロフィール情報の取得に失敗しました: {error}';
			case 'profile.displayName': return '表示名';
			case 'profile.username': return 'ユーザー名';
			case 'profile.userId': return 'ユーザーID';
			case 'profile.engageCard': return 'エンゲージカード';
			case 'profile.frined': return 'フレンド';
			case 'profile.dateJoined': return '登録日';
			case 'profile.userType': return 'ユーザータイプ';
			case 'profile.status': return 'ステータス';
			case 'profile.statusMessage': return 'ステータスメッセージ';
			case 'profile.bio': return '自己紹介';
			case 'profile.links': return 'リンク';
			case 'profile.group': return '所属グループ';
			case 'profile.groupDetail': return 'グループ詳細を表示';
			case 'profile.avatar': return '現在のアバター';
			case 'profile.avatarDetail': return 'アバター詳細を表示';
			case 'profile.public': return '公開';
			case 'profile.private': return '非公開';
			case 'profile.hidden': return '非表示';
			case 'profile.unknown': return '不明';
			case 'profile.friends': return 'フレンド';
			case 'profile.loadingLinks': return 'リンク情報を読み込み中...';
			case 'profile.noGroup': return '所属グループはありません';
			case 'profile.noBio': return '自己紹介はありません';
			case 'profile.noLinks': return 'リンクはありません';
			case 'profile.save': return '変更を保存';
			case 'profile.saved': return 'プロフィールを更新しました';
			case 'profile.saveFailed': return '更新に失敗しました: {error}';
			case 'profile.discardTitle': return '変更を破棄しますか？';
			case 'profile.discardContent': return 'プロフィールに加えた変更は保存されません。';
			case 'profile.discardCancel': return 'キャンセル';
			case 'profile.discardOk': return '破棄する';
			case 'profile.basic': return '基本情報';
			case 'profile.pronouns': return '代名詞';
			case 'profile.addLink': return '追加';
			case 'profile.removeLink': return '削除';
			case 'profile.linkHint': return 'リンクを入力 (例: https://twitter.com/username)';
			case 'profile.linksHint': return 'リンクはプロフィールに表示され、タップすると開くことができます';
			case 'profile.statusMessageHint': return 'あなたの今の状況やメッセージを入力';
			case 'profile.bioHint': return 'あなた自身について書いてみましょう';
			case 'engageCard.pickBackground': return '背景画像を選択';
			case 'engageCard.removeBackground': return '背景画像を削除';
			case 'engageCard.scanQr': return 'QRコードをスキャン';
			case 'engageCard.showAvatar': return 'アバターを表示';
			case 'engageCard.hideAvatar': return 'アバターを非表示';
			case 'engageCard.noBackground': return '背景画像が選択されていません\n右上のボタンから設定できます';
			case 'engageCard.loading': return '読み込み中...';
			case 'engageCard.error': return ({required Object error}) => 'エンゲージカード情報の取得に失敗しました: ${error}';
			case 'engageCard.copyUserId': return 'ユーザーIDをコピー';
			case 'engageCard.copied': return 'コピーしました';
			case 'qrScanner.title': return 'QRコードスキャン';
			case 'qrScanner.guide': return 'QRコードを枠内に合わせてください';
			case 'qrScanner.loading': return 'カメラを初期化中...';
			case 'qrScanner.error': return ({required Object error}) => 'QRコードの読み取りに失敗しました: ${error}';
			case 'qrScanner.notFound': return '有効なユーザーQRコードが見つかりません';
			case 'favorites.title': return 'お気に入り';
			case 'favorites.frined': return 'フレンド';
			case 'favorites.friendsTab': return 'フレンド';
			case 'favorites.worldsTab': return 'ワールド';
			case 'favorites.avatarsTab': return 'アバター';
			case 'favorites.emptyFolderTitle': return 'お気に入りフォルダがありません';
			case 'favorites.emptyFolderDescription': return 'VRChat内でお気に入りフォルダを作成してください';
			case 'favorites.emptyFriends': return 'このフォルダにはフレンドがいません';
			case 'favorites.emptyWorlds': return 'このフォルダにはワールドがありません';
			case 'favorites.emptyAvatars': return 'このフォルダにはアバターがありません';
			case 'favorites.emptyWorldsTabTitle': return 'お気に入りのワールドがありません';
			case 'favorites.emptyWorldsTabDescription': return 'ワールド詳細画面からお気に入りに登録できます';
			case 'favorites.emptyAvatarsTabTitle': return 'お気に入りのアバターがありません';
			case 'favorites.emptyAvatarsTabDescription': return 'アバター詳細画面からお気に入りに登録できます';
			case 'favorites.loading': return 'お気に入りを読み込み中...';
			case 'favorites.loadingFolder': return 'フォルダ情報を読み込み中...';
			case 'favorites.error': return ({required Object error}) => 'お気に入りの読み込みに失敗しました: ${error}';
			case 'favorites.errorFolder': return '情報の取得に失敗しました';
			case 'favorites.remove': return 'お気に入りから削除';
			case 'favorites.removeSuccess': return ({required Object name}) => '${name}をお気に入りから削除しました';
			case 'favorites.removeFailed': return ({required Object error}) => '削除に失敗しました: ${error}';
			case 'favorites.itemsCount': return ({required Object count}) => '${count} アイテム';
			case 'favorites.public': return '公開';
			case 'favorites.private': return '非公開';
			case 'favorites.hidden': return '非表示';
			case 'favorites.unknown': return '不明';
			case 'favorites.loadingError': return '読み込みエラー';
			case 'notifications.emptyTitle': return '通知はありません';
			case 'notifications.emptyDescription': return 'フレンドリクエストや招待など\n新しい通知がここに表示されます';
			case 'notifications.friendRequest': return ({required Object userName}) => '${userName}さんからフレンドリクエストが届いています';
			case 'notifications.invite': return ({required Object userName, required Object worldName}) => '${userName}さんから${worldName}への招待が届いています';
			case 'notifications.friendOnline': return ({required Object userName}) => '${userName}さんがオンラインになりました';
			case 'notifications.friendOffline': return ({required Object userName}) => '${userName}さんがオフラインになりました';
			case 'notifications.friendActive': return ({required Object userName}) => '${userName}さんがアクティブになりました';
			case 'notifications.friendAdd': return ({required Object userName}) => '${userName}さんがフレンドに追加されました';
			case 'notifications.friendRemove': return ({required Object userName}) => '${userName}さんがフレンドから削除されました';
			case 'notifications.statusUpdate': return ({required Object userName, required Object status, required Object world}) => '${userName}さんのステータスが更新されました: ${status}${world}';
			case 'notifications.locationChange': return ({required Object userName, required Object worldName}) => '${userName}さんが${worldName}に移動しました';
			case 'notifications.userUpdate': return ({required Object world}) => 'あなたの情報が更新されました${world}';
			case 'notifications.myLocationChange': return ({required Object worldName}) => 'あなたの移動: ${worldName}';
			case 'notifications.requestInvite': return ({required Object userName}) => '${userName}さんから参加リクエストが届いています';
			case 'notifications.votekick': return ({required Object userName}) => '${userName}さんから投票キックがありました';
			case 'notifications.responseReceived': return ({required Object userName}) => '通知ID:${userName}の応答を受信しました';
			case 'notifications.error': return ({required Object worldName}) => 'エラー: ${worldName}';
			case 'notifications.system': return ({required Object extraData}) => 'システム通知: ${extraData}';
			case 'notifications.secondsAgo': return ({required Object seconds}) => '${seconds}秒前';
			case 'notifications.minutesAgo': return ({required Object minutes}) => '${minutes}分前';
			case 'notifications.hoursAgo': return ({required Object hours}) => '${hours}時間前';
			case 'eventCalendar.title': return 'イベントカレンダー';
			case 'eventCalendar.filter': return 'イベントを絞り込む';
			case 'eventCalendar.refresh': return 'イベント情報を更新';
			case 'eventCalendar.loading': return 'イベント情報を取得中...';
			case 'eventCalendar.error': return ({required Object error}) => 'イベント情報の取得に失敗しました: ${error}';
			case 'eventCalendar.filterActive': return ({required Object count}) => 'フィルター適用中（${count}件）';
			case 'eventCalendar.clear': return 'クリア';
			case 'eventCalendar.noEvents': return '条件に一致するイベントがありません';
			case 'eventCalendar.clearFilter': return 'フィルターをクリア';
			case 'eventCalendar.today': return '今日';
			case 'eventCalendar.reminderSet': return 'リマインダーを設定';
			case 'eventCalendar.reminderSetDone': return '設定済みリマインダー';
			case 'eventCalendar.reminderDeleted': return 'リマインダーを削除しました';
			case 'eventCalendar.eventName': return 'イベント名';
			case 'eventCalendar.organizer': return '主催者';
			case 'eventCalendar.description': return '説明';
			case 'eventCalendar.genre': return 'ジャンル';
			case 'eventCalendar.condition': return '参加条件';
			case 'eventCalendar.way': return '参加方法';
			case 'eventCalendar.note': return '備考';
			case 'eventCalendar.quest': return 'Quest対応';
			case 'eventCalendar.reminderCount': return ({required Object count}) => '${count}件';
			case 'eventCalendar.startToEnd': return ({required Object start, required Object end}) => '${start}〜${end}';
			case 'avatars.title': return 'アバター';
			case 'avatars.searchHint': return 'アバター名などで検索';
			case 'avatars.searchTooltip': return '検索';
			case 'avatars.searchEmptyTitle': return '検索結果が見つかりませんでした';
			case 'avatars.searchEmptyDescription': return '別の検索ワードをお試しください';
			case 'avatars.emptyTitle': return 'アバターがありません';
			case 'avatars.emptyDescription': return 'アバターを追加するか、後でもう一度お試しください';
			case 'avatars.refresh': return '更新する';
			case 'avatars.loading': return 'アバターを読み込み中...';
			case 'avatars.error': return ({required Object error}) => 'アバター情報の取得に失敗しました: ${error}';
			case 'avatars.current': return '使用中';
			case 'avatars.public': return '公開';
			case 'avatars.private': return '非公開';
			case 'avatars.hidden': return '非表示';
			case 'avatars.author': return '作者';
			case 'avatars.sortUpdated': return '更新順';
			case 'avatars.sortName': return '名前順';
			case 'avatars.sortTooltip': return '並び替え';
			case 'avatars.viewModeTooltip': return '表示モード切替';
			case 'worldDetail.loading': return 'ワールド情報を読み込み中...';
			case 'worldDetail.error': return ({required Object error}) => 'ワールド情報の取得に失敗しました: ${error}';
			case 'worldDetail.share': return 'このワールドを共有';
			case 'worldDetail.openInVRChat': return 'VRChat公式サイトで開く';
			case 'worldDetail.report': return 'このワールドを通報';
			case 'worldDetail.creator': return '作成者';
			case 'worldDetail.created': return '作成';
			case 'worldDetail.updated': return '更新';
			case 'worldDetail.favorites': return 'お気に入り';
			case 'worldDetail.visits': return '訪問数';
			case 'worldDetail.occupants': return '現在の人数';
			case 'worldDetail.popularity': return '評価';
			case 'worldDetail.description': return '説明';
			case 'worldDetail.noDescription': return '説明はありません';
			case 'worldDetail.tags': return 'タグ';
			case 'worldDetail.joinPublic': return 'パブリックで招待を送信';
			case 'worldDetail.favoriteAdded': return 'お気に入りに追加しました';
			case 'worldDetail.favoriteRemoved': return 'お気に入りから削除しました';
			case 'worldDetail.unknown': return '不明';
			case 'avatarDetail.changeSuccess': return ({required Object name}) => 'アバター「${name}」に変更しました';
			case 'avatarDetail.changeFailed': return ({required Object error}) => 'アバターの変更に失敗しました: ${error}';
			case 'avatarDetail.changing': return '変更中...';
			case 'avatarDetail.useThisAvatar': return 'このアバターを使用';
			case 'avatarDetail.creator': return '作成者';
			case 'avatarDetail.created': return '作成';
			case 'avatarDetail.updated': return '更新';
			case 'avatarDetail.description': return '説明';
			case 'avatarDetail.noDescription': return '説明はありません';
			case 'avatarDetail.tags': return 'タグ';
			case 'avatarDetail.addToFavorites': return 'お気に入りに追加';
			case 'avatarDetail.public': return '公開';
			case 'avatarDetail.private': return '非公開';
			case 'avatarDetail.hidden': return '非表示';
			case 'avatarDetail.unknown': return '不明';
			case 'avatarDetail.share': return '共有';
			case 'avatarDetail.loading': return 'アバター情報を読み込み中...';
			case 'avatarDetail.error': return ({required Object error}) => 'アバター情報の取得に失敗しました: ${error}';
			case 'groups.title': return 'グループ';
			case 'groups.loadingUser': return 'ユーザー情報を読み込み中...';
			case 'groups.errorUser': return ({required Object error}) => 'ユーザー情報の取得に失敗しました: ${error}';
			case 'groups.loadingGroups': return 'グループ情報を読み込み中...';
			case 'groups.errorGroups': return ({required Object error}) => 'グループ情報の取得に失敗しました: ${error}';
			case 'groups.emptyTitle': return 'グループに参加していません';
			case 'groups.emptyDescription': return 'VRChatアプリやウェブサイトからグループに参加できます';
			case 'groups.searchGroups': return 'グループを探す';
			case 'groups.members': return ({required Object count}) => '${count}人のメンバー';
			case 'groups.showDetails': return '詳細を表示';
			case 'groups.unknownName': return '名称不明';
			case 'groupDetail.loading': return 'グループ情報を読み込み中...';
			case 'groupDetail.error': return ({required Object error}) => 'グループ情報の取得に失敗しました: ${error}';
			case 'groupDetail.share': return 'グループ情報を共有';
			case 'groupDetail.description': return '説明';
			case 'groupDetail.roles': return 'ロール';
			case 'groupDetail.basicInfo': return '基本情報';
			case 'groupDetail.createdAt': return '作成日';
			case 'groupDetail.owner': return 'オーナー';
			case 'groupDetail.rules': return 'ルール';
			case 'groupDetail.languages': return '言語';
			case 'groupDetail.memberCount': return ({required Object count}) => '${count} メンバー';
			case 'groupDetail.privacy.public': return '公開';
			case 'groupDetail.privacy.private': return '非公開';
			case 'groupDetail.privacy.friends': return 'フレンド';
			case 'groupDetail.privacy.invite': return '招待制';
			case 'groupDetail.privacy.unknown': return '不明';
			case 'groupDetail.role.admin': return '管理者';
			case 'groupDetail.role.moderator': return 'モデレーター';
			case 'groupDetail.role.member': return 'メンバー';
			case 'groupDetail.role.unknown': return '不明';
			case 'inventory.title': return 'インベントリ';
			case 'inventory.gallery': return 'ギャラリー';
			case 'inventory.icon': return 'アイコン';
			case 'inventory.emoji': return '絵文字';
			case 'inventory.sticker': return 'ステッカー';
			case 'inventory.print': return 'プリント';
			case 'inventory.upload': return 'ファイルをアップロード';
			case 'inventory.uploadGallery': return 'ギャラリー画像をアップロード中...';
			case 'inventory.uploadIcon': return 'アイコンをアップロード中...';
			case 'inventory.uploadEmoji': return '絵文字をアップロード中...';
			case 'inventory.uploadSticker': return 'ステッカーをアップロード中...';
			case 'inventory.uploadPrint': return 'プリント画像をアップロード中...';
			case 'inventory.selectImage': return '画像を選択';
			case 'inventory.selectFromGallery': return 'ギャラリーから選択';
			case 'inventory.takePhoto': return 'カメラで撮影';
			case 'inventory.uploadSuccess': return 'アップロードが完了しました';
			case 'inventory.uploadFailed': return 'アップロードに失敗しました';
			case 'inventory.uploadFailedFormat': return 'ファイル形式またはサイズに問題があります。PNG形式で1MB以下の画像を選択してください。';
			case 'inventory.uploadFailedAuth': return '認証に失敗しました。再度ログインしてください。';
			case 'inventory.uploadFailedSize': return 'ファイルサイズが大きすぎます。より小さな画像を選択してください。';
			case 'inventory.uploadFailedServer': return ({required Object code}) => 'サーバーエラーが発生しました (${code})';
			case 'inventory.pickImageFailed': return ({required Object error}) => '画像の選択に失敗しました: ${error}';
			case 'inventory.tabs.emojiInventory.loading': return '絵文字を読み込み中...';
			case 'inventory.tabs.emojiInventory.error': return ({required Object error}) => '絵文字の取得に失敗しました: ${error}';
			case 'inventory.tabs.emojiInventory.emptyTitle': return '絵文字がありません';
			case 'inventory.tabs.emojiInventory.emptyDescription': return 'VRChatでアップロードした絵文字がここに表示されます';
			case 'inventory.tabs.emojiInventory.zoomHint': return 'ダブルタップでズーム';
			case 'inventory.tabs.galleryInventory.loading': return 'ギャラリーを読み込み中...';
			case 'inventory.tabs.galleryInventory.error': return ({required Object error}) => 'ギャラリーの取得に失敗しました: ${error}';
			case 'inventory.tabs.galleryInventory.emptyTitle': return 'ギャラリーがありません';
			case 'inventory.tabs.galleryInventory.emptyDescription': return 'VRChatでアップロードしたギャラリーがここに表示されます';
			case 'inventory.tabs.galleryInventory.zoomHint': return 'ダブルタップでズーム';
			case 'inventory.tabs.iconInventory.loading': return 'アイコンを読み込み中...';
			case 'inventory.tabs.iconInventory.error': return ({required Object error}) => 'アイコンの取得に失敗しました: ${error}';
			case 'inventory.tabs.iconInventory.emptyTitle': return 'アイコンがありません';
			case 'inventory.tabs.iconInventory.emptyDescription': return 'VRChatでアップロードしたアイコンがここに表示されます';
			case 'inventory.tabs.iconInventory.zoomHint': return 'ダブルタップでズーム';
			case 'inventory.tabs.printInventory.loading': return 'プリントを読み込み中...';
			case 'inventory.tabs.printInventory.error': return ({required Object error}) => 'プリントの取得に失敗しました: ${error}';
			case 'inventory.tabs.printInventory.emptyTitle': return 'プリントがありません';
			case 'inventory.tabs.printInventory.emptyDescription': return 'VRChatでアップロードしたプリントがここに表示されます';
			case 'inventory.tabs.printInventory.zoomHint': return 'ダブルタップでズーム';
			case 'inventory.tabs.stickerInventory.loading': return 'ステッカーを読み込み中...';
			case 'inventory.tabs.stickerInventory.error': return ({required Object error}) => 'ステッカーの取得に失敗しました: ${error}';
			case 'inventory.tabs.stickerInventory.emptyTitle': return 'ステッカーがありません';
			case 'inventory.tabs.stickerInventory.emptyDescription': return 'VRChatでアップロードしたステッカーがここに表示されます';
			case 'inventory.tabs.stickerInventory.zoomHint': return 'ダブルタップでズーム';
			case 'vrcnsync.title': return 'VRCNSync (β)';
			case 'vrcnsync.betaTitle': return 'ベータ版機能';
			case 'vrcnsync.betaDescription': return 'この機能は開発中のベータ版です。予期せぬ問題が発生する可能性があります。\n現在はローカルのみの実装ですが、クラウド版が需要があれば実装します。';
			case 'vrcnsync.githubLink': return 'VRCNSyncのGitHubページ';
			case 'vrcnsync.openGithub': return 'GitHubページを開く';
			case 'vrcnsync.serverRunning': return 'サーバー実行中';
			case 'vrcnsync.serverStopped': return 'サーバー停止中';
			case 'vrcnsync.serverRunningDesc': return 'PCからの写真をVRCNアルバムに保存します';
			case 'vrcnsync.serverStoppedDesc': return 'サーバーが停止しています';
			case 'vrcnsync.photoSaved': return '写真をVRCNアルバムに保存しました';
			case 'vrcnsync.photoReceived': return '写真を受信しました（アルバム保存に失敗）';
			case 'vrcnsync.openAlbum': return 'アルバムを開く';
			case 'vrcnsync.permissionErrorIos': return 'フォトライブラリへのアクセス権限が必要です';
			case 'vrcnsync.permissionErrorAndroid': return 'ストレージへのアクセス権限が必要です';
			case 'vrcnsync.openSettings': return '設定を開く';
			case 'vrcnsync.initError': return ({required Object error}) => '初期化に失敗しました: ${error}';
			case 'vrcnsync.openPhotoAppError': return 'フォトアプリを開けませんでした';
			case 'vrcnsync.serverInfo': return 'サーバー情報';
			case 'vrcnsync.ip': return ({required Object ip}) => 'IP: ${ip}';
			case 'vrcnsync.port': return ({required Object port}) => 'ポート: ${port}';
			case 'vrcnsync.address': return ({required Object ip, required Object port}) => '${ip}:${port}';
			case 'vrcnsync.autoSave': return '受信した写真は「VRCN」アルバムに自動保存されます';
			case 'vrcnsync.usage': return '使用方法';
			case 'vrcnsync.usageSteps.0.title': return 'PCでVRCNSyncアプリを起動';
			case 'vrcnsync.usageSteps.0.desc': return 'PCでVRCNSyncアプリを起動してください';
			case 'vrcnsync.usageSteps.1.title': return '同じWiFiネットワークに接続';
			case 'vrcnsync.usageSteps.1.desc': return 'PC・モバイル端末を同じWiFiネットワークに接続してください';
			case 'vrcnsync.usageSteps.2.title': return '接続先にモバイル端末を指定';
			case 'vrcnsync.usageSteps.2.desc': return 'PCアプリで上記のIPアドレスとポートを指定してください';
			case 'vrcnsync.usageSteps.3.title': return '写真を送信';
			case 'vrcnsync.usageSteps.3.desc': return 'PCから写真を送信すると、自動的にVRCNアルバムに保存されます';
			case 'vrcnsync.stats': return '接続状況';
			case 'vrcnsync.statServer': return 'サーバー状態';
			case 'vrcnsync.statServerRunning': return '実行中';
			case 'vrcnsync.statServerStopped': return '停止中';
			case 'vrcnsync.statNetwork': return 'ネットワーク';
			case 'vrcnsync.statNetworkConnected': return '接続済み';
			case 'vrcnsync.statNetworkDisconnected': return '未接続';
			case 'feedback.title': return 'フィードバック';
			case 'feedback.type': return 'フィードバックタイプ';
			case 'feedback.types.bug': return 'バグ報告';
			case 'feedback.types.feature': return '機能要望';
			case 'feedback.types.improvement': return '改善提案';
			case 'feedback.types.other': return 'その他';
			case 'feedback.inputTitle': return 'タイトル *';
			case 'feedback.inputTitleHint': return '簡潔にお聞かせください';
			case 'feedback.inputDescription': return '詳細説明 *';
			case 'feedback.inputDescriptionHint': return '詳細な説明をお聞かせください...';
			case 'feedback.cancel': return 'キャンセル';
			case 'feedback.send': return '送信';
			case 'feedback.sending': return '送信中...';
			case 'feedback.required': return 'タイトルと詳細説明は必須項目です';
			case 'feedback.success': return 'フィードバックを送信しました。ありがとうございます！';
			case 'feedback.fail': return 'フィードバックの送信に失敗しました';
			case 'settings.appearance': return '外観';
			case 'settings.language': return '言語';
			case 'settings.languageDescription': return 'アプリの表示言語を選択できます';
			case 'settings.appIcon': return 'アプリアイコン';
			case 'settings.appIconDescription': return 'ホーム画面に表示されるアプリのアイコンを変更します';
			case 'settings.contentSettings': return 'コンテンツ設定';
			case 'settings.searchEnabled': return '検索機能が有効になりました';
			case 'settings.searchDisabled': return '検索機能が無効になりました';
			case 'settings.enableSearch': return '検索機能を有効';
			case 'settings.enableSearchDescription': return '検索結果に性的なコンテンツや暴力的なコンテンツが表示される可能性があります。';
			case 'settings.apiSetting': return 'アバター検索API';
			case 'settings.apiSettingDescription': return 'アバター検索機能のAPIを設定します';
			case 'settings.apiSettingSaveUrl': return 'URLを保存しました';
			case 'settings.notSet': return '未設定 (アバター検索機能が使用できません)';
			case 'settings.notifications': return '通知設定';
			case 'settings.eventReminder': return 'イベントリマインダー';
			case 'settings.eventReminderDescription': return '設定したイベントの開始前に通知を受け取ります';
			case 'settings.manageReminders': return '設定済みリマインダーの管理';
			case 'settings.manageRemindersDescription': return '通知のキャンセルや確認ができます';
			case 'settings.dataStorage': return 'データとストレージ';
			case 'settings.clearCache': return 'キャッシュを削除';
			case 'settings.clearCacheSuccess': return 'キャッシュを削除しました';
			case 'settings.clearCacheError': return 'キャッシュの削除中にエラーが発生しました';
			case 'settings.cacheSize': return ({required Object size}) => 'キャッシュサイズ: ${size}';
			case 'settings.calculatingCache': return 'キャッシュサイズを計算中...';
			case 'settings.cacheError': return 'キャッシュサイズを取得できませんでした';
			case 'settings.confirmClearCache': return 'キャッシュを削除すると、一時的に保存された画像やデータが削除されます。\n\nアカウント情報やアプリの設定は削除されません。';
			case 'settings.appInfo': return 'アプリ情報';
			case 'settings.version': return 'バージョン';
			case 'settings.packageName': return 'パッケージ名';
			case 'settings.credit': return 'クレジット';
			case 'settings.creditDescription': return '開発者・貢献者情報';
			case 'settings.contact': return 'お問い合わせ';
			case 'settings.contactDescription': return '不具合報告・ご意見はこちら';
			case 'settings.privacyPolicy': return 'プライバシーポリシー';
			case 'settings.privacyPolicyDescription': return '個人情報の取り扱いについて';
			case 'settings.termsOfService': return '利用規約';
			case 'settings.termsOfServiceDescription': return 'アプリのご利用条件';
			case 'settings.openSource': return 'オープンソース情報';
			case 'settings.openSourceDescription': return '使用しているライブラリ等のライセンス';
			case 'settings.github': return 'GitHubリポジトリ';
			case 'settings.githubDescription': return 'ソースコードを見る';
			case 'settings.logoutConfirm': return 'ログアウトしますか？';
			case 'settings.logoutError': return ({required Object error}) => 'ログアウト中にエラーが発生しました: ${error}';
			case 'settings.iconChangeNotSupported': return 'お使いのデバイスではアプリアイコンの変更がサポートされていません';
			case 'settings.iconChangeFailed': return 'アイコンの変更に失敗しました';
			case 'settings.themeMode': return 'テーマモード';
			case 'settings.themeModeDescription': return 'アプリの表示テーマを選択できます';
			case 'settings.themeLight': return '明るい';
			case 'settings.themeSystem': return 'システム';
			case 'settings.themeDark': return '暗い';
			case 'settings.appIconDefault': return 'デフォルト';
			case 'settings.appIconIcon': return 'アイコン';
			case 'settings.appIconLogo': return 'ロゴ';
			case 'settings.delete': return '削除する';
			case 'credits.title': return 'クレジット';
			case 'credits.section.development': return '開発';
			case 'credits.section.iconPeople': return '愉快なアイコンの人たち';
			case 'credits.section.testFeedback': return 'テスト・フィードバック';
			case 'credits.section.specialThanks': return 'スペシャルサンクス';
			case 'download.success': return 'ダウンロードが完了しました';
			case 'download.failure': return ({required Object error}) => 'ダウンロードに失敗しました: ${error}';
			case 'download.shareFailure': return ({required Object error}) => '共有に失敗しました: ${error}';
			case 'download.permissionTitle': return '権限が必要です';
			case 'download.permissionDenied': return ({required Object permissionType}) => '${permissionType}への保存権限が拒否されています。\n設定アプリから権限を有効にしてください。';
			case 'download.permissionCancel': return 'キャンセル';
			case 'download.permissionOpenSettings': return '設定を開く';
			case 'download.permissionPhoto': return 'フォト';
			case 'download.permissionPhotoLibrary': return 'フォトライブラリ';
			case 'download.permissionStorage': return 'ストレージ';
			case 'download.permissionPhotoRequired': return '写真への保存権限が必要です';
			case 'download.permissionPhotoLibraryRequired': return 'フォトライブラリへの保存権限が必要です';
			case 'download.permissionStorageRequired': return 'ストレージへのアクセス権限が必要です';
			case 'download.permissionError': return ({required Object error}) => '権限チェック中にエラーが発生しました: ${error}';
			case 'download.downloading': return ({required Object fileName}) => '${fileName} をダウンロード中...';
			case 'download.sharing': return ({required Object fileName}) => '${fileName} を共有準備中...';
			case 'instance.type.public': return 'パブリック';
			case 'instance.type.hidden': return 'フレンド+';
			case 'instance.type.friends': return 'フレンド';
			case 'instance.type.private': return 'インバイト+';
			case 'instance.type.unknown': return '不明';
			case 'status.active': return 'オンライン';
			case 'status.joinMe': return 'だれでもおいで';
			case 'status.askMe': return 'きいてみてね';
			case 'status.busy': return '取り込み中';
			case 'status.offline': return 'オフライン';
			case 'status.unknown': return 'ステータス不明';
			case 'location.private': return 'プライベート';
			case 'location.playerCount': return ({required Object userCount, required Object capacity}) => 'プレイヤー数: ${userCount} / ${capacity}';
			case 'location.instanceType': return ({required Object type}) => 'インスタンスタイプ: ${type}';
			case 'location.noInfo': return 'ロケーション情報はありません';
			case 'location.fetchError': return 'ロケーション情報の取得に失敗しました';
			case 'location.privateLocation': return 'プライベートな場所にいます';
			case 'location.inviteSending': return '招待を送信中...';
			case 'location.inviteSent': return '招待を送信しました。通知から参加できます';
			case 'location.inviteFailed': return ({required Object error}) => '招待の送信に失敗しました: ${error}';
			case 'location.inviteButton': return '自分に招待を送信';
			case 'location.isPrivate': return ({required Object number}) => '${number}人がプライベート';
			case 'location.isActive': return ({required Object number}) => '${number}人がアクティブ';
			case 'location.isOffline': return ({required Object number}) => '${number}人がオフライン';
			case 'location.isTraveling': return ({required Object number}) => '${number}人が移動中';
			case 'location.isStaying': return ({required Object number}) => '${number}人が滞在中';
			case 'reminder.dialogTitle': return 'リマインダーを設定';
			case 'reminder.alreadySet': return '設定済み';
			case 'reminder.set': return '設定する';
			case 'reminder.cancel': return 'キャンセル';
			case 'reminder.delete': return '削除する';
			case 'reminder.deleteAll': return 'すべてのリマインダーを削除';
			case 'reminder.deleteAllConfirm': return '設定したすべてのイベントリマインダーを削除します。この操作は元に戻せません。';
			case 'reminder.deleted': return 'リマインダーを削除しました';
			case 'reminder.deletedAll': return 'すべてのリマインダーを削除しました';
			case 'reminder.noReminders': return '設定済みのリマインダーはありません';
			case 'reminder.setFromEvent': return 'イベントページから通知を設定できます';
			case 'reminder.eventStart': return ({required Object time}) => '${time} 開始';
			case 'reminder.notifyAt': return ({required Object time, required Object label}) => '${time} (${label})';
			case 'reminder.receiveNotification': return 'いつ通知を受け取りますか？';
			case 'friend.sortFilter': return '並び替え・フィルター';
			case 'friend.filter': return 'フィルター';
			case 'friend.filterAll': return 'すべて表示';
			case 'friend.filterOnline': return 'オンラインのみ';
			case 'friend.filterOffline': return 'オフラインのみ';
			case 'friend.filterFavorite': return 'お気に入りのみ';
			case 'friend.sort': return '並び替え';
			case 'friend.sortStatus': return 'オンライン状態順';
			case 'friend.sortName': return '名前順';
			case 'friend.sortLastLogin': return '最終ログイン順';
			case 'friend.sortAsc': return '昇順';
			case 'friend.sortDesc': return '降順';
			case 'friend.close': return '閉じる';
			case 'eventCalendarFilter.filterTitle': return 'イベントを絞り込む';
			case 'eventCalendarFilter.clear': return 'クリア';
			case 'eventCalendarFilter.keyword': return 'キーワード検索';
			case 'eventCalendarFilter.keywordHint': return 'イベント名、説明、主催者など';
			case 'eventCalendarFilter.date': return '日付で絞り込み';
			case 'eventCalendarFilter.dateHint': return '特定の日付範囲のイベントを表示できます';
			case 'eventCalendarFilter.startDate': return '開始日';
			case 'eventCalendarFilter.endDate': return '終了日';
			case 'eventCalendarFilter.select': return '選択してください';
			case 'eventCalendarFilter.time': return '時間帯で絞り込み';
			case 'eventCalendarFilter.timeHint': return '特定の時間帯に開催されるイベントを表示できます';
			case 'eventCalendarFilter.startTime': return '開始時間';
			case 'eventCalendarFilter.endTime': return '終了時間';
			case 'eventCalendarFilter.genre': return 'ジャンルで絞り込み';
			case 'eventCalendarFilter.genreSelected': return ({required Object count}) => '${count}個のジャンルを選択中';
			case 'eventCalendarFilter.apply': return '適用する';
			case 'eventCalendarFilter.filterSummary': return 'フィルター';
			case 'eventCalendarFilter.filterNone': return 'フィルターは設定されていません';
			default: return null;
		}
	}
}

