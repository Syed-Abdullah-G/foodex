class Userdetails {

Userdetails({required this.name, required this.shopmobilenumber, required this.shopname, required this.address});

   String name;
   String shopmobilenumber;
   String shopname;
   String address;


   Map<String, String> toJson() {
    return {
      "name":name,
      "shopnumber":shopmobilenumber,
      "shopname":shopname,
      "address": address,
    };
   }

  

}