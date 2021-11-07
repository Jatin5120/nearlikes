// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.customer,
  });

  CustomerClass customer;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customer: CustomerClass.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "customer": customer.toJson(),
  };
}

class CustomerClass {
  CustomerClass({
    this.active,
    this.blocked,
    this.referal,
    this.associations,
    this.tags,
    this.createdAt,
    this.id,
    this.coupons,
    this.cashback,
    this.name,
    this.age,
    this.phone,
    this.location,
    this.status,
    this.eat,
    this.code,
    this.v,
    this.push,
    this.email,
    this.upi,
    this.followers,
    this.insta,
    this.token,
    this.user,
  });

  bool active;
  bool blocked;
  String referal;
  List<dynamic> associations;
  List<dynamic> tags;
  int createdAt;
  String id;
  List<dynamic> coupons;
  List<dynamic> cashback;
  String name;
  int age;
  String phone;
  String location;
  String status;
  int eat;
  String code;
  int v;
  String push;
  String email;
  String upi;
  int followers;
  String insta;
  String token;
  String user;

  factory CustomerClass.fromJson(Map<String, dynamic> json) => CustomerClass(
    active: json["active"],
    blocked: json["blocked"],
    referal: json["referal"],
    associations: List<dynamic>.from(json["associations"].map((x) => x)),
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    createdAt: json["createdAt"],
    id: json["_id"],
    coupons: List<dynamic>.from(json["coupons"].map((x) => x)),
    cashback: List<dynamic>.from(json["cashback"].map((x) => x)),
    name: json["name"],
    age: json["age"],
    phone: json["phone"],
    location: json["location"],
    status: json["status"],
    eat: json["eat"],
    code: json["code"],
    v: json["__v"],
    push: json["push"],
    email: json["email"],
    upi: json["upi"],
    followers: json["followers"],
    insta: json["insta"],
    token: json["token"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "blocked": blocked,
    "referal": referal,
    "associations": List<dynamic>.from(associations.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "createdAt": createdAt,
    "_id": id,
    "coupons": List<dynamic>.from(coupons.map((x) => x)),
    "cashback": List<dynamic>.from(cashback.map((x) => x)),
    "name": name,
    "age": age,
    "phone": phone,
    "location": location,
    "status": status,
    "eat": eat,
    "code": code,
    "__v": v,
    "push": push,
    "email": email,
    "upi": upi,
    "followers": followers,
    "insta": insta,
    "token": token,
    "user": user,
  };
}
