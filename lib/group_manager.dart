import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Group {
  String id;
  String host;
  int createdAt;
  String groupName;
  var users = [];

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

void searchGroup(String uid) {
//  print('Search Group.....');
//  return StreamBuilder<QuerySnapshot>(
//    stream: Firestore.instance
//        .collection('group')
//        .snapshots()
//        .handleError((onError) {
//      print('onError  $onError');
//    }),
//    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//      if (snapshot.hasError) {
//        print('error');
//        return Text('Error: ${snapshot.error}');
//      }
//      if (snapshot.hasData) {
//        print('snapshot data');
//        return Text('dddd');
//      } else {
//        print('no data');
//        return Text('Empty');
//      }
//    },
//  );
//  Firestore.instance
//      .collection('group')
//      .where("uid", isEqualTo: uid)
//      .snapshots()
//      .first
//      .then((data) => data.documents.forEach((doc) => print(doc["msg"])),
//          onError: () {});
}

Future<bool> isExistGroup(String groupName) async {
  return Firestore.instance
      .collection('group')
      .where("group_name", isEqualTo: groupName)
      .snapshots()
      .first
      .then((data) {
    return data.documents.isNotEmpty;
  }, onError: (error) {
    print('error');
    return false;
  });
}

Future<bool> joinedGroup(String uid) async {
  return Firestore.instance
      .collection('group')
      .where("users", arrayContains: uid)
      .snapshots()
      .first
      .then((data) {
    return data.documents.isNotEmpty;
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
        print('updateUsers error $error');
        return false;
      });
    }, onError: (error) {
      print('update users error1 $error');
      return false;
    });
  }, onError: (error) {
    print('update users error2 $error');
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
//
//      .then((data) {
//    return true;
//  }, onError: (error) {
//    print('update users error $error');
//    return false;
//  });
}
