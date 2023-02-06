import 'package:get/get.dart';

class BreedRepository extends GetConnect{

  Future<List<String>> getImagesByBreed(String breed) async {
    var response = await get("https://dog.ceo/api/breed/$breed/images");
    if(response.isOk){
      return response.body['message'].cast<String>();
    }else
      throw Exception("It was not possible to bring the images.");
  }
}