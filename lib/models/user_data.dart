class UserData {
  final String? id;
  final String name;
  final String address;
  final String phone;

  UserData(
      {this.id,
      required this.name,
      required this.address,
      required this.phone});

  static UserData fromJson(Map<String, dynamic> json, String id) => UserData(
      id: id,
      name: json['name'],
      address: json['address'],
      phone: json['phone']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'address': address, 'phone': phone};
}
