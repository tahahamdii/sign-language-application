class DataUserModel {
  String? id;
  String? username;
  String? email;
  String? birthday;
  String? password;
  String? resetCode;

  DataUserModel(
      {this.id,
      this.username,
      this.email,
      this.birthday,
      this.password,
      this.resetCode});

  DataUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    birthday = json['birthday'];
    password = json['password'];
    resetCode = json['resetCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['password'] = this.password;
    data['resetCode'] = this.resetCode;
    return data;
  }
}
