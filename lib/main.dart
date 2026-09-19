import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IslamPrayerApp());
}

class IslamPrayerApp extends StatefulWidget {
  const IslamPrayerApp({super.key});

  @override
  State<IslamPrayerApp> createState() => _IslamPrayerAppState();
}

class _IslamPrayerAppState extends State<IslamPrayerApp> {
  String _currentLang = 'ru';
  bool _isFirstLaunch = true;
  String _currentBg = 'https://images.unsplash.com/photo-1564769625405-afc0465b7cff'; 
  String _notificationMode = 'azan'; 
  String _azanVoice = 'makkah';

  final Map<String, int> _qadaCounters = {
    'fajr': 0, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0
  };

  void _changeLanguage(String lang) {
    setState(() {
      _currentLang = lang;
      _isFirstLaunch = false;
    });
  }

  void _changeBackground(String bgUrl) {
    setState(() {
      _currentBg = bgUrl;
    });
  }

  void _changeNotificationMode(String mode) {
    setState(() {
      _notificationMode = mode;
    });
  }

  void _changeAzanVoice(String voice) {
    setState(() {
      _azanVoice = voice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naseeb Taqvim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: _isFirstLaunch
          ? LanguageSelectionScreen(onLangSelected: _changeLanguage)
          : MainNavigationScreen(
              currentLang: _currentLang,
              currentBg: _currentBg,
              notificationMode: _notificationMode,
              azanVoice: _azanVoice,
              qadaCounters: _qadaCounters,
              onBgChanged: _changeBackground,
              onLangChanged: _changeLanguage,
              onModeChanged: _changeNotificationMode,
              onVoiceChanged: _changeAzanVoice,
            ),
    );
  }
}

Map<String, Map<String, String>> _localizedValues = {
  'ru': {
    'prayer': 'Намаз', 'tasbih': 'Тасбих', 'qibla': 'Кибла', 'settings': 'Настройки',
    'left': 'ДО НАЧАЛА ОСТАЛОСЬ:', 'next': 'Следующий', 'rounds': 'Круги',
    'bg_settings': 'ВЫБОР ФОНА ПРИЛОЖЕНИЯ', 'lang_settings': 'ЯЗЫК ИНТЕРФЕЙСА', 
    'makkah': 'Мекка', 'madinah': 'Медина', 'sound_settings': 'РЕЖИМ ОПОВЕЩЕНИЯ НАМАЗА',
    'mode_azan': '🕌 Включить Азан', 'mode_click': '🔔 Звук Тлик-Тлик', 'mode_vibrate': '📳 Только Вибрация',
    'gps_loading': 'Определение геопозиции по GPS...', 'qada_title': 'Учет пропущенных намазов (Када)',
    'ayah_title': '📖 АЯТ ДНЯ', 'voice_title': '🎤 ГОЛОС МУЭДЗИНА (АЗАН)',
    'voice_makkah': 'Мекка (Масджид аль-Харам)', 'voice_madinah': 'Медина (Ан-Набави)', 'voice_aqsa': 'Иерусалим (Аль-Акса)'
  },
  'uz': {
    'prayer': 'Namozi', 'tasbih': 'Tasbeh', 'qibla': 'Qibla', 'settings': 'Sozlamalar',
    'left': 'BOSHLANISHIGA QOLDI:', 'next': 'Keyingi', 'rounds': 'Aylanishlar',
    'bg_settings': 'FON RASMINI TANLASH', 'lang_settings': 'TIZIM TILI', 
    'makkah': 'Makka', 'madinah': 'Madina', 'sound_settings': 'NAMOZ BILDIRISHNOMALARI',
    'mode_azan': '🕌 Azonni yoqish', 'mode_click': '🔔 Tlik-Tlik ovozi', 'mode_vibrate': '📳 Faqat tebranish (Vibro)',
    'gps_loading': 'GPS orqali joylashuv aniqlanmoqda...', 'qada_title': 'Qazo namozlari hisobi (Qada)',
    'ayah_title': '📖 KUN OYATI', 'voice_title': '🎤 MUAZZIN OVOZI (AZON)',
    'voice_makkah': 'Makka (Masjid al-Haram)', 'voice_madinah': 'Madina (An-Nabavi)', 'voice_aqsa': 'Quddus (Al-Aksa)'
  },
  'en': {
    'prayer': 'Prayer', 'tasbih': 'Tasbih', 'qibla': 'Qibla', 'settings': 'Settings',
    'left': 'TIME REMAINING:', 'next': 'Next', 'rounds': 'Rounds',
    'bg_settings': 'BACKGROUND PICTURE', 'lang_settings': 'LANGUAGE', 
    'makkah': 'Makkah', 'madinah': 'Madinah', 'sound_settings': 'PRAYER ALERT MODE',
    'mode_azan': '🕌 Enable Full Azan', 'mode_click': '🔔 Click-Click Sound', 'mode_vibrate': '📳 Vibration Only',
    'gps_loading': 'Detecting GPS location...', 'qada_title': 'Missed Prayers Counter (Qada)',
    'ayah_title': '📖 AYAH OF THE DAY', 'voice_title': '🎤 MUEZZIN VOICE (AZAN)',
    'voice_makkah': 'Makkah (Al-Haram)', 'voice_madinah': 'Madinah (An-Nabawi)', 'voice_aqsa': 'Jerusalem (Al-Aqsa)'
  }
};

Widget buildGlassContainer({required Widget child, double borderRadius = 20, double blur = 15}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        ),
        child: child,
      ),
    ),
  );
}

