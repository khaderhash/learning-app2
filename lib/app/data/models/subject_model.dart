class Subject {
  final int id;
  final String title;
  final String imageUrl;
  final String price;

  Subject({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      title: json['title'],
      imageUrl: 'https://picsum.photos/200/300?random=${json['id']}',
      price: json['price'].toString(),
    );
  }
}
