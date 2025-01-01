import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleIDProvider extends StateNotifier<String> {
  GoogleIDProvider() : super(''); // Initialize with an empty string or a default value

  // Method to update order details
  void updateId(String id) {
    state = id;
  }

  String getId() {
    return state;
  }
}

final googleIDProvider = StateNotifierProvider<GoogleIDProvider, String>((ref) {
  return GoogleIDProvider();
});