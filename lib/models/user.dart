
class SessionUser{
   dynamic id;
   String emailAddress;
   String firstName;
   String lastName;
   String sex;
   int age;

  SessionUser({this.id, required this.emailAddress, required this.firstName, required this.lastName,
      required this.sex, required this.age});

  @override
  String toString() {
    return 'SessionUser{emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName, sex: $sex, age: $age}';
  }
   factory SessionUser.fromSnapshot(Map <String, dynamic> data){
    // print(data['firstName']);
     return SessionUser(
         id: data['id'],
         emailAddress : data['emailAddress'],
         firstName : data['firstName'],
         lastName : data['lastName'],
         sex : data['sex'],
         age : data['age'],
     );
   }

}