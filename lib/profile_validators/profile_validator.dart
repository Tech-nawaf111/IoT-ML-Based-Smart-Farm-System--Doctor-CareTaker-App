enum Flags{
Numbers,
  Alphabets,
}

class Custom_validators{



  String? CustomTextValidator(text,flag) {
  if(flag=="T"){
    for (var i = 0; i < text.length; i++) {
      if(text.contains(new RegExp(r'[0-9]'))){
        return 'Can\'t be number';
      }
    }}
  if (text == null || text.isEmpty) {
  return 'Can\'t be empty';
  }
  if (text.length < 4) {
  return 'Too short';
  }
  return null;
  }



}