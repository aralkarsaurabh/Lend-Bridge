class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address_line_1;
  final String address_line_2;
  final String city;
  final String pin_code;
  final String state;
  final String pan_card_file_url;
  final String pan_card_file_name;
  final String aadhar_card_file_url;
  final String aadhar_card_file_name;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address_line_1,
    required this.address_line_2,
    required this.city,
    required this.pin_code,
    required this.state,
    required this.pan_card_file_url,
    required this.pan_card_file_name,
    required this.aadhar_card_file_url,
    required this.aadhar_card_file_name,
  });

  factory UserModel.fromFirestor(Map<String, dynamic> data, String uid) {
    final pan_map = data['pan_card'] as Map<String, dynamic>?;
    final aadhar_map = data['aadhar_card'] as Map<String, dynamic>?;

    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address_line_1: data['address_line_1'] ?? '',
      address_line_2: data['address_line_2'] ?? '',
      city: data['city'] ?? '',
      pin_code: data['pin_code'] ?? '',
      state: data['state'] ?? '',
      pan_card_file_name: pan_map?['file_name'] ?? '',
      pan_card_file_url: pan_map?['file_url'] ?? '',
      aadhar_card_file_name: aadhar_map?['file_name'] ?? '',
      aadhar_card_file_url: aadhar_map?['file_url'] ?? '',
    );
  }
}
