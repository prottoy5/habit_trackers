import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/habit.dart';
import '../models/quote.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // ------------------ User Profile ------------------
  Future<void> saveUserProfile(UserProfile profile) async {
    await _db
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(uid, doc.data()!);
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return UserProfile.fromMap(uid, snap.data()!);
    });
  }

  // ------------------ Habits ------------------
  CollectionReference<Map<String, dynamic>> habitsRef(String uid) =>
      _db.collection('users').doc(uid).collection('habits');

  Future<void> addHabit(String uid, Habit habit) async {
    await habitsRef(uid).doc(habit.id).set(habit.toMap());
  }

  Future<void> updateHabit(String uid, Habit habit) async {
    await habitsRef(uid)
        .doc(habit.id)
        .set(habit.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteHabit(String uid, String habitId) async {
    await habitsRef(uid).doc(habitId).delete();
  }

  Stream<List<Habit>> watchHabits(String uid) {
    return habitsRef(uid)
        .orderBy('creationDate', descending: true)
        .snapshots()
        .map((qs) => qs.docs.map((d) => Habit.fromMap(d.id, d.data())).toList());
  }

  // ------------------ Favorite Quotes ------------------
  CollectionReference<Map<String, dynamic>> favoriteQuotesRef(String uid) =>
      _db.collection('users').doc(uid).collection('favorite_quotes');

  Future<void> favoriteQuote(String uid, Quote q) async {
    await favoriteQuotesRef(uid).doc(q.id).set(q.toMap());
  }

  Future<void> unfavoriteQuote(String uid, String id) async {
    await favoriteQuotesRef(uid).doc(id).delete();
  }

  Stream<List<Quote>> watchFavoriteQuotes(String uid) {
    return favoriteQuotesRef(uid).snapshots().map(
            (qs) => qs.docs.map((d) => Quote.fromMap(d.data())).toList());
  }
}
