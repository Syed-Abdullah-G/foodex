class OrdersModel {
      OrdersModel({
    required this.dateOfProduce,
    required this.itemDescription,
    required this.quantity,
    required this.shopname,
    required this.totalPrice
  });

String dateOfProduce;
String itemDescription;
String quantity;
String shopname;
String totalPrice;


Map<String, dynamic> toJson() {
  return {
    "dateofproduce":dateOfProduce,
    "itemdescription": itemDescription,
    "quantity": quantity,
    "shopname": shopname,
    "totalprice": totalPrice
  };
}

}