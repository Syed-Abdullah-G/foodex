class Areamodel {
  Areamodel({required this.area});
  final String area;

  
  
  @override
  String toString() {
    return area;
  }

  bool filter(String query) {
    return area.toLowerCase().contains(query.toLowerCase());
  }

}