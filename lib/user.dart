class User {
  final int? seq; // 일정 번호 (자동 생성)
  final String title; // 일정 제목
  final String contents; // 일정 내용

  User({
    this.seq,
    required this.title,
    required this.contents,
  });
 
  User.fromMap(Map<String, dynamic> res)
      : seq = res["seq"],
        title = res["title"],
        contents = res["contents"];

  Map<String, Object?> toMap() {
    return {
      'seq': seq,
      'title': title,
      'contents': contents,
    };
  }
}
