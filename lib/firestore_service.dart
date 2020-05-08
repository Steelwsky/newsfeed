import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:webfeed/webfeed.dart';

class FirestoreDatabase {
  FirestoreDatabase._();

  static final FirestoreDatabase _instance = FirestoreDatabase._();

  factory FirestoreDatabase() {
    return _instance;
  }

  final databaseFirestore = Firestore.instance;

  Future<void> addToHistory(RssItem item) async {
    databaseFirestore.collection('historyItems').document().setData({
      'id': _getUuidFromString(item.title),
      'title': item.title,
      'description': item.description,
      'link': item.link,
    });
  }

  String _getUuidFromString(String title) => Uuid().v5(title, 'UUID');

  Future<List<String>> retrieveViewedItemIds() async {
    final Iterable<String> myBool = await databaseFirestore
        .collection('historyItems')
        .getDocuments()
        .then((onValue) => onValue.documents)
        .then((document) => document.map((d) => d.data['id']));
    print(myBool.toList());
    return myBool.toList();
  }

  Future<void> deleteHistory() async {
    await databaseFirestore.collection('historyItems').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
    await databaseFirestore.collection('links').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<RssItem>> getHistory() {
    return databaseFirestore.collection('historyItems').snapshots().map((convert) => convert.documents
        .map((item) => RssItem(
            guid: item.data['id'],
            title: item.data['title'],
            description: item.data['description'],
            link: item.data['link']))
        .toList());
  }
}
