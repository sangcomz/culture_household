import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Group {
  String id;
  String host;
  int createdAt;
  String groupName;
  List<String> users = [];
  Group(this.id, this.host, this.createdAt, this.groupName, this.users);
}

Future<bool> createGroup(String groupName) async {
  return FirebaseAuth.instance.currentUser().then((user) {
    if (user != null) {
      final Firestore firestore = Firestore.instance;

      var doc = firestore.collection('group').document();
      return firestore.collection('group').document().setData({
        'id': doc.documentID,
        'host': user.uid,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'group_name': groupName,
        'users': [user.uid]
      }).then((value) {
        return true;
      }, onError: (error) {
        return false;
      });
    }
  });
}

Future<Group> isExistGroup(String groupName) async {
  return Firestore.instance
      .collection('group')
      .where("group_name", isEqualTo: groupName)
      .snapshots()
      .first
      .then((data) {
    if(data.documents.length == 0){
      return null;
    }
    var groupDoc = data.documents.first.data;
    List<String> users = List.from(groupDoc['users']);
    var group = Group(groupDoc['id'], groupDoc['host'], groupDoc['create_at'],
        groupDoc['group_name'], users);
    return group;
  }, onError: (error) {
    print('error');
    return null;
  });
}

Future<Group> joinedGroup(String uid) async {
  return Firestore.instance
      .collection('group')
      .where("users", arrayContains: uid)
      .snapshots()
      .first
      .then((data) {
    if(data.documents.length == 0){
      return null;
    }
    var groupDoc = data.documents.first.data;
    List<String> users = List.from(groupDoc['users']);
    var group = Group(groupDoc['id'], groupDoc['host'], groupDoc['create_at'],
        groupDoc['group_name'], users);
    return group;
  }, onError: (error) {
    print('error');
    return null;
  });
}

Future<bool> joinGroup(String groupName) async {
  return FirebaseAuth.instance.currentUser().then((user) {
    return Firestore.instance
        .collection('group')
        .where("group_name", isEqualTo: groupName)
        .snapshots()
        .first
        .then((data) {
      return updateUsers(user, data).then((data) {
        return data;
      }, onError: (error) {
        return false;
      });
    }, onError: (error) {
      return false;
    });
  }, onError: (error) {
    return false;
  });
}

Future<bool> updateUsers(FirebaseUser user, QuerySnapshot data) {
  return Firestore.instance.runTransaction((Transaction tx) async {
    final DocumentReference groupRef =
        Firestore.instance.document('group/${data.documents.first.documentID}');
    DocumentSnapshot groupSnapshot = await tx.get(groupRef);
    List<String> users = List.from(groupSnapshot.data['users']);
    if (!users.contains(user.uid)) users.add(user.uid);
    if (groupSnapshot.exists)
      return await tx.update(groupRef, <String, dynamic>{'users': users});
  }).then((data) {
    return true;
  }, onError: (error) {
    return false;
  });
}
