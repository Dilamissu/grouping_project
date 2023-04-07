import 'data_controller.dart';

import 'dart:io' as io show File;

/// ## a base class of every data in database, can only use as ***Polymorphism***
/// every subclass should pass all follow attribute to this superclass
/// * [id] : the id of this data
/// * [databasePath] : the collection path of this type of data
/// * [storageRequired] : whether this type of data need firebase storage
abstract class BaseDataModel<T extends BaseDataModel<T>> {
  final String? id;
  String databasePath;
  bool storageRequired;
  // bool setOwnerRequired;

  /// ## a base class of every data in database, can only use as ***Polymorphism***
  /// every subclass should pass all follow attribute to this superclass
  /// * [id] : the id of this data
  /// * [databasePath] : the collection path of this type of data
  /// * [storageRequired] : whether this type of data need firebase storage
  BaseDataModel({
    required this.id,
    required this.databasePath,
    required this.storageRequired,
    // required this.setOwnerRequired
  });

  /// return a `map` data in order to upload to firestore
  /// * every subclass should override this method
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController});

  /// return a `T<T extends DataModel>` data in order to download from firestore
  /// * every subclass should override this method
  Future<T> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController});
}

/// ## a base class of every data in storage, can only be implement
abstract class BaseStorageData {
  Map<String, io.File> toStorage();
  void setAttributeFromStorage({required Map<String, io.File> data});
}
