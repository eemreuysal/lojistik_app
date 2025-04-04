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
  List<DropdownMenuItem<int>> _customerItems = [];
  
  final bool _isLoading = false;  // final olarak işaretlendi
  
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
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? _startDate ?? DateTime.now()),
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
        'end_date': _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null,
        'vehicle': _selectedVehicleId,
        'driver': _selectedDriverId,
        'customer': _selectedCustomerId,
      };
      
      // Not: API üzerinden kaydet - tripData gönderilecek
      debugPrint('Gönderilecek veri: $tripData');  // Debug için
      
      // Go back to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sefer Oluştur',
          style: AppTheme.manropeSemiBold(20, Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Column(
          children: [
            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sefer Bilgileri',
                                style: AppTheme.manropeBold(18),
                              ),
                              const SizedBox(height: 24),
                              
                              // Başlangıç Tarihi
                              TextFormField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Başlangıç Tarihi',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
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
                              const SizedBox(height: 16),
                              
                              // Bitiş Tarihi
                              TextFormField(
                                controller: _endDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Bitiş Tarihi',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () => _selectDate(context, false),
                              ),
                              const SizedBox(height: 16),
                              
                              // Araç Seçimi
                              DropdownButtonFormField<int>(
                                value: _selectedVehicleId,
                                decoration: const InputDecoration(
                                  labelText: 'Araç',
                                  prefixIcon: Icon(Icons.directions_car),
                                  border: OutlineInputBorder(),
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
                              const SizedBox(height: 16),
                              
                              // Şoför Seçimi
                              DropdownButtonFormField<int>(
                                value: _selectedDriverId,
                                decoration: const InputDecoration(
                                  labelText: 'Şoför',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                items: _driverItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDriverId = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // Müşteri Seçimi
                              DropdownButtonFormField<int>(
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
                              const SizedBox(height: 32),
                              
                              // Butonlar
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppTheme.textDark,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: BorderSide(color: AppTheme.textGrey.withAlpha(128)),  // withOpacity(0.5) yerine withAlpha kullanıldı
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
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryDark,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Oluştur',
                                        style: AppTheme.manropeSemiBold(14, Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}