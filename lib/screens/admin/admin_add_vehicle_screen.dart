import 'package:flutter/material.dart';
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
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();

  // Yeni değişkenler
  DateTime? _selectedModelYear;
  String? _selectedBrand;

  // Marka listesi
  final List<String> brands = [
    'Mercedes-Benz',
    'Volvo',
    'Scania',
    'MAN',
    'DAF',
    'Renault',
    'Iveco',
    'Ford Trucks',
    'BMC',
    'Diğer'
  ];

  @override
  void dispose() {
    _plateNumberController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // Yıl seçme fonksiyonu
  Future<void> _selectYear(BuildContext context) async {
    // Mevcut yıl
    final int currentYear = DateTime.now().year;

    // Kullanıcının şu anki seçimi veya varsayılan olarak günümüz
    int selectedYear = _selectedModelYear?.year ?? currentYear;

    // Özel bir yıl seçici göstermek için dialog kullan
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Model Yılı Seçin'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: currentYear - 1950 + 1, // 1950'den günümüze
              itemBuilder: (context, index) {
                final int year = currentYear - index;
                return ListTile(
                  title: Text(
                    year.toString(),
                    style: TextStyle(
                      fontWeight: year == selectedYear
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: year == selectedYear
                          ? AppTheme.primaryDark
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedModelYear = DateTime(year);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final vehiclesProvider =
          Provider.of<VehiclesProvider>(context, listen: false);

      final vehicleData = {
        'plate_number': _plateNumberController.text,
        'brand': _selectedBrand ?? '',
        'model': _modelController.text,
        'model_year': _selectedModelYear?.year ?? DateTime.now().year,
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
            content: Text(
                vehiclesProvider.error ?? 'Araç eklenirken bir hata oluştu'),
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
      body: Stack(
        children: [
          // Arka plan gradient
          Container(
            width: 430,
            height: 534,
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),

          // Ana içerik
          SafeArea(
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

                // Form Alanı (beyaz arka plan)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                              "Araç Plakası",
                              style: AppTheme.manropeRegular(14, Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _plateNumberController,
                              decoration: InputDecoration(
                                hintText: "Araç Plakası",
                                hintStyle: AppTheme.interMedium(
                                    14, Colors.grey.withAlpha(153)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withAlpha(77)),
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

                            // Yeni satır - Marka ve Model Yılı yan yana
                            Row(
                              children: [
                                // Model Yılı seçici
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Model Yılı",
                                        style: AppTheme.manropeRegular(
                                            14, Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectYear(context),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.withAlpha(77),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _selectedModelYear != null
                                                        ? _selectedModelYear!
                                                            .year
                                                            .toString()
                                                        : "Yıl Seçiniz",
                                                    style: _selectedModelYear !=
                                                            null
                                                        ? AppTheme.interMedium(
                                                            14, Colors.black)
                                                        : AppTheme.interMedium(
                                                            14,
                                                            Colors.grey
                                                                .withAlpha(
                                                                    153)),
                                                  ),
                                                ],
                                              ),
                                              const Icon(Icons.arrow_drop_down,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Marka dropdown
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Marka",
                                        style: AppTheme.manropeRegular(
                                            14, Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withAlpha(77),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedBrand,
                                            hint: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Text(
                                                "Seçiniz...",
                                                style: AppTheme.interMedium(14,
                                                    Colors.grey.withAlpha(153)),
                                              ),
                                            ),
                                            icon: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 16),
                                              child:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                            isExpanded: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedBrand = newValue;
                                              });
                                            },
                                            items: brands
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Text(
                                                    value,
                                                    style: AppTheme.interMedium(
                                                        14),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                hintStyle: AppTheme.interMedium(
                                    14, Colors.grey.withAlpha(153)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withAlpha(77)),
                                ),
                              ),
                            ),

                            // Boşluk ekleyerek alt butonlar için yer açalım
                            const SizedBox(height: 60),
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
                          onPressed:
                              vehiclesProvider.isLoading ? null : _saveVehicle,
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
                                  style: AppTheme.manropeSemiBold(
                                      14, Colors.white),
                                ),
                        ),
                      ),
                    ],
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
