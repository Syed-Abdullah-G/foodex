
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodex/models/foodDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();


class event_details extends StatefulWidget {
    event_details({super.key, 
    required this.shopname,
    required this.account,
    required this.shopnumber,
    required this.address,
    required this.userid,
  });


  String shopname;
  String account;
  String shopnumber;
  String address;
  String userid;
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<event_details> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final priceController =  TextEditingController();
  final quantityController = TextEditingController();

  File? _imageFile;
  String? image;
  int price = 0;
  String areaName = "";
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
                final reference = storage.child(areaName).child("${widget.shopname}/${imageFile.path}.png");
                // uploading the file to storage
                  await reference.putFile(imageFile);
                // obtaining download url of the image
                final imageDownloadUrl =await reference.getDownloadURL();
 
             // uploading the details along with the download URL to firestore database

             //price added with commission
double price = double.parse(priceController.text) * 1.07;
int wholePrice = price.round();



            final foodDetail = FoodDetails(
                shopname: widget.shopname,
                shopaddress: widget.address,
                shopnumber: widget.shopnumber,
                dateofproduce:
                    selectedDate.toLocal().toString().split(' ')[0],
                itemDescription: descriptionController.text,
                area: areaName, imageFileURL: imageDownloadUrl,account: widget.account, quantity: int.parse(quantityController.text) ,userid: widget.userid, shopprice: int.parse(priceController.text));
            Map<String, dynamic> foodMap = foodDetail.toJson();

            await db
                .collection(areaName)
                .doc(widget.userid)
                .set({"fooditems": FieldValue.arrayUnion([foodMap])},SetOptions(merge: true));
          

          Navigator.pop(context);
  }


  Future getUserData() async {

SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
 setState(() {
  areaName = sharedPreferences.getString("area")!;
});

}


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Post Food'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:  BorderRadius.circular(4),
                  ), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(areaName),
                ),
            
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
            
                const Text("Total Quantity", style: TextStyle(
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
                    if (value == null || value.trim().isEmpty) {
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
                        await _createPost(_imageFile!);
                       
                        
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
      ),
    );
  }
}
