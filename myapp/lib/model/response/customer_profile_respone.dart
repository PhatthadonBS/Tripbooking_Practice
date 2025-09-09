// To parse this JSON data, do
//
//     final customerProfileRespones = customerProfileResponesFromJson(jsonString);

import 'dart:convert';

CustomerProfileRespones customerProfileResponesFromJson(String str) =>
    CustomerProfileRespones.fromJson(json.decode(str));

String customerProfileResponesToJson(CustomerProfileRespones data) =>
    json.encode(data.toJson());

class CustomerProfileRespones {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomerProfileRespones({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomerProfileRespones.fromJson(Map<String, dynamic> json) =>
      CustomerProfileRespones(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}
