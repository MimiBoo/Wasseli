class Language {
  final int id;
  final String name, flag, languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇺🇸', 'en'),
      Language(2, 'عربية', '🇸🇦', 'ar'),
    ];
  }
}
