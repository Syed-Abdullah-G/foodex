class FoodDetails {

FoodDetails({required this.shopname, required this.shopaddress, required this.shopnumber, required this.dateofproduce, required this.itemDescription,required this.area});

   String shopname;
   String shopaddress;
   String shopnumber;
   String dateofproduce;
   String itemDescription;
   String area;



   Map<String, String> toJson() {
    return {
      "shopname":shopname,
      "shopaddress":shopaddress,
      "shopmobile":shopnumber,
      "dateofproduce": dateofproduce,
      "itemDescription":itemDescription,

    };
   }

  

}