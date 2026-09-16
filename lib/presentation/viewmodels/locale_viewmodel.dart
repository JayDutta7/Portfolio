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
  String get navHome {
    switch (this) {
      case AppLanguage.bengali: return 'হোম';
      case AppLanguage.hindi: return 'होम';
      case AppLanguage.english: return 'HOME';
    }
  }

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
      case AppLanguage.bengali:
        return 'নতুন সুযোগের জন্য উপলব্ধ ( মোবাইল আর্কিটেক্ট , মোবাইল লিড , সিনিয়র পজিশন )';
      case AppLanguage.hindi:
        return 'नए अवसरों के लिए उपलब्ध ( मोबाइल आर्किटेक्ट , मोबाइल लीड , सीनियर पद )';
      case AppLanguage.english:
        return 'Available for new opportunities ( Mobile Architect , Mobile Lead , Senior Position )';
    }
  }

  String get heroGreeting {
    switch (this) {
      case AppLanguage.bengali: return 'নমস্কার, আমি';
      case AppLanguage.hindi: return 'नमस्ते, मैं';
      case AppLanguage.english: return 'Hello, Myself';
    }
  }

  List<String> get animatedRoles {
    switch (this) {
      case AppLanguage.bengali:
      case AppLanguage.hindi:
      case AppLanguage.english:
        return const [
          'Senior android developer',
          'Flutter developer',
          'Ios publisher',
          'AI - assisted mobile developer',
        ];
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
      case AppLanguage.bengali:
        return 'নতুন সুযোগের জন্য উপলব্ধ ( মোবাইল আর্কিটেক্ট , মোবাইল লিড , সিনিয়র পজিশন )';
      case AppLanguage.hindi:
        return 'नए अवसरों के लिए उपलब्ध ( मोबाइल आर्किटेक्ट , मोबाइल लीड , सीनियर पद )';
      case AppLanguage.english:
        return 'Available for new opportunities ( Mobile Architect , Mobile Lead , Senior Position )';
    }
  }

  String get navBadge {
    switch (this) {
      case AppLanguage.bengali: return 'ইন-অফিস / রিমোট';
      case AppLanguage.hindi: return 'इन-ऑफिस / रिमोट';
      case AppLanguage.english: return 'IN-OFFICE / REMOTE';
    }
  }

  String get metricYearsExperience {
    switch (this) {
      case AppLanguage.bengali: return 'বছরের অভিজ্ঞতা';
      case AppLanguage.hindi: return 'वर्षों का अनुभव';
      case AppLanguage.english: return 'Years Experience';
    }
  }

  String get metricYearsValue {
    switch (this) {
      case AppLanguage.bengali: return '৯+';
      case AppLanguage.hindi: return '9+';
      case AppLanguage.english: return '9+';
    }
  }

  String get metricAppsShipped {
    switch (this) {
      case AppLanguage.bengali: return 'প্রোডাকশন অ্যাপস';
      case AppLanguage.hindi: return 'प्रोडक्शन ऐप्स';
      case AppLanguage.english: return 'Production Apps Shipped';
    }
  }

  String get metricAppsValue {
    switch (this) {
      case AppLanguage.bengali: return '১৫+';
      case AppLanguage.hindi: return '15+';
      case AppLanguage.english: return '15+';
    }
  }

  String get metricTotalDownloads {
    switch (this) {
      case AppLanguage.bengali: return 'মোট ডাউনলোড';
      case AppLanguage.hindi: return 'कुल डाउनलोड';
      case AppLanguage.english: return 'Total Downloads';
    }
  }

  String get metricDownloadsValue {
    switch (this) {
      case AppLanguage.bengali: return '২০K+';
      case AppLanguage.hindi: return '20K+';
      case AppLanguage.english: return '20K+';
    }
  }

  String get metricCrashFreeRates {
    switch (this) {
      case AppLanguage.bengali: return 'ক্র্যাশ-মুক্ত হার';
      case AppLanguage.hindi: return 'क्रैश-मुक्त दर';
      case AppLanguage.english: return 'Crash-Free Rates';
    }
  }

  String get metricCrashFreeValue {
    switch (this) {
      case AppLanguage.bengali: return '৯৯.৮%+';
      case AppLanguage.hindi: return '99.8%+';
      case AppLanguage.english: return '99.8%+';
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
