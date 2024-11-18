
class FoodDetails {

      FoodDetails({
    required this.account,
    required this.shopname,
    required this.shopaddress,
    required this.shopnumber,
    required this.dateofproduce,
    required this.itemDescription,
    required this.area,
    required this.imageFileURL,
    required this.price,
    required this.quantity
  });



  String account;
   String shopname;
   String shopaddress;
   String shopnumber;
   String dateofproduce;
   String itemDescription;
   String area;
   String imageFileURL;
   double price;
   double quantity;



   Map<String, dynamic> toJson() {
    return {
      "account": account,
      "shopname":shopname,
      "shopaddress":shopaddress,
      "shopmobile":shopnumber,
      "dateofproduce": dateofproduce,
      "itemDescription":itemDescription,
      "imageFileURL": imageFileURL,
      "price": price,
      "quantity": quantity
    };
   }

  

}