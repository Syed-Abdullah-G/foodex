class Userdetails {

  Userdetails({
    required this.account,
    required this.shopmobilenumber,
    required this.shopname,
    required this.address,
    required this.imagePath
  });


   String account;
   String shopmobilenumber;
   String shopname;
   String address;
   String imagePath;


   Map<String, String> toJson() {
    return {
      "account":account,
      "shopnumber":shopmobilenumber,
      "shopname":shopname,
      "address": address,
      "imagePath": imagePath
    };
   }

  

}