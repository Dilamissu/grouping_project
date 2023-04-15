// import 'package:cloud_firestore/cloud_firestore.dart';

// /// ## a `FirestoreController` instance controll all things with Firestore
// /// * an instance can controll all data of one user/group
// class FirestoreController {
//   final db = FirebaseFirestore.instance;

//   /// ## a `FirestoreController` instance controll all things with Firestore
//   /// * an instance can controll all data of one user/group
//   /// -----
//   /// * [forUser] : whether this instance is going to controll data of a user or not
//   /// * [ownerId] : the id of user/group this instance is going to controll
//   FirestoreController();

//   /// ### create a group with no data inside and return group id
//   Future<String> createGroup() async {
//     return (await FirebaseFirestore.instance
//             .collection('group_properties')
//             .add({}))
//         .id;
//   }

//   /// ### add a new data to the specific path
//   /// * [processData] : the data to be added
//   /// * [collectionPath] : the path to add data, suppose to be `T<T extends DataModel>.databasePath`
//   /// * [dataId] : if not given, firestore will generate a random id
//   Future<String> set(
//       {required Map<String, dynamic> processData,
//       required String collectionPath,
//       String? dataId}) async {
//     if (dataId != null) {
//       await db.collection(collectionPath).doc(dataId).set(processData);
//       return dataId;
//     } else {
//       var snap = await db.collection(collectionPath).add(processData);
//       return snap.id;
//     }
//   }

//   /// ### update an existed data
//   /// * [processData] : the data to be updated
//   /// * [collectionPath] : the path to update data, suppose to be `T<T extends DataModel>.databasePath`
//   /// * [dataId] : the data id
//   /// * if firestore does not exist the data of the id, throw an Exception.
//   Future<void> update(
//       {required Map<String, dynamic> processData,
//       required String collectionPath,
//       required String dataId}) async {
//     await db.collection(collectionPath).doc(dataId).update(processData);
//     return;
//   }

//   /// ### get an existed data
//   /// * [collectionPath] : the path to get data, suppose to be `T<T extends DataModel>.databasePath`
//   /// * [dataId] : the data id
//   /// * if firestore does not exist the data of the id, throw an Exception.
//   Future<DocumentSnapshot<Map<String, dynamic>>> get(
//       {required String collectionPath, required String dataId}) async {
//     return await db.collection(collectionPath).doc(dataId).get();
//   }

//   /// ### get all data of specific type
//   /// * [collectionPath] : the path to get data, suppose to be `T<T extends DataModel>.databasePath`
//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAll(
//       {required String collectionPath}) async {
//     return (await db.collection(collectionPath).get()).docs;
//   }

//   /// ### delete an existed data
//   /// * [collectionPath] : the path to delete data, suppose to be `T<T extends DataModel>.databasePath`
//   /// * [dataId] : the data id
//   /// * if firestore does not exist the data of the id, throw an Exception.
//   Future<void> delete(
//       {required String collectionPath, required String dataId}) async {
//     await ownerPath.collection(collectionPath).doc(dataId).delete();
//     return;
//   }
// }
