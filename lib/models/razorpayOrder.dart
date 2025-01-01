
class RazorpayOrderState {
  final String? orderId;
  final int? amount;
  final List<dynamic>? transfers;
  final String? status;
  final int? quantitypurchased;
  final String? itemDescription;
  final String? area;
  final String? userid;
  final int? shopprice;
  final String? shopname;
  final String? shopuid;

    RazorpayOrderState({
    this.orderId,
    this.amount,
    this.transfers,
    this.status,
    this.quantitypurchased,
    this.itemDescription,
    this.area,
    this.userid,
    this.shopprice,
    this.shopname,
    this.shopuid,

  });


RazorpayOrderState copyWith({
   String? orderId,
    int? amount,
    List<dynamic>? transfers,
    String? status,
    int? quantitypurchased,
    String? itemDescription,
    String? area,
    String? userid,
    int? shopprice,
    String? shopname,
    String? shopuid,

}) {
   return RazorpayOrderState(
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      transfers: transfers ?? this.transfers,
      status: status ?? this.status,
      quantitypurchased: quantitypurchased ?? this.quantitypurchased,
      itemDescription: itemDescription ?? this.itemDescription,
      area: area ?? this.area,
      userid: userid ?? this.userid,
      shopprice: shopprice ?? this.shopprice,
      shopname: shopname ?? this.shopname,
      shopuid: shopuid ?? this.shopuid,
    );
}



}