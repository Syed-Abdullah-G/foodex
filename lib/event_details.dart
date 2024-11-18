import 'dart:ffi';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/models/areaModel.dart';
import 'package:foodex/models/foodDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();


class AddExpenseScreen extends StatefulWidget {
    AddExpenseScreen({
    required this.shopname,
    required this.account,
    required this.shopnumber,
    required this.address
  });


  String shopname;
  String account;
  String shopnumber;
  String address;
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final priceController =  TextEditingController();
  final quantityController = TextEditingController();

  File? _imageFile;
  String? image;
  String? selectedArea;
  double price = 0;
  bool _isloading = false;
  
  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a Photo"),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() {
                      _imageFile = File(image.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _imageFile = File(image.path);
                    });
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  _createPost(File imageFile) async{

                // creating reference to the cloud storage
                final reference = storage.child(selectedArea!).child("${widget.shopname}/${imageFile.path}.png");
                // uploading the file to storage
                  await reference.putFile(imageFile);
                // obtaining download url of the image
                final imageDownloadUrl =await reference.getDownloadURL();
 
             // uploading the details along with the download URL to firestore database

            final foodDetail = FoodDetails(
                shopname: widget.shopname,
                shopaddress: widget.address,
                shopnumber: widget.shopnumber,
                dateofproduce:
                    selectedDate.toLocal().toString().split(' ')[0],
                itemDescription: descriptionController.text,
                area: selectedArea!, imageFileURL: imageDownloadUrl, price: double.parse(priceController.text), account: widget.account, quantity: double.parse(quantityController.text) );
            Map<String, dynamic> foodMap = foodDetail.toJson();

            await db
                .collection(selectedArea!)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({"fooditems": FieldValue.arrayUnion([foodMap])},SetOptions(merge: true));
          
          print("completed .........");
          Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Add new event'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Area*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              CustomDropdown.search(
                  items: Area_list,
                  hintText: "Select Area*",
                  excludeSelected: false,
                  onChanged: (value) {
                    setState(() {
                      selectedArea = value;
                    });
                  }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Date of Produce*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.toLocal()}'.split(' ')[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Item Description*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: null,
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Price*", style: TextStyle(
                fontSize: 14, color: Colors.black87,
              ),),
              const SizedBox(height: 8,),
              TextFormField(controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                ),validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a price";
                  } 
                  return null;
                },
              ),
              const SizedBox(height: 16,),

              const Text("Quantity", style: TextStyle(
                fontSize: 14, color: Colors.black87,
              ),),
              const SizedBox(height: 8,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                ), validator: (value) {
                  if (value == null || value.isNotEmpty) {
                    return "Please enter quantity";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              
              const Text(
                'File attachment*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
             
                 (_imageFile != null) ?
                 Image.file(_imageFile!,
                 height: 200,
                 fit: BoxFit.cover) 
                  : const SizedBox(),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Choose Image/ Take Photo',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.attach_file, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _imageFile !=null) {
                      setState(() {
                        _isloading = true;
                      });
                      //await call uploading logic here
                      setState(() {
                        _isloading = false;
                      });
                      Navigator.pop(context);
                    } 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child:  _isloading ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                              height: 20,
                              width: 20,
                             
                              child: CircularProgressIndicator(color: Colors.white,),
                            ),
                  ):  const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
