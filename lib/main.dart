import 'dart:math';
import 'package:flutter/material.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  
    ErrorWidget.builder = (FlutterErrorDetails details) {
    return const SizedBox.shrink();
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    // Prevent yellow overflow warnings from appearing
    debugPrint('Flutter Error: ${details.exceptionAsString()}');
  };

    debugPrint = (String? message, {int? wrapWidth}) {};


  runApp(const WindDashboardApp());
}

class WindDashboardApp extends StatelessWidget {
  const WindDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wind Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        fontFamily: 'Arial',
      ),
      home: const WindDashboard(),
    );
  }
}

class WindDashboard extends StatefulWidget {
  const WindDashboard({super.key});

  @override
  State<WindDashboard> createState() => _WindDashboardState();
}

class _WindDashboardState extends State<WindDashboard> {
  static const int historyDays = 30; // change this to 60, 90, etc. "dates up to whenever"

  late final DateTime now;
  late final List<WindEntry> entries; // oldest → newest (today last)
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    entries = _generateHistory(now, historyDays);
    _currentIndex = entries.length - 1; // today
    _pageController = PageController(initialPage: _currentIndex, viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String location = 'General Trias, Cavite, Philippines';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F1FF), Color(0xFFE4F3F2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(location),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 30,
                                offset: const Offset(0, 20),
                                color: Colors.black.withOpacity(0.08),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: _buildShell(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ───────────────────────── TOP BAR OUTSIDE SHELL ─────────────────────────

  Widget _buildTopBar(String location) {
    const String email = 'contact@winderella.app';
    final String date = _formatFullDate(now);
    final String time = _formatTime(now);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Winderella',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              'Design & Development • $location',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$date • $time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ───────────────────────── INNER SHELL (LIKE TABLET) ─────────────────────────

  Widget _buildShell() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left vertical icon bar (like screenshot)
        Container(
          width: 56,
          margin: const EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF0F766E),
                child: const Icon(Icons.air, size: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.dashboard_outlined, size: 22, color: Colors.grey),
              const SizedBox(height: 14),
              const Icon(Icons.map_outlined, size: 22, color: Colors.grey),
              const SizedBox(height: 14),
              const Icon(Icons.insights_outlined, size: 22, color: Colors.grey),
              const Spacer(),
              const Icon(Icons.settings_outlined, size: 20, color: Colors.grey),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShellHeader(),
              const SizedBox(height: 18),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWide = constraints.maxWidth > 900;
                    if (isWide) {
                      return Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: _buildHeroCardSection()),
                                const SizedBox(width: 18),
                                Expanded(flex: 3, child: _buildMapCard()),
                                const SizedBox(width: 18),
                                Expanded(flex: 2, child: _buildTomorrowCard()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Expanded(
                            flex: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: _buildHistoryAndStability()),
                                const SizedBox(width: 18),
                                Expanded(flex: 2, child: _buildInterpretationCard()),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // smaller width: stack vertically
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroCardSection(),
                            const SizedBox(height: 18),
                            _buildMapCard(),
                            const SizedBox(height: 18),
                            _buildTomorrowCard(),
                            const SizedBox(height: 18),
                            _buildHistoryAndStability(),
                            const SizedBox(height: 18),
                            _buildInterpretationCard(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShellHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Aundreka 👋',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            Text(
              'Here\'s your wind dashboard for today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Fake search box & icons, like screenshot
        Expanded(
          flex: 2,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Search here...',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const Spacer(),
                Icon(Icons.calendar_today_outlined,
                    size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 10),
                Icon(Icons.notifications_none,
                    size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF0F766E),
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────── HERO CARD (WEATHER-STYLE) ─────────────────────────

  Widget _buildHeroCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: entries.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final entry = entries[index];
              final label = _windLabel(entry.speedKph);
              final iconAsset = _windIconAsset(entry.speedKph);
              final isToday = index == entries.length - 1;
              return HeroWindCard(
                entry: entry,
                label: label,
                iconAsset: iconAsset,
                isToday: isToday,
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────────────────── MAP CARD ─────────────────────────

  Widget _buildMapCard() {
    final selected = entries[_currentIndex];
    final label = _windLabel(selected.speedKph);
    final iconAsset = _windIconAsset(selected.speedKph);

    return MapWindCard(
      entry: selected,
      label: label,
      iconAsset: iconAsset,
    );
  }

  // ───────────────────────── TOMORROW / SAFETY ART CARD ─────────────────────────

  Widget _buildTomorrowCard() {
    final tomorrow = now.add(const Duration(days: 1));
    final speed = windSpeedForDate(tomorrow);
    final label = _windLabel(speed);
    final iconAsset = _windIconAsset(speed);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5FCE5),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tomorrow',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatShortDate(tomorrow),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${speed.toStringAsFixed(1)} km/h',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      iconAsset,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Plan ahead for errands\nand outdoor activities.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ───────────────────────── HISTORY STRIP + STABILITY ─────────────────────────

  Widget _buildHistoryAndStability() {
    final double minSpeed =
        entries.map((e) => e.speedKph).reduce(min).toDouble();
    final double avgSpeed = entries
            .map((e) => e.speedKph)
            .reduce((a, b) => a + b) /
        entries.length;
    final double maxSpeed =
        entries.map((e) => e.speedKph).reduce(max).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past $historyDays days',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final bool selected = index == _currentIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                  );
                  setState(() => _currentIndex = index);
                },
                child: MiniDayCard(entry: entry, selected: selected),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF020617), Color(0xFF0B1120)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wind stability',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Min ${minSpeed.toStringAsFixed(1)} • '
                      'Avg ${avgSpeed.toStringAsFixed(1)} • '
                      'Max ${maxSpeed.toStringAsFixed(1)} km/h',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use this to gauge how steady or gusty the recent days have been.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'images/cloud.png',
                width: 64,
                height: 64,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────── INTERPRETATION CARD ─────────────────────────

  Widget _buildInterpretationCard() {
    final selected = entries[_currentIndex];
    final label = _windLabel(selected.speedKph);
    final message = _dayAdvice(selected.speedKph);

    return InterpretationCard(label: label, message: message);
  }
}

// ───────────────────────── DATA & HELPERS ─────────────────────────

class WindEntry {
  final DateTime date;
  final double speedKph;

  WindEntry({required this.date, required this.speedKph});
}

// Generate last N days of history (oldest first, today last)
List<WindEntry> _generateHistory(DateTime base, int days) {
  final List<WindEntry> list = [];
  for (int i = days - 1; i >= 0; i--) {
    final date = DateTime(base.year, base.month, base.day).subtract(Duration(days: i));
    final speed = windSpeedForDate(date);
    list.add(WindEntry(date: date, speedKph: speed));
  }
  return list;
}

// Deterministic pseudo-random wind speed per date (so it stays stable)
double windSpeedForDate(DateTime date) {
  final seed = date.year * 10000 + date.month * 100 + date.day;
  final rand = Random(seed);
  // base 8–50 km/h, plus small weekly variation
  final base = 8 + rand.nextDouble() * 42;
  final weeklyWave = 4 * sin(date.weekday / 7 * 2 * pi);
  return (base + weeklyWave).clamp(5.0, 60.0);
}

String _windLabel(double speed) {
  if (speed < 20) return 'Calm to light breeze';
  if (speed < 40) return 'Moderate breeze';
  if (speed < 60) return 'Strong winds';
  return 'Very strong winds';
}

String _windIconAsset(double speed) {
  if (speed < 15) return 'images/sun.png';
  if (speed < 30) return 'images/cloud.png';
  if (speed < 50) return 'images/rain.png';
  return 'images/lightning.png';
}

String _dayAdvice(double speed) {
  if (speed < 20) {
    return 'Winds are gentle. Outdoor activities, commuting, and light setups '
        'such as umbrellas or street stalls are generally safe.';
  } else if (speed < 40) {
    return 'Expect a noticeable breeze. Secure lightweight items and be cautious '
        'when biking or carrying large umbrellas.';
  } else if (speed < 60) {
    return 'Strong winds can affect branches, tarpaulins, and signboards. Avoid '
        'staying under tall trees, and drive carefully.';
  } else {
    return 'Very strong winds may be hazardous. Stay indoors when possible and '
        'follow official weather advisories.';
  }
}

String _formatFullDate(DateTime dt) {
  const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final weekday = weekdays[dt.weekday - 1];
  final month = months[dt.month - 1];
  final day = dt.day.toString().padLeft(2, '0');
  final year = dt.year.toString();
  return '$weekday, $month $day, $year';
}

String _formatShortDate(DateTime dt) {
  const weekdaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final weekday = weekdaysShort[dt.weekday - 1];
  final month = monthsShort[dt.month - 1];
  final day = dt.day.toString().padLeft(2, '0');
  return '$weekday • $month $day';
}

String _formatTime(DateTime dt) {
  int hour = dt.hour;
  final minute = dt.minute.toString().padLeft(2, '0');
  final suffix = hour >= 12 ? 'PM' : 'AM';
  if (hour == 0) hour = 12;
  if (hour > 12) hour -= 12;
  return '$hour:$minute $suffix';
}

String _formatShortTimeOfDay(DateTime dt) => _formatTime(dt);

// ───────────────────────── UI COMPONENTS ─────────────────────────

class HeroWindCard extends StatelessWidget {
  final WindEntry entry;
  final String label;
  final String iconAsset;
  final bool isToday;

  const HeroWindCard({
    super.key,
    required this.entry,
    required this.label,
    required this.iconAsset,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = isToday ? 'Today' : _formatShortDate(entry.date);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF4FD1C5), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Left text
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wind • $subtitle',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Current wind speed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      entry.speedKph.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'km/h',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white.withOpacity(0.25),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Feels like ${entry.speedKph.toStringAsFixed(0)} km/h • '
                  'Updated ${_formatShortTimeOfDay(DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right art
          Expanded(
            flex: 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -10,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    iconAsset,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MiniDayCard extends StatelessWidget {
  final WindEntry entry;
  final bool selected;

  const MiniDayCard({
    super.key,
    required this.entry,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = _formatShortDate(entry.date);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: selected ? const Color(0xFF0F766E) : const Color(0xFFF5F7FB),
        boxShadow: selected
            ? [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: const Color(0xFF0F766E).withOpacity(0.25),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${entry.speedKph.toStringAsFixed(1)} km/h',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _windLabel(entry.speedKph),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: selected ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class MapWindCard extends StatelessWidget {
  final WindEntry entry;
  final String label;
  final String iconAsset;

  const MapWindCard({
    super.key,
    required this.entry,
    required this.label,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: 0.55,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.16),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Opacity(
                    opacity: 0.35,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Opacity(
                    opacity: 0.25,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.22),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    iconAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wind snapshot',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatShortDate(entry.date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${entry.speedKph.toStringAsFixed(1)} km/h',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Recent values help you see if today is calmer, similar, '
                  'or windier than the last days.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InterpretationCard extends StatelessWidget {
  final String label;
  final String message;

  const InterpretationCard({
    super.key,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFF5F7FB),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wind interpretation',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F766E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Quick guideline',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 6),
          _guideRow('0–19 km/h', 'Calm. Ideal for outdoor activities.'),
          _guideRow(
              '20–39 km/h', 'Moderate breeze. Secure tarps, tents, and signage.'),
          _guideRow(
              '40–59 km/h', 'Strong winds. Avoid tall trees and loose structures.'),
          _guideRow('60+ km/h',
              'Very strong. Stay indoors and follow local advisories.'),
        ],
      ),
    );
  }

  Widget _guideRow(String range, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
