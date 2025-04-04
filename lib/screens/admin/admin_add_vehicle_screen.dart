import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/vehicles_provider.dart';

class AdminAddVehicleScreen extends StatefulWidget {
  const AdminAddVehicleScreen({super.key});

  @override
  State<AdminAddVehicleScreen> createState() => _AdminAddVehicleScreenState();
}

class _AdminAddVehicleScreenState extends State<AdminAddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _modelYearController = TextEditingController();
  final _colorController = TextEditingController();
  
  @override
  void dispose() {
    _plateNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _modelYearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final vehiclesProvider = Provider.of<VehiclesProvider>(context, listen: false);
      
      final vehicleData = {
        'plate_number': _plateNumberController.text,
        'brand': _brandController.text,
        'model': _modelController.text,
        'model_year': int.tryParse(_modelYearController.text) ?? 0,
        'color': _colorController.text,
      };
      
      final success = await vehiclesProvider.addVehicle(vehicleData);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Araç başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vehiclesProvider.error ?? 'Araç eklenirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesProvider = Provider.of<VehiclesProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım (Başlık)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Araç Ekle",
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),
              
              // Form Alanı
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plaka alanı
                          Text(
                            "Plaka",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _plateNumberController,
                            decoration: InputDecoration(
                              hintText: "34 ABC 123",
                              hintStyle: AppTheme.interMedium(14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Plaka alanı boş bırakılamaz';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Marka alanı
                          Text(
                            "Marka",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _brandController,
                            decoration: InputDecoration(
                              hintText: "Mercedes-Benz, Ford, Volvo vb.",
                              hintStyle: AppTheme.interMedium(14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Marka alanı boş bırakılamaz';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Model alanı
                          Text(
                            "Model",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _modelController,
                            decoration: InputDecoration(
                              hintText: "Actros, FH16 vb.",
                              hintStyle: AppTheme.interMedium(14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Model Yılı alanı
                          Text(
                            "Model Yılı",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _modelYearController,
                            decoration: InputDecoration(
                              hintText: "2023",
                              hintStyle: AppTheme.interMedium(14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Model yılı boş bırakılamaz';
                              }
                              final year = int.tryParse(value);
                              if (year == null || year < 1950 || year > 2030) {
                                return 'Geçerli bir model yılı girin';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Renk alanı
                          Text(
                            "Renk",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _colorController,
                            decoration: InputDecoration(
                              hintText: "Beyaz, Kırmızı, Mavi vb.",
                              hintStyle: AppTheme.interMedium(14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Alt butonlar (Vazgeç ve Kaydet)
              Container(
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
                          side: BorderSide(color: AppTheme.textGrey.withAlpha(128)),
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
                        onPressed: vehiclesProvider.isLoading ? null : _saveVehicle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: vehiclesProvider.isLoading
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
                                style: AppTheme.manropeSemiBold(14, Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}