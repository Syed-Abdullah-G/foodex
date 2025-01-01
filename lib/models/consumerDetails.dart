
class Consumerdetails {
  Consumerdetails({
    required this.name,
    required this.mobile,
    required this.uid,
    required this.area,
    required this.email,
    required this.orders,
  });

  String name;
  String mobile;
  String area;
  String uid;
  String email;
  String orders;

  Map<String, String> toJson() {
    return {
      "name": name,
      "shopnumber": mobile,
      "area": area,
      "uid": uid,
      "email": email,
      "orders": orders,
    };
  }
}
