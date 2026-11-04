import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color primary = const Color(0xFF00875A);
  final Color background = const Color(0xFFF5F8F7);

  int selectedDate = 0;
  int selectedCourt = 0;
  int selectedSlot = 0;
  int racketQty = 1;

  bool useShoes = false;
  bool useUmpire = false;

  final List<String> dates = [
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];

  final List<String> days = [
    'JUM',
    'SAB',
    'MIN',
    'SEN',
    'SEL',
    'RAB',
    'KAM',
  ];

  final List<String> timeSlots = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '17:00 - 18:00',
    '19:00 - 20:00',
    '21:00 - 22:00',
  ];

  int get courtPrice => selectedCourt == 0 ? 65000 : 80000;

  int get addonPrice {
    return (racketQty * 15000) +
        (useShoes ? 10000 : 0) +
        (useUmpire ? 25000 : 0);
  }

  int get totalPrice => courtPrice + addonPrice;

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MySILMA',
              style: TextStyle(
                color: Color(0xFF00875A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Booking Lapangan',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _venueCard(),
            const SizedBox(height: 18),

            _sectionTitle('Pilih Tanggal Main'),
            const SizedBox(height: 10),
            _dateSelector(),

            const SizedBox(height: 18),
            _sectionTitle('Pilih Lapangan'),
            const SizedBox(height: 10),
            _courtSelector(),

            const SizedBox(height: 18),
            _sectionTitle('Slot Jam'),
            const SizedBox(height: 5),
            const Text(
              'Pilih waktu bermain yang tersedia',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _timeSelector(),

            const SizedBox(height: 18),
            _sectionTitle('Peralatan & Add-on Tambahan'),
            const SizedBox(height: 10),
            _addons(),

            const SizedBox(height: 18),
            _summary(),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  Widget _venueCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_tennis,
              color: Color(0xFF00875A),
              size: 45,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '★ Terverifikasi',
                    style: TextStyle(
                      color: Color(0xFF00875A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'GOR Bina Sakti Sport Center',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jl. TB Simatupang, Jakarta Selatan',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${rupiah(65000)} / jam',
                  style: const TextStyle(
                    color: Color(0xFF00875A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _dateSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'November 2026',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(dates.length, (index) {
              final selected = selectedDate == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedDate = index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: selected
                          ? primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: selected
                            ? primary
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 9,
                            color: selected
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          dates[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _courtSelector() {
    return Row(
      children: [
        Expanded(
          child: _courtButton(
            'Lapangan Vinyl',
            'Rp65.000 / jam',
            0,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _courtButton(
            'Lapangan Parquet',
            'Rp80.000 / jam',
            1,
          ),
        ),
      ],
    );
  }

  Widget _courtButton(String name, String price, int index) {
    final selected = selectedCourt == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCourt = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? primary : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: primary,
              size: 18,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 10,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeSelector() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timeSlots.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          childAspectRatio: 1.65,
        ),
        itemBuilder: (context, index) {
          final selected = selectedSlot == index;

          return GestureDetector(
            onTap: () {
              setState(() => selectedSlot = index);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: selected
                    ? primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? primary
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                timeSlots[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addons() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_tennis,
                color: Color(0xFF00875A),
                size: 22,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sewa Raket Yonex Nanoray',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp15.000 / raket',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (racketQty > 0) racketQty--;
                  });
                },
                icon: const Icon(Icons.remove_circle_outline),
                color: primary,
                iconSize: 20,
              ),
              Text(
                '$racketQty',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => racketQty++);
                },
                icon: const Icon(Icons.add_circle_outline),
                color: primary,
                iconSize: 20,
              ),
            ],
          ),
          const Divider(),
          _addonCheck(
            '1 Slotk Kom Samual Hitam',
            'Rp10.000 / slot',
            useShoes,
            (value) => setState(() => useShoes = value),
            Icons.directions_run,
          ),
          const Divider(),
          _addonCheck(
            'Wasit / Umpire Pertandingan',
            'Rp25.000 / pertandingan',
            useUmpire,
            (value) => setState(() => useUmpire = value),
            Icons.sports,
          ),
        ],
      ),
    );
  }

  Widget _addonCheck(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Checkbox(
          value: value,
          activeColor: primary,
          onChanged: (checked) {
            onChanged(checked ?? false);
          },
        ),
      ],
    );
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Text(
            'Ringkasan Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            'Lapangan',
            rupiah(courtPrice),
          ),
          const SizedBox(height: 8),
          _summaryRow(
            'Peralatan & Add-on',
            rupiah(addonPrice),
          ),
          const Divider(height: 20),
          _summaryRow(
            'Total Pembayaran',
            rupiah(totalPrice),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String price, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 12,
            color: bold ? primary : Colors.black87,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                Text(
                  rupiah(totalPrice),
                  style: TextStyle(
                    color: primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Booking ${timeSlots[selectedSlot]} '
                    'berhasil dipilih!',
                  ),
                  backgroundColor: primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Lanjut Bayar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 17),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey.shade200,
      ),
    );
  }
}