extension ArticleContentCleaner on String {
  /// يزيل لاحقة "[+XXXX chars]" التي تضيفها NewsAPI في الخطة المجانية
  /// ويستبدلها بثلاث نقاط
  String cleanTruncatedContent() {
    final regex = RegExp(r'\[\+\d+ chars\]\s*$');
    if (regex.hasMatch(this)) {
      return '${replaceFirst(regex, '').trim()} . . .';
    }
    return this;
  }
}