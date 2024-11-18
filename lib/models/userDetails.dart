class Userdetails {

  Userdetails({
    required this.account,
    required this.shopmobilenumber,
    required this.shopname,
    required this.address,
    required this.profileImage
  });


   String account;
   String shopmobilenumber;
   String shopname;
   String address;
   String profileImage;


   Map<String, String> toJson() {
    return {
      "account":account,
      "shopnumber":shopmobilenumber,
      "shopname":shopname,
      "address": address,
      "profileImage": profileImage
    };
   }

  

}