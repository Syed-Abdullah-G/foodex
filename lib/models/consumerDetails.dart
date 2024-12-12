import 'package:http/retry.dart';

class Consumerdetails {
  Consumerdetails({
    required this.name,
    required this.mobile,
    required this.uid,
    required this.area,
    required this.email,
  });

  String name;
  String mobile;
  String area;
  String uid;
  String email;

  Map<String, String> toJson() {
    return {
      "name": name,
      "shopnumber": mobile,
      "area": area,
      "uid": uid,
      "email": email,
    };
  }
}
