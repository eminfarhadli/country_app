import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class LanguageCubit extends Cubit<Locale> {
  final _box = GetStorage();

  LanguageCubit() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    String? langCode = _box.read('lang_code');
    if (langCode != null) {
      emit(Locale(langCode));
    }
  }

  void changeLanguage(String langCode) {
    _box.write('lang_code', langCode);
    emit(Locale(langCode));
  }
}
