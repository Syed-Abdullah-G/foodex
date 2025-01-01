import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/api/razorpayApiCall2.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/widgets/textfield.dart';
import 'package:google_fonts/google_fonts.dart';

class GetShopDetails1 extends StatefulWidget {
  const GetShopDetails1({super.key});

  @override
  State<GetShopDetails1> createState() => _GetShopDetails1State();
}

class _GetShopDetails1State extends State<GetShopDetails1> {
  final contact_name = TextEditingController();
  final account_number = TextEditingController();
  final ifsc_code = TextEditingController();
  final beneficiary_name = TextEditingController();
  String subcategory = "";
  String shopType = "";
    bool isLoading = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contact_name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Text(
                  "Choose Business Type",
                  style: GoogleFonts.poppins(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Restaurant',
                        style: TextStyle(
                          color: shopType == "restaurant" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "restaurant",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "restaurant";
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Dairy Products',
                        style: TextStyle(
                          color: shopType == "dairy_products" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "dairy_products",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "dairy_products";
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Bakery',
                        style: TextStyle(
                          color: shopType == "bakery" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "bakery",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "bakery";
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Bank Details",
                  style: GoogleFonts.poppins(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                getTextField2("Account Number", account_number),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("IFSC Code", ifsc_code),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("Beneficiary Name", beneficiary_name),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      const razorpayId = "acc_PGXA5GFiAwFfLD";

                        if (shopType.isEmpty || account_number.text.isEmpty || ifsc_code.text.isEmpty || beneficiary_name.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all the details')),
                          );
                        } else {

                          try{
                             showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

                         await RazorpayHandler().initiateRazorpayProcess(razorpayId: razorpayId, email: email, phone: phone, businessName: businessName, accountNumber: accountNumber, ifscCode: ifscCode, beneficiaryName: beneficiaryName, contactName: contactName, businessType: businessType, area: area, pan: pan, gst: gst)

                          } catch (e) {}


                         
                     
                        }
                     
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(purpleColor),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: WidgetStateProperty.all(TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : 
                                Image.asset("assets/userPhoto/google_logo.png")
                             ,
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("Create Account")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
