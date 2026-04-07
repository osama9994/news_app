import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';

class AppStrings {
  AppStrings(this.language);

  final AppLanguage language;

  static AppStrings of(BuildContext context) {
    return AppStrings(context.read<LanguageCubit>().state.language);
  }

  bool get isArabic => language == AppLanguage.arabic;

  String get localeCode => language.code;

  String text(String key) {
    return _localizedValues[language]![key] ?? key;
  }

  String category(String key) {
    return _categoryValues[language]![key.toLowerCase()] ?? key;
  }

  String languageName(AppLanguage appLanguage) {
    return _languageNames[language]![appLanguage]!;
  }

  String categoryNewsTitle(String categoryKey) {
    return isArabic
        ? '${text('news')} ${category(categoryKey)}'
        : '${category(categoryKey)} ${text('news')}';
  }

  String topicCount(int count) {
    if (isArabic) {
      return count == 1 ? 'تم اختيار موضوع واحد' : 'تم اختيار $count مواضيع';
    }
    return count == 1 ? '1 topic selected' : '$count topics selected';
  }

  String articleStateLabel(bool isBreaking) {
    return isBreaking ? text('breaking') : text('trending');
  }

  String fieldRequired(String label) {
    return isArabic ? 'حقل $label مطلوب' : '$label cannot be empty!';
  }

