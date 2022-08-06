
class SessionUser {
  dynamic id;
  String email;
  String firstName;
  String lastName;
  String sex;
  int age;

  SessionUser(
      {this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.sex,
      required this.age});

  @override
  String toString() {
    return 'SessionUser{emailAddress: $email, firstName: $firstName, lastName: $lastName, sex: $sex, age: $age}';
  }

  factory SessionUser.fromSnapshot(Map<String, dynamic> data) {
    // print(data['firstName']);
    return SessionUser(
      id: data['id'],
      email: data['emailAddress'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      sex: data['sex'],
      age: data['age'],
    );
  }

  // factory SessionUser.fromFirebaseUser(User? user) {
  //   return SessionUser(
  //     id: user?.uid ?? "",
  //   lastName: user?.na
  //   );
  // }
}
