import 'package:flutter/material.dart';

const String ROLE = 'role';
const String USER_NUMBER = 'user_number';
const String PROJECT_ID = 'project_id';
const String TOPIC_ID = 'topic_id';
const String STUDENT_NUMBER = 'student_number';

const String HOST = 'http://172.18.192.1:8080/api/v1/';

const SUPPORT_LANGUAGES = [
  Locale('en', 'US'),
  Locale('es', 'ES'),
  Locale('id'),
  Locale('ms'),
  Locale('th'),
  Locale('vi'),
  Locale('it', 'IT'),
  Locale('ja', 'JP'),
  Locale('ko', 'KR'),
  Locale('pt', 'PT'),
  Locale('ru', 'RU'),
  Locale('tr', 'TR'),
  Locale('zh', 'CN'),
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
