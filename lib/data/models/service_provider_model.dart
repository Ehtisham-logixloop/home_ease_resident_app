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
}