  static const Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.english: {
      'appName': 'News App',
      'home': 'Home',
      'favorites': 'Favorites',
      'noFavoritesYet': 'No favorites yet!',
      'categories': 'Categories',
      'myInterests': 'My Interests',
      'profile': 'Profile',
      'logOut': 'Log Out',
      'notifications': 'Notifications',
      'noNotificationsYet': 'No notifications yet',
      'deleteNotification': 'Delete notification',
      'noTitle': 'No title',
      'loginAccount': 'Login Account',
      'loginPrompt': 'Please, login with registered account!',
      'email': 'Email',
      'password': 'Password',
      'enterYourEmail': 'Enter your email',
      'enterYourPassword': 'Enter your password',
      'forgotPassword': 'Forgot Password',
      'login': 'Login',
      'noAccountRegister': 'Don\'t have an account? Register',
      'otherMethod': 'Or using other method',
      'loginWithGoogle': 'Login with Google',
      'createAccount': 'Create Account',
      'createAccountPrompt':
          'Make your knowledge better by creating your account',
      'alreadyHaveAccount': 'Already have an account? Login',
      'orSignUpUsing': 'Or sign up using',
      'signUpWithGoogle': 'Sign up with Google',
      'resetPassword': 'Reset Password',
      'sendResetLink': 'Send Reset Link',
      'resetLinkSent': 'Reset link sent to your email',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm Password',
      'enterCurrentPassword': 'Enter current password',
      'enterNewPassword': 'Enter new password',
      'confirmNewPassword': 'Confirm new password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'editInterests': 'Edit Interests',
      'updateYourInterests': 'Update your interests',
      'chooseTopicsFollow': 'Choose the topics you want to follow.',
      'interestsUpdatedSuccess': 'Interests updated successfully!',
      'saveChanges': 'Save Changes',
      'whatInterestsYouMost': 'What interests\nyou the most?',
      'onboardingPrompt':
          'Pick your favorite topics, and we\'ll send you personalized news and notifications.',
      'getStarted': 'Get Started',
      'skipForNow': 'Skip for now',
      'search': 'Search',
      'pleaseEnterSearchTerm': 'Please enter a search term',
      'searchForNews': 'Search for news...',
      'filterByCategory': 'Filter by category',
      'noArticlesFound': 'No articles found',
      'retrySearch': 'Retry Search',
      'goToOfflineFavorites': 'Go to Offline Favorites',
      'searchAnyNewsTopic': 'Search for any news topic',
      'news': 'News',
      'breakingNews': 'Breaking News',
      'recommendation': 'Recommendation',
      'recommendationNews': 'Recommendation News',
      'noBreakingNewsAvailable': 'No breaking news available',
      'noRecommendationsAvailable': 'No recommendations available',
      'noNewsForCategory': 'There is no news for this category',
      'noNewsForTopic': 'No news available for this topic.',
      'retry': 'Retry',
      'offlineTitle': 'You are offline!',
      'offlineSubtitle': 'Check your connection or try again.',
      'goToFavorites': 'Go to Favorites',
      'shareArticle': 'Share Article',
      'translateToArabic': 'Translate to Arabic',
      'translating': 'Translating...',
      'translatedToArabic': 'Translated to Arabic',
      'readMore': 'Read more',
      'noArticleLinkAvailable': 'No article link available.',
      'couldNotOpenArticleLink': 'Couldn\'t open the article link.',
      'general': 'General',
      'breaking': 'Breaking',
      'trending': 'Trending',
      'noUserLoggedIn': 'No user logged in',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'editLanguage': 'Language: {language}',
      'emptyInterestsTitle': 'No interests selected yet!',
      'emptyInterestsSubtitle':
          'Go to your profile and choose\nyour favorite topics.',
      'noCategoryData': 'No category data provided',
      'noArticleData': 'No article data provided',
      'noRouteDefined': 'No route defined for {route}',
      'all': 'All',
    },
    AppLanguage.arabic: {
      'appName': 'تطبيق الأخبار',
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'noFavoritesYet': 'لا توجد عناصر في المفضلة بعد',
      'categories': 'التصنيفات',
      'myInterests': 'اهتماماتي',
      'profile': 'الملف الشخصي',
      'logOut': 'تسجيل الخروج',
      'notifications': 'الإشعارات',
      'noNotificationsYet': 'لا توجد إشعارات حتى الآن',
      'deleteNotification': 'حذف الإشعار',
      'noTitle': 'بدون عنوان',
      'loginAccount': 'تسجيل الدخول',
      'loginPrompt': 'يرجى تسجيل الدخول باستخدام حسابك المسجل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'enterYourEmail': 'أدخل بريدك الإلكتروني',
      'enterYourPassword': 'أدخل كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور',
      'login': 'تسجيل الدخول',
      'noAccountRegister': 'ليس لديك حساب؟ أنشئ حسابًا',
      'otherMethod': 'أو استخدم طريقة أخرى',
      'loginWithGoogle': 'تسجيل الدخول عبر Google',
      'createAccount': 'إنشاء حساب',
      'createAccountPrompt': 'طوّر تجربتك الإخبارية عبر إنشاء حسابك',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ سجّل الدخول',
      'orSignUpUsing': 'أو أنشئ حسابًا باستخدام',
      'signUpWithGoogle': 'إنشاء حساب عبر Google',
      'resetPassword': 'إعادة تعيين كلمة المرور',
      'sendResetLink': 'إرسال رابط إعادة التعيين',
      'resetLinkSent': 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
      'changePassword': 'تغيير كلمة المرور',
      'currentPassword': 'كلمة المرور الحالية',
      'newPassword': 'كلمة المرور الجديدة',
      'confirmPassword': 'تأكيد كلمة المرور',
      'enterCurrentPassword': 'أدخل كلمة المرور الحالية',
      'enterNewPassword': 'أدخل كلمة المرور الجديدة',
      'confirmNewPassword': 'أكد كلمة المرور الجديدة',
      'passwordsDoNotMatch': 'كلمتا المرور غير متطابقتين',
      'editInterests': 'تعديل الاهتمامات',
      'updateYourInterests': 'حدّث اهتماماتك',
      'chooseTopicsFollow': 'اختر المواضيع التي تريد متابعتها.',
      'interestsUpdatedSuccess': 'تم تحديث الاهتمامات بنجاح',
      'saveChanges': 'حفظ التغييرات',
      'whatInterestsYouMost': 'ما أكثر ما\nيثير اهتمامك؟',
      'onboardingPrompt':
          'اختر مواضيعك المفضلة وسنرسل لك أخبارًا وإشعارات مخصصة.',
      'getStarted': 'ابدأ الآن',
      'skipForNow': 'تخطي الآن',
      'search': 'بحث',
      'pleaseEnterSearchTerm': 'يرجى إدخال كلمة للبحث',
      'searchForNews': 'ابحث عن الأخبار...',
      'filterByCategory': 'تصفية حسب التصنيف',
      'noArticlesFound': 'لم يتم العثور على مقالات',
      'retrySearch': 'إعادة البحث',
      'goToOfflineFavorites': 'الانتقال إلى المفضلة المحفوظة',
      'searchAnyNewsTopic': 'ابحث عن أي موضوع إخباري',
      'news': 'أخبار',
      'breakingNews': 'أخبار عاجلة',
      'recommendation': 'مقترحات',
      'recommendationNews': 'الأخبار المقترحة',
      'noBreakingNewsAvailable': 'لا توجد أخبار عاجلة متاحة',
      'noRecommendationsAvailable': 'لا توجد مقترحات متاحة',
      'noNewsForCategory': 'لا توجد أخبار لهذا التصنيف',
      'noNewsForTopic': 'لا توجد أخبار متاحة لهذا الموضوع.',
      'retry': 'إعادة المحاولة',
      'offlineTitle': 'أنت غير متصل بالإنترنت',
      'offlineSubtitle': 'تحقق من الاتصال أو حاول مرة أخرى.',
      'goToFavorites': 'الانتقال إلى المفضلة',
      'shareArticle': 'مشاركة المقال',
      'translateToArabic': 'ترجم إلى العربية',
      'translating': 'جارٍ الترجمة...',
      'translatedToArabic': 'تمت الترجمة إلى العربية',
      'readMore': 'قراءة المزيد',
      'noArticleLinkAvailable': 'لا يتوفر رابط لهذا المقال.',
      'couldNotOpenArticleLink': 'تعذر فتح رابط المقال.',
      'general': 'عام',
      'breaking': 'عاجل',
      'trending': 'رائج',
      'noUserLoggedIn': 'لا يوجد مستخدم مسجل الدخول',
      'lightMode': 'الوضع الفاتح',
      'darkMode': 'الوضع الداكن',
      'language': 'اللغة',
      'editLanguage': 'اللغة: {language}',
      'emptyInterestsTitle': 'لم يتم اختيار أي اهتمامات بعد',
      'emptyInterestsSubtitle':
          'اذهب إلى ملفك الشخصي واختر\nالمواضيع المفضلة لديك.',
      'noCategoryData': 'لم يتم تمرير بيانات التصنيف',
      'noArticleData': 'لم يتم تمرير بيانات المقال',
      'noRouteDefined': 'لا يوجد مسار معرف لـ {route}',
      'all': 'الكل',
    },
  };

  static const Map<AppLanguage, Map<String, String>> _categoryValues = {
    AppLanguage.english: {
      'all': 'All',
      'business': 'Business',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'science': 'Science',
      'sports': 'Sports',
      'technology': 'Technology',
      'politics': 'Politics',
      'general': 'General',
    },
    AppLanguage.arabic: {
      'all': 'الكل',
      'business': 'الأعمال',
      'entertainment': 'الترفيه',
      'health': 'الصحة',
      'science': 'العلوم',
      'sports': 'الرياضة',
      'technology': 'التكنولوجيا',
      'politics': 'السياسة',
      'general': 'عام',
    },
  };

  static const Map<AppLanguage, Map<AppLanguage, String>> _languageNames = {
    AppLanguage.english: {
      AppLanguage.english: 'English',
      AppLanguage.arabic: 'Arabic',
    },
    AppLanguage.arabic: {
      AppLanguage.english: 'الإنجليزية',
      AppLanguage.arabic: 'العربية',
    },
  };
}

extension AppStringsX on BuildContext {
  AppStrings get tr => AppStrings.of(this);
}