class LanguageSelectionScreen extends StatelessWidget {
  final Function(String) onLangSelected;
  const LanguageSelectionScreen({super.key, required this.onLangSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1564769625405-afc0465b7cff'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: buildGlassContainer(
                borderRadius: 28,
                blur: 20,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Naseeb Taqvim', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      const Text('Выберите язык / Tilni tanlang\nSelect Language', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 13)),
                      const SizedBox(height: 24),
                      _buildLangBtn('Oʻzbekcha', '🇺🇿', () => onLangSelected('uz')),
                      const SizedBox(height: 12),
                      _buildLangBtn('Русский', '🇷🇺', () => onLangSelected('ru')),
                      const SizedBox(height: 12),
                      _buildLangBtn('English', '🇬🇧', () => onLangSelected('en')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String text, String flag, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.12),
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(flag, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final String currentLang;
  final String currentBg;
  final String notificationMode;
  final String azanVoice;
  final Map<String, int> qadaCounters;
  final Function(String) onBgChanged;
  final Function(String) onLangChanged;
  final Function(String) onModeChanged;
  final Function(String) onVoiceChanged;

  const MainNavigationScreen({
    super.key,
    required this.currentLang,
    required this.currentBg,
    required this.notificationMode,
    required this.azanVoice,
    required this.qadaCounters,
    required this.onBgChanged,
    required this.onLangChanged,
    required this.onModeChanged,
    required this.onVoiceChanged,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      PrayerHomeScreen(currentLang: widget.currentLang, notificationMode: widget.notificationMode),
      TasbihScreen(currentLang: widget.currentLang, qadaCounters: widget.qadaCounters),
      const QiblaScreen(),
      SettingsScreen(
        currentLang: widget.currentLang,
        currentBg: widget.currentBg,
        notificationMode: widget.notificationMode,
        azanVoice: widget.azanVoice,
        onBgChanged: widget.onBgChanged,
        onLangChanged: widget.onLangChanged,
        onModeChanged: widget.onModeChanged,
        onVoiceChanged: widget.onVoiceChanged,
      ),
    ];

    String t(String key) => _localizedValues[widget.currentLang]?[key] ?? key;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(widget.currentBg), fit: BoxFit.cover),
            ),
          ),
          Container(color: const Color(0xFF03140C).withOpacity(0.60)), 
          SafeArea(child: screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white.withOpacity(0.04),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white30,
            elevation: 0,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.access_time), label: t('prayer')),
              BottomNavigationBarItem(icon: const Icon(Icons.fingerprint), label: t('tasbih')),
              BottomNavigationBarItem(icon: const Icon(Icons.explore), label: t('qibla')),
              BottomNavigationBarItem(icon: const Icon(Icons.settings), label: t('settings')),
            ],
          ),
        ),
      ),
    );
  }
}

