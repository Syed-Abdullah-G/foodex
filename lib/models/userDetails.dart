class Userdetails {

  Userdetails({
    required this.name,
    required this.shopmobilenumber,
    required this.shopname,
    required this.address,
    required this.imagePath
  });


   String name;
   String shopmobilenumber;
   String shopname;
   String address;
   String imagePath;


   Map<String, String> toJson() {
    return {
      "name":name,
      "shopnumber":shopmobilenumber,
      "shopname":shopname,
      "address": address,
      "imagePath": imagePath
    };
   }

  

}