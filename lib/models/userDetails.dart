class Userdetails {

      Userdetails({
    required this.account,
    required this.uid,
    required this.shopmobilenumber,
    required this.shopname,
    required this.address,
    required this.area,
    required this.accountType,
    required this.email,
  });




   String account;
   String uid;
   String shopmobilenumber;
   String shopname;
   String address;
   String area;
   String accountType;
   String email;


   Map<String, String> toJson() {
    return {
      "account":account,
      "uid":uid,
      "shopnumber":shopmobilenumber,
      "shopname":shopname,
      "address": address,
      "area": area,
      "accountType": accountType,
      "email": email,
    };
   }

  

}