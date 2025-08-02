//ID generator for ticket IDs
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart';

String generateTicketId(String alphabet, int number) {
  return '$alphabet${number.toString().padLeft(5, '0')}';
}

//Number getter from ids
int extractTicketNumber(String ticketId) {
  // Remove the 'T' prefix and parse the remaining string as an integer
  return int.parse(ticketId.substring(1));
}

//Count data row
Future<int> countDataRow(String collection) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collection).get();
  return snapshot.size;
}

//Count with condition
Future<int> countDataRowWithCon(
    String collection, String variable, String value) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(collection)
      .where(variable, isEqualTo: value)
      .get();
  return snapshot.size;
}

//Return review exist
Future<bool> hasReviewToday(String patientIC) async {
  final now = DateTime.now().toUtc().add(Duration(hours: 8));
  final startOfDay = DateTime(now.year, now.month, now.day);

  final snapshot = await FirebaseFirestore.instance
      .collection('Review')
      .where('Timestamp', isGreaterThanOrEqualTo: startOfDay)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
}

//Check data existence with the selected field
Future<bool> checkDataExistence(
    String collection, String field, String value) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(collection)
      .where(field, isEqualTo: value)
      .get();
  return snapshot.docs.isNotEmpty;
}

//Get Data with condition
Future<String?> getDataWithCon(
  String collection,
  String checkField,
  String checkValue,
  String targetField,
) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(collection)
      .where(checkField, isEqualTo: checkValue)
      .get();

  if (snapshot.docs.isNotEmpty) {
    var data = snapshot.docs.first.data() as Map<String, dynamic>;
    return data[targetField]?.toString(); // return the target field's value
  } else {
    return null; // or handle it however you want (e.g., throw an error)
  }
}

Future<String?> getValueFromDocumentID(
  String collection,
  String documentID,
  String targetField,
) async {
  try {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentID)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      return data?[targetField]?.toString(); // Convert to String if not null
    }
    return null;
  } catch (e) {
    print('Error getting document: $e');
    return null;
  }
}

void storedocumentquery(String Collection, Map<String, dynamic> doc) {
  var db = FirebaseFirestore.instance;
  db.collection(Collection).add(doc);
}

Future<List<Map<String, dynamic>>> getNotifBySenderIC(String collection,
    String SenderICField, String recieverICfield, String recieverIC) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collection).get();
  List<Map<String, dynamic>> dataList = [];

  for (var doc in snapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data.containsKey(SenderICField) &&
        data[recieverICfield] == recieverIC) {
      data['docId'] = doc.id;
      dataList.add(data);
    }
  }

  return dataList;
}

void markAsRead(String docId) async {
  await FirebaseFirestore.instance
      .collection("Notifications")
      .doc(docId)
      .update({"read": true});
}

Future<int> countUnreadlist(
    String collection, String SenderICField, String recieverICfield) async {
  int count = 0;
  List<Map<String, dynamic>> data = await getNotifBySenderIC(
      collection, SenderICField, recieverICfield, globalIC);
  print(data);

  for (Map<String, dynamic> i in data) {
    if (i["read"] == false) {
      count++;
    }
  }

  return count;
}
