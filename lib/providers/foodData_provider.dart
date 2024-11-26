import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodex/models/foodDetails.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:foodex/models/paymentFood.dart';

part "foodData_provider.g.dart";


@riverpod
class FoodNotifier extends _$FoodNotifier {

  //initial value
  @override
   List<PaymentFoodDetails> build() {
    return [
      PaymentFoodDetails(Order_Id: "", Total_Amount: "", Transfers_1_id: "", Transfers_1_amount: "", Transfers_1_notes: "")
  ];
  }

  //methods to update state
  void updateFoodDetail(PaymentFoodDetails details){
    state = [details];
  }

   String showData() {
    return state[0].Order_Id;
  }
}
