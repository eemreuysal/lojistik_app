import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<DropdownMenuItem<int>> _customerItems = [];

  final bool _isLoading = false;

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

    _customerItems = [
      const DropdownMenuItem(value: 1, child: Text('ABC Şirketi')),
      const DropdownMenuItem(value: 2, child: Text('XYZ Şirketi')),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, submit data
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

      // Not: API üzerinden kaydet - tripData gönderilecek
      debugPrint('Gönderilecek veri: $tripData'); // Debug için

      // Go back to previous screen
      Navigator.pop(context);
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
                                      color: Color(0xFFDFE2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
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
                              const SizedBox(height: 20),

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
                                      color: Color(0xFFDFE2E3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
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
                              const SizedBox(height: 20),

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
                                      color: Color(0xFFDFE2E3),
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
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 16, right: 8),
                                      child: Icon(Icons.calendar_today,
                                          size: 20, color: Color(0xFF474747)),
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
                              const SizedBox(height: 20),

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
                                      color: Color(0xFFDFE2E3),
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
                                    ),
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 16, right: 8),
                                      child: Icon(Icons.calendar_today,
                                          size: 20, color: Color(0xFF474747)),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context, false),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Müşteri Seçimi (saklı) - Figma'da yok ama işlevsellik için korundu
                              Opacity(
                                opacity: 0,
                                child: DropdownButtonFormField<int>(
                                  value: _selectedCustomerId,
                                  decoration: const InputDecoration(
                                    labelText: 'Müşteri',
                                    prefixIcon: Icon(Icons.business),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _customerItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCustomerId = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom buttons
                  Container(
                    height: 104,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Vazgeç button
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Vazgeç',
                            style: TextStyle(
                              color: Color(0xFF474747),
                              fontSize: 18,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                        ),

                        // Kaydet button
                        Container(
                          width: 152,
                          height: 48,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, 0.00),
                              end: Alignment(1.00, 1.00),
                              colors: [
                                Color(0xFF06263E),
                                Color(0xFF10344F),
                                Color(0xFF1E485C)
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: TextButton(
                            onPressed: _submitForm,
                            child: const Text(
                              'Kaydet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
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
                color: Colors.black.withOpacity(0.3),
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
