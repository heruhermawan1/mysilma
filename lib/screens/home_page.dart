import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final dynamic userId;
  final String userName;

  const HomePage({super.key, this.userId = 1, this.userName = 'Pengguna'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  String _selectedFilter = 'Semua';

  static const _green900 = Color(0xFF1A5C38);
  static const _green700 = Color(0xFF27AE60);
  static const _green400 = Color(0xFF2ECC71);
  static const _bgColor = Color(0xFFF2F3F7);

  final List<String> _filters = [
    'Semua',
    'Karpet Vinyl',
    'Karpet Parquet',
    'Fiber',
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _bgColor,
        body: Column(
          children: [
            // ── Top Nav Bar (hijau) ──
            _buildTopBar(),

            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero card hijau ──
                    _buildHeroCard(),

                    const SizedBox(height: 14),

                    // ── Jadwal main terdekat ──
                    _buildJadwalCard(),

                    const SizedBox(height: 14),

                    // ── Search bar ──
                    _buildSearchBar(),

                    const SizedBox(height: 14),

                    // ── Filter chips ──
                    _buildFilterChips(),

                    const SizedBox(height: 16),

                    // ── Menu grid ──
                    _buildMenuGrid(),

                    const SizedBox(height: 14),

                    // ── Flash Promo banner ──
                    _buildFlashPromoBanner(),

                    const SizedBox(height: 20),

                    // ── Lapangan Populer ──
                    _buildLapanganHeader(),

                    const SizedBox(height: 12),

                    // ── Lapangan Card 1 ──
                    _buildLapanganCard(
                      imagePath: 'assets/images/Lapangan1.png',
                      name: 'GOR Silma Hall A Sport Center',
                      rating: 4.9,
                      reviewCount: 320,
                      address: 'Jl. Bintara 11 No. 18, Kota Bekasi',
                      tags: [
                        'Karpet Vinyl Taraflex (4 Lapangan)',
                        'Parkir Luas',
                      ],
                      extraTag: 'Kantin & Shower',
                      distance: '1.2 km',
                      badge: 'Instant Book',
                      badgeColor: _green700,
                      slotInfo: '3 Slot Tersedia Hari Ini',
                      price: 'Rp 65.000',
                    ),

                    const SizedBox(height: 14),

                    // ── Lapangan Card 2 ──
                    _buildLapanganCard(
                      imagePath: 'assets/images/Lapangan2.png',
                      name: 'GOR Silma Hall B Sport Center',
                      rating: 4.8,
                      reviewCount: 185,
                      address: 'Jl. Bintara 11 No. 18, Kota Bekasi',
                      tags: [
                        'Parquet Kayu BWF Standard (6 Lapangan)',
                        'AC Sentral',
                      ],
                      extraTag: 'Pro Shop Raket',
                      distance: '2.8 km',
                      badge: 'BWF Grade',
                      badgeColor: const Color(0xFF2563EB),
                      slotInfo: 'Slot Malam Terbatas',
                      slotWarning: true,
                      price: 'Rp 80.000',
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Bottom Nav ──
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // TOP BAR
  // ══════════════════════════════════════════════════════════
  Widget _buildTopBar() {
    return Container(
      color: _green900,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          // Logo + nama + lokasi
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/MySILMA Logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MySILMA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF2ECC71),
                    size: 11,
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    'Kota Bekasi',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white54,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Notifikasi
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _green700,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1.5),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // HERO CARD
  // ══════════════════════════════════════════════════════════
  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D7A4F), Color(0xFF1A5C38)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _green900.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Halo + poin
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${widget.userName}! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _GreenPill(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Level: Intermediate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _GreenPill(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Rank #42 Selatan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Poin
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      '1.240',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Poin',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 14),

          // Saldo SilmaPay
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SALDO SILMAPAY',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    'Rp 0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Top Up button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _green400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Top Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // JADWAL CARD
  // ══════════════════════════════════════════════════════════
  Widget _buildJadwalCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dot merah
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'JADWAL MAIN TERDEKAT',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Besok, 19:00 – 21:00 • GOR Silma Hall A',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF7F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Text(
                  'Tiket',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A5C38),
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: Color(0xFF1A5C38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // SEARCH BAR
  // ══════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cari GOR, hall badminton, atau area...',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF374151),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ══════════════════════════════════════════════════════════
  Widget _buildFilterChips() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _filters[i] == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? _green900 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? _green900 : const Color(0xFFE4E6EA),
                ),
              ),
              child: Center(
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // MENU GRID
  // ══════════════════════════════════════════════════════════
  Widget _buildMenuGrid() {
    final menus = [
      (icon: Icons.sports_tennis_rounded, label: 'Sewa Lap.', badge: ''),
      (icon: Icons.people_alt_outlined, label: 'Mabar', badge: 'Ramai'),
      (icon: Icons.emoji_events_outlined, label: 'Turnamen', badge: ''),
      (icon: Icons.school_outlined, label: 'Akademi', badge: ''),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menus.map((m) {
          return _MenuTile(icon: m.icon, label: m.label, badge: m.badge);
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // FLASH PROMO BANNER
  // ══════════════════════════════════════════════════════════
  Widget _buildFlashPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _green900.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 2.2,
              child: Image.asset(
                'assets/images/Flash Promo Diskon.png',
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            // Overlay konten
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFFFBBC05),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'FLASH PROMO',
                          style: TextStyle(
                            color: Color(0xFFFBBC05),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Diskon Main Malam 25%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Spesial slot 20.00–23.00 di GOR Champion Arena.',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'KODE: SMASHMIEMAT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.copy_rounded,
                                color: Colors.white70,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // LAPANGAN HEADER
  // ══════════════════════════════════════════════════════════
  Widget _buildLapanganHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Lapangan Populer &\nTerdekat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.3,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Lihat\nSemua',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF27AE60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // LAPANGAN CARD
  // ══════════════════════════════════════════════════════════
  Widget _buildLapanganCard({
    required String imagePath,
    required String name,
    required double rating,
    required int reviewCount,
    required String address,
    required List<String> tags,
    required String extraTag,
    required String distance,
    required String badge,
    required Color badgeColor,
    required String slotInfo,
    bool slotWarning = false,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gambar ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 2.2,
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Distance badge
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Book badge
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Favorit
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
              // Slot info
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: slotWarning ? const Color(0xFFF59E0B) : _green700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slotInfo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Info ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama + rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFBBC05),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      ' ($reviewCount)',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Alamat
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF9CA3AF),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...tags.map((t) => _TagChip(label: t)),
                    _TagChip(label: extraTag),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[100], height: 1),
                const SizedBox(height: 12),
                // Harga + tombol
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mulai dari',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        Text(
                          '$price / jam',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green900,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_today_rounded, size: 14),
                      label: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // BOTTOM NAV
  // ══════════════════════════════════════════════════════════
  Widget _buildBottomNav() {
    final items = [
      (icon: Icons.home_rounded, label: 'Beranda'),
      (icon: Icons.calendar_month_outlined, label: 'Booking'),
      (icon: Icons.people_alt_outlined, label: 'Mabar'),
      (icon: Icons.assignment_outlined, label: 'Jadwal Saya'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 4,
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == _currentTab;
          return GestureDetector(
            onTap: () => setState(() => _currentTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active
                    ? _green900.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].icon,
                    size: 22,
                    color: active ? _green900 : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? _green900 : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Helper Widgets
// ══════════════════════════════════════════════════════════════

class _GreenPill extends StatelessWidget {
  final Widget child;
  const _GreenPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;

  const _MenuTile({required this.icon, required this.label, this.badge = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFF1A5C38), size: 26),
            ),
            if (badge.isNotEmpty)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF27AE60),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