class SimplePrayerCalculator {
  static List<Map<String, dynamic>> calculateTimes(double lat, double lng) {
    final double localShift = (lng - 69.24) * 4;
    int fajrMin = (4 * 60 + 50 + localShift).round();
    int sunriseMin = (6 * 60 + 07 + localShift).round();
    int dhuhrMin = (12 * 60 + 17 + localShift).round();
    int asrMin = (16 * 60 + 37 + localShift).round();
    int maghribMin = (18 * 60 + 31 + localShift).round();
    int ishaMin = (19 * 60 + 43 + localShift).round();
    
    String format(int totalMinutes) {
      int h = (totalMinutes ~/ 60) % 24;
      int m = totalMinutes % 60;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
    }
    
    return [
      {'id': 'fajr', 'name': 'Фаджр', 'time': format(fajrMin), 'enabled': true},
      {'id': 'sunrise', 'name': 'Восход', 'time': format(sunriseMin), 'enabled': false},
      {'id': 'dhuhr', 'name': 'Зухр', 'time': format(dhuhrMin), 'enabled': true},
      {'id': 'asr', 'name': 'Аср', 'time': format(asrMin), 'enabled': true},
      {'id': 'maghrib', 'name': 'Магриб', 'time': format(maghribMin), 'enabled': true},
      {'id': 'isha', 'name': 'Иша', 'time': format(ishaMin), 'enabled': true},
    ];
  }
}

class PrayerHomeScreen extends StatefulWidget {
  final String currentLang;
  final String notificationMode;
  const PrayerHomeScreen({super.key, required this.currentLang, required this.notificationMode});

  @override
  State<PrayerHomeScreen> createState() => _PrayerHomeScreenState();
}

class _PrayerHomeScreenState extends State<PrayerHomeScreen> {
  late Timer _timer;
  String _timeString = "00:00";
  String _countdownString = "00:00:00";
  String _nextPrayerName = "";
  String _hijriDate = "27 Rabi' al-Awwal 1448";
  bool _5minWarningTriggered = false;
  bool _nowTriggered = false;
  bool _isGpsLoaded = false;
  int _ayahIndex = 0;
  
  final List<Map<String, Map<String, String>>> _ayahList = [
    {
      'ru': '«Воистину, намаз предписан верующим в определенное время». (Ан-Ниса, 103)',
      'uz': '«Albatta, namoz moʻminlarga vaqtida farz qilindi». (Niso surasi, 103)'
    },
    {
      'ru': '«Поминайте Меня, и Я буду помнить о вас». (Аль-Бакара, 152)',
      'uz': '«Bilingki, Allohni zikr qilish bilan qalblar orom olur». (Ra\'d surasi, 28)'
    }
  ];
  
  List<Map<String, dynamic>> _prayerList = [];

