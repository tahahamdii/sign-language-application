class AllMessagesModel {
  List<Data>? data;

  AllMessagesModel({this.data});

  AllMessagesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Message? message;
  String? timestamp;

  Data({this.message, this.timestamp});

  Data.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Message {
  String? id;
  String? message;
  String? senderId;
  String? recipientId;
  Null? chanel;
  Null? content;
  Null? members;
  Null? chatId;

  Message(
      {this.id,
      this.message,
      this.senderId,
      this.recipientId,
      this.chanel,
      this.content,
      this.members,
      this.chatId});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderId = json['senderId'];
    recipientId = json['recipientId'];
    chanel = json['chanel'];
    content = json['content'];
    members = json['members'];
    chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['chanel'] = this.chanel;
    data['content'] = this.content;
    data['members'] = this.members;
    data['chatId'] = this.chatId;
    return data;
  }
}