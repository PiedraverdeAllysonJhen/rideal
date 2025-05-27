class Vehicle {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final double distance;
  final String imageUrl;
  final String category;
  bool isBookmarked; // Add this

  Vehicle({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.imageUrl,
    required this.category,
    this.isBookmarked = false,
  });
}
