class FoodDetails {

    FoodDetails({
    required this.account,
    required this.shopname,
    required this.shopaddress,
    required this.shopnumber,
    required this.dateofproduce,
    required this.itemDescription,
    required this.area,
    required this.imageUrls,
    required this.price
  });


  String account;
   String shopname;
   String shopaddress;
   String shopnumber;
   String dateofproduce;
   String itemDescription;
   String area;
   List imageUrls;
   double price;



   Map<String, dynamic> toJson() {
    return {
      "account": account,
      "shopname":shopname,
      "shopaddress":shopaddress,
      "shopmobile":shopnumber,
      "dateofproduce": dateofproduce,
      "itemDescription":itemDescription,
      "imageUrls": imageUrls,
      "price": price
    };
   }

  

}