  @override
  void initState() {
    super.initState();
    _initLocationAndTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _initLocationAndTimes() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _prayerList = SimplePrayerCalculator.calculateTimes(41.2995, 69.2401);
      if (widget.currentLang == 'uz') {
        _hijriDate = "27 Rabi'ul-avval 1448 y.";
      } else if (widget.currentLang == 'ru') {
        _hijriDate = "27 Раби аль-авваль 1448 г.";
      } else {
        _hijriDate = "27 Rabi' al-Awwal 1448";
      }
      _isGpsLoaded = true;
    });
    _updateTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!_isGpsLoaded || _prayerList.isEmpty) return;
    final now = DateTime.now();
    final timeFormat = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    String nextName = "Фаджр";
    Duration shortestRemaining = const Duration(hours: 24);
    bool isNextNotificationEnabled = true;

    for (var prayer in _prayerList) {
      List parts = prayer['time'].split(':');
      DateTime pTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      if (pTime.isAfter(now)) {
        Duration diff = pTime.difference(now);
        if (diff < shortestRemaining) {
          shortestRemaining = diff;
          nextName = prayer['name'];
          isNextNotificationEnabled = prayer['enabled'];
        }
      }
    }

    if (isNextNotificationEnabled) {
      if (shortestRemaining.inMinutes == 5 && shortestRemaining.inSeconds % 60 == 0 && !_5minWarningTriggered) {
        _5minWarningTriggered = true;
        _triggerAlertMode();
      }
      if (shortestRemaining.inSeconds == 0 && !_nowTriggered && nextName != 'Восход') {
        _nowTriggered = true;
        _triggerAlertMode();
      }
    }

    if (shortestRemaining.inSeconds > 0) _nowTriggered = false;
    if (shortestRemaining.inMinutes != 5) _5minWarningTriggered = false;

    if (widget.currentLang == 'uz') {
      if (nextName == 'Фаджр') nextName = 'Bomdod';
      if (nextName == 'Восход') nextName = 'Quyosh';
      if (nextName == 'Зухр') nextName = 'Peshin';
      if (nextName == 'Магриб') nextName = 'Shom';
      if (nextName == 'Иша') nextName = 'Xufton';
    }

    setState(() {
      _timeString = timeFormat;
      _nextPrayerName = nextName;
      _countdownString = "${shortestRemaining.inHours.toString().padLeft(2, '0')}:${(shortestRemaining.inMinutes % 60).toString().padLeft(2, '0')}:${(shortestRemaining.inSeconds % 60).toString().padLeft(2, '0')}";
    });
  }

  void _triggerAlertMode() {
    if (widget.notificationMode == 'vibrate') {
      HapticFeedback.vibrate();
    } else if (widget.notificationMode == 'click') {
      SystemSound.play(SystemSoundType.click);
    } else {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => _localizedValues[widget.currentLang]?[key] ?? key;

    if (!_isGpsLoaded) {
      return Center(
        child: buildGlassContainer(
          borderRadius: 16,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text(t('gps_loading'), style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Center(
            child: Text(_hijriDate, style: const TextStyle(fontSize: 14, color: Colors.amberAccent, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
          const SizedBox(height: 8),
          buildGlassContainer(
            borderRadius: 24,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_timeString, style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text("${t('next')}: $_nextPrayerName", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  const Divider(color: Colors.white12, height: 20),
                  Text(t('left'), style: const TextStyle(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(_countdownString, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _ayahIndex = (_ayahIndex + 1) % _ayahList.length;
              });
              HapticFeedback.lightImpact();
            },
            child: buildGlassContainer(
              borderRadius: 14,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('ayah_title'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(
                      _ayahList[_ayahIndex][widget.currentLang == 'uz' ? 'uz' : 'ru']!,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white90),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _prayerList.length,
              itemBuilder: (context, index) {
                var prayer = _prayerList[index];
                String rawName = prayer['name'];
                String timeStr = prayer['time'];
                bool isEnabled = prayer['enabled'];
                String displayName = rawName;

                if (widget.currentLang == 'uz') {
                  if (rawName == 'Фаджр') displayName = 'Bomdod';
                  if (rawName == 'Восход') displayName = 'Quyosh';
                  if (rawName == 'Зухр') displayName = 'Peshin';
                  if (rawName == 'Магриб') displayName = 'Shom';
                  if (rawName == 'Иша') displayName = 'Xufton';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: buildGlassContainer(
                    borderRadius: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(displayName, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          Text(timeStr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(width: 14),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                prayer['enabled'] = !prayer['enabled'];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isEnabled ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isEnabled ? Icons.volume_up : Icons.volume_off,
                                color: isEnabled ? Colors.greenAccent : Colors.white38,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  final String currentLang;
  final Map<String, int> qadaCounters;
  const TasbihScreen({super.key, required this.currentLang, required this.qadaCounters});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _target = 33;
  int _rounds = 0;

  @override
  Widget build(BuildContext context) {
    String t(String key) => _localizedValues[widget.currentLang]?[key] ?? key;
    
    List<Map<String, String>> qadaItems = [
      {'id': 'fajr', 'ru': 'Фаджр', 'uz': 'Bomdod'},
      {'id': 'dhuhr', 'ru': 'Зухр', 'uz': 'Peshin'},
      {'id': 'asr', 'ru': 'Аср', 'uz': 'Asr'},
      {'id': 'maghrib', 'ru': 'Магриб', 'uz': 'Shom'},
      {'id': 'isha', 'ru': 'Иша', 'uz': 'Xufton'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text('${t('rounds')}: $_rounds', style: const TextStyle(fontSize: 20, color: Colors.white70)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(label: const Text('33'), selected: _target == 33, onSelected: (v) => setState(() => _target = 33)),
                    const SizedBox(width: 15),
                    ChoiceChip(label: const Text('99'), selected: _target == 99, onSelected: (v) => setState(() => _target = 99)),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _counter++;
                      if (_counter >= _target) {
                        _counter = 0;
                        _rounds++;
                        HapticFeedback.vibrate();
                      }
                    });
                  },
                  child: buildGlassContainer(
                    borderRadius: 100,
                    child: Container(
                      width: 170,
                      height: 170,
                      alignment: Alignment.center,
                      child: Text('$_counter', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 28, color: Colors.white60),
                  onPressed: () => setState(() { _counter = 0; _rounds = 0; }),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('qada_title'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amberAccent, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                Column(
                  children: qadaItems.map((item) {
                    String id = item['id']!;
                    String label = widget.currentLang == 'uz' ? item['uz']! : item['ru']!;
                    int count = widget.qadaCounters[id] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.white54, size: 22),
                                onPressed: () {
                                  if (count > 0) {
                                    setState(() => widget.qadaCounters[id] = count - 1);
                                    HapticFeedback.lightImpact();
                                  }
                                },
                              ),
                              Container(
                                width: 36,
                                alignment: Alignment.center,
                                child: Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent, size: 22),
                                onPressed: () {
                                  setState(() => widget.qadaCounters[id] = count + 1);
                                  HapticFeedback.lightImpact();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildGlassContainer(
        borderRadius: 110,
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.navigation, size: 90, color: Colors.white),
              SizedBox(height: 8),
              Text('QIBLA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final String currentLang;
  final String currentBg;
  final String notificationMode;
  final String azanVoice;
  final Function(String) onBgChanged;
  final Function(String) onLangChanged;
  final Function(String) onModeChanged;
  final Function(String) onVoiceChanged;

  SettingsScreen({
    super.key,
    required this.currentLang,
    required this.currentBg,
    required this.notificationMode,
    required this.azanVoice,
    required this.onBgChanged,
    required this.onLangChanged,
    required this.onModeChanged,
    required this.onVoiceChanged,
  });

  final List<String> _makkahBgs = const [
    'https://images.unsplash.com/photo-1564769625405-afc0465b7cff',
    'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa',
    'https://images.unsplash.com/photo-1542816417-0983c9c9ad53'
  ];

  final List<String> _madinahBgs = const [
    'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f',
    'https://images.unsplash.com/photo-1590073844006-33379778ae09',
    'https://images.unsplash.com/photo-1565552403673-83876d75d3d2'
  ];

  String t(String key) => _localizedValues[currentLang]?[key] ?? key;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('lang_settings'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLangChip('Oʻzbekcha', 'uz', currentLang == 'uz'),
                    _buildLangChip('Русский', 'ru', currentLang == 'ru'),
                    _buildLangChip('English', 'en', currentLang == 'en'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('sound_settings'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54)),
                const SizedBox(height: 12),
                _buildModeRadio(t('mode_azan'), 'azan'),
                const SizedBox(height: 8),
                _buildModeRadio(t('mode_click'), 'click'),
                const SizedBox(height: 8),
                _buildModeRadio(t('mode_vibrate'), 'vibrate'),
              ],
            ),
          ),
        ),
        if (notificationMode == 'azan') ...[
          const SizedBox(height: 14),
          buildGlassContainer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('voice_title'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54)),
                  const SizedBox(height: 10),
                  _buildVoiceRadio(t('voice_makkah'), 'makkah'),
                  const SizedBox(height: 6),
                  _buildVoiceRadio(t('voice_madinah'), 'madinah'),
                  const SizedBox(height: 6),
                  _buildVoiceRadio(t('voice_aqsa'), 'aqsa'),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('bg_settings'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54)),
                const SizedBox(height: 12),
                Text(t('makkah'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                _buildBgHorizontalList(_makkahBgs),
                const SizedBox(height: 14),
                Text(t('madinah'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                _buildBgHorizontalList(_madinahBgs),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeRadio(String title, String mode) {
    bool isSelected = notificationMode == mode;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onModeChanged(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E5E3A).withOpacity(0.5) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.white30 : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceRadio(String title, String voice) {
    bool isSelected = azanVoice == voice;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onVoiceChanged(voice);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.amber.withOpacity(0.4) : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 13, color: isSelected ? Colors.amberAccent : Colors.white90)),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.amber : Colors.white30,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangChip(String label, String code, bool isSelected) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontSize: 12)),
      selected: isSelected,
      selectedColor: const Color(0xFF1E5E3A).withOpacity(0.6),
      backgroundColor: Colors.white.withOpacity(0.03),
      onSelected: (val) { if (val) onLangChanged(code); },
    );
  }

  Widget _buildBgHorizontalList(List<String> list) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, i) {
          bool isCurrent = currentBg == list[i]; // Исправлена ошибка сравнения
          return GestureDetector(
            onTap: () => onBgChanged(list[i]),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isCurrent ? Colors.white : Colors.white12, width: isCurrent ? 2 : 1),
                image: DecorationImage(image: NetworkImage(list[i]), fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
