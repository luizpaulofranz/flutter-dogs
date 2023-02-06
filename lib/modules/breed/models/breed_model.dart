class BreedModel {
  String? imagePath;
  String breed;
  bool isFavorite;

  BreedModel({required this.breed, this.isFavorite = false, this.imagePath});
}