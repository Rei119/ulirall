import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> addToFavorites(int productId) async {
    final user = getCurrentUser();
    if (user != null) {
      await _firestore.collection('favorites').doc(user.uid).set({
        'products': FieldValue.arrayUnion([productId]),
      }, SetOptions(merge: true));
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    final user = getCurrentUser();
    if (user != null) {
      await _firestore.collection('favorites').doc(user.uid).update({
        'products': FieldValue.arrayRemove([productId]),
      });
    }
  }

  Future<List<int>> getFavorites() async {
    final user = getCurrentUser();
    print('🔍 Getting favorites for user: ${user?.uid}');
    print('🔍 User email: ${user?.email}');

    if (user != null) {
      try {
        final doc =
            await _firestore.collection('favorites').doc(user.uid).get();
        print('🔍 Document exists: ${doc.exists}');
        print('🔍 Document data: ${doc.data()}');

        if (doc.exists && doc.data()?['products'] != null) {
          final products = doc.data()!['products'];
          if (products is List) {
            final favoritesList = products
                .map((e) => e is int ? e : int.parse(e.toString()))
                .toList();
            print('🔍 Favorites list: $favoritesList');
            return favoritesList;
          }
        }
      } catch (e) {
        print(' Error getting favorites: $e');
      }
    } else {
      print(' No user logged in!');
    }
    return [];
  }

  Stream<List<int>> getFavoritesStream() {
    final user = getCurrentUser();
    if (user != null) {
      return _firestore
          .collection('favorites')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
        try {
          if (doc.exists && doc.data()?['products'] != null) {
            final products = doc.data()!['products'];
            if (products is List) {
              return products
                  .map((e) => e is int ? e : int.parse(e.toString()))
                  .toList();
            }
          }
        } catch (e) {
          print('Error in favorites stream: $e');
        }
        return <int>[];
      });
    }
    return Stream.value([]);
  }

  Future<void> addReview(Review review) async {
    await _firestore.collection('reviews').add(review.toMap());
  }

  Stream<List<Review>> getReviews(int productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    });
  }
}
