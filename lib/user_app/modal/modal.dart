import 'dart:convert';

import 'dart:typed_data';

class CustomerModal {
  int id;
  String email;
  String password;
  String name;
  Role role;
  String avatar;
  Uint8List? imageBlob; // Local image data
  DateTime creationAt;
  DateTime updatedAt;

  CustomerModal({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
    this.imageBlob,
  });

  // Factory constructor to create an object from API response JSON
  factory CustomerModal.fromMap(Map<String, dynamic> json) => CustomerModal(
    id: json["id"],
    email: json["email"],
    password: json["password"],
    name: json["name"],
    role: roleValues.map[json["role"]] ?? Role.CUSTOMER,
    avatar: json["avatar"],
    creationAt: DateTime.parse(json["creationAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    imageBlob: null, // This will be handled separately for offline storage
  );

  // Convert the object to a map for SQLite storage
  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "password": password,
    "name": name,
    "role": roleValues.reverse[role],
    "avatar": avatar,
    "imageBlob": imageBlob, // Stored as BLOB
    "creationAt": creationAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  // Convert an SQLite map to a CustomerModal object
  factory CustomerModal.fromDatabase(Map<String, dynamic> dbMap) => CustomerModal(
    id: dbMap["id"],
    email: dbMap["email"],
    password: dbMap["password"],
    name: dbMap["name"],
    role: roleValues.map[dbMap["role"]] ?? Role.CUSTOMER,
    avatar: dbMap["avatar"],
    imageBlob: dbMap["imageBlob"],
    creationAt: DateTime.parse(dbMap["creationAt"]),
    updatedAt: DateTime.parse(dbMap["updatedAt"]),
  );
}

enum Role { ADMIN, CUSTOMER }

// Enum helper for string-to-enum mapping
class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// Mapping Role to Strings
final roleValues = EnumValues({
  "admin": Role.ADMIN,
  "customer": Role.CUSTOMER,
});

