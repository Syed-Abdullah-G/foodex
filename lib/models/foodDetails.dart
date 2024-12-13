
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
    required this.quantity,
    required this.userid,
    required this.shopprice,
  });





  String account;
   String shopname;
   String shopaddress;
   String shopnumber;
   String dateofproduce;
   String itemDescription;
   String area;
   String imageFileURL;
   int quantity;
   String userid;
   int shopprice;



   Map<String, dynamic> toJson() {
    return {
      "account": account,
      "shopname":shopname,
      "shopaddress":shopaddress,
      "shopmobile":shopnumber,
      "dateofproduce": dateofproduce,
      "itemDescription":itemDescription,
      "imageFileURL": imageFileURL,
      "quantity": quantity,
      "userid": userid,
      "shopprice":shopprice,
    };
   }

  

}