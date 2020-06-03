import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  String firstName;
  String lastName;
  String email;
  String phoneNo;

  Profile({
    @required this.email,
    @required this.lastName,
    @required this.firstName,
  });
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orangeAccent,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
              "${firstName.substring(0, 1).toUpperCase()} ${lastName.substring(0, 1).toUpperCase()}"),
        ),
        title: Text(
          "${firstName} ${lastName}",
        ),
        subtitle: Text("$email"),
      ),
    );
  }
}
