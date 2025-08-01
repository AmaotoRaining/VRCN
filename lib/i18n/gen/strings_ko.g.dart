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
class TranslationsKo implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKo({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsKo _root = this; // ignore: unused_field

	@override 
	TranslationsKo $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKo(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonKo common = _TranslationsCommonKo._(_root);
	@override late final _TranslationsTermsAgreementKo termsAgreement = _TranslationsTermsAgreementKo._(_root);
	@override late final _TranslationsDrawerKo drawer = _TranslationsDrawerKo._(_root);
	@override late final _TranslationsLoginKo login = _TranslationsLoginKo._(_root);
	@override late final _TranslationsFriendsKo friends = _TranslationsFriendsKo._(_root);
	@override late final _TranslationsFriendDetailKo friendDetail = _TranslationsFriendDetailKo._(_root);
	@override late final _TranslationsSearchKo search = _TranslationsSearchKo._(_root);
	@override late final _TranslationsProfileKo profile = _TranslationsProfileKo._(_root);
	@override late final _TranslationsEngageCardKo engageCard = _TranslationsEngageCardKo._(_root);
	@override late final _TranslationsQrScannerKo qrScanner = _TranslationsQrScannerKo._(_root);
	@override late final _TranslationsFavoritesKo favorites = _TranslationsFavoritesKo._(_root);
	@override late final _TranslationsNotificationsKo notifications = _TranslationsNotificationsKo._(_root);
	@override late final _TranslationsEventCalendarKo eventCalendar = _TranslationsEventCalendarKo._(_root);
	@override late final _TranslationsAvatarsKo avatars = _TranslationsAvatarsKo._(_root);
	@override late final _TranslationsWorldDetailKo worldDetail = _TranslationsWorldDetailKo._(_root);
	@override late final _TranslationsAvatarDetailKo avatarDetail = _TranslationsAvatarDetailKo._(_root);
	@override late final _TranslationsGroupsKo groups = _TranslationsGroupsKo._(_root);
	@override late final _TranslationsGroupDetailKo groupDetail = _TranslationsGroupDetailKo._(_root);
	@override late final _TranslationsInventoryKo inventory = _TranslationsInventoryKo._(_root);
	@override late final _TranslationsVrcnsyncKo vrcnsync = _TranslationsVrcnsyncKo._(_root);
	@override late final _TranslationsFeedbackKo feedback = _TranslationsFeedbackKo._(_root);
	@override late final _TranslationsSettingsKo settings = _TranslationsSettingsKo._(_root);
	@override late final _TranslationsCreditsKo credits = _TranslationsCreditsKo._(_root);
	@override late final _TranslationsDownloadKo download = _TranslationsDownloadKo._(_root);
	@override late final _TranslationsInstanceKo instance = _TranslationsInstanceKo._(_root);
	@override late final _TranslationsStatusKo status = _TranslationsStatusKo._(_root);
	@override late final _TranslationsLocationKo location = _TranslationsLocationKo._(_root);
	@override late final _TranslationsReminderKo reminder = _TranslationsReminderKo._(_root);
	@override late final _TranslationsFriendKo friend = _TranslationsFriendKo._(_root);
	@override late final _TranslationsEventCalendarFilterKo eventCalendarFilter = _TranslationsEventCalendarFilterKo._(_root);
}

// Path: common
class _TranslationsCommonKo implements TranslationsCommonJa {
	_TranslationsCommonKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCN';
	@override String get ok => '확인';
	@override String get cancel => '취소';
	@override String get close => '닫기';
	@override String get save => '저장';
	@override String get edit => '편집';
	@override String get delete => '삭제';
	@override String get yes => '예';
	@override String get no => '아니요';
	@override String get loading => '로딩 중...';
	@override String error({required Object error}) => '오류가 발생했습니다: ${error}';
	@override String get errorNomessage => '오류가 발생했습니다';
	@override String get retry => '재시도';
	@override String get search => '검색';
	@override String get settings => '설정';
	@override String get confirm => '확인';
	@override String get agree => '동의';
	@override String get decline => '동의 안 함';
	@override String get username => '사용자 이름';
	@override String get password => '비밀번호';
	@override String get login => '로그인';
	@override String get logout => '로그아웃';
	@override String get share => '공유';
}

// Path: termsAgreement
class _TranslationsTermsAgreementKo implements TranslationsTermsAgreementJa {
	_TranslationsTermsAgreementKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'VRCN에 오신 것을 환영합니다';
	@override String get welcomeMessage => '앱을 사용하기 전에\n이용약관과 개인정보처리방침을 확인해 주세요';
	@override String get termsTitle => '이용약관';
	@override String get termsSubtitle => '앱 이용 조건에 대하여';
	@override String get privacyTitle => '개인정보처리방침';
	@override String get privacySubtitle => '개인정보 취급에 대하여';
	@override String agreeTerms({required Object title}) => '\'${title}\'에 동의합니다';
	@override String get checkContent => '내용 확인';
	@override String get notice => '이 앱은 VRChat Inc.의 비공식 앱입니다.\nVRChat Inc.와는 일절 관계가 없습니다.';
}

// Path: drawer
class _TranslationsDrawerKo implements TranslationsDrawerJa {
	_TranslationsDrawerKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get home => '홈';
	@override String get profile => '프로필';
	@override String get favorite => '즐겨찾기';
	@override String get eventCalendar => '이벤트 캘린더';
	@override String get avatar => '아바타';
	@override String get group => '그룹';
	@override String get inventory => '인벤토리';
	@override String get vrcnsync => 'VRCNSync (β)';
	@override String get review => '리뷰';
	@override String get feedback => '피드백';
	@override String get settings => '설정';
	@override String get userLoading => '사용자 정보 로딩 중...';
	@override String get userError => '사용자 정보 로딩에 실패했습니다';
	@override String get retry => '재시도';
	@override late final _TranslationsDrawerSectionKo section = _TranslationsDrawerSectionKo._(_root);
}

// Path: login
class _TranslationsLoginKo implements TranslationsLoginJa {
	_TranslationsLoginKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get forgotPassword => '비밀번호를 잊으셨나요?';
	@override String get subtitle => 'VRChat 계정 정보로 로그인';
	@override String get email => '이메일 주소';
	@override String get emailHint => '이메일 또는 사용자 이름 입력';
	@override String get passwordHint => '비밀번호 입력';
	@override String get rememberMe => '로그인 상태 유지';
	@override String get loggingIn => '로그인 중...';
	@override String get errorEmptyEmail => '사용자 이름 또는 이메일 주소를 입력해 주세요';
	@override String get errorEmptyPassword => '비밀번호를 입력해 주세요';
	@override String get errorLoginFailed => '로그인에 실패했습니다. 이메일 주소와 비밀번호를 확인해 주세요.';
	@override String get twoFactorTitle => '2단계 인증';
	@override String get twoFactorSubtitle => '인증 코드를 입력해 주세요';
	@override String get twoFactorInstruction => '인증 앱에 표시된\n6자리 코드를 입력해 주세요';
	@override String get twoFactorCodeHint => '인증 코드';
	@override String get verify => '인증';
	@override String get verifying => '인증 중...';
	@override String get errorEmpty2fa => '인증 코드를 입력해 주세요';
	@override String get error2faFailed => '2단계 인증에 실패했습니다. 코드가 올바른지 확인해 주세요.';
	@override String get backToLogin => '로그인 화면으로 돌아가기';
	@override String get paste => '붙여넣기';
}

// Path: friends
class _TranslationsFriendsKo implements TranslationsFriendsJa {
	_TranslationsFriendsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '친구 정보 로딩 중...';
	@override String error({required Object error}) => '친구 정보 로딩에 실패했습니다: ${error}';
	@override String get notFound => '친구를 찾을 수 없습니다';
	@override String get private => '프라이빗';
	@override String get active => '활동 중';
	@override String get offline => '오프라인';
	@override String get online => '온라인';
	@override String get groupTitle => '월드별로 그룹화';
	@override String get refresh => '새로고침';
	@override String get searchHint => '친구 이름으로 검색';
	@override String get noResult => '해당하는 친구가 없습니다';
}

// Path: friendDetail
class _TranslationsFriendDetailKo implements TranslationsFriendDetailJa {
	_TranslationsFriendDetailKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '사용자 정보 로딩 중...';
	@override String error({required Object error}) => '사용자 정보 로딩에 실패했습니다: ${error}';
	@override String get currentLocation => '현재 위치';
	@override String get basicInfo => '기본 정보';
	@override String get userId => '사용자 ID';
	@override String get dateJoined => '가입일';
	@override String get lastLogin => '마지막 로그인';
	@override String get bio => '자기소개';
	@override String get links => '링크';
	@override String get loadingLinks => '링크 정보 로딩 중...';
	@override String get group => '소속 그룹';
	@override String get groupDetail => '그룹 상세 정보 보기';
	@override String groupCode({required Object code}) => '그룹 코드: ${code}';
	@override String memberCount({required Object count}) => '멤버 수: ${count}명';
	@override String get unknownGroup => '알 수 없는 그룹';
	@override String get block => '차단';
	@override String get mute => '음소거';
	@override String get openWebsite => '웹사이트에서 열기';
	@override String get shareProfile => '프로필 공유';
	@override String confirmBlockTitle({required Object name}) => '${name}님을 차단하시겠습니까?';
	@override String get confirmBlockMessage => '차단하면 이 사용자로부터 친구 신청이나 메시지를 받지 않게 됩니다.';
	@override String confirmMuteTitle({required Object name}) => '${name}님을 음소거하시겠습니까?';
	@override String get confirmMuteMessage => '음소거하면 이 사용자의 음성이 들리지 않게 됩니다.';
	@override String get blockSuccess => '차단했습니다';
	@override String get muteSuccess => '음소거했습니다';
	@override String operationFailed({required Object error}) => '작업에 실패했습니다: ${error}';
}

// Path: search
class _TranslationsSearchKo implements TranslationsSearchJa {
	_TranslationsSearchKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get userTab => '사용자';
	@override String get worldTab => '월드';
	@override String get avatarTab => '아바타';
	@override String get groupTab => '그룹';
	@override late final _TranslationsSearchTabsKo tabs = _TranslationsSearchTabsKo._(_root);
}

// Path: profile
class _TranslationsProfileKo implements TranslationsProfileJa {
	_TranslationsProfileKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '프로필';
	@override String get edit => '편집';
	@override String get refresh => '새로고침';
	@override String get loading => '프로필 정보 로딩 중...';
	@override String get error => '프로필 정보 로딩에 실패했습니다: {error}';
	@override String get displayName => '표시 이름';
	@override String get username => '사용자 이름';
	@override String get userId => '사용자 ID';
	@override String get engageCard => '인게이지 카드';
	@override String get frined => '친구';
	@override String get dateJoined => '가입일';
	@override String get userType => '사용자 유형';
	@override String get status => '상태';
	@override String get statusMessage => '상태 메시지';
	@override String get bio => '자기소개';
	@override String get links => '링크';
	@override String get group => '소속 그룹';
	@override String get groupDetail => '그룹 상세 정보 보기';
	@override String get avatar => '현재 아바타';
	@override String get avatarDetail => '아바타 상세 정보 보기';
	@override String get public => '공개';
	@override String get private => '비공개';
	@override String get hidden => '숨김';
	@override String get unknown => '알 수 없음';
	@override String get friends => '친구';
	@override String get loadingLinks => '링크 정보 로딩 중...';
	@override String get noGroup => '소속된 그룹이 없습니다';
	@override String get noBio => '자기소개가 없습니다';
	@override String get noLinks => '링크가 없습니다';
	@override String get save => '변경사항 저장';
	@override String get saved => '프로필을 업데이트했습니다';
	@override String get saveFailed => '업데이트에 실패했습니다: {error}';
	@override String get discardTitle => '변경사항을 취소하시겠습니까?';
	@override String get discardContent => '프로필에 적용한 변경사항은 저장되지 않습니다.';
	@override String get discardCancel => '취소';
	@override String get discardOk => '취소하기';
	@override String get basic => '기본 정보';
	@override String get pronouns => '대명사';
	@override String get addLink => '추가';
	@override String get removeLink => '삭제';
	@override String get linkHint => '링크 입력 (예: https://twitter.com/username)';
	@override String get linksHint => '링크는 프로필에 표시되며, 탭하여 열 수 있습니다';
	@override String get statusMessageHint => '현재 상황이나 메시지를 입력하세요';
	@override String get bioHint => '자신에 대해 작성해 보세요';
}

// Path: engageCard
class _TranslationsEngageCardKo implements TranslationsEngageCardJa {
	_TranslationsEngageCardKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get pickBackground => '배경 이미지 선택';
	@override String get removeBackground => '배경 이미지 삭제';
	@override String get scanQr => 'QR 코드 스캔';
	@override String get showAvatar => '아바타 표시';
	@override String get hideAvatar => '아바타 숨기기';
	@override String get noBackground => '배경 이미지가 선택되지 않았습니다\n오른쪽 상단 버튼으로 설정할 수 있습니다';
	@override String get loading => '로딩 중...';
	@override String error({required Object error}) => '인게이지 카드 정보 로딩에 실패했습니다: ${error}';
	@override String get copyUserId => '사용자 ID 복사';
	@override String get copied => '복사했습니다';
}

// Path: qrScanner
class _TranslationsQrScannerKo implements TranslationsQrScannerJa {
	_TranslationsQrScannerKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'QR 코드 스캔';
	@override String get guide => 'QR 코드를 프레임 안에 맞춰주세요';
	@override String get loading => '카메라 초기화 중...';
	@override String error({required Object error}) => 'QR 코드 읽기에 실패했습니다: ${error}';
	@override String get notFound => '유효한 사용자 QR 코드를 찾을 수 없습니다';
}

// Path: favorites
class _TranslationsFavoritesKo implements TranslationsFavoritesJa {
	_TranslationsFavoritesKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '즐겨찾기';
	@override String get frined => '친구';
	@override String get friendsTab => '친구';
	@override String get worldsTab => '월드';
	@override String get avatarsTab => '아바타';
	@override String get emptyFolderTitle => '즐겨찾기 폴더가 없습니다';
	@override String get emptyFolderDescription => 'VRChat에서 즐겨찾기 폴더를 생성해 주세요';
	@override String get emptyFriends => '이 폴더에는 친구가 없습니다';
	@override String get emptyWorlds => '이 폴더에는 월드가 없습니다';
	@override String get emptyAvatars => '이 폴더에는 아바타가 없습니다';
	@override String get emptyWorldsTabTitle => '즐겨찾는 월드가 없습니다';
	@override String get emptyWorldsTabDescription => '월드 상세 화면에서 즐겨찾기에 등록할 수 있습니다';
	@override String get emptyAvatarsTabTitle => '즐겨찾는 아바타가 없습니다';
	@override String get emptyAvatarsTabDescription => '아바타 상세 화면에서 즐겨찾기에 등록할 수 있습니다';
	@override String get loading => '즐겨찾기 로딩 중...';
	@override String get loadingFolder => '폴더 정보 로딩 중...';
	@override String error({required Object error}) => '즐겨찾기 로딩에 실패했습니다: ${error}';
	@override String get errorFolder => '정보를 가져오는데 실패했습니다';
	@override String get remove => '즐겨찾기에서 삭제';
	@override String removeSuccess({required Object name}) => '${name}을(를) 즐겨찾기에서 삭제했습니다';
	@override String removeFailed({required Object error}) => '삭제에 실패했습니다: ${error}';
	@override String itemsCount({required Object count}) => '${count} 아이템';
	@override String get public => '공개';
	@override String get private => '비공개';
	@override String get hidden => '숨김';
	@override String get unknown => '알 수 없음';
	@override String get loadingError => '로딩 오류';
}

// Path: notifications
class _TranslationsNotificationsKo implements TranslationsNotificationsJa {
	_TranslationsNotificationsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '알림이 없습니다';
	@override String get emptyDescription => '친구 요청이나 초대 등\n새로운 알림이 여기에 표시됩니다';
	@override String friendRequest({required Object userName}) => '${userName}님으로부터 친구 요청이 도착했습니다';
	@override String invite({required Object userName, required Object worldName}) => '${userName}님으로부터 ${worldName}(으)로 초대가 도착했습니다';
	@override String friendOnline({required Object userName}) => '${userName}님이 온라인 상태가 되었습니다';
	@override String friendOffline({required Object userName}) => '${userName}님이 오프라인 상태가 되었습니다';
	@override String friendActive({required Object userName}) => '${userName}님이 활동 중 상태가 되었습니다';
	@override String friendAdd({required Object userName}) => '${userName}님이 친구에 추가되었습니다';
	@override String friendRemove({required Object userName}) => '${userName}님이 친구에서 삭제되었습니다';
	@override String statusUpdate({required Object userName, required Object status, required Object world}) => '${userName}님의 상태가 업데이트되었습니다: ${status}${world}';
	@override String locationChange({required Object userName, required Object worldName}) => '${userName}님이 ${worldName}(으)로 이동했습니다';
	@override String userUpdate({required Object world}) => '당신의 정보가 업데이트되었습니다${world}';
	@override String myLocationChange({required Object worldName}) => '당신의 이동: ${worldName}';
	@override String requestInvite({required Object userName}) => '${userName}님으로부터 참가 요청이 도착했습니다';
	@override String votekick({required Object userName}) => '${userName}님으로부터 투표 추방이 있었습니다';
	@override String responseReceived({required Object userName}) => '알림 ID:${userName}의 응답을 수신했습니다';
	@override String error({required Object worldName}) => '오류: ${worldName}';
	@override String system({required Object extraData}) => '시스템 알림: ${extraData}';
	@override String secondsAgo({required Object seconds}) => '${seconds}초 전';
	@override String minutesAgo({required Object minutes}) => '${minutes}분 전';
	@override String hoursAgo({required Object hours}) => '${hours}시간 전';
}

// Path: eventCalendar
class _TranslationsEventCalendarKo implements TranslationsEventCalendarJa {
	_TranslationsEventCalendarKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '이벤트 캘린더';
	@override String get filter => '이벤트 필터링';
	@override String get refresh => '이벤트 정보 새로고침';
	@override String get loading => '이벤트 정보 로딩 중...';
	@override String error({required Object error}) => '이벤트 정보 로딩에 실패했습니다: ${error}';
	@override String filterActive({required Object count}) => '필터 적용 중 (${count}건)';
	@override String get clear => '초기화';
	@override String get noEvents => '조건에 맞는 이벤트가 없습니다';
	@override String get clearFilter => '필터 초기화';
	@override String get today => '오늘';
	@override String get reminderSet => '리마인더 설정';
	@override String get reminderSetDone => '리마인더 설정됨';
	@override String get reminderDeleted => '리마인더를 삭제했습니다';
	@override String get organizer => '주최자';
	@override String get description => '설명';
	@override String get genre => '장르';
	@override String get condition => '참가 조건';
	@override String get way => '참가 방법';
	@override String get note => '비고';
	@override String get quest => 'Quest 대응';
	@override String reminderCount({required Object count}) => '${count}건';
	@override String startToEnd({required Object start, required Object end}) => '${start} ~ ${end}';
}

// Path: avatars
class _TranslationsAvatarsKo implements TranslationsAvatarsJa {
	_TranslationsAvatarsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '아바타';
	@override String get searchHint => '아바타 이름 등으로 검색';
	@override String get searchTooltip => '검색';
	@override String get searchEmptyTitle => '검색 결과를 찾을 수 없습니다';
	@override String get searchEmptyDescription => '다른 검색어로 시도해 주세요';
	@override String get emptyTitle => '아바타가 없습니다';
	@override String get emptyDescription => '아바타를 추가하거나 나중에 다시 시도해 주세요';
	@override String get refresh => '새로고침';
	@override String get loading => '아바타 로딩 중...';
	@override String error({required Object error}) => '아바타 정보 로딩에 실패했습니다: ${error}';
	@override String get current => '사용 중';
	@override String get public => '공개';
	@override String get private => '비공개';
	@override String get hidden => '숨김';
	@override String get author => '제작자';
	@override String get sortUpdated => '업데이트 순';
	@override String get sortName => '이름 순';
	@override String get sortTooltip => '정렬';
	@override String get viewModeTooltip => '보기 모드 전환';
}

// Path: worldDetail
class _TranslationsWorldDetailKo implements TranslationsWorldDetailJa {
	_TranslationsWorldDetailKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '월드 정보 로딩 중...';
	@override String error({required Object error}) => '월드 정보 로딩에 실패했습니다: ${error}';
	@override String get share => '이 월드 공유하기';
	@override String get openInVRChat => 'VRChat 공식 웹사이트에서 열기';
	@override String get report => '이 월드 신고하기';
	@override String get creator => '제작자';
	@override String get created => '생성일';
	@override String get updated => '업데이트일';
	@override String get favorites => '즐겨찾기 수';
	@override String get visits => '방문 수';
	@override String get occupants => '현재 인원';
	@override String get popularity => '평가';
	@override String get description => '설명';
	@override String get noDescription => '설명이 없습니다';
	@override String get tags => '태그';
	@override String get joinPublic => '퍼블릭으로 초대 보내기';
	@override String get favoriteAdded => '즐겨찾기에 추가했습니다';
	@override String get favoriteRemoved => '즐겨찾기에서 삭제했습니다';
	@override String get unknown => '알 수 없음';
}

// Path: avatarDetail
class _TranslationsAvatarDetailKo implements TranslationsAvatarDetailJa {
	_TranslationsAvatarDetailKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String changeSuccess({required Object name}) => '아바타 \'${name}\'(으)로 변경했습니다';
	@override String changeFailed({required Object error}) => '아바타 변경에 실패했습니다: ${error}';
	@override String get changing => '변경 중...';
	@override String get useThisAvatar => '이 아바타 사용하기';
	@override String get creator => '제작자';
	@override String get created => '생성일';
	@override String get updated => '업데이트일';
	@override String get description => '설명';
	@override String get noDescription => '설명이 없습니다';
	@override String get tags => '태그';
	@override String get addToFavorites => '즐겨찾기에 추가';
	@override String get public => '공개';
	@override String get private => '비공개';
	@override String get hidden => '숨김';
	@override String get unknown => '알 수 없음';
	@override String get share => '공유';
	@override String get loading => '아바타 정보 로딩 중...';
	@override String error({required Object error}) => '아바타 정보 로딩에 실패했습니다: ${error}';
}

// Path: groups
class _TranslationsGroupsKo implements TranslationsGroupsJa {
	_TranslationsGroupsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '그룹';
	@override String get loadingUser => '사용자 정보 로딩 중...';
	@override String errorUser({required Object error}) => '사용자 정보 로딩에 실패했습니다: ${error}';
	@override String get loadingGroups => '그룹 정보 로딩 중...';
	@override String errorGroups({required Object error}) => '그룹 정보 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '가입한 그룹이 없습니다';
	@override String get emptyDescription => 'VRChat 앱이나 웹사이트에서 그룹에 가입할 수 있습니다';
	@override String get searchGroups => '그룹 찾기';
	@override String members({required Object count}) => '${count}명의 멤버';
	@override String get showDetails => '상세 정보 보기';
	@override String get unknownName => '이름 알 수 없음';
}

// Path: groupDetail
class _TranslationsGroupDetailKo implements TranslationsGroupDetailJa {
	_TranslationsGroupDetailKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '그룹 정보 로딩 중...';
	@override String error({required Object error}) => '그룹 정보 로딩에 실패했습니다: ${error}';
	@override String get share => '그룹 정보 공유';
	@override String get description => '설명';
	@override String get roles => '역할';
	@override String get basicInfo => '기본 정보';
	@override String get createdAt => '생성일';
	@override String get owner => '소유자';
	@override String get rules => '규칙';
	@override String get languages => '언어';
	@override String memberCount({required Object count}) => '${count} 멤버';
	@override late final _TranslationsGroupDetailPrivacyKo privacy = _TranslationsGroupDetailPrivacyKo._(_root);
	@override late final _TranslationsGroupDetailRoleKo role = _TranslationsGroupDetailRoleKo._(_root);
}

// Path: inventory
class _TranslationsInventoryKo implements TranslationsInventoryJa {
	_TranslationsInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '인벤토리';
	@override String get gallery => '갤러리';
	@override String get icon => '아이콘';
	@override String get emoji => '이모지';
	@override String get sticker => '스티커';
	@override String get print => '프린트';
	@override String get upload => '파일 업로드';
	@override String get uploadGallery => '갤러리 이미지 업로드 중...';
	@override String get uploadIcon => '아이콘 업로드 중...';
	@override String get uploadEmoji => '이모지 업로드 중...';
	@override String get uploadSticker => '스티커 업로드 중...';
	@override String get uploadPrint => '프린트 이미지 업로드 중...';
	@override String get selectImage => '이미지 선택';
	@override String get selectFromGallery => '갤러리에서 선택';
	@override String get takePhoto => '카메라로 촬영';
	@override String get uploadSuccess => '업로드가 완료되었습니다';
	@override String get uploadFailed => '업로드에 실패했습니다';
	@override String get uploadFailedFormat => '파일 형식 또는 크기에 문제가 있습니다. PNG 형식의 1MB 이하 이미지를 선택해 주세요.';
	@override String get uploadFailedAuth => '인증에 실패했습니다. 다시 로그인해 주세요.';
	@override String get uploadFailedSize => '파일 크기가 너무 큽니다. 더 작은 이미지를 선택해 주세요.';
	@override String uploadFailedServer({required Object code}) => '서버 오류가 발생했습니다 (${code})';
	@override String pickImageFailed({required Object error}) => '이미지 선택에 실패했습니다: ${error}';
	@override late final _TranslationsInventoryTabsKo tabs = _TranslationsInventoryTabsKo._(_root);
}

// Path: vrcnsync
class _TranslationsVrcnsyncKo implements TranslationsVrcnsyncJa {
	_TranslationsVrcnsyncKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'VRCNSync (β)';
	@override String get betaTitle => '베타 기능';
	@override String get betaDescription => '이 기능은 개발 중인 베타 버전입니다. 예기치 않은 문제가 발생할 수 있습니다.\n현재는 로컬에서만 구현되어 있지만, 수요가 있으면 클라우드 버전을 구현할 예정입니다.';
	@override String get githubLink => 'VRCNSync GitHub 페이지';
	@override String get openGithub => 'GitHub 페이지 열기';
	@override String get serverRunning => '서버 실행 중';
	@override String get serverStopped => '서버 중지됨';
	@override String get serverRunningDesc => 'PC의 사진을 VRCN 앨범에 저장합니다';
	@override String get serverStoppedDesc => '서버가 중지되었습니다';
	@override String get photoSaved => '사진을 VRCN 앨범에 저장했습니다';
	@override String get photoReceived => '사진을 수신했습니다 (앨범 저장 실패)';
	@override String get openAlbum => '앨범 열기';
	@override String get permissionErrorIos => '사진 라이브러리에 대한 접근 권한이 필요합니다';
	@override String get permissionErrorAndroid => '저장소에 대한 접근 권한이 필요합니다';
	@override String get openSettings => '설정 열기';
	@override String initError({required Object error}) => '초기화에 실패했습니다: ${error}';
	@override String get openPhotoAppError => '사진 앱을 열 수 없었습니다';
	@override String get serverInfo => '서버 정보';
	@override String ip({required Object ip}) => 'IP: ${ip}';
	@override String port({required Object port}) => '포트: ${port}';
	@override String address({required Object ip, required Object port}) => '${ip}:${port}';
	@override String get autoSave => '수신된 사진은 \'VRCN\' 앨범에 자동 저장됩니다';
	@override String get usage => '사용 방법';
	@override List<dynamic> get usageSteps => [
		_TranslationsVrcnsync$usageSteps$0i0$Ko._(_root),
		_TranslationsVrcnsync$usageSteps$0i1$Ko._(_root),
		_TranslationsVrcnsync$usageSteps$0i2$Ko._(_root),
		_TranslationsVrcnsync$usageSteps$0i3$Ko._(_root),
	];
	@override String get stats => '연결 상태';
	@override String get statServer => '서버 상태';
	@override String get statServerRunning => '실행 중';
	@override String get statServerStopped => '중지됨';
	@override String get statNetwork => '네트워크';
	@override String get statNetworkConnected => '연결됨';
	@override String get statNetworkDisconnected => '연결 안 됨';
}

// Path: feedback
class _TranslationsFeedbackKo implements TranslationsFeedbackJa {
	_TranslationsFeedbackKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '피드백';
	@override String get type => '피드백 유형';
	@override Map<String, String> get types => {
		'bug': '버그 신고',
		'feature': '기능 요청',
		'improvement': '개선 제안',
		'other': '기타',
	};
	@override String get inputTitle => '제목 *';
	@override String get inputTitleHint => '간결하게 작성해 주세요';
	@override String get inputDescription => '상세 설명 *';
	@override String get inputDescriptionHint => '자세한 설명을 작성해 주세요...';
	@override String get cancel => '취소';
	@override String get send => '전송';
	@override String get sending => '전송 중...';
	@override String get required => '제목과 상세 설명은 필수 항목입니다';
	@override String get success => '피드백을 전송했습니다. 감사합니다!';
	@override String get fail => '피드백 전송에 실패했습니다';
}

// Path: settings
class _TranslationsSettingsKo implements TranslationsSettingsJa {
	_TranslationsSettingsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get appearance => '화면';
	@override String get appIcon => '앱 아이콘';
	@override String get appIconDescription => '홈 화면에 표시되는 앱 아이콘을 변경합니다';
	@override String get contentSettings => '콘텐츠 설정';
	@override String get searchEnabled => '검색 기능이 활성화되었습니다';
	@override String get searchDisabled => '검색 기능이 비활성화되었습니다';
	@override String get enableSearch => '검색 기능 활성화';
	@override String get enableSearchDescription => '검색 결과에 성적인 콘텐츠나 폭력적인 콘텐츠가 표시될 수 있습니다.';
	@override String get apiSetting => '아바타 검색 API';
	@override String get apiSettingDescription => '아바타 검색 기능의 API를 설정합니다';
	@override String get apiSettingSaveUrl => 'URL을 저장했습니다';
	@override String get notSet => '설정되지 않음 (아바타 검색 기능을 사용할 수 없습니다)';
	@override String get notifications => '알림 설정';
	@override String get eventReminder => '이벤트 리마인더';
	@override String get eventReminderDescription => '설정한 이벤트 시작 전에 알림을 받습니다';
	@override String get manageReminders => '설정된 리마인더 관리';
	@override String get manageRemindersDescription => '알림 취소 및 확인이 가능합니다';
	@override String get dataStorage => '데이터 및 저장 공간';
	@override String get clearCache => '캐시 삭제';
	@override String get clearCacheSuccess => '캐시를 삭제했습니다';
	@override String get clearCacheError => '캐시 삭제 중 오류가 발생했습니다';
	@override String cacheSize({required Object size}) => '캐시 크기: ${size}';
	@override String get calculatingCache => '캐시 크기 계산 중...';
	@override String get cacheError => '캐시 크기를 가져올 수 없었습니다';
	@override String get confirmClearCache => '캐시를 삭제하면 임시로 저장된 이미지나 데이터가 삭제됩니다.\n\n계정 정보나 앱 설정은 삭제되지 않습니다.';
	@override String get appInfo => '앱 정보';
	@override String get version => '버전';
	@override String get packageName => '패키지 이름';
	@override String get credit => '크레딧';
	@override String get creditDescription => '개발자·기여자 정보';
	@override String get contact => '문의하기';
	@override String get contactDescription => '버그 신고·의견은 여기로';
	@override String get privacyPolicy => '개인정보처리방침';
	@override String get privacyPolicyDescription => '개인정보 취급에 대하여';
	@override String get termsOfService => '이용약관';
	@override String get termsOfServiceDescription => '앱 이용 조건';
	@override String get openSource => '오픈소스 정보';
	@override String get openSourceDescription => '사용 중인 라이브러리 등의 라이선스';
	@override String get github => 'GitHub 리포지토리';
	@override String get githubDescription => '소스 코드 보기';
	@override String get logoutConfirm => '로그아웃하시겠습니까?';
	@override String logoutError({required Object error}) => '로그아웃 중 오류가 발생했습니다: ${error}';
	@override String get iconChangeNotSupported => '사용 중인 기기에서는 앱 아이콘 변경을 지원하지 않습니다';
	@override String get iconChangeFailed => '아이콘 변경에 실패했습니다';
	@override String get themeMode => '테마 모드';
	@override String get themeModeDescription => '앱의 표시 테마를 선택할 수 있습니다';
	@override String get themeLight => '밝게';
	@override String get themeSystem => '시스템';
	@override String get themeDark => '어둡게';
	@override String get appIconDefault => '기본';
	@override String get appIconIcon => '아이콘';
	@override String get appIconLogo => '로고';
	@override String get delete => '삭제하기';
}

// Path: credits
class _TranslationsCreditsKo implements TranslationsCreditsJa {
	_TranslationsCreditsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '크레딧';
	@override late final _TranslationsCreditsSectionKo section = _TranslationsCreditsSectionKo._(_root);
}

// Path: download
class _TranslationsDownloadKo implements TranslationsDownloadJa {
	_TranslationsDownloadKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get success => '다운로드가 완료되었습니다';
	@override String failure({required Object error}) => '다운로드에 실패했습니다: ${error}';
	@override String shareFailure({required Object error}) => '공유에 실패했습니다: ${error}';
	@override String get permissionTitle => '권한이 필요합니다';
	@override String permissionDenied({required Object permissionType}) => '${permissionType}에 대한 저장 권한이 거부되었습니다.\n설정 앱에서 권한을 활성화해 주세요.';
	@override String get permissionCancel => '취소';
	@override String get permissionOpenSettings => '설정 열기';
	@override String get permissionPhoto => '사진';
	@override String get permissionPhotoLibrary => '사진 라이브러리';
	@override String get permissionStorage => '저장 공간';
	@override String get permissionPhotoRequired => '사진에 대한 저장 권한이 필요합니다';
	@override String get permissionPhotoLibraryRequired => '사진 라이브러리에 대한 저장 권한이 필요합니다';
	@override String get permissionStorageRequired => '저장 공간에 대한 접근 권한이 필요합니다';
	@override String permissionError({required Object error}) => '권한 확인 중 오류가 발생했습니다: ${error}';
	@override String downloading({required Object fileName}) => '${fileName} 다운로드 중...';
	@override String sharing({required Object fileName}) => '${fileName} 공유 준비 중...';
}

// Path: instance
class _TranslationsInstanceKo implements TranslationsInstanceJa {
	_TranslationsInstanceKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInstanceTypeKo type = _TranslationsInstanceTypeKo._(_root);
}

// Path: status
class _TranslationsStatusKo implements TranslationsStatusJa {
	_TranslationsStatusKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get active => '온라인';
	@override String get joinMe => '누구나 와요';
	@override String get askMe => '물어보세요';
	@override String get busy => '바쁨';
	@override String get offline => '오프라인';
	@override String get unknown => '상태 알 수 없음';
}

// Path: location
class _TranslationsLocationKo implements TranslationsLocationJa {
	_TranslationsLocationKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get private => '프라이빗';
	@override String playerCount({required Object userCount, required Object capacity}) => '플레이어 수: ${userCount} / ${capacity}';
	@override String instanceType({required Object type}) => '인스턴스 타입: ${type}';
	@override String get noInfo => '위치 정보가 없습니다';
	@override String get fetchError => '위치 정보 로딩에 실패했습니다';
	@override String get privateLocation => '프라이빗한 장소에 있습니다';
	@override String get inviteSending => '초대 보내는 중...';
	@override String get inviteSent => '초대를 보냈습니다. 알림에서 참여할 수 있습니다';
	@override String inviteFailed({required Object error}) => '초대 보내기에 실패했습니다: ${error}';
	@override String get inviteButton => '나에게 초대 보내기';
}

// Path: reminder
class _TranslationsReminderKo implements TranslationsReminderJa {
	_TranslationsReminderKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => '리마인더 설정';
	@override String get alreadySet => '설정됨';
	@override String get set => '설정하기';
	@override String get cancel => '취소';
	@override String get delete => '삭제하기';
	@override String get deleteAll => '모든 리마인더 삭제';
	@override String get deleteAllConfirm => '설정한 모든 이벤트 리마인더를 삭제합니다. 이 작업은 되돌릴 수 없습니다.';
	@override String get deleted => '리마인더를 삭제했습니다';
	@override String get deletedAll => '모든 리마인더를 삭제했습니다';
	@override String get noReminders => '설정된 리마인더가 없습니다';
	@override String get setFromEvent => '이벤트 페이지에서 알림을 설정할 수 있습니다';
	@override String eventStart({required Object time}) => '${time} 시작';
	@override String notifyAt({required Object time, required Object label}) => '${time} (${label})';
	@override String get receiveNotification => '언제 알림을 받으시겠습니까?';
}

// Path: friend
class _TranslationsFriendKo implements TranslationsFriendJa {
	_TranslationsFriendKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get sortFilter => '정렬·필터';
	@override String get filter => '필터';
	@override String get filterAll => '모두 표시';
	@override String get filterOnline => '온라인만';
	@override String get filterOffline => '오프라인만';
	@override String get filterFavorite => '즐겨찾기만';
	@override String get sort => '정렬';
	@override String get sortStatus => '온라인 상태 순';
	@override String get sortName => '이름 순';
	@override String get sortLastLogin => '마지막 로그인 순';
	@override String get sortAsc => '오름차순';
	@override String get sortDesc => '내림차순';
	@override String get close => '닫기';
}

// Path: eventCalendarFilter
class _TranslationsEventCalendarFilterKo implements TranslationsEventCalendarFilterJa {
	_TranslationsEventCalendarFilterKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get filterTitle => '이벤트 필터링';
	@override String get clear => '초기화';
	@override String get keyword => '키워드 검색';
	@override String get keywordHint => '이벤트 이름, 설명, 주최자 등';
	@override String get date => '날짜로 필터링';
	@override String get dateHint => '특정 날짜 범위의 이벤트를 표시할 수 있습니다';
	@override String get startDate => '시작일';
	@override String get endDate => '종료일';
	@override String get select => '선택해 주세요';
	@override String get time => '시간대로 필터링';
	@override String get timeHint => '특정 시간대에 개최되는 이벤트를 표시할 수 있습니다';
	@override String get startTime => '시작 시간';
	@override String get endTime => '종료 시간';
	@override String get genre => '장르로 필터링';
	@override String genreSelected({required Object count}) => '${count}개의 장르 선택 중';
	@override String get apply => '적용하기';
	@override String get filterSummary => '필터';
	@override String get filterNone => '필터가 설정되지 않았습니다';
}

// Path: drawer.section
class _TranslationsDrawerSectionKo implements TranslationsDrawerSectionJa {
	_TranslationsDrawerSectionKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get content => '콘텐츠';
	@override String get other => '기타';
}

// Path: search.tabs
class _TranslationsSearchTabsKo implements TranslationsSearchTabsJa {
	_TranslationsSearchTabsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSearchTabsUserSearchKo userSearch = _TranslationsSearchTabsUserSearchKo._(_root);
	@override late final _TranslationsSearchTabsWorldSearchKo worldSearch = _TranslationsSearchTabsWorldSearchKo._(_root);
	@override late final _TranslationsSearchTabsGroupSearchKo groupSearch = _TranslationsSearchTabsGroupSearchKo._(_root);
	@override late final _TranslationsSearchTabsAvatarSearchKo avatarSearch = _TranslationsSearchTabsAvatarSearchKo._(_root);
}

// Path: groupDetail.privacy
class _TranslationsGroupDetailPrivacyKo implements TranslationsGroupDetailPrivacyJa {
	_TranslationsGroupDetailPrivacyKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get public => '공개';
	@override String get private => '비공개';
	@override String get friends => '친구';
	@override String get invite => '초대제';
	@override String get unknown => '알 수 없음';
}

// Path: groupDetail.role
class _TranslationsGroupDetailRoleKo implements TranslationsGroupDetailRoleJa {
	_TranslationsGroupDetailRoleKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get admin => '관리자';
	@override String get moderator => '모더레이터';
	@override String get member => '멤버';
	@override String get unknown => '알 수 없음';
}

// Path: inventory.tabs
class _TranslationsInventoryTabsKo implements TranslationsInventoryTabsJa {
	_TranslationsInventoryTabsKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsInventoryTabsEmojiInventoryKo emojiInventory = _TranslationsInventoryTabsEmojiInventoryKo._(_root);
	@override late final _TranslationsInventoryTabsGalleryInventoryKo galleryInventory = _TranslationsInventoryTabsGalleryInventoryKo._(_root);
	@override late final _TranslationsInventoryTabsIconInventoryKo iconInventory = _TranslationsInventoryTabsIconInventoryKo._(_root);
	@override late final _TranslationsInventoryTabsPrintInventoryKo printInventory = _TranslationsInventoryTabsPrintInventoryKo._(_root);
	@override late final _TranslationsInventoryTabsStickerInventoryKo stickerInventory = _TranslationsInventoryTabsStickerInventoryKo._(_root);
}

// Path: vrcnsync.usageSteps.0
class _TranslationsVrcnsync$usageSteps$0i0$Ko implements TranslationsVrcnsync$usageSteps$0i0$Ja {
	_TranslationsVrcnsync$usageSteps$0i0$Ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => 'PC에서 VRCNSync 앱 실행';
	@override String get desc => 'PC에서 VRCNSync 앱을 실행해 주세요';
}

// Path: vrcnsync.usageSteps.1
class _TranslationsVrcnsync$usageSteps$0i1$Ko implements TranslationsVrcnsync$usageSteps$0i1$Ja {
	_TranslationsVrcnsync$usageSteps$0i1$Ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '동일한 WiFi 네트워크에 연결';
	@override String get desc => 'PC와 모바일 기기를 동일한 WiFi 네트워크에 연결해 주세요';
}

// Path: vrcnsync.usageSteps.2
class _TranslationsVrcnsync$usageSteps$0i2$Ko implements TranslationsVrcnsync$usageSteps$0i2$Ja {
	_TranslationsVrcnsync$usageSteps$0i2$Ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '연결 대상으로 모바일 기기 지정';
	@override String get desc => 'PC 앱에서 위의 IP 주소와 포트를 지정해 주세요';
}

// Path: vrcnsync.usageSteps.3
class _TranslationsVrcnsync$usageSteps$0i3$Ko implements TranslationsVrcnsync$usageSteps$0i3$Ja {
	_TranslationsVrcnsync$usageSteps$0i3$Ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '사진 전송';
	@override String get desc => 'PC에서 사진을 전송하면 자동으로 VRCN 앨범에 저장됩니다';
}

// Path: credits.section
class _TranslationsCreditsSectionKo implements TranslationsCreditsSectionJa {
	_TranslationsCreditsSectionKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get development => '개발';
	@override String get iconPeople => '재미있는 아이콘 제공자들';
	@override String get testFeedback => '테스트·피드백';
	@override String get specialThanks => '스페셜 땡스';
}

// Path: instance.type
class _TranslationsInstanceTypeKo implements TranslationsInstanceTypeJa {
	_TranslationsInstanceTypeKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get public => '퍼블릭';
	@override String get hidden => '프렌드+';
	@override String get friends => '프렌드';
	@override String get private => '인바이트+';
	@override String get unknown => '알 수 없음';
}

// Path: search.tabs.userSearch
class _TranslationsSearchTabsUserSearchKo implements TranslationsSearchTabsUserSearchJa {
	_TranslationsSearchTabsUserSearchKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '사용자 검색';
	@override String get emptyDescription => '사용자 이름이나 ID로 검색할 수 있습니다';
	@override String get searching => '검색 중...';
	@override String get noResults => '해당하는 사용자를 찾을 수 없습니다';
	@override String error({required Object error}) => '사용자 검색 중 오류가 발생했습니다: ${error}';
	@override String get inputPlaceholder => '사용자 이름 또는 ID 입력';
}

// Path: search.tabs.worldSearch
class _TranslationsSearchTabsWorldSearchKo implements TranslationsSearchTabsWorldSearchJa {
	_TranslationsSearchTabsWorldSearchKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '월드 탐색';
	@override String get emptyDescription => '키워드를 입력하여 검색해 주세요';
	@override String get searching => '검색 중...';
	@override String get noResults => '해당하는 월드를 찾을 수 없습니다';
	@override String noResultsWithQuery({required Object query}) => '\'${query}\'에 일치하는 월드를\n찾을 수 없었습니다';
	@override String get noResultsHint => '검색 키워드를 바꿔보세요';
	@override String error({required Object error}) => '월드 검색 중 오류가 발생했습니다: ${error}';
	@override String resultCount({required Object count}) => '${count}개의 월드를 찾았습니다';
	@override String authorPrefix({required Object authorName}) => 'by ${authorName}';
	@override String get listView => '리스트 뷰';
	@override String get gridView => '그리드 뷰';
}

// Path: search.tabs.groupSearch
class _TranslationsSearchTabsGroupSearchKo implements TranslationsSearchTabsGroupSearchJa {
	_TranslationsSearchTabsGroupSearchKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get emptyTitle => '그룹 검색';
	@override String get emptyDescription => '키워드를 입력하여 검색해 주세요';
	@override String get searching => '검색 중...';
	@override String get noResults => '해당하는 그룹을 찾을 수 없습니다';
	@override String noResultsWithQuery({required Object query}) => '\'${query}\'에 일치하는 그룹을\n찾을 수 없었습니다';
	@override String get noResultsHint => '검색 키워드를 바꿔보세요';
	@override String error({required Object error}) => '그룹 검색 중 오류가 발생했습니다: ${error}';
	@override String resultCount({required Object count}) => '${count}개의 그룹을 찾았습니다';
	@override String get listView => '리스트 뷰';
	@override String get gridView => '그리드 뷰';
	@override String memberCount({required Object count}) => '${count} 멤버';
}

// Path: search.tabs.avatarSearch
class _TranslationsSearchTabsAvatarSearchKo implements TranslationsSearchTabsAvatarSearchJa {
	_TranslationsSearchTabsAvatarSearchKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get avatar => '아바타';
	@override String get emptyTitle => '아바타 검색';
	@override String get emptyDescription => '키워드를 입력하여 검색해 주세요';
	@override String get searching => '아바타 검색 중...';
	@override String get noResults => '검색 결과를 찾을 수 없습니다';
	@override String get noResultsHint => '다른 키워드로 시도해 보세요';
	@override String error({required Object error}) => '아바타 검색 중 오류가 발생했습니다: ${error}';
}

// Path: inventory.tabs.emojiInventory
class _TranslationsInventoryTabsEmojiInventoryKo implements TranslationsInventoryTabsEmojiInventoryJa {
	_TranslationsInventoryTabsEmojiInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '이모지 로딩 중...';
	@override String error({required Object error}) => '이모지 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '이모지가 없습니다';
	@override String get emptyDescription => 'VRChat에서 업로드한 이모지가 여기에 표시됩니다';
	@override String get zoomHint => '더블 탭으로 확대';
}

// Path: inventory.tabs.galleryInventory
class _TranslationsInventoryTabsGalleryInventoryKo implements TranslationsInventoryTabsGalleryInventoryJa {
	_TranslationsInventoryTabsGalleryInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '갤러리 로딩 중...';
	@override String error({required Object error}) => '갤러리 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '갤러리가 없습니다';
	@override String get emptyDescription => 'VRChat에서 업로드한 갤러리가 여기에 표시됩니다';
	@override String get zoomHint => '더블 탭으로 확대';
}

// Path: inventory.tabs.iconInventory
class _TranslationsInventoryTabsIconInventoryKo implements TranslationsInventoryTabsIconInventoryJa {
	_TranslationsInventoryTabsIconInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '아이콘 로딩 중...';
	@override String error({required Object error}) => '아이콘 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '아이콘이 없습니다';
	@override String get emptyDescription => 'VRChat에서 업로드한 아이콘이 여기에 표시됩니다';
	@override String get zoomHint => '더블 탭으로 확대';
}

// Path: inventory.tabs.printInventory
class _TranslationsInventoryTabsPrintInventoryKo implements TranslationsInventoryTabsPrintInventoryJa {
	_TranslationsInventoryTabsPrintInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '프린트 로딩 중...';
	@override String error({required Object error}) => '프린트 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '프린트가 없습니다';
	@override String get emptyDescription => 'VRChat에서 업로드한 프린트가 여기에 표시됩니다';
	@override String get zoomHint => '더블 탭으로 확대';
}

// Path: inventory.tabs.stickerInventory
class _TranslationsInventoryTabsStickerInventoryKo implements TranslationsInventoryTabsStickerInventoryJa {
	_TranslationsInventoryTabsStickerInventoryKo._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get loading => '스티커 로딩 중...';
	@override String error({required Object error}) => '스티커 로딩에 실패했습니다: ${error}';
	@override String get emptyTitle => '스티커가 없습니다';
	@override String get emptyDescription => 'VRChat에서 업로드한 스티커가 여기에 표시됩니다';
	@override String get zoomHint => '더블 탭으로 확대';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsKo {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'common.title': return 'VRCN';
			case 'common.ok': return '확인';
			case 'common.cancel': return '취소';
			case 'common.close': return '닫기';
			case 'common.save': return '저장';
			case 'common.edit': return '편집';
			case 'common.delete': return '삭제';
			case 'common.yes': return '예';
			case 'common.no': return '아니요';
			case 'common.loading': return '로딩 중...';
			case 'common.error': return ({required Object error}) => '오류가 발생했습니다: ${error}';
			case 'common.errorNomessage': return '오류가 발생했습니다';
			case 'common.retry': return '재시도';
			case 'common.search': return '검색';
			case 'common.settings': return '설정';
			case 'common.confirm': return '확인';
			case 'common.agree': return '동의';
			case 'common.decline': return '동의 안 함';
			case 'common.username': return '사용자 이름';
			case 'common.password': return '비밀번호';
			case 'common.login': return '로그인';
			case 'common.logout': return '로그아웃';
			case 'common.share': return '공유';
			case 'termsAgreement.welcomeTitle': return 'VRCN에 오신 것을 환영합니다';
			case 'termsAgreement.welcomeMessage': return '앱을 사용하기 전에\n이용약관과 개인정보처리방침을 확인해 주세요';
			case 'termsAgreement.termsTitle': return '이용약관';
			case 'termsAgreement.termsSubtitle': return '앱 이용 조건에 대하여';
			case 'termsAgreement.privacyTitle': return '개인정보처리방침';
			case 'termsAgreement.privacySubtitle': return '개인정보 취급에 대하여';
			case 'termsAgreement.agreeTerms': return ({required Object title}) => '\'${title}\'에 동의합니다';
			case 'termsAgreement.checkContent': return '내용 확인';
			case 'termsAgreement.notice': return '이 앱은 VRChat Inc.의 비공식 앱입니다.\nVRChat Inc.와는 일절 관계가 없습니다.';
			case 'drawer.home': return '홈';
			case 'drawer.profile': return '프로필';
			case 'drawer.favorite': return '즐겨찾기';
			case 'drawer.eventCalendar': return '이벤트 캘린더';
			case 'drawer.avatar': return '아바타';
			case 'drawer.group': return '그룹';
			case 'drawer.inventory': return '인벤토리';
			case 'drawer.vrcnsync': return 'VRCNSync (β)';
			case 'drawer.review': return '리뷰';
			case 'drawer.feedback': return '피드백';
			case 'drawer.settings': return '설정';
			case 'drawer.userLoading': return '사용자 정보 로딩 중...';
			case 'drawer.userError': return '사용자 정보 로딩에 실패했습니다';
			case 'drawer.retry': return '재시도';
			case 'drawer.section.content': return '콘텐츠';
			case 'drawer.section.other': return '기타';
			case 'login.forgotPassword': return '비밀번호를 잊으셨나요?';
			case 'login.subtitle': return 'VRChat 계정 정보로 로그인';
			case 'login.email': return '이메일 주소';
			case 'login.emailHint': return '이메일 또는 사용자 이름 입력';
			case 'login.passwordHint': return '비밀번호 입력';
			case 'login.rememberMe': return '로그인 상태 유지';
			case 'login.loggingIn': return '로그인 중...';
			case 'login.errorEmptyEmail': return '사용자 이름 또는 이메일 주소를 입력해 주세요';
			case 'login.errorEmptyPassword': return '비밀번호를 입력해 주세요';
			case 'login.errorLoginFailed': return '로그인에 실패했습니다. 이메일 주소와 비밀번호를 확인해 주세요.';
			case 'login.twoFactorTitle': return '2단계 인증';
			case 'login.twoFactorSubtitle': return '인증 코드를 입력해 주세요';
			case 'login.twoFactorInstruction': return '인증 앱에 표시된\n6자리 코드를 입력해 주세요';
			case 'login.twoFactorCodeHint': return '인증 코드';
			case 'login.verify': return '인증';
			case 'login.verifying': return '인증 중...';
			case 'login.errorEmpty2fa': return '인증 코드를 입력해 주세요';
			case 'login.error2faFailed': return '2단계 인증에 실패했습니다. 코드가 올바른지 확인해 주세요.';
			case 'login.backToLogin': return '로그인 화면으로 돌아가기';
			case 'login.paste': return '붙여넣기';
			case 'friends.loading': return '친구 정보 로딩 중...';
			case 'friends.error': return ({required Object error}) => '친구 정보 로딩에 실패했습니다: ${error}';
			case 'friends.notFound': return '친구를 찾을 수 없습니다';
			case 'friends.private': return '프라이빗';
			case 'friends.active': return '활동 중';
			case 'friends.offline': return '오프라인';
			case 'friends.online': return '온라인';
			case 'friends.groupTitle': return '월드별로 그룹화';
			case 'friends.refresh': return '새로고침';
			case 'friends.searchHint': return '친구 이름으로 검색';
			case 'friends.noResult': return '해당하는 친구가 없습니다';
			case 'friendDetail.loading': return '사용자 정보 로딩 중...';
			case 'friendDetail.error': return ({required Object error}) => '사용자 정보 로딩에 실패했습니다: ${error}';
			case 'friendDetail.currentLocation': return '현재 위치';
			case 'friendDetail.basicInfo': return '기본 정보';
			case 'friendDetail.userId': return '사용자 ID';
			case 'friendDetail.dateJoined': return '가입일';
			case 'friendDetail.lastLogin': return '마지막 로그인';
			case 'friendDetail.bio': return '자기소개';
			case 'friendDetail.links': return '링크';
			case 'friendDetail.loadingLinks': return '링크 정보 로딩 중...';
			case 'friendDetail.group': return '소속 그룹';
			case 'friendDetail.groupDetail': return '그룹 상세 정보 보기';
			case 'friendDetail.groupCode': return ({required Object code}) => '그룹 코드: ${code}';
			case 'friendDetail.memberCount': return ({required Object count}) => '멤버 수: ${count}명';
			case 'friendDetail.unknownGroup': return '알 수 없는 그룹';
			case 'friendDetail.block': return '차단';
			case 'friendDetail.mute': return '음소거';
			case 'friendDetail.openWebsite': return '웹사이트에서 열기';
			case 'friendDetail.shareProfile': return '프로필 공유';
			case 'friendDetail.confirmBlockTitle': return ({required Object name}) => '${name}님을 차단하시겠습니까?';
			case 'friendDetail.confirmBlockMessage': return '차단하면 이 사용자로부터 친구 신청이나 메시지를 받지 않게 됩니다.';
			case 'friendDetail.confirmMuteTitle': return ({required Object name}) => '${name}님을 음소거하시겠습니까?';
			case 'friendDetail.confirmMuteMessage': return '음소거하면 이 사용자의 음성이 들리지 않게 됩니다.';
			case 'friendDetail.blockSuccess': return '차단했습니다';
			case 'friendDetail.muteSuccess': return '음소거했습니다';
			case 'friendDetail.operationFailed': return ({required Object error}) => '작업에 실패했습니다: ${error}';
			case 'search.userTab': return '사용자';
			case 'search.worldTab': return '월드';
			case 'search.avatarTab': return '아바타';
			case 'search.groupTab': return '그룹';
			case 'search.tabs.userSearch.emptyTitle': return '사용자 검색';
			case 'search.tabs.userSearch.emptyDescription': return '사용자 이름이나 ID로 검색할 수 있습니다';
			case 'search.tabs.userSearch.searching': return '검색 중...';
			case 'search.tabs.userSearch.noResults': return '해당하는 사용자를 찾을 수 없습니다';
			case 'search.tabs.userSearch.error': return ({required Object error}) => '사용자 검색 중 오류가 발생했습니다: ${error}';
			case 'search.tabs.userSearch.inputPlaceholder': return '사용자 이름 또는 ID 입력';
			case 'search.tabs.worldSearch.emptyTitle': return '월드 탐색';
			case 'search.tabs.worldSearch.emptyDescription': return '키워드를 입력하여 검색해 주세요';
			case 'search.tabs.worldSearch.searching': return '검색 중...';
			case 'search.tabs.worldSearch.noResults': return '해당하는 월드를 찾을 수 없습니다';
			case 'search.tabs.worldSearch.noResultsWithQuery': return ({required Object query}) => '\'${query}\'에 일치하는 월드를\n찾을 수 없었습니다';
			case 'search.tabs.worldSearch.noResultsHint': return '검색 키워드를 바꿔보세요';
			case 'search.tabs.worldSearch.error': return ({required Object error}) => '월드 검색 중 오류가 발생했습니다: ${error}';
			case 'search.tabs.worldSearch.resultCount': return ({required Object count}) => '${count}개의 월드를 찾았습니다';
			case 'search.tabs.worldSearch.authorPrefix': return ({required Object authorName}) => 'by ${authorName}';
			case 'search.tabs.worldSearch.listView': return '리스트 뷰';
			case 'search.tabs.worldSearch.gridView': return '그리드 뷰';
			case 'search.tabs.groupSearch.emptyTitle': return '그룹 검색';
			case 'search.tabs.groupSearch.emptyDescription': return '키워드를 입력하여 검색해 주세요';
			case 'search.tabs.groupSearch.searching': return '검색 중...';
			case 'search.tabs.groupSearch.noResults': return '해당하는 그룹을 찾을 수 없습니다';
			case 'search.tabs.groupSearch.noResultsWithQuery': return ({required Object query}) => '\'${query}\'에 일치하는 그룹을\n찾을 수 없었습니다';
			case 'search.tabs.groupSearch.noResultsHint': return '검색 키워드를 바꿔보세요';
			case 'search.tabs.groupSearch.error': return ({required Object error}) => '그룹 검색 중 오류가 발생했습니다: ${error}';
			case 'search.tabs.groupSearch.resultCount': return ({required Object count}) => '${count}개의 그룹을 찾았습니다';
			case 'search.tabs.groupSearch.listView': return '리스트 뷰';
			case 'search.tabs.groupSearch.gridView': return '그리드 뷰';
			case 'search.tabs.groupSearch.memberCount': return ({required Object count}) => '${count} 멤버';
			case 'search.tabs.avatarSearch.avatar': return '아바타';
			case 'search.tabs.avatarSearch.emptyTitle': return '아바타 검색';
			case 'search.tabs.avatarSearch.emptyDescription': return '키워드를 입력하여 검색해 주세요';
			case 'search.tabs.avatarSearch.searching': return '아바타 검색 중...';
			case 'search.tabs.avatarSearch.noResults': return '검색 결과를 찾을 수 없습니다';
			case 'search.tabs.avatarSearch.noResultsHint': return '다른 키워드로 시도해 보세요';
			case 'search.tabs.avatarSearch.error': return ({required Object error}) => '아바타 검색 중 오류가 발생했습니다: ${error}';
			case 'profile.title': return '프로필';
			case 'profile.edit': return '편집';
			case 'profile.refresh': return '새로고침';
			case 'profile.loading': return '프로필 정보 로딩 중...';
			case 'profile.error': return '프로필 정보 로딩에 실패했습니다: {error}';
			case 'profile.displayName': return '표시 이름';
			case 'profile.username': return '사용자 이름';
			case 'profile.userId': return '사용자 ID';
			case 'profile.engageCard': return '인게이지 카드';
			case 'profile.frined': return '친구';
			case 'profile.dateJoined': return '가입일';
			case 'profile.userType': return '사용자 유형';
			case 'profile.status': return '상태';
			case 'profile.statusMessage': return '상태 메시지';
			case 'profile.bio': return '자기소개';
			case 'profile.links': return '링크';
			case 'profile.group': return '소속 그룹';
			case 'profile.groupDetail': return '그룹 상세 정보 보기';
			case 'profile.avatar': return '현재 아바타';
			case 'profile.avatarDetail': return '아바타 상세 정보 보기';
			case 'profile.public': return '공개';
			case 'profile.private': return '비공개';
			case 'profile.hidden': return '숨김';
			case 'profile.unknown': return '알 수 없음';
			case 'profile.friends': return '친구';
			case 'profile.loadingLinks': return '링크 정보 로딩 중...';
			case 'profile.noGroup': return '소속된 그룹이 없습니다';
			case 'profile.noBio': return '자기소개가 없습니다';
			case 'profile.noLinks': return '링크가 없습니다';
			case 'profile.save': return '변경사항 저장';
			case 'profile.saved': return '프로필을 업데이트했습니다';
			case 'profile.saveFailed': return '업데이트에 실패했습니다: {error}';
			case 'profile.discardTitle': return '변경사항을 취소하시겠습니까?';
			case 'profile.discardContent': return '프로필에 적용한 변경사항은 저장되지 않습니다.';
			case 'profile.discardCancel': return '취소';
			case 'profile.discardOk': return '취소하기';
			case 'profile.basic': return '기본 정보';
			case 'profile.pronouns': return '대명사';
			case 'profile.addLink': return '추가';
			case 'profile.removeLink': return '삭제';
			case 'profile.linkHint': return '링크 입력 (예: https://twitter.com/username)';
			case 'profile.linksHint': return '링크는 프로필에 표시되며, 탭하여 열 수 있습니다';
			case 'profile.statusMessageHint': return '현재 상황이나 메시지를 입력하세요';
			case 'profile.bioHint': return '자신에 대해 작성해 보세요';
			case 'engageCard.pickBackground': return '배경 이미지 선택';
			case 'engageCard.removeBackground': return '배경 이미지 삭제';
			case 'engageCard.scanQr': return 'QR 코드 스캔';
			case 'engageCard.showAvatar': return '아바타 표시';
			case 'engageCard.hideAvatar': return '아바타 숨기기';
			case 'engageCard.noBackground': return '배경 이미지가 선택되지 않았습니다\n오른쪽 상단 버튼으로 설정할 수 있습니다';
			case 'engageCard.loading': return '로딩 중...';
			case 'engageCard.error': return ({required Object error}) => '인게이지 카드 정보 로딩에 실패했습니다: ${error}';
			case 'engageCard.copyUserId': return '사용자 ID 복사';
			case 'engageCard.copied': return '복사했습니다';
			case 'qrScanner.title': return 'QR 코드 스캔';
			case 'qrScanner.guide': return 'QR 코드를 프레임 안에 맞춰주세요';
			case 'qrScanner.loading': return '카메라 초기화 중...';
			case 'qrScanner.error': return ({required Object error}) => 'QR 코드 읽기에 실패했습니다: ${error}';
			case 'qrScanner.notFound': return '유효한 사용자 QR 코드를 찾을 수 없습니다';
			case 'favorites.title': return '즐겨찾기';
			case 'favorites.frined': return '친구';
			case 'favorites.friendsTab': return '친구';
			case 'favorites.worldsTab': return '월드';
			case 'favorites.avatarsTab': return '아바타';
			case 'favorites.emptyFolderTitle': return '즐겨찾기 폴더가 없습니다';
			case 'favorites.emptyFolderDescription': return 'VRChat에서 즐겨찾기 폴더를 생성해 주세요';
			case 'favorites.emptyFriends': return '이 폴더에는 친구가 없습니다';
			case 'favorites.emptyWorlds': return '이 폴더에는 월드가 없습니다';
			case 'favorites.emptyAvatars': return '이 폴더에는 아바타가 없습니다';
			case 'favorites.emptyWorldsTabTitle': return '즐겨찾는 월드가 없습니다';
			case 'favorites.emptyWorldsTabDescription': return '월드 상세 화면에서 즐겨찾기에 등록할 수 있습니다';
			case 'favorites.emptyAvatarsTabTitle': return '즐겨찾는 아바타가 없습니다';
			case 'favorites.emptyAvatarsTabDescription': return '아바타 상세 화면에서 즐겨찾기에 등록할 수 있습니다';
			case 'favorites.loading': return '즐겨찾기 로딩 중...';
			case 'favorites.loadingFolder': return '폴더 정보 로딩 중...';
			case 'favorites.error': return ({required Object error}) => '즐겨찾기 로딩에 실패했습니다: ${error}';
			case 'favorites.errorFolder': return '정보를 가져오는데 실패했습니다';
			case 'favorites.remove': return '즐겨찾기에서 삭제';
			case 'favorites.removeSuccess': return ({required Object name}) => '${name}을(를) 즐겨찾기에서 삭제했습니다';
			case 'favorites.removeFailed': return ({required Object error}) => '삭제에 실패했습니다: ${error}';
			case 'favorites.itemsCount': return ({required Object count}) => '${count} 아이템';
			case 'favorites.public': return '공개';
			case 'favorites.private': return '비공개';
			case 'favorites.hidden': return '숨김';
			case 'favorites.unknown': return '알 수 없음';
			case 'favorites.loadingError': return '로딩 오류';
			case 'notifications.emptyTitle': return '알림이 없습니다';
			case 'notifications.emptyDescription': return '친구 요청이나 초대 등\n새로운 알림이 여기에 표시됩니다';
			case 'notifications.friendRequest': return ({required Object userName}) => '${userName}님으로부터 친구 요청이 도착했습니다';
			case 'notifications.invite': return ({required Object userName, required Object worldName}) => '${userName}님으로부터 ${worldName}(으)로 초대가 도착했습니다';
			case 'notifications.friendOnline': return ({required Object userName}) => '${userName}님이 온라인 상태가 되었습니다';
			case 'notifications.friendOffline': return ({required Object userName}) => '${userName}님이 오프라인 상태가 되었습니다';
			case 'notifications.friendActive': return ({required Object userName}) => '${userName}님이 활동 중 상태가 되었습니다';
			case 'notifications.friendAdd': return ({required Object userName}) => '${userName}님이 친구에 추가되었습니다';
			case 'notifications.friendRemove': return ({required Object userName}) => '${userName}님이 친구에서 삭제되었습니다';
			case 'notifications.statusUpdate': return ({required Object userName, required Object status, required Object world}) => '${userName}님의 상태가 업데이트되었습니다: ${status}${world}';
			case 'notifications.locationChange': return ({required Object userName, required Object worldName}) => '${userName}님이 ${worldName}(으)로 이동했습니다';
			case 'notifications.userUpdate': return ({required Object world}) => '당신의 정보가 업데이트되었습니다${world}';
			case 'notifications.myLocationChange': return ({required Object worldName}) => '당신의 이동: ${worldName}';
			case 'notifications.requestInvite': return ({required Object userName}) => '${userName}님으로부터 참가 요청이 도착했습니다';
			case 'notifications.votekick': return ({required Object userName}) => '${userName}님으로부터 투표 추방이 있었습니다';
			case 'notifications.responseReceived': return ({required Object userName}) => '알림 ID:${userName}의 응답을 수신했습니다';
			case 'notifications.error': return ({required Object worldName}) => '오류: ${worldName}';
			case 'notifications.system': return ({required Object extraData}) => '시스템 알림: ${extraData}';
			case 'notifications.secondsAgo': return ({required Object seconds}) => '${seconds}초 전';
			case 'notifications.minutesAgo': return ({required Object minutes}) => '${minutes}분 전';
			case 'notifications.hoursAgo': return ({required Object hours}) => '${hours}시간 전';
			case 'eventCalendar.title': return '이벤트 캘린더';
			case 'eventCalendar.filter': return '이벤트 필터링';
			case 'eventCalendar.refresh': return '이벤트 정보 새로고침';
			case 'eventCalendar.loading': return '이벤트 정보 로딩 중...';
			case 'eventCalendar.error': return ({required Object error}) => '이벤트 정보 로딩에 실패했습니다: ${error}';
			case 'eventCalendar.filterActive': return ({required Object count}) => '필터 적용 중 (${count}건)';
			case 'eventCalendar.clear': return '초기화';
			case 'eventCalendar.noEvents': return '조건에 맞는 이벤트가 없습니다';
			case 'eventCalendar.clearFilter': return '필터 초기화';
			case 'eventCalendar.today': return '오늘';
			case 'eventCalendar.reminderSet': return '리마인더 설정';
			case 'eventCalendar.reminderSetDone': return '리마인더 설정됨';
			case 'eventCalendar.reminderDeleted': return '리마인더를 삭제했습니다';
			case 'eventCalendar.organizer': return '주최자';
			case 'eventCalendar.description': return '설명';
			case 'eventCalendar.genre': return '장르';
			case 'eventCalendar.condition': return '참가 조건';
			case 'eventCalendar.way': return '참가 방법';
			case 'eventCalendar.note': return '비고';
			case 'eventCalendar.quest': return 'Quest 대응';
			case 'eventCalendar.reminderCount': return ({required Object count}) => '${count}건';
			case 'eventCalendar.startToEnd': return ({required Object start, required Object end}) => '${start} ~ ${end}';
			case 'avatars.title': return '아바타';
			case 'avatars.searchHint': return '아바타 이름 등으로 검색';
			case 'avatars.searchTooltip': return '검색';
			case 'avatars.searchEmptyTitle': return '검색 결과를 찾을 수 없습니다';
			case 'avatars.searchEmptyDescription': return '다른 검색어로 시도해 주세요';
			case 'avatars.emptyTitle': return '아바타가 없습니다';
			case 'avatars.emptyDescription': return '아바타를 추가하거나 나중에 다시 시도해 주세요';
			case 'avatars.refresh': return '새로고침';
			case 'avatars.loading': return '아바타 로딩 중...';
			case 'avatars.error': return ({required Object error}) => '아바타 정보 로딩에 실패했습니다: ${error}';
			case 'avatars.current': return '사용 중';
			case 'avatars.public': return '공개';
			case 'avatars.private': return '비공개';
			case 'avatars.hidden': return '숨김';
			case 'avatars.author': return '제작자';
			case 'avatars.sortUpdated': return '업데이트 순';
			case 'avatars.sortName': return '이름 순';
			case 'avatars.sortTooltip': return '정렬';
			case 'avatars.viewModeTooltip': return '보기 모드 전환';
			case 'worldDetail.loading': return '월드 정보 로딩 중...';
			case 'worldDetail.error': return ({required Object error}) => '월드 정보 로딩에 실패했습니다: ${error}';
			case 'worldDetail.share': return '이 월드 공유하기';
			case 'worldDetail.openInVRChat': return 'VRChat 공식 웹사이트에서 열기';
			case 'worldDetail.report': return '이 월드 신고하기';
			case 'worldDetail.creator': return '제작자';
			case 'worldDetail.created': return '생성일';
			case 'worldDetail.updated': return '업데이트일';
			case 'worldDetail.favorites': return '즐겨찾기 수';
			case 'worldDetail.visits': return '방문 수';
			case 'worldDetail.occupants': return '현재 인원';
			case 'worldDetail.popularity': return '평가';
			case 'worldDetail.description': return '설명';
			case 'worldDetail.noDescription': return '설명이 없습니다';
			case 'worldDetail.tags': return '태그';
			case 'worldDetail.joinPublic': return '퍼블릭으로 초대 보내기';
			case 'worldDetail.favoriteAdded': return '즐겨찾기에 추가했습니다';
			case 'worldDetail.favoriteRemoved': return '즐겨찾기에서 삭제했습니다';
			case 'worldDetail.unknown': return '알 수 없음';
			case 'avatarDetail.changeSuccess': return ({required Object name}) => '아바타 \'${name}\'(으)로 변경했습니다';
			case 'avatarDetail.changeFailed': return ({required Object error}) => '아바타 변경에 실패했습니다: ${error}';
			case 'avatarDetail.changing': return '변경 중...';
			case 'avatarDetail.useThisAvatar': return '이 아바타 사용하기';
			case 'avatarDetail.creator': return '제작자';
			case 'avatarDetail.created': return '생성일';
			case 'avatarDetail.updated': return '업데이트일';
			case 'avatarDetail.description': return '설명';
			case 'avatarDetail.noDescription': return '설명이 없습니다';
			case 'avatarDetail.tags': return '태그';
			case 'avatarDetail.addToFavorites': return '즐겨찾기에 추가';
			case 'avatarDetail.public': return '공개';
			case 'avatarDetail.private': return '비공개';
			case 'avatarDetail.hidden': return '숨김';
			case 'avatarDetail.unknown': return '알 수 없음';
			case 'avatarDetail.share': return '공유';
			case 'avatarDetail.loading': return '아바타 정보 로딩 중...';
			case 'avatarDetail.error': return ({required Object error}) => '아바타 정보 로딩에 실패했습니다: ${error}';
			case 'groups.title': return '그룹';
			case 'groups.loadingUser': return '사용자 정보 로딩 중...';
			case 'groups.errorUser': return ({required Object error}) => '사용자 정보 로딩에 실패했습니다: ${error}';
			case 'groups.loadingGroups': return '그룹 정보 로딩 중...';
			case 'groups.errorGroups': return ({required Object error}) => '그룹 정보 로딩에 실패했습니다: ${error}';
			case 'groups.emptyTitle': return '가입한 그룹이 없습니다';
			case 'groups.emptyDescription': return 'VRChat 앱이나 웹사이트에서 그룹에 가입할 수 있습니다';
			case 'groups.searchGroups': return '그룹 찾기';
			case 'groups.members': return ({required Object count}) => '${count}명의 멤버';
			case 'groups.showDetails': return '상세 정보 보기';
			case 'groups.unknownName': return '이름 알 수 없음';
			case 'groupDetail.loading': return '그룹 정보 로딩 중...';
			case 'groupDetail.error': return ({required Object error}) => '그룹 정보 로딩에 실패했습니다: ${error}';
			case 'groupDetail.share': return '그룹 정보 공유';
			case 'groupDetail.description': return '설명';
			case 'groupDetail.roles': return '역할';
			case 'groupDetail.basicInfo': return '기본 정보';
			case 'groupDetail.createdAt': return '생성일';
			case 'groupDetail.owner': return '소유자';
			case 'groupDetail.rules': return '규칙';
			case 'groupDetail.languages': return '언어';
			case 'groupDetail.memberCount': return ({required Object count}) => '${count} 멤버';
			case 'groupDetail.privacy.public': return '공개';
			case 'groupDetail.privacy.private': return '비공개';
			case 'groupDetail.privacy.friends': return '친구';
			case 'groupDetail.privacy.invite': return '초대제';
			case 'groupDetail.privacy.unknown': return '알 수 없음';
			case 'groupDetail.role.admin': return '관리자';
			case 'groupDetail.role.moderator': return '모더레이터';
			case 'groupDetail.role.member': return '멤버';
			case 'groupDetail.role.unknown': return '알 수 없음';
			case 'inventory.title': return '인벤토리';
			case 'inventory.gallery': return '갤러리';
			case 'inventory.icon': return '아이콘';
			case 'inventory.emoji': return '이모지';
			case 'inventory.sticker': return '스티커';
			case 'inventory.print': return '프린트';
			case 'inventory.upload': return '파일 업로드';
			case 'inventory.uploadGallery': return '갤러리 이미지 업로드 중...';
			case 'inventory.uploadIcon': return '아이콘 업로드 중...';
			case 'inventory.uploadEmoji': return '이모지 업로드 중...';
			case 'inventory.uploadSticker': return '스티커 업로드 중...';
			case 'inventory.uploadPrint': return '프린트 이미지 업로드 중...';
			case 'inventory.selectImage': return '이미지 선택';
			case 'inventory.selectFromGallery': return '갤러리에서 선택';
			case 'inventory.takePhoto': return '카메라로 촬영';
			case 'inventory.uploadSuccess': return '업로드가 완료되었습니다';
			case 'inventory.uploadFailed': return '업로드에 실패했습니다';
			case 'inventory.uploadFailedFormat': return '파일 형식 또는 크기에 문제가 있습니다. PNG 형식의 1MB 이하 이미지를 선택해 주세요.';
			case 'inventory.uploadFailedAuth': return '인증에 실패했습니다. 다시 로그인해 주세요.';
			case 'inventory.uploadFailedSize': return '파일 크기가 너무 큽니다. 더 작은 이미지를 선택해 주세요.';
			case 'inventory.uploadFailedServer': return ({required Object code}) => '서버 오류가 발생했습니다 (${code})';
			case 'inventory.pickImageFailed': return ({required Object error}) => '이미지 선택에 실패했습니다: ${error}';
			case 'inventory.tabs.emojiInventory.loading': return '이모지 로딩 중...';
			case 'inventory.tabs.emojiInventory.error': return ({required Object error}) => '이모지 로딩에 실패했습니다: ${error}';
			case 'inventory.tabs.emojiInventory.emptyTitle': return '이모지가 없습니다';
			case 'inventory.tabs.emojiInventory.emptyDescription': return 'VRChat에서 업로드한 이모지가 여기에 표시됩니다';
			case 'inventory.tabs.emojiInventory.zoomHint': return '더블 탭으로 확대';
			case 'inventory.tabs.galleryInventory.loading': return '갤러리 로딩 중...';
			case 'inventory.tabs.galleryInventory.error': return ({required Object error}) => '갤러리 로딩에 실패했습니다: ${error}';
			case 'inventory.tabs.galleryInventory.emptyTitle': return '갤러리가 없습니다';
			case 'inventory.tabs.galleryInventory.emptyDescription': return 'VRChat에서 업로드한 갤러리가 여기에 표시됩니다';
			case 'inventory.tabs.galleryInventory.zoomHint': return '더블 탭으로 확대';
			case 'inventory.tabs.iconInventory.loading': return '아이콘 로딩 중...';
			case 'inventory.tabs.iconInventory.error': return ({required Object error}) => '아이콘 로딩에 실패했습니다: ${error}';
			case 'inventory.tabs.iconInventory.emptyTitle': return '아이콘이 없습니다';
			case 'inventory.tabs.iconInventory.emptyDescription': return 'VRChat에서 업로드한 아이콘이 여기에 표시됩니다';
			case 'inventory.tabs.iconInventory.zoomHint': return '더블 탭으로 확대';
			case 'inventory.tabs.printInventory.loading': return '프린트 로딩 중...';
			case 'inventory.tabs.printInventory.error': return ({required Object error}) => '프린트 로딩에 실패했습니다: ${error}';
			case 'inventory.tabs.printInventory.emptyTitle': return '프린트가 없습니다';
			case 'inventory.tabs.printInventory.emptyDescription': return 'VRChat에서 업로드한 프린트가 여기에 표시됩니다';
			case 'inventory.tabs.printInventory.zoomHint': return '더블 탭으로 확대';
			case 'inventory.tabs.stickerInventory.loading': return '스티커 로딩 중...';
			case 'inventory.tabs.stickerInventory.error': return ({required Object error}) => '스티커 로딩에 실패했습니다: ${error}';
			case 'inventory.tabs.stickerInventory.emptyTitle': return '스티커가 없습니다';
			case 'inventory.tabs.stickerInventory.emptyDescription': return 'VRChat에서 업로드한 스티커가 여기에 표시됩니다';
			case 'inventory.tabs.stickerInventory.zoomHint': return '더블 탭으로 확대';
			case 'vrcnsync.title': return 'VRCNSync (β)';
			case 'vrcnsync.betaTitle': return '베타 기능';
			case 'vrcnsync.betaDescription': return '이 기능은 개발 중인 베타 버전입니다. 예기치 않은 문제가 발생할 수 있습니다.\n현재는 로컬에서만 구현되어 있지만, 수요가 있으면 클라우드 버전을 구현할 예정입니다.';
			case 'vrcnsync.githubLink': return 'VRCNSync GitHub 페이지';
			case 'vrcnsync.openGithub': return 'GitHub 페이지 열기';
			case 'vrcnsync.serverRunning': return '서버 실행 중';
			case 'vrcnsync.serverStopped': return '서버 중지됨';
			case 'vrcnsync.serverRunningDesc': return 'PC의 사진을 VRCN 앨범에 저장합니다';
			case 'vrcnsync.serverStoppedDesc': return '서버가 중지되었습니다';
			case 'vrcnsync.photoSaved': return '사진을 VRCN 앨범에 저장했습니다';
			case 'vrcnsync.photoReceived': return '사진을 수신했습니다 (앨범 저장 실패)';
			case 'vrcnsync.openAlbum': return '앨범 열기';
			case 'vrcnsync.permissionErrorIos': return '사진 라이브러리에 대한 접근 권한이 필요합니다';
			case 'vrcnsync.permissionErrorAndroid': return '저장소에 대한 접근 권한이 필요합니다';
			case 'vrcnsync.openSettings': return '설정 열기';
			case 'vrcnsync.initError': return ({required Object error}) => '초기화에 실패했습니다: ${error}';
			case 'vrcnsync.openPhotoAppError': return '사진 앱을 열 수 없었습니다';
			case 'vrcnsync.serverInfo': return '서버 정보';
			case 'vrcnsync.ip': return ({required Object ip}) => 'IP: ${ip}';
			case 'vrcnsync.port': return ({required Object port}) => '포트: ${port}';
			case 'vrcnsync.address': return ({required Object ip, required Object port}) => '${ip}:${port}';
			case 'vrcnsync.autoSave': return '수신된 사진은 \'VRCN\' 앨범에 자동 저장됩니다';
			case 'vrcnsync.usage': return '사용 방법';
			case 'vrcnsync.usageSteps.0.title': return 'PC에서 VRCNSync 앱 실행';
			case 'vrcnsync.usageSteps.0.desc': return 'PC에서 VRCNSync 앱을 실행해 주세요';
			case 'vrcnsync.usageSteps.1.title': return '동일한 WiFi 네트워크에 연결';
			case 'vrcnsync.usageSteps.1.desc': return 'PC와 모바일 기기를 동일한 WiFi 네트워크에 연결해 주세요';
			case 'vrcnsync.usageSteps.2.title': return '연결 대상으로 모바일 기기 지정';
			case 'vrcnsync.usageSteps.2.desc': return 'PC 앱에서 위의 IP 주소와 포트를 지정해 주세요';
			case 'vrcnsync.usageSteps.3.title': return '사진 전송';
			case 'vrcnsync.usageSteps.3.desc': return 'PC에서 사진을 전송하면 자동으로 VRCN 앨범에 저장됩니다';
			case 'vrcnsync.stats': return '연결 상태';
			case 'vrcnsync.statServer': return '서버 상태';
			case 'vrcnsync.statServerRunning': return '실행 중';
			case 'vrcnsync.statServerStopped': return '중지됨';
			case 'vrcnsync.statNetwork': return '네트워크';
			case 'vrcnsync.statNetworkConnected': return '연결됨';
			case 'vrcnsync.statNetworkDisconnected': return '연결 안 됨';
			case 'feedback.title': return '피드백';
			case 'feedback.type': return '피드백 유형';
			case 'feedback.types.bug': return '버그 신고';
			case 'feedback.types.feature': return '기능 요청';
			case 'feedback.types.improvement': return '개선 제안';
			case 'feedback.types.other': return '기타';
			case 'feedback.inputTitle': return '제목 *';
			case 'feedback.inputTitleHint': return '간결하게 작성해 주세요';
			case 'feedback.inputDescription': return '상세 설명 *';
			case 'feedback.inputDescriptionHint': return '자세한 설명을 작성해 주세요...';
			case 'feedback.cancel': return '취소';
			case 'feedback.send': return '전송';
			case 'feedback.sending': return '전송 중...';
			case 'feedback.required': return '제목과 상세 설명은 필수 항목입니다';
			case 'feedback.success': return '피드백을 전송했습니다. 감사합니다!';
			case 'feedback.fail': return '피드백 전송에 실패했습니다';
			case 'settings.appearance': return '화면';
			case 'settings.appIcon': return '앱 아이콘';
			case 'settings.appIconDescription': return '홈 화면에 표시되는 앱 아이콘을 변경합니다';
			case 'settings.contentSettings': return '콘텐츠 설정';
			case 'settings.searchEnabled': return '검색 기능이 활성화되었습니다';
			case 'settings.searchDisabled': return '검색 기능이 비활성화되었습니다';
			case 'settings.enableSearch': return '검색 기능 활성화';
			case 'settings.enableSearchDescription': return '검색 결과에 성적인 콘텐츠나 폭력적인 콘텐츠가 표시될 수 있습니다.';
			case 'settings.apiSetting': return '아바타 검색 API';
			case 'settings.apiSettingDescription': return '아바타 검색 기능의 API를 설정합니다';
			case 'settings.apiSettingSaveUrl': return 'URL을 저장했습니다';
			case 'settings.notSet': return '설정되지 않음 (아바타 검색 기능을 사용할 수 없습니다)';
			case 'settings.notifications': return '알림 설정';
			case 'settings.eventReminder': return '이벤트 리마인더';
			case 'settings.eventReminderDescription': return '설정한 이벤트 시작 전에 알림을 받습니다';
			case 'settings.manageReminders': return '설정된 리마인더 관리';
			case 'settings.manageRemindersDescription': return '알림 취소 및 확인이 가능합니다';
			case 'settings.dataStorage': return '데이터 및 저장 공간';
			case 'settings.clearCache': return '캐시 삭제';
			case 'settings.clearCacheSuccess': return '캐시를 삭제했습니다';
			case 'settings.clearCacheError': return '캐시 삭제 중 오류가 발생했습니다';
			case 'settings.cacheSize': return ({required Object size}) => '캐시 크기: ${size}';
			case 'settings.calculatingCache': return '캐시 크기 계산 중...';
			case 'settings.cacheError': return '캐시 크기를 가져올 수 없었습니다';
			case 'settings.confirmClearCache': return '캐시를 삭제하면 임시로 저장된 이미지나 데이터가 삭제됩니다.\n\n계정 정보나 앱 설정은 삭제되지 않습니다.';
			case 'settings.appInfo': return '앱 정보';
			case 'settings.version': return '버전';
			case 'settings.packageName': return '패키지 이름';
			case 'settings.credit': return '크레딧';
			case 'settings.creditDescription': return '개발자·기여자 정보';
			case 'settings.contact': return '문의하기';
			case 'settings.contactDescription': return '버그 신고·의견은 여기로';
			case 'settings.privacyPolicy': return '개인정보처리방침';
			case 'settings.privacyPolicyDescription': return '개인정보 취급에 대하여';
			case 'settings.termsOfService': return '이용약관';
			case 'settings.termsOfServiceDescription': return '앱 이용 조건';
			case 'settings.openSource': return '오픈소스 정보';
			case 'settings.openSourceDescription': return '사용 중인 라이브러리 등의 라이선스';
			case 'settings.github': return 'GitHub 리포지토리';
			case 'settings.githubDescription': return '소스 코드 보기';
			case 'settings.logoutConfirm': return '로그아웃하시겠습니까?';
			case 'settings.logoutError': return ({required Object error}) => '로그아웃 중 오류가 발생했습니다: ${error}';
			case 'settings.iconChangeNotSupported': return '사용 중인 기기에서는 앱 아이콘 변경을 지원하지 않습니다';
			case 'settings.iconChangeFailed': return '아이콘 변경에 실패했습니다';
			case 'settings.themeMode': return '테마 모드';
			case 'settings.themeModeDescription': return '앱의 표시 테마를 선택할 수 있습니다';
			case 'settings.themeLight': return '밝게';
			case 'settings.themeSystem': return '시스템';
			case 'settings.themeDark': return '어둡게';
			case 'settings.appIconDefault': return '기본';
			case 'settings.appIconIcon': return '아이콘';
			case 'settings.appIconLogo': return '로고';
			case 'settings.delete': return '삭제하기';
			case 'credits.title': return '크레딧';
			case 'credits.section.development': return '개발';
			case 'credits.section.iconPeople': return '재미있는 아이콘 제공자들';
			case 'credits.section.testFeedback': return '테스트·피드백';
			case 'credits.section.specialThanks': return '스페셜 땡스';
			case 'download.success': return '다운로드가 완료되었습니다';
			case 'download.failure': return ({required Object error}) => '다운로드에 실패했습니다: ${error}';
			case 'download.shareFailure': return ({required Object error}) => '공유에 실패했습니다: ${error}';
			case 'download.permissionTitle': return '권한이 필요합니다';
			case 'download.permissionDenied': return ({required Object permissionType}) => '${permissionType}에 대한 저장 권한이 거부되었습니다.\n설정 앱에서 권한을 활성화해 주세요.';
			case 'download.permissionCancel': return '취소';
			case 'download.permissionOpenSettings': return '설정 열기';
			case 'download.permissionPhoto': return '사진';
			case 'download.permissionPhotoLibrary': return '사진 라이브러리';
			case 'download.permissionStorage': return '저장 공간';
			case 'download.permissionPhotoRequired': return '사진에 대한 저장 권한이 필요합니다';
			case 'download.permissionPhotoLibraryRequired': return '사진 라이브러리에 대한 저장 권한이 필요합니다';
			case 'download.permissionStorageRequired': return '저장 공간에 대한 접근 권한이 필요합니다';
			case 'download.permissionError': return ({required Object error}) => '권한 확인 중 오류가 발생했습니다: ${error}';
			case 'download.downloading': return ({required Object fileName}) => '${fileName} 다운로드 중...';
			case 'download.sharing': return ({required Object fileName}) => '${fileName} 공유 준비 중...';
			case 'instance.type.public': return '퍼블릭';
			case 'instance.type.hidden': return '프렌드+';
			case 'instance.type.friends': return '프렌드';
			case 'instance.type.private': return '인바이트+';
			case 'instance.type.unknown': return '알 수 없음';
			case 'status.active': return '온라인';
			case 'status.joinMe': return '누구나 와요';
			case 'status.askMe': return '물어보세요';
			case 'status.busy': return '바쁨';
			case 'status.offline': return '오프라인';
			case 'status.unknown': return '상태 알 수 없음';
			case 'location.private': return '프라이빗';
			case 'location.playerCount': return ({required Object userCount, required Object capacity}) => '플레이어 수: ${userCount} / ${capacity}';
			case 'location.instanceType': return ({required Object type}) => '인스턴스 타입: ${type}';
			case 'location.noInfo': return '위치 정보가 없습니다';
			case 'location.fetchError': return '위치 정보 로딩에 실패했습니다';
			case 'location.privateLocation': return '프라이빗한 장소에 있습니다';
			case 'location.inviteSending': return '초대 보내는 중...';
			case 'location.inviteSent': return '초대를 보냈습니다. 알림에서 참여할 수 있습니다';
			case 'location.inviteFailed': return ({required Object error}) => '초대 보내기에 실패했습니다: ${error}';
			case 'location.inviteButton': return '나에게 초대 보내기';
			case 'reminder.dialogTitle': return '리마인더 설정';
			case 'reminder.alreadySet': return '설정됨';
			case 'reminder.set': return '설정하기';
			case 'reminder.cancel': return '취소';
			case 'reminder.delete': return '삭제하기';
			case 'reminder.deleteAll': return '모든 리마인더 삭제';
			case 'reminder.deleteAllConfirm': return '설정한 모든 이벤트 리마인더를 삭제합니다. 이 작업은 되돌릴 수 없습니다.';
			case 'reminder.deleted': return '리마인더를 삭제했습니다';
			case 'reminder.deletedAll': return '모든 리마인더를 삭제했습니다';
			case 'reminder.noReminders': return '설정된 리마인더가 없습니다';
			case 'reminder.setFromEvent': return '이벤트 페이지에서 알림을 설정할 수 있습니다';
			case 'reminder.eventStart': return ({required Object time}) => '${time} 시작';
			case 'reminder.notifyAt': return ({required Object time, required Object label}) => '${time} (${label})';
			case 'reminder.receiveNotification': return '언제 알림을 받으시겠습니까?';
			case 'friend.sortFilter': return '정렬·필터';
			case 'friend.filter': return '필터';
			case 'friend.filterAll': return '모두 표시';
			case 'friend.filterOnline': return '온라인만';
			case 'friend.filterOffline': return '오프라인만';
			case 'friend.filterFavorite': return '즐겨찾기만';
			case 'friend.sort': return '정렬';
			case 'friend.sortStatus': return '온라인 상태 순';
			case 'friend.sortName': return '이름 순';
			case 'friend.sortLastLogin': return '마지막 로그인 순';
			case 'friend.sortAsc': return '오름차순';
			case 'friend.sortDesc': return '내림차순';
			case 'friend.close': return '닫기';
			case 'eventCalendarFilter.filterTitle': return '이벤트 필터링';
			case 'eventCalendarFilter.clear': return '초기화';
			case 'eventCalendarFilter.keyword': return '키워드 검색';
			case 'eventCalendarFilter.keywordHint': return '이벤트 이름, 설명, 주최자 등';
			case 'eventCalendarFilter.date': return '날짜로 필터링';
			case 'eventCalendarFilter.dateHint': return '특정 날짜 범위의 이벤트를 표시할 수 있습니다';
			case 'eventCalendarFilter.startDate': return '시작일';
			case 'eventCalendarFilter.endDate': return '종료일';
			case 'eventCalendarFilter.select': return '선택해 주세요';
			case 'eventCalendarFilter.time': return '시간대로 필터링';
			case 'eventCalendarFilter.timeHint': return '특정 시간대에 개최되는 이벤트를 표시할 수 있습니다';
			case 'eventCalendarFilter.startTime': return '시작 시간';
			case 'eventCalendarFilter.endTime': return '종료 시간';
			case 'eventCalendarFilter.genre': return '장르로 필터링';
			case 'eventCalendarFilter.genreSelected': return ({required Object count}) => '${count}개의 장르 선택 중';
			case 'eventCalendarFilter.apply': return '적용하기';
			case 'eventCalendarFilter.filterSummary': return '필터';
			case 'eventCalendarFilter.filterNone': return '필터가 설정되지 않았습니다';
			default: return null;
		}
	}
}

