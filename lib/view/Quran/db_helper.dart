import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/Ayah.dart';
import '../../model/Surah.dart';
import '../../model/SurahDetail.dart';
import '../../model/Word.dart';


class DatabaseHelper {
  Future<List<SurahModal>> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran.db');

    final exist = await databaseExists(path);

    if (exist) {
      print('db already exists');
      await openDatabase(path);
    } else {
      print('creating a copy from assets');

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', 'quran.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print('db copied');
    }
    var QuranDataTable = await openDatabase(path, readOnly: true);

    List<Map<String, dynamic>> x = await QuranDataTable.rawQuery(
        'SELECT * FROM surah_info ORDER BY id ASC');

    List<SurahModal> list = <SurahModal>[];
    x.forEach((element) {
      list.add(new SurahModal(
          element['id'],
          element['surrah_name'],
          element['surrah_name_ar'],
          element['surrah_name_en'],
          element['length']));
    });

    // print(x[113]['surrah_name_ar']);

    return list;
  }

  Future<List<AyahModal>> SurahDb(var surah_id) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran.db');

    final exist = await databaseExists(path);

    if (exist) {
      print('db already exists');
      await openDatabase(path);
    } else {
      print('creating a copy from assets');

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', 'quran.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print('db copied');
    }
    var QuranDataTable = await openDatabase(path, readOnly: true);

    List<Map<String, dynamic>> x = await QuranDataTable.rawQuery(
        'SELECT data FROM surah where id = ' + surah_id);

    List<SurahDetailModal> list = <SurahDetailModal>[];
    x.forEach((element) {
      list.add(new SurahDetailModal(
          jsonDecode(element['data'])['surrah_name'],
          jsonDecode(element['data'])['surrah_name_ar'],
          jsonDecode(element['data'])['surrah_name_en'],
          ayah_list(jsonDecode(element['data'])['surah_data'])));
      print(jsonDecode(element['data'])['surrah_name']);
    });

    // x.forEach((element) {
    //   // print(jsonDecode(element['data'])['surah_data'][0]['ayat_words'][0]);
    //   print(jsonDecode(element['data'])['surah_data'][0]['ayat_words'][0]);
    // });

    // print(list[0].list);

    return list[0].list;
  }

  List<AyahModal> ayah_list(var x) {
    int len = x.length;
    List<AyahModal> list = <AyahModal>[];
    for (int i = 0; i < len; i++) {
      list.add(new AyahModal(x[i]['urdu_translation1'],
          x[i]['urdu_translation2'], word_list(x[i]['ayat_words'])));
    }

    return list;
  }

  List<WordModal> word_list(var x) {
    int len = x.length;
    List<WordModal> list = <WordModal>[];
    for (int i = 0; i < len; i++) {
      list.add(new WordModal(
          x[i]['arabic_word'], x[i]['english_word'], x[i]['urdu_meaning']));
    }

    return list;
  }
}
