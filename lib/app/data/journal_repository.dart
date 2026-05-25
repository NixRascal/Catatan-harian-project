import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'journal_entry.dart';

class JournalRepository {
  JournalRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('journals');

  String? get uid => auth.currentUser?.uid;

  Stream<List<JournalEntry>> watchEntries() {
    final currentUid = uid;
    if (currentUid == null) return Stream.value(const []);

    return _collection
        .where('userId', isEqualTo: currentUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(JournalEntry.fromDoc).toList());
  }

  Future<JournalEntry?> getById(String id) async {
    if (id.isEmpty) return null;
    final snapshot = await _collection.doc(id).get();
    if (!snapshot.exists) return null;
    final entry = JournalEntry.fromSnapshot(snapshot);
    if (entry.userId != uid) return null;
    return entry;
  }

  Future<void> add({
    required String title,
    required String content,
    required String mood,
    required String moodLabel,
    required String category,
    required String colorTint,
  }) async {
    final currentUid = uid;
    if (currentUid == null) throw StateError('User belum login.');
    await _collection.add(
      JournalEntry.createMap(
        userId: currentUid,
        title: title,
        content: content,
        mood: mood,
        moodLabel: moodLabel,
        category: category,
        colorTint: colorTint,
      ),
    );
  }

  Future<void> update(JournalEntry entry) async {
    await _collection.doc(entry.id).update(entry.toUpdateMap());
  }

  Future<void> toggleFavorite(JournalEntry entry) async {
    await _collection.doc(entry.id).update({
      'isFavorite': !entry.isFavorite,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> deleteAllForCurrentUser() async {
    final currentUid = uid;
    if (currentUid == null) return;
    final snapshot =
        await _collection.where('userId', isEqualTo: currentUid).get();
    for (var i = 0; i < snapshot.docs.length; i += 450) {
      final batch = firestore.batch();
      for (final doc in snapshot.docs.skip(i).take(450)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
