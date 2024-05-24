class ListMessageBySender {
  List<Data>? data;

  ListMessageBySender({this.data});


  ListMessageBySender.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  List<String> getListRecipient() {
    List<String> listRecipient = [];
    if (data != null) {
      listRecipient = data!.map((data) => data.recipientId!).toList();
    }
    return listRecipient;
  }
}

class Data {
  String? id;
  String? message;
  String? senderId;
  String? recipientId;
  Null? content;
  Null? members;
  Null? chatId;

  Data(
      {this.id,
      this.message,
      this.senderId,
      this.recipientId,
      this.content,
      this.members,
      this.chatId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderId = json['senderId'];
    recipientId = json['recipientId'];
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
    data['content'] = this.content;
    data['members'] = this.members;
    data['chatId'] = this.chatId;
    return data;
  }
}