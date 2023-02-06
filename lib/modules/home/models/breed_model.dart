class BreedModel {
  
  late String breed;
  late bool isFavorite;
  List<String>? imageUrls;

  BreedModel({this.breed = "", this.isFavorite = false, this.imageUrls});

  BreedModel.fromJson(Map<String, dynamic> json) {
    breed = json['breed'];
    isFavorite = json['isFavorite'];
    imageUrls = json['imageUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['breed'] = this.breed;
    data['isFavorite'] = this.isFavorite;
    data['imageUrls'] = this.imageUrls;
    return data;
  }
}