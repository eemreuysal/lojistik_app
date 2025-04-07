import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/load_model.dart';
import '../../utils/date_helpers.dart';

class LoadDetailScreen extends StatefulWidget {
  final Load load;
  final String tripNumber;
  final String vehiclePlate;

  const LoadDetailScreen({
    super.key,
    required this.load,
    required this.tripNumber,
    required this.vehiclePlate,
  });

  @override
  State<LoadDetailScreen> createState() => _LoadDetailScreenState();
}

class _LoadDetailScreenState extends State<LoadDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient Background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 534,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF06263E),
                      const Color(0xFF10344F),
                      const Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // App Bar with Back Button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Geri butonu
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),

                    // Ekran başlığı
                    Text(
                      'Yük Detayları',
                      style: TextStyle(
                        color: const Color(0xFFDEDFE1),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Trip and Vehicle Info
            Positioned(
              left: 20,
              top: 70,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sefer Numarası
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sefer Numarası',
                        style: TextStyle(
                          color: Color(0xFFBBBDC1),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                      Text(
                        widget.tripNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Clash Grotesk',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),

                  // Araç
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Araç',
                        style: TextStyle(
                          color: Color(0xFFBBBDC1),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                      Text(
                        widget.vehiclePlate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Clash Grotesk',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Load Info Card
            Positioned(
              left: 20,
              right: 20,
              top: 130,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x7F082740),
                      blurRadius: 4.70,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Yük Adı
                    Text(
                      widget.load.name ?? 'Paletli Mermer Fayans',
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 22,
                        fontFamily: 'Clash Grotesk',
                        fontWeight: FontWeight.w600,
                        height: 1.09,
                      ),
                    ),

                    // Yük Birimi
                    Text(
                      '${widget.load.quantity?.toStringAsFixed(0) ?? '14'} ${widget.load.unit ?? 'Palet'}',
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.71,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Yükleme ve Teslimat Tarihleri
                    Row(
                      children: [
                        // Yükleme Tarihi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yükleme Tarihi',
                                style: TextStyle(
                                  color: Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 2,
                                ),
                              ),
                              Text(
                                widget.load.loadingDate != null
                                    ? DateHelpers.formatDateAndTime(
                                        widget.load.pickupDate!)
                                    : '14 Mayıs 2025 14:30',
                                style: TextStyle(
                                  color: Color(0xFF474747),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.71,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Teslimat Tarihi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Teslimat Tarihi',
                                style: TextStyle(
                                  color: Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 2,
                                ),
                              ),
                              Text(
                                widget.load.deliveryDate != null
                                    ? DateHelpers.formatDateAndTime(
                                        widget.load.deliveryDate!)
                                    : '14 Mayıs 2025 14:30',
                                style: TextStyle(
                                  color: Color(0xFF474747),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.71,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Müşteri
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Müşteri',
                          style: TextStyle(
                            color: Color(0xFFBBBDC1),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                        Text(
                          widget.load.customerName ?? 'Gediz Ekol Madencilik',
                          style: TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.71,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tabs
            Positioned(
              left: 20,
              top: 310,
              right: 20,
              child: Row(
                children: [
                  _buildTabButton(
                      title: 'Yükleme Noktaları',
                      isSelected: _selectedTabIndex == 0,
                      onTap: () {
                        _tabController.animateTo(0);
                      }),
                  const SizedBox(width: 35),
                  _buildTabButton(
                      title: 'Teslimat Noktaları',
                      isSelected: _selectedTabIndex == 1,
                      onTap: () {
                        _tabController.animateTo(1);
                      }),
                ],
              ),
            ),

            // White Background for tab content
            Positioned(
              left: 0,
              top: 358,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),

            // Add Button Based on Tab
            Positioned(
              left: 20,
              right: 20,
              top: 370,
              child: GestureDetector(
                onTap: () {
                  if (_selectedTabIndex == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadingPointAddScreen(
                          loadId: widget.load.id,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryPointAddScreen(
                          loadId: widget.load.id,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDFE2E3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _selectedTabIndex == 0
                          ? 'Yükleme Noktası Ekle'
                          : 'Teslimat Noktası Ekle',
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 15,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tab Content
            Positioned(
              left: 0,
              top: 430,
              right: 0,
              bottom: 100, // Space for bottom nav bar
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Yükleme Noktaları Tab
                  _buildLoadingPointsList(),

                  // Teslimat Noktaları Tab
                  _buildDeliveryPointsList(),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              left: 15,
              bottom: 15,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Tab button
  Widget _buildTabButton(
      {required String title,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF84AAC9),
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
              height: 1.60,
            ),
          ),
          if (isSelected)
            Container(
              height: 3,
              width: title.length * 8.0, // Adjust width based on text length
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  // Example loading points list
  Widget _buildLoadingPointsList() {
    // Demo data for loading points
    final loadingPoints = [
      {
        'id': 1,
        'location': 'Gediz, Kütahya',
        'name': 'Gediz Ekol Madencilik Ana Sahası',
        'address':
            'Kınıklı Mah. Hüseyin Yılmaz Cad. Pamukkale Üniversitesi Teknokent No: 67 B Blok Z-12 Pamukkale / Denizli',
      },
      {
        'id': 2,
        'location': 'Merkez, Uşak',
        'name': 'Gediz Ekol Madencilik Ana Sahası',
        'address':
            'Kınıklı Mah. Hüseyin Yılmaz Cad. Pamukkale Üniversitesi Teknokent No: 67 B Blok Z-12 Pamukkale / Denizli',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: loadingPoints.length,
      itemBuilder: (context, index) {
        final point = loadingPoints[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: const Color(0xFFEAEAEA),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location name
                    Text(
                      point['location'] as String,
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),

                    // Point number badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE0E2E3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${point['id']}.',
                                style: TextStyle(
                                  color: Color(0xFF474747),
                                  fontSize: 13,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Yükleme',
                            style: TextStyle(
                              color: Color(0xFF474747),
                              fontSize: 13,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.85,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Company name
                Text(
                  point['name'] as String,
                  style: TextStyle(
                    color: Color(0xFF898A8A),
                    fontSize: 15,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                  ),
                ),

                const SizedBox(height: 10),

                // Address
                Text(
                  point['address'] as String,
                  style: TextStyle(
                    color: Color(0xFFBCBEC2),
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.62,
                  ),
                ),

                const SizedBox(height: 10),

                // Description label
                Text(
                  'Açıklama',
                  style: TextStyle(
                    color: Color(0xFFBCBEC2),
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.85,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Example delivery points list
  Widget _buildDeliveryPointsList() {
    // Demo data for delivery points
    final deliveryPoints = [
      {
        'id': 1,
        'location': 'Pozantı, Adana',
        'name': 'Adana Lojistik Merkezi',
        'address':
            'Adana Organize Sanayi Bölgesi, 5. Cadde, No: 27, Sarıçam / Adana',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: deliveryPoints.length,
      itemBuilder: (context, index) {
        final point = deliveryPoints[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: const Color(0xFFEAEAEA),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location name
                    Text(
                      point['location'] as String,
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),

                    // Point number badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE0E2E3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${point['id']}.',
                                style: TextStyle(
                                  color: Color(0xFF474747),
                                  fontSize: 13,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Teslimat',
                            style: TextStyle(
                              color: Color(0xFF474747),
                              fontSize: 13,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.85,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Company name
                Text(
                  point['name'] as String,
                  style: TextStyle(
                    color: Color(0xFF898A8A),
                    fontSize: 15,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                  ),
                ),

                const SizedBox(height: 10),

                // Address
                Text(
                  point['address'] as String,
                  style: TextStyle(
                    color: Color(0xFFBCBEC2),
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.62,
                  ),
                ),

                const SizedBox(height: 10),

                // Description label
                Text(
                  'Açıklama',
                  style: TextStyle(
                    color: Color(0xFFBCBEC2),
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.85,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 69,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.01, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [
            const Color(0xFF06263E),
            const Color(0xFF10344F),
            const Color(0xFF1E485C)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Ana Sayfa', false),
          _buildNavItem(Icons.attach_money, 'Giderler', false),
          _buildNavItem(Icons.route, 'Seferler', true),
          _buildNavItem(Icons.person, 'Hesabım', false),
          _buildNavItem(Icons.settings, 'Ayarlar', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFFDDDDDD),
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFDDDDDD),
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
