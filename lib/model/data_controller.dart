import 'data_model.dart';
import 'profile_model.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'package:flutter/material.dart';

/// ## to get any data from firebase, you need a DataController
class DataController {
  late bool _forUser;
  late String _ownerId;

  /// ## construct a DataController to communicate with firebase database
  /// * auto get current user id if not given group id
  DataController({String? groupId}) {
    _forUser = (groupId == null);
    _ownerId = groupId ?? AuthService().getUid();
  }

  /// ## upload *"one"* data from database.
  /// * [uploadData] : the data you want to upload
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if [uploadData.id] exist, would be updating the data
  /// * throw exception if the database does not has the data of the id.
  Future<void> upload<T extends DataModel<T>>({required T uploadData}) async {
    String dataId;
    if ((uploadData.id == null) || (uploadData.id == 'profile')) {
      dataId = await FirestoreController(forUser: _forUser, ownerId: _ownerId)
          .set(
              processData: uploadData.toFirestore(),
              collectionPath: uploadData.databasePath,
              dataId: uploadData.id);
    } else {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).update(
          processData: uploadData.toFirestore(),
          collectionPath: uploadData.databasePath,
          dataId: uploadData.id!);
      dataId = uploadData.id!;
    }

    if (uploadData.storageRequired && uploadData is StorageData) {
      var uploadFileMap = (uploadData as StorageData).toStorage();
      StorageController storageController =
          StorageController(forUser: _forUser, ownerId: _ownerId);
      for (String key in uploadFileMap.keys) {
        storageController.set(
            processData: uploadFileMap[key]!,
            collectionPath: '${uploadData.databasePath}/$dataId',
            dataId: key);
      }
    }
    return;
  }

  /// ## download *"one"* data from database.
  /// * retrun one object of the type you specify.
  /// * [dataTypeToGet] : the data type you want to get, suppose to be
  /// `T<T extends DataModel>()`
  /// * [dataId] : the id of the data
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if you want to get [ProfileModel] , just pass `ProfileModel().id!` to [dataId]
  Future<T> download<T extends DataModel<T>>(
      {required T dataTypeToGet, required String dataId}) async {
    var firestoreSnap =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .get(collectionPath: dataTypeToGet.databasePath, dataId: dataId);

    var ownerProfile = dataTypeToGet.setOwnerRequired
        ? await download(
            dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        : null;

    if (firestoreSnap.exists != true) {
      debugPrint('[Exception] data does not exist');
      throw Exception('[Exception] data does not exist');
    } else {
      T processData = dataTypeToGet.fromFirestore(
          id: firestoreSnap.id,
          data: firestoreSnap.data() ?? {},
          ownerProfile: ownerProfile);
      if (processData.storageRequired && processData is StorageData) {
        (processData as StorageData).setAttributeFromStorage(
            data: await StorageController(forUser: _forUser, ownerId: _ownerId)
                .getAllInFile(
                    collectionPath:
                        '${processData.databasePath}/${processData.id}'));
      }

      return processData;
    }
  }

  /// ## download a lot of data from database, which are all same type
  /// and belong to same user.
  /// * retrun a list of the type you specify.
  /// * [dataTypeToGet] : an object of the type you want to get, suppose to be
  /// `T<T extends DataModel>()`
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if you want to get ProfileModel, use `download()` is better.
  Future<List<T>> downloadAll<T extends DataModel<T>>(
      {required T dataTypeToGet}) async {
    // if (_forUser == false && dataTypeToGet.runtimeType == GroupModel) {
    //   debugPrint(
    //       '[Warning] not suppose to happened. trying to get group model list of a group!');
    //   return [];
    // }

    List<T> dataList = [];

    var firestoreSnapList =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .getAll(collectionPath: dataTypeToGet.databasePath);

    var ownerProfile = dataTypeToGet.setOwnerRequired
        ? await download(
            dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        : null;

    for (var snap in firestoreSnapList) {
      T temp = dataTypeToGet.fromFirestore(
          id: snap.id, data: snap.data(), ownerProfile: ownerProfile);
      if (temp.storageRequired && temp is StorageData) {
        (temp as StorageData).setAttributeFromStorage(
            data: await StorageController(forUser: _forUser, ownerId: _ownerId)
                .getAllInFile(
                    collectionPath: '${temp.databasePath}/${temp.id}'));
      }
      dataList.add(temp);
    }

    if (_forUser == true) {
      ownerProfile ??= await download(
          dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
      for (var groupId in ownerProfile.associateEntityId ?? []) {
        var dataListForGroup = await DataController(groupId: groupId)
            .downloadAll(dataTypeToGet: dataTypeToGet);
        dataList.addAll(dataListForGroup);
      }
    }

    return dataList;
  }

  /// ## remove the data you specific from database.
  /// * [removeData] : the data you wnat to remove.
  /// ------
  /// **Notice below :**
  /// - remember to check the data has a correct id.
  /// - remember to use ***await*** in front of this method.
  Future<void> remove<T extends DataModel<T>>({required T removeData}) async {
    if (removeData.id != null) {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).delete(
          collectionPath: removeData.databasePath, dataId: removeData.id!);

      if (removeData.storageRequired) {
        StorageController(forUser: _forUser, ownerId: _ownerId).deleteAll(
            collectionPath: '${removeData.databasePath}/${removeData.id}');
      }
    } else {
      debugPrint("[Exception] data id should be pass");
      throw Exception('[Exception] data id should be pass');
    }

    return;
  }

  /// create a group from current user
  /// return new group id
  Future<String> createGroup(ProfileModel groupProfile) async {
    if (_forUser == false) {
      throw Exception('[Exception] trying to create group for group');
    }
    String groupId = await FirestoreController.createGroup();

    var userProfile = await download(
        dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
    userProfile.addEntity(groupId);
    await upload(uploadData: userProfile);

    groupProfile.addEntity(_ownerId);
    await DataController(groupId: groupId).upload(uploadData: groupProfile);

    return groupId;
  }
}
