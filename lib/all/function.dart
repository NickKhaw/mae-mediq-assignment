import 'package:cloud_firestore/cloud_firestore.dart';

void storeProfilePic(String collectionName, String field, String requiredData,
    String newField, dynamic data) async {
  var db = FirebaseFirestore.instance;
  final snapshot = await db
      .collection(collectionName)
      .where("$field", isEqualTo: requiredData)
      .get();
  final docId = snapshot.docs.first.id;
  db.collection(collectionName).doc(docId).update({"$newField": data});
}

Future<String?> fetchProfilePicUrl(String collectionName, String field, String requiredData) async {
  var db = FirebaseFirestore.instance;

  final snapshot = await db
      .collection(collectionName)
      .where(field, isEqualTo: requiredData)
      .get();

  if (snapshot.docs.isNotEmpty) {
    final doc = snapshot.docs.first;
    return doc.data()['Profile Pic'];
  }
  return null;
}

Future<void> updateData(
  String collectionName,
  String field,
  String requiredData,
  String newField,
  dynamic data,
) async {
  final db = FirebaseFirestore.instance;
  final snapshot = await db
      .collection(collectionName)
      .where(field, isEqualTo: requiredData)
      .get();
      
  if (snapshot.docs.isEmpty) {
    throw Exception('Document not found');
  }
  
  final docId = snapshot.docs.first.id;
  // Return the Future from the update operation
  return db.collection(collectionName).doc(docId).update({newField: data});
}

