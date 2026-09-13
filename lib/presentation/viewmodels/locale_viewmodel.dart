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
      case AppLanguage.bengali: return 'সিনিয়র মোবাইল ডেভেলপার\nAndroid • Kotlin • Flutter';
      case AppLanguage.hindi: return 'सीनियर मोबाइल डेवलपर\nAndroid • Kotlin • Flutter';
      case AppLanguage.english: return 'Senior Mobile Developer\nAndroid • Kotlin • Flutter';
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
      case AppLanguage.bengali: return 'রিজিউম ডাউনলোড';
      case AppLanguage.hindi: return 'रिज्यूमे डाउनलोड';
      case AppLanguage.english: return 'DOWNLOAD RESUME';
    }
  }

  String get availableBadge {
    switch (this) {
      case AppLanguage.bengali: return 'নতুন সুযোগের সন্ধান • ইন-অফিস বা রিমোট উপলব্ধ';
      case AppLanguage.hindi: return 'नए अवसर की तलाश • इन-ऑफिस या रिमोट में उपलब्ध';
      case AppLanguage.english: return 'Looking for new opportunity available in in-office or remote';
    }
  }

  String get navBadge {
    switch (this) {
      case AppLanguage.bengali: return 'ইন-অফিস / রিমোট';
      case AppLanguage.hindi: return 'इन-ऑफिस / रिमोट';
      case AppLanguage.english: return 'IN-OFFICE / REMOTE';
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
