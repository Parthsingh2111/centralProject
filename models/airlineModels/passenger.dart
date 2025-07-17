class Passenger {
  final String firstName;
  final String lastName;
  final String email;

  Passenger({required this.firstName, required this.lastName, required this.email});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'emailId': email,
      };
}