import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods {


  // getUsersByName(String userName) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('name', isEqualTo: userName)
  //       .get();
  // }

  // getUsersByEmail(String email) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  // }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  Future getLastMessage(String chatRoomId, String username) async {

    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timeStamp',descending: true)
        .limit(1)
        .get();
  }

  getConversationMessages(String chatRoomId,String username) async {
    QuerySnapshot chats = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .where('sendBy', isEqualTo: username)
        .where('read',isEqualTo: 'unread').get();
    print(chats.docs.length);
    for(int i=0; i<chats.docs.length;i++){
      FirebaseFirestore.instance.collection('ChatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(chats.docs[i].id)
          .update({'read': 'read'});
    }
    Stream<QuerySnapshot> querySnapshot =  await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timeStamp')
        .snapshots();
    return querySnapshot;
  }
  Future getNotifications()async{
    print('wnenk');
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: 'kUserName')
        .get();


  }
  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap);
  }
  uploadDocInfo(userMap) {
    FirebaseFirestore.instance.collection('doctors').add(userMap);
  }

  createChatRoom(String chatroomId, chatRoomMap, String cusUserName) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatroomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}