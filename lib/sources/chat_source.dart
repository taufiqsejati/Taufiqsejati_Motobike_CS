import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taufiqsejati_motobike_cs/models/chat.dart';

class ChatSource {
  static Future<void> openChatRoom(String uid, String userName) async {
    await FirebaseFirestore.instance.collection('CS').doc(uid).update({
      'newFromUser': false,
    });
    // final doc =
    //     await FirebaseFirestore.instance.collection('CS').doc(uid).get();
    // if (doc.exists) {
    //   await FirebaseFirestore.instance.collection('CS').doc(uid).update({
    //     'newFromUser': false,
    //   });
    //   return;
    // }

    // // first time chat room
    // await FirebaseFirestore.instance.collection('CS').doc(uid).set({
    //   'roomId': uid,
    //   'name': userName,
    //   'lastMessage': 'Welcome to Motobike',
    //   'newFromUser': false,
    //   'newFromCS': true,
    // });
    // await FirebaseFirestore.instance
    //     .collection('CS')
    //     .doc(uid)
    //     .collection('chats')
    //     .add({
    //   'roomId': uid,
    //   'message': 'Welcome to Motobike',
    //   'receiverId': uid,
    //   'senderId': 'cs',
    //   'bikeDetail': null,
    //   'timestamp': FieldValue.serverTimestamp(),
    // });
  }

  static Future<void> send(Chat chat, String uid) async {
    await FirebaseFirestore.instance.collection('CS').doc(uid).update({
      'lastMessage': chat.message,
      'newFromUser': false,
      'newFromCS': true,
    });
    await FirebaseFirestore.instance
        .collection('CS')
        .doc(uid)
        .collection('chats')
        .add({
      'roomId': chat.roomId,
      'message': chat.message,
      'receiverId': chat.receiverId,
      'senderId': chat.senderId,
      'bikeDetail': chat.bikeDetail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
