class GetUserModel {
  String? id;
  String? username;
  String? email;
  String? birthday;
  String? password;
  String? resetCode;
  Null? role;
  Null? photoData;
  Null? contacts;

  GetUserModel(
      {this.id,
      this.username,
      this.email,
      this.birthday,
      this.password,
      this.resetCode,
      this.role,
      this.photoData,
      this.contacts});

  GetUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    birthday = json['birthday'];
    password = json['password'];
    resetCode = json['resetCode'];
    role = json['role'];
    photoData = json['photoData'];
    contacts = json['contacts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['password'] = this.password;
    data['resetCode'] = this.resetCode;
    data['role'] = this.role;
    data['photoData'] = this.photoData;
    data['contacts'] = this.contacts;
    return data;
  }
}
