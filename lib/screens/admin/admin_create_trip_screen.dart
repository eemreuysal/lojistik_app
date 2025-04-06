import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

class AdminCreateTripScreen extends StatefulWidget {
  const AdminCreateTripScreen({super.key});

  @override
  State<AdminCreateTripScreen> createState() => _AdminCreateTripScreenState();
}

class _AdminCreateTripScreenState extends State<AdminCreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedVehicleId;
  int? _selectedDriverId;
  int? _selectedCustomerId;

  List<DropdownMenuItem<int>> _vehicleItems = [];
  List<DropdownMenuItem<int>> _driverItems = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Mock data - normally we would load these from API
    _vehicleItems = [
      const DropdownMenuItem(value: 1, child: Text('Mercedes - 34ABC123')),
      const DropdownMenuItem(value: 2, child: Text('Ford - 06DEF456')),
    ];

    _driverItems = [
      const DropdownMenuItem(value: 1, child: Text('Ahmet Yılmaz')),
      const DropdownMenuItem(value: 2, child: Text('Mehmet Öztürk')),
    ];
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd.MM.yyyy').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd.MM.yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // API entegrasyonu için veri hazırlanıyor:
        Map<String, dynamic> tripData = {
          'start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
          'end_date': _endDate != null
              ? DateFormat('yyyy-MM-dd').format(_endDate!)
              : null,
          'vehicle': _selectedVehicleId,
          'driver': _selectedDriverId,
          'customer': _selectedCustomerId,
        };

        // Yapay gecikme (API entegrasyonu için kaldırılacak)
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Not: API üzerinden kaydet - tripData gönderilecek
        debugPrint('Gönderilecek veri: $tripData'); // Debug için

        if (mounted) {
          // Başarı mesajı göster
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sefer başarıyla oluşturuldu'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Önceki ekrana dön
          Navigator.pop(context);
        }
      } catch (e) {
        // Hata durumunda
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sefer oluşturulurken hata: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: 534,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, 0.00),
                    end: Alignment(1.00, 1.00),
                    colors: [
                      Color(0xFF06263E),
                      Color(0xFF10344F),
                      Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // Light gray background for content
            Positioned(
              left: 0,
              top: 115,
              child: Container(
                width: screenWidth,
                height: 822,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8F8F8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // White background for bottom buttons
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: 104,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // Safe area for content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar

                  // Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Sefer Oluştur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.09,
                      ),
                    ),
                  ),

                  // Form content
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(19, 20, 19, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Araç Seçimi
                              const Text(
                                'Araç',
                                style: TextStyle(
                                  color: Color(0xFF878787),
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFE0E2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
                                  icon: Icon(
                                      Icons.keyboard_arrow_down), // Özel ikon
                                  iconSize: 24, // İkon boyutu
                                  value: _selectedVehicleId,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    border: InputBorder.none,
                                    hintText: 'Araç Seçiniz...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC1C1C2),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.33,
                                    ),
                                  ),
                                  items: _vehicleItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedVehicleId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Lütfen bir araç seçin';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Şoför Seçimi
                              const Text(
                                'Şöför',
                                style: TextStyle(
                                  color: Color(0xFF878787),
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFE0E2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
                                  icon: Icon(
                                      Icons.keyboard_arrow_down), // Özel ikon
                                  iconSize: 24, // İkon boyutu
                                  value: _selectedDriverId,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    border: InputBorder.none,
                                    hintText: 'Şöför Seçiniz...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC1C1C2),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.33,
                                    ),
                                  ),
                                  items: _driverItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDriverId = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Başlangıç Tarihi
                              const Text(
                                'Başlangıç Tarihi',
                                style: TextStyle(
                                  color: Color(0xFF878787),
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFE0E2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _startDateController,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    border: InputBorder.none,
                                    hintText: 'Başlangıç Tarihi',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC1C1C2),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.33,
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 16, right: 8),
                                      child: Icon(Icons.calendar_month,
                                          size: 20, color: Color(0xFFC1C2C2)),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context, true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen başlangıç tarihi seçin';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Bitiş Tarihi
                              const Text(
                                'Bitiş Tarihi',
                                style: TextStyle(
                                  color: Color(0xFF878787),
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFE0E2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _endDateController,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    border: InputBorder.none,
                                    hintText: 'Başlangıç Tarihi',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC1C1C2),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.33,
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 16, right: 8),
                                      child: Icon(Icons.calendar_month,
                                          size: 20, color: Color(0xFFC1C2C2)),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context, false),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom buttons
                  Container(
                    height: 104,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        // Vazgeç butonu
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textDark,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                  color: AppTheme.textGrey.withAlpha(128)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Vazgeç',
                              style: AppTheme.manropeSemiBold(14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Kaydet butonu
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Kaydet',
                                    style:
                                        AppTheme.manropeSemiBold(14, Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.black.withAlpha(77),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
