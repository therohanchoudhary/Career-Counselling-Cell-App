class UserRegisterDetailClass {
  final String name;
  final String email;
  final String mobileNumber;
  final String gender;
  final String country;
  final String countryCode;
  final String address;
  final String state;
  final String city;
  final String password;
  final String dob;

  UserRegisterDetailClass(
      {this.country,
        this.name,
        this.state,
        this.city,
        this.address,
        this.countryCode,
        this.email,
        this.dob,
        this.gender,
        this.mobileNumber,
        this.password});
}