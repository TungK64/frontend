import 'package:flutter/material.dart';

const String ROLE = 'role';
const String USER_NUMBER = 'user_number';
const String PROJECT_ID = 'project_id';

const String HOST = 'http://192.168.98.179:8080/api/v1/';

const SUPPORT_LANGUAGES = [
  Locale('en', 'US'),
  Locale('es', 'ES'),
  Locale('es', 'US'),
  Locale('id'),
  Locale('ms'),
  Locale('th'),
  Locale('vi'),
  Locale('it', 'IT'),
  Locale('ja', 'JP'),
  Locale('ko', 'KR'),
  Locale('pt', 'BR'),
  Locale('pt', 'PT'),
  Locale('ru', 'RU'),
  Locale('tr', 'TR'),
  Locale('zh', 'CN'),
  Locale('zh', 'HK'),
  Locale('zh', 'TW')
];

const Map<String, String> LANGUAGE_NAMES = {
  'en US': 'English',
  'es ES': 'Spanish',
  'es US': 'Spanish(US)',
  'pt BR': 'Portuguese(BR)',
  'id': 'Indonesian',
  'ms': 'Malay',
  'th': 'Thai',
  'vi': 'Vietnamese',
  'it IT': 'Italian',
  'ja JP': 'Japanese',
  'ko KR': 'Korean',
  'pt PT': 'Portuguese',
  'ru RU': 'Russian',
  'tr TR': 'Turkish',
  'zh CN': 'Chinese',
  'zh HK': 'Chinese(HK)',
  'zh TW': 'Chinese(TW)'
};
