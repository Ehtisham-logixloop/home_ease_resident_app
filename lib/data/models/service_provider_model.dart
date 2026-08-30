class ServiceProvider {
  final String id;
  final String name;
  final String profession;
  final double rating;
  final int pricePerHour;
  final String image;
  final String description;
  final int yearsOfExperience;
  final List<String> servicesOffered;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.profession,
    required this.rating,
    required this.pricePerHour,
    required this.image,
    required this.description,
    required this.yearsOfExperience,
    required this.servicesOffered,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: (json['user_id'] ?? json['provider_id'] ?? json['id'] ?? '').toString(),

      name: json['name'] ?? '',

      profession: json['service_category'] ?? json['profession'] ?? '',

      rating: double.tryParse(
        json['rating']?.toString() ?? '0',
      ) ??
          0.0,

      pricePerHour: int.tryParse(
        json['price_per_hour']?.toString() ??
            json['pricePerHour']?.toString() ??
            '0',
      ) ??
          0,

      image: json['profile_picture'] ??
          'assets/images/user.png',

      description: json['description'] ?? '',

      yearsOfExperience: int.tryParse(
        json['years_of_experience']?.toString() ??
            json['yearsOfExperience']?.toString() ??
            '0',
      ) ??
          0,

      servicesOffered:
      json['services_offered'] != null
          ? List<String>.from(
        json['services_offered'],
      )
          : [],
    );
  }
}