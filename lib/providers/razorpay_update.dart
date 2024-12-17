import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodex/models/razorpayOrder.dart';




class RazorpayOrderNotifier extends StateNotifier<RazorpayOrderState> {
  RazorpayOrderNotifier() : super(RazorpayOrderState());

  // Method to update order details
  void updateOrderDetails(Map<String, dynamic> orderResponse, int quantitypurchased, String itemdescription, String area, String userid, int shopprice, String shopname) {
    state = RazorpayOrderState(
      orderId: orderResponse['id'],
      amount: orderResponse['amount'],
      transfers: orderResponse['transfers'],
      status: orderResponse['status'] ?? 'created',
      quantitypurchased: quantitypurchased,
      itemDescription: itemdescription,
      area: area,
      userid: userid,
      shopprice: shopprice,
      shopname: shopname

    );
  }

  // Method to reset the state
  void resetOrderDetails() {
    state = RazorpayOrderState();
  }
}

final razorpayOrderProvider = StateNotifierProvider<RazorpayOrderNotifier, RazorpayOrderState>((ref) {
  return RazorpayOrderNotifier();
});