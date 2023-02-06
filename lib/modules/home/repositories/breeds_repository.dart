import 'package:get/get_connect.dart';

class BreedsRepository extends GetConnect{

  Future<Map<String, dynamic>> getAllBreeds() async {
    var response = await get('https://dog.ceo/api/breeds/list/all');
    if(response.isOk)
      return response.body['message'];
    else
      throw Exception("It was not possible to bring the breed list.");
  }

  Future<String> getRandonImageByBreed(String breed) async {
    var response = await get("https://dog.ceo/api/breed/$breed/images/random");
    if(response.isOk)
      return response.body['message'];
    else
      throw Exception("It was not possible to bring the image.");
  }
}