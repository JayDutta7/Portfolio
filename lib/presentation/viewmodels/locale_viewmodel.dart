import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage {
  english('en', 'English', '🇬🇧', 'EN'),
  bengali('bn', 'বাংলা', '🇮🇳', 'বাংলা'),
  hindi('hi', 'हिंदी', '🇮🇳', 'हिंदी');

  final String code;
  final String displayName;
  final String flag;
  final String shortName;

  const AppLanguage(this.code, this.displayName, this.flag, this.shortName);
}

extension AppLanguageX on AppLanguage {
  String get navWork {
    switch (this) {
      case AppLanguage.bengali: return 'কাজ';
      case AppLanguage.hindi: return 'कार्य';
      case AppLanguage.english: return 'WORK';
    }
  }

  String get navExperience {
    switch (this) {
      case AppLanguage.bengali: return 'অভিজ্ঞতা';
      case AppLanguage.hindi: return 'अनुभव';
      case AppLanguage.english: return 'EXPERIENCE';
    }
  }

  String get navEngineering {
    switch (this) {
      case AppLanguage.bengali: return 'ইঞ্জিনিয়ারিং';
      case AppLanguage.hindi: return 'इंजीनियरिंग';
      case AppLanguage.english: return 'ENGINEERING';
    }
  }

  String get navAbout {
    switch (this) {
      case AppLanguage.bengali: return 'আমার সম্পর্কে';
      case AppLanguage.hindi: return 'পরিচয়';
      case AppLanguage.english: return 'ABOUT';
    }
  }

  String get heroBadge {
    switch (this) {
      case AppLanguage.bengali: return 'সিনিয়র মোবাইল আর্কিটেক্ট • ৯+ বছর';
      case AppLanguage.hindi: return 'सीनियर मोबाइल आर्किटेक्ट • 9+ वर्ष';
      case AppLanguage.english: return 'SENIOR MOBILE ARCHITECT • 9+ YEARS';
    }
  }

  String get heroHeadline {
    switch (this) {
      case AppLanguage.bengali: return 'মানুষ পছন্দ করে এমন\nচমৎকার মোবাইল\nঅভিজ্ঞতা তৈরি করা।';
      case AppLanguage.hindi: return 'लोगों को पसंद आने वाले\nशानदार मोबाइल\nअनुभव बनाना।';
      case AppLanguage.english: return 'Building mobile\nexperiences that\npeople love.';
    }
  }

  String get exploreWork {
    switch (this) {
      case AppLanguage.bengali: return 'আমার কাজ দেখুন';
      case AppLanguage.hindi: return 'मेरा काम देखें';
      case AppLanguage.english: return 'EXPLORE MY WORK';
    }
  }

  String get downloadCv {
    switch (this) {
      case AppLanguage.bengali: return 'সিভি ডাউনলোড করুন';
      case AppLanguage.hindi: return 'सीवी डाउनलोड करें';
      case AppLanguage.english: return 'DOWNLOAD CV';
    }
  }

  String get availableBadge {
    switch (this) {
      case AppLanguage.bengali: return '৯+ বছর • কাজ করতে ইচ্ছুক';
      case AppLanguage.hindi: return '9+ वर्ष • काम के लिए उपलब्ध';
      case AppLanguage.english: return '9+ YRS • AVAILABLE FOR PROJECTS';
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleViewModel, AppLanguage>((ref) {
  return LocaleViewModel();
});

class LocaleViewModel extends StateNotifier<AppLanguage> {
  LocaleViewModel() : super(AppLanguage.english);

  void setLanguage(AppLanguage language) {
    state = language;
  }
}
