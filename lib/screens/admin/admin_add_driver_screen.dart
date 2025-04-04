import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/drivers_provider.dart';

class AdminAddDriverScreen extends StatefulWidget {
  const AdminAddDriverScreen({super.key});

  @override
  State<AdminAddDriverScreen> createState() => _AdminAddDriverScreenState();
}

class _AdminAddDriverScreenState extends State<AdminAddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _saveDriver() async {
    if (_formKey.currentState!.validate()) {
      final driversProvider =
          Provider.of<DriversProvider>(context, listen: false);

      final driverData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _phoneController.text,
        'national_id': _nationalIdController.text,
        'is_active': true,
      };

      final success = await driversProvider.addDriver(driverData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şoför başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                driversProvider.error ?? 'Şoför eklenirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final driversProvider = Provider.of<DriversProvider>(context);

    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Background gradient
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 430,
                height: 534,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, 0.00),
                    end: Alignment(1.00, 1.00),
                    colors: [
                      const Color(0xFF06263E),
                      const Color(0xFF10344F),
                      const Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // Light gray background
            Positioned(
              left: 0,
              top: 115,
              child: Container(
                width: 430,
                height: 822,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8F8F8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // White bottom bar
            Positioned(
              left: 0,
              top: 828,
              child: Container(
                width: 430,
                height: 104,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // Title
            Positioned(
              left: 19,
              top: 67,
              child: Text(
                'Şoför Ekle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.09,
                ),
              ),
            ),

            // Form ve form elemanları
            Positioned(
              left: 0,
              top: 115,
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: 430,
                  height: 700,
                  child: Stack(
                    children: [
                      // First name label
                      Positioned(
                        left: 19,
                        top: 14,
                        child: SizedBox(
                          width: 184.79,
                          child: Text(
                            'Adı',
                            style: TextStyle(
                              color: const Color(0xFF878787),
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ),
                      ),

                      // First name field
                      Positioned(
                        left: 19,
                        top: 42,
                        child: Container(
                          width: 189.92,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ad alanı boş bırakılamaz';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Adı',
                              hintStyle: TextStyle(
                                color: const Color(0xFFC1C1C2),
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Last name label
                      Positioned(
                        left: 223,
                        top: 14,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'Soyadı',
                            style: TextStyle(
                              color: const Color(0xFF878787),
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ),
                      ),

                      // Last name field
                      Positioned(
                        left: 223,
                        top: 42,
                        child: Container(
                          width: 185,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Soyad alanı boş bırakılamaz';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Soyadı',
                              hintStyle: TextStyle(
                                color: const Color(0xFFC1C1C2),
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Phone label
                      Positioned(
                        left: 19,
                        top: 102,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'Telefon Numarası',
                            style: TextStyle(
                              color: const Color(0xFF878787),
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ),
                      ),

                      // Phone field
                      Positioned(
                        left: 19,
                        top: 130,
                        child: Container(
                          width: 384,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Telefon numarası boş bırakılamaz';
                              } else if (value.length < 10) {
                                return 'Geçerli bir telefon numarası girin';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Telefon Numarası',
                              hintStyle: TextStyle(
                                color: const Color(0xFFC1C1C2),
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // National ID label
                      Positioned(
                        left: 19,
                        top: 190,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'TC Kimlik No',
                            style: TextStyle(
                              color: const Color(0xFF878787),
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ),
                      ),

                      // National ID field
                      Positioned(
                        left: 19,
                        top: 218,
                        child: Container(
                          width: 384,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _nationalIdController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              // TC Kimlik No opsiyonel
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.length != 11) {
                                return 'TC kimlik numarası 11 haneli olmalıdır';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'TC Kimlik No',
                              hintStyle: TextStyle(
                                color: const Color(0xFFC1C1C2),
                                fontSize: 18,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            // Cancel button
            Positioned(
              left: 26,
              top: 850,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 179,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE0E2E3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Vazgeç',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF474747),
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Save button
            Positioned(
              left: 225,
              top: 850,
              child: GestureDetector(
                onTap: driversProvider.isLoading ? null : _saveDriver,
                child: Container(
                  width: 179,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.00),
                      end: Alignment(1.00, 1.00),
                      colors: [
                        const Color(0xFF06263E),
                        const Color(0xFF10344F),
                        const Color(0xFF1E485C)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: driversProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
