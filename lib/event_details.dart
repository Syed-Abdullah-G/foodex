import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodex/models/areaModel.dart';
import 'package:foodex/models/foodDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();

const _list = [
  "Adyar", "T Nagar", "Royapettah", "Anna Nagar", "Guindy", "Thousand Lights"
];

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({
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
  List<XFile> _selectedImages = [];
    List<String> imageUrls = [];
  String? _imageName;
  String? selectedArea;

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Take a Photo"),
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
                leading: Icon(Icons.photo_library),
                title: Text("Choose from Gallery"),
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
        leading: BackButton(),
        title: Text('Add new expense'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Area*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              CustomDropdown.search(
                  items: _list,
                  hintText: "Select Area*",
                  excludeSelected: false,
                  onChanged: (value) {
                    setState(() {
                      selectedArea = value;
                    });
                  }),
              SizedBox(
                height: 8,
              ),
              Text(
                'Date of Produce*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${selectedDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Item Description*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                maxLines: null,
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              Text(
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
                                    child: Icon(
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
                  : SizedBox(),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
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
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    print("Process started");
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
                          area: selectedArea!, imageUrls: imageUrls);
                      Map<String, dynamic> foodMap = foodDetail.toJson();
          
                    print("created mapping for food");
                      await db
                          .collection("area")
                          .doc(selectedArea!).collection(widget.shopname).doc("food_items")
                          .set(foodMap);
                    }
                    print("completed .........");
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
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
