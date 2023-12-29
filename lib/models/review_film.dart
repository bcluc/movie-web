class ReviewFilm {
  String userId;
  String hoTen;
  String avatarUrl;
  int star;
  DateTime createAt;

  ReviewFilm({
    required this.userId,
    required this.hoTen,
    required this.avatarUrl,
    required this.star,
    required this.createAt,
  });
}
