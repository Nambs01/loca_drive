import 'dart:convert';

import '../api/ApiClient.dart';
import '../models/location.dart';

class LocationService {
  static const _url = "/location";
  final ApiClient _apiClient = ApiClient();

  Future<List<Location>> getAllLocations() async {
    try {
      final response = await _apiClient.get(_url);
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Erreur lors de la récupération : $error');
    }
  }

  Future<Location> addLocation(LocationCreateDto location) async {
    try {
      final response = await _apiClient.post(_url, body: location.toJson());
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Location.fromJson(data);
    } catch (error) {
      throw Exception("Erreur lors de l'ajout : $error");
    }
  }

  Future<Location> updateLocation(int id, LocationCreateDto location) async {
    print(id.toString());
    print(location.toJson());
    try {
      final response = await _apiClient.put('$_url/$id', body: location.toJson());
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Location.fromJson(data);
    } catch (error) {
      throw Exception("Erreur lors de la modification : $error");
    }
  }

  Future<void> deleteLocation(int id) async {
    try {
      await _apiClient.delete('$_url/$id');
    } catch (error) {
      throw Exception("Erreur lors du suppression : $error");
    }
  }
}