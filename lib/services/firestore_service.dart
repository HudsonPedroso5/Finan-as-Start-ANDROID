import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/goal.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:fintracker/model/user.model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> salvarUsuario(UserModel user) {
    return _db.collection('users').doc(user.uid).set(user.toJson());
  }

  static Future<UserModel?> buscarUsuario(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!..['uid'] = uid);
  }

  static Future<void> atualizarXP(String uid, int xp, int nivel) {
    return _db.collection('users').doc(uid).update({'xp': xp, 'nivel': nivel});
  }

  static Future<void> salvarMeta(String uid, Goal goal) {
    return _db.collection('users').doc(uid).collection('goals').doc(goal.id).set(goal.toJson());
  }

  static Future<List<Goal>> buscarMetas(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('goals').get();
    return snapshot.docs.map((doc) => Goal.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  static Future<void> salvarTransacao(String uid, Payment payment) {
    return _db.collection('users').doc(uid).collection('transactions').doc(payment.id.toString()).set(payment.toJson());
  }

  static Future<List<Payment>> buscarTransacoes(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('transactions').get();
    return snapshot.docs.map((doc) => Payment.fromJson(doc.data()..['id'] = int.tryParse(doc.id) ?? 0)).toList();
  }

  static Future<void> salvarConta(String uid, Account account) {
    return _db.collection('users').doc(uid).collection('accounts').doc(account.id.toString()).set(account.toJson());
  }

  static Future<List<Account>> buscarContas(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('accounts').get();
    return snapshot.docs.map((doc) => Account.fromJson(doc.data()..['id'] = int.tryParse(doc.id) ?? 0)).toList();
  }

  static Future<void> salvarCategoria(String uid, Category category) {
    return _db.collection('users').doc(uid).collection('categories').doc(category.id.toString()).set(category.toJson());
  }

  static Future<List<Category>> buscarCategorias(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromJson(doc.data()..['id'] = int.tryParse(doc.id) ?? 0)).toList();
  }
}
