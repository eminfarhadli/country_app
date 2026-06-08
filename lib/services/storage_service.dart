import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();
  static const String _favoritesKey = 'favorites_cca3';

  List<String> getFavorites() {
    final List<dynamic> stored = _box.read(_favoritesKey) ?? [];
    return stored.cast<String>();
  }

  Future<void> toggleFavorite(String cca3) async {
    final List<String> currentFavs = getFavorites();
    if (currentFavs.contains(cca3)) {
      currentFavs.remove(cca3);
    } else {
      currentFavs.add(cca3);
    }
    await _box.write(_favoritesKey, currentFavs);
  }
}
