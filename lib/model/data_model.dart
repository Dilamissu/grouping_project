import 'profile_model.dart';

/// !! NOTICE !!
/// this is a super class of every data in database,
/// can only use as POLYMORPHISM
abstract class DataModel<T extends DataModel<T>> {
  final String? id;
  String databasePath;
  bool storageRequired;
  bool setOwnerRequired;

  /// !! NOTICE !!
  /// every subclass should return id to this superclass,
  /// either get it or set a value to it in constructor
  DataModel(
      {required this.id,
      required this.databasePath,
      required this.storageRequired,
      required this.setOwnerRequired});

  /// !! NOTICE !!
  /// every subclass should override this method
  Map<String, dynamic> toFirestore();

  /// !! NOTICE !!
  /// every subclass should override this method
  T fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile});
}
