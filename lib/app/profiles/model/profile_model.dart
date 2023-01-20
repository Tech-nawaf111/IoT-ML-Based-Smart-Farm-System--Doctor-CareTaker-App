import 'dart:io';

/// profile model that takes all desired user data for creating profile

class ProfileModel{

  ProfileModel(this.Firstname, this.Lastname, this.DateofBirth,
      this.IDcardnumber, this.PhoneNumber, this.Address,this.Type,this.imageFile);

  String? Firstname;
  String? Lastname;
  String? DateofBirth;
  String? IDcardnumber;
  String? PhoneNumber;
  String?  Address;
  String? Type;
  File? imageFile;


}