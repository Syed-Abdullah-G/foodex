class FoodDetails {

  FoodDetails({
    required this.shopname,
    required this.shopaddress,
    required this.shopnumber,
    required this.dateofproduce,
    required this.itemDescription,
    required this.area,
    required this.imageUrls,
    required this.price
  });


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