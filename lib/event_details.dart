import 'dart:ffi';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/models/areaModel.dart';
import 'package:foodex/models/foodDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();


class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({super.key, 
    required this.shopname,
    required this.shopnumber,
    required this.address,
  });

  String shopname;
  String shopnumber;
  String address;
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  File? _imageFile;
  final List<XFile> _selectedImages = [];
    List<String> imageUrls = [];
  String? _imageName;
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
                  final XFile? images =
                      await picker.pickImage(source: ImageSource.camera);

                  if (images != null) {
                    setState(() {
                      _selectedImages.add(images);
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
                  final XFile? images =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (images != null) {
                    setState(() {
                      _selectedImages.add(images);
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
              TextFormField(
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
                },onChanged: (value) {
            setState(() {
              price = double.parse(value);
            });
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
              _selectedImages.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      children: _selectedImages
                          .map(
                            (image) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.remove(image);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList(),
                    )
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
                    setState(() {
                      _isloading = !_isloading;
                    });
                      imageUrls = [];
                    
                    if (_formKey.currentState!.validate()) {
                          for (XFile item in _selectedImages){
                          final reference = storage.child(selectedArea!).child("${widget.shopname}/${item.path}.png");
                            await reference.putFile(File(item.path));
                          final imageDownloadUrl =await storage.child(selectedArea!).child("${widget.shopname}/${item.path}.png").getDownloadURL();
                          imageUrls.add(imageDownloadUrl);
                    print("download urls updated");
                          }


                      final foodDetail = FoodDetails(
                          shopname: widget.shopname,
                          shopaddress: widget.address,
                          shopnumber: widget.shopnumber,
                          dateofproduce:
                              selectedDate.toLocal().toString().split(' ')[0],
                          itemDescription: descriptionController.text,
                          area: selectedArea!, imageUrls: imageUrls, price: price);
                      Map<String, dynamic> foodMap = foodDetail.toJson();
          
                    print("created mapping for food");
                      await db
                          .collection(selectedArea!)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({"fooditems": FieldValue.arrayUnion([foodMap])},SetOptions(merge: true));
                    }
                    print("completed .........");
                    Navigator.pop(context);
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
                             
                              child: CircularProgressIndicator(),
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
