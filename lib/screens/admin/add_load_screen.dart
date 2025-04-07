import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/load_model.dart';
import '../../utils/logger.dart';

class AddLoadScreen extends StatefulWidget {
  final int?
      tripId; // Eğer bir sefer detayından açılıyorsa, sefere yük eklemek için

  const AddLoadScreen({super.key, this.tripId});

  @override
  State<AddLoadScreen> createState() => _AddLoadScreenState();
}

class _AddLoadScreenState extends State<AddLoadScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form değişkenleri
  String? customerId;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loadNameController = TextEditingController();
  final TextEditingController _quantityController =
      TextEditingController(text: "0.00");
  String? unit;
  DateTime? loadingDate;
  DateTime? deliveryDate;
  final TextEditingController _priceController =
      TextEditingController(text: "0.00");

  // Birim seçenekleri listesi
  final List<String> _unitOptions = [
    'Kg',
    'Ton',
    'Adet',
    'Paket',
    'Palet',
    'Kutu',
    'Metre',
    'Metreküp'
  ];

  // Örnek müşteri listesi - Gerçek uygulamada API'den çekilir
  final List<Map<String, String>> _customerList = [
    {'id': '1', 'name': 'Gediz Ekol Madencilik'},
    {'id': '2', 'name': 'Koç Holding'},
    {'id': '3', 'name': 'Eczacıbaşı'},
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _loadNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Tarih seçimi için dialog
  Future<void> _selectDate(BuildContext context, bool isLoadingDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isLoadingDate
          ? loadingDate ?? DateTime.now()
          : deliveryDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06263E),
              onPrimary: Colors.white,
              onSurface: Color(0xFF474747),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF06263E),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isLoadingDate) {
          loadingDate = picked;
        } else {
          deliveryDate = picked;
        }
      });
    }
  }

  // Yük kaydetme işlemi
  Future<void> _saveLoad() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        logger.d("Yük kaydetme işlemi başlatıldı");

        // Yeni load nesnesi oluştur
        final newLoad = Load(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _loadNameController.text,
          description: _loadNameController.text,
          weight: 0.0,
          type: 'Genel Kargo',
          customerId: int.tryParse(customerId ?? '0'),
          customerName: _customerNameController.text,
          phoneNumber: _phoneNumberController.text,
          email: _emailController.text,
          quantity: double.tryParse(_quantityController.text) ?? 0.0,
          unit: unit,
          loadingDate: loadingDate?.toIso8601String(),
          deliveryDate: deliveryDate?.toIso8601String(),
          price: double.tryParse(_priceController.text) ?? 0.0,
        );

        logger.d("Oluşturulan yük: ${newLoad.toJson()}");

        // API çağrısı buraya gelecek
        await Future.delayed(
            const Duration(seconds: 1)); // API çağrısı simülasyonu

        // Başarılı olursa
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yük başarıyla kaydedildi'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(
              context, newLoad); // Önceki ekrana dönüş ve yeni yükü döndür
        }
      } catch (e) {
        logger.e("Yük kaydedilirken hata: $e");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yük kaydedilirken hata oluştu: $e'),
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
    return Scaffold(
      body: Form(
        key: _formKey,
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
                    colors: const [
                      Color(0xFF06263E),
                      Color(0xFF10344F),
                      Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // Main Container (Rounded corners)
            Positioned(
              left: 0,
              top: 115,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 115,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8F8F8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Bar for Buttons
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 104,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Vazgeç Butonu
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Vazgeç',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF474747),
                          fontSize: 18,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),

                    // Kaydet Butonu
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveLoad,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF06263E),
                        minimumSize: const Size(180, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Kaydet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Title
            Positioned(
              left: 19,
              top: 67,
              child: const Text(
                'Yük Ekle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.09,
                ),
              ),
            ),

            // Form Content - Scrollable
            Positioned(
              left: 0,
              top: 115,
              right: 0,
              bottom: 104, // Bottom bar height
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 19),

                      // Müşteri
                      _buildFieldLabel('Müşteri'),
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
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: customerId,
                              hint: const Text(
                                'Müşteri Seçiniz...',
                                style: TextStyle(
                                  color: Color(0xFFC1C1C2),
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF474747),
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Color(0xFF06263E)),
                              items: _customerList.map((customer) {
                                return DropdownMenuItem<String>(
                                  value: customer['id'],
                                  child: Text(
                                    customer['name']!,
                                    style: const TextStyle(
                                      color: Color(0xFF474747),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  customerId = value;

                                  // Seçilen müşteriye göre isim alanı doldurulur
                                  if (value != null) {
                                    final selectedCustomer =
                                        _customerList.firstWhere((customer) =>
                                            customer['id'] == value);
                                    _customerNameController.text =
                                        selectedCustomer['name'] ?? '';
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // Müşteri Adı
                      _buildFieldLabel('Müşteri Adı'),
                      _buildTextField(
                        controller: _customerNameController,
                        hintText: 'Müşteri Adı',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Müşteri adı gereklidir';
                          }
                          return null;
                        },
                      ),

                      // Telefon Numarası
                      _buildFieldLabel('Telefon Numarası'),
                      _buildTextField(
                        controller: _phoneNumberController,
                        hintText: 'Telefon Numarası',
                        keyboardType: TextInputType.phone,
                      ),

                      // Mail Adresi
                      _buildFieldLabel('Mail Adresi'),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Mail Adresi',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // Yük Bilgileri Başlığı
                      const SizedBox(height: 20),
                      const Text(
                        'Yük Bilgileri',
                        style: TextStyle(
                          color: Color(0xFF0D2F49),
                          fontSize: 19,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.26,
                        ),
                      ),

                      // Yük Adı
                      _buildFieldLabel('Yük Adı'),
                      _buildTextField(
                        controller: _loadNameController,
                        hintText: 'Yük Adı',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Yük adı gereklidir';
                          }
                          return null;
                        },
                      ),

                      // Adet ve Birim
                      Row(
                        children: [
                          // Adet
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Adet'),
                                _buildTextField(
                                  controller: _quantityController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  width: 185,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 19),
                          // Birim
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Birim'),
                                Container(
                                  width: 185,
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
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: unit,
                                        hint: const Text(
                                          'Seçiniz',
                                          style: TextStyle(
                                            color: Color(0xFFC1C1C2),
                                            fontSize: 18,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w600,
                                            height: 1.33,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF474747),
                                          fontSize: 18,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w600,
                                          height: 1.33,
                                        ),
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Color(0xFF06263E)),
                                        items: _unitOptions.map((unit) {
                                          return DropdownMenuItem<String>(
                                            value: unit,
                                            child: Text(
                                              unit,
                                              style: const TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 18,
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            unit = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Yükleme Tarihi
                      _buildFieldLabel('Yükleme Tarihi'),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFFC1C1C2),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                loadingDate != null
                                    ? DateFormat('dd.MM.yyyy')
                                        .format(loadingDate!)
                                    : 'Yükleme Tarihi',
                                style: TextStyle(
                                  color: loadingDate != null
                                      ? const Color(0xFF474747)
                                      : const Color(0xFFC1C1C2),
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Teslimat Tarihi
                      _buildFieldLabel('Teslimat Tarihi'),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFFC1C1C2),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                deliveryDate != null
                                    ? DateFormat('dd.MM.yyyy')
                                        .format(deliveryDate!)
                                    : 'Teslimat Tarihi',
                                style: TextStyle(
                                  color: deliveryDate != null
                                      ? const Color(0xFF474747)
                                      : const Color(0xFFC1C1C2),
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tutar
                      _buildFieldLabel('Tutar'),
                      _buildTextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        width: 185,
                        suffix: const Text(
                          '₺',
                          style: TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 18,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Back button (optional)
            Positioned(
              left: 16,
              top: 16,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_left,
                        color: Color(0xFF06263E),
                        size: 26,
                      ),
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

  // Alan etiketi widgetı
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF878787),
          fontSize: 15,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.60,
        ),
      ),
    );
  }

  // Text field widgetı
  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    double? width,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: width ?? double.infinity,
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
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          color: Color(0xFF474747),
          fontSize: 18,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFC1C1C2),
            fontSize: 18,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
          suffixIcon: suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: suffix,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
