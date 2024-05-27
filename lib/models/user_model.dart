class UserLoginModel {
  String? jwt;
  UserDetails? userDetails;

  UserLoginModel({this.jwt, this.userDetails});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    jwt = json['jwt'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jwt'] = this.jwt;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? role;
  String? id;
  String? username;
  String? email;
  String? birthday;
  String? password;
  bool? credentialsNonExpired;
  bool? accountNonExpired;
  List<Authorities>? authorities;
  bool? accountNonLocked;
  bool? enabled;

  UserDetails(
      {this.role,
      this.id,
      this.username,
      this.email,
      this.birthday,
      this.password,
      this.credentialsNonExpired,
      this.accountNonExpired,
      this.authorities,
      this.accountNonLocked,
      this.enabled});

  UserDetails.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    birthday = json['birthday'];
    password = json['password'];
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonExpired = json['accountNonExpired'];
    if (json['authorities'] != null) {
      authorities = <Authorities>[];
      json['authorities'].forEach((v) {
        authorities!.add(new Authorities.fromJson(v));
      });
    }
    accountNonLocked = json['accountNonLocked'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['password'] = this.password;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonExpired'] = this.accountNonExpired;
    if (this.authorities != null) {
      data['authorities'] = this.authorities!.map((v) => v.toJson()).toList();
    }
    data['accountNonLocked'] = this.accountNonLocked;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Authorities {
  String? authority;

  Authorities({this.authority});

  Authorities.fromJson(Map<String, dynamic> json) {
    authority = json['authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority'] = this.authority;
    return data;
  }
}