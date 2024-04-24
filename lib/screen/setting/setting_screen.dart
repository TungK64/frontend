import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/home/home_screen.dart';
import 'package:frontend/screen/setting/components/setting_label.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  String getLanguageName(Locale locale) {
    String languageCode = locale.languageCode;
    if (locale.countryCode != null) {
      languageCode = "${locale.languageCode} ${locale.countryCode}";
    }
    String? languageName = LANGUAGE_NAMES[languageCode];

    return languageName ?? languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 15, right: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    },
                    child: const Icon(Icons.close),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                child: ListView(
                  children: [
                    ListTile(
                      title: Container(
                        constraints: const BoxConstraints(maxHeight: 60),
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 208, 229, 245),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/translate.svg",
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('language'.tr(),
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis),
                            const Spacer(),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<Locale>(
                                // value: EasyLocalization.of(context)!.locale,
                                onChanged: (value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'selectedLocale', value.toString());
                                  // EasyLocalization.of(context)!
                                  //     .setLocale(value!);
                                },
                                borderRadius: BorderRadius.circular(15),
                                dropdownColor: Colors.white70,
                                menuMaxHeight: 400,
                                items: SUPPORT_LANGUAGES
                                    .map<DropdownMenuItem<Locale>>(
                                  (Locale value) {
                                    return DropdownMenuItem<Locale>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          value.countryCode != null
                                              ? Image.asset(
                                                  'assets/flags/${value.countryCode}.png',
                                                  width: 24,
                                                  height: 24,
                                                )
                                              : Image.asset(
                                                  'assets/flags/${value.languageCode}.png',
                                                  width: 24,
                                                  height: 24,
                                                  // You may need to adjust width and height according to your flag images
                                                ),
                                          const SizedBox(width: 10),
                                          Text(
                                            getLanguageName(value),
                                            textAlign: TextAlign.end,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingLabel("assets/svg/email.svg", 'support'.tr(),
                        () async {
                      final Uri _url = Uri.parse(
                          'mailto:appstore@vnpublisher.com?subject=PDF Scanner support the issue');
                      if (!await launchUrl(
                        _url,
                        mode: LaunchMode.platformDefault,
                      )) {
                        throw Exception('Could not launch $_url');
                      }
                    }),
                    SettingLabel("assets/svg/supports.svg", 'Terms_of_use'.tr(),
                        () async {
                      final Uri _url = Uri.parse(
                          'https://vnpublisher.com/privacy-policy.html');
                      if (!await launchUrl(
                        _url,
                        mode: LaunchMode.inAppWebView,
                        webViewConfiguration:
                            const WebViewConfiguration(enableJavaScript: false),
                      )) {
                        throw Exception('Could not launch $_url');
                      }
                    }),
                    SettingLabel("assets/svg/privacy.svg", 'policy'.tr(),
                        () async {
                      final Uri _url = Uri.parse(
                          'https://vnpublisher.com/privacy-policy.html');
                      if (!await launchUrl(
                        _url,
                        mode: LaunchMode.inAppWebView,
                        webViewConfiguration:
                            const WebViewConfiguration(enableJavaScript: true),
                      )) {
                        throw Exception('Could not launch $_url');
                      }
                    }),
                    SettingLabel("assets/svg/star.svg", 'rate_us'.tr(),
                        () async {
                      String url = Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=com.flabs.pdf.scanner'
                          : '';
                      final Uri _url = Uri.parse(url);
                      if (!await launchUrl(
                        _url,
                        mode: LaunchMode.inAppWebView,
                        webViewConfiguration:
                            const WebViewConfiguration(enableJavaScript: true),
                      )) {
                        throw Exception('Could not launch $_url');
                      }
                    }),
                    SettingLabel("assets/svg/share.svg", 'share_app'.tr(),
                        () async {
                      String url = Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=com.flabs.pdf.scanner'
                          : '';
                      Share.share(url);
                    }),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
