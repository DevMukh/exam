class UserProfile {
  final String fullName;
  final String gender;
  final String occupation;
  final String phoneNumber;
  final String whatsappNumber;
  final String email;
  final String state;
  final String borough;
  final String year;
  final String password;
  final String bankAccount;
  final String uid;

  UserProfile({
    required this.fullName,
    required this.gender,
    required this.occupation,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.email,
    required this.state,
    required this.borough,
    required this.year,
    required this.password,
    required this.bankAccount,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'gender': gender,
      'occupation': occupation,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'state': state,
      'borough': borough,
      'year': year,
      'password': password,
      'bankAccount': bankAccount,
      'uid': uid,
    };
  }
}
