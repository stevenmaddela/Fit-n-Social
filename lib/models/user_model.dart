import 'message_model.dart';

class InboxUser {
  final String id;
  final String name;
  final String imageUrl;
  final Message lastMessage;

  InboxUser({
    this.id,
    this.name,
    this.imageUrl,
    this.lastMessage,
  });
  @override
  String toString() {
    // TODO: implement toString
    return "id: " + id + " - name: " + name;
  }
}