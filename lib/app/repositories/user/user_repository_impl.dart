
// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist_provider/app/exception/auth_exception.dart';
import 'package:todolist_provider/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

   final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}): _firebaseAuth = firebaseAuth;
  @override
  Future<User?> register(String email, String password) async {

   try {

    final userCredencial =  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   return userCredencial.user;

   } on FirebaseAuthException catch (e){

    //email-already-exists <-- possivel novo codigo de erro.
    if(e.code == 'email-already-in-use'){
      final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if(loginTypes.contains('password')){
          throw AuthException(
            message: 'Email já utilizado, por favor tente outro e-mail');
      }else if (loginTypes.contains('google')) {
        throw AuthException
        (message: 'Você se cadastrou através do Google, por favor utilize o botão Google para entrar' );
      } else {
        throw AuthException(message: 'E-mail não encontrado.');
      }
    } else {
      throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
    }
   }

  }
  
  @override
  Future<User?> login(String email, String password) async {
    

  try{

    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  return userCredential.user;

  } on PlatformException catch(e,s ){
    print(s);

    throw AuthException(message: e.message ?? 'Erro ao realizar Login');

  } on FirebaseAuthException catch (e, s){
    if(e.code == 'wrong-password'){
      throw AuthException(message: e.message ?? 'Login ou senha incorreto');
    }
    print(s);

    throw AuthException(message: e.message ?? 'Erro ao realizar Login');

  }

  }
  
  @override
  Future<void> forgotPassword(String email) async {
   var loginMethods =  await _firebaseAuth.fetchSignInMethodsForEmail(email);

   try {

    if(loginMethods.contains('password')){
    await _firebaseAuth.sendPasswordResetEmail(email: email);
   } else {
    throw AuthException(message: 'Cadastro realizado com o google, não e possivel resetar senha.');
   }

   } on PlatformException {
    
    throw AuthException(message: 'Erro ao resetar senha.');
   } 

  }
  
  @override
  Future<User?> googleLogin() async {
        List<String>? loginMethods;
    try {
        
        final googleSignin = GoogleSignIn();
        final googleUser =  await googleSignin.signIn();
        if(googleUser != null){
          loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
          if(loginMethods.contains('password')){
            throw AuthException(message: 'Email cadastrado, use "Esqueci a senha"');
          } else {
            final googleAuth = await googleUser.authentication;
            final firebaseCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken
            );
        
            var userCredencial = await _firebaseAuth.signInWithCredential(firebaseCredential);
            return userCredencial.user;
          }
        }
} on FirebaseAuthException catch (e, s) {
  print(s);
  if(e.code == 'account-exists-with-different-credential'){
    throw AuthException(message:  ''' 
    Email ja cadastrado nos seguintes provedores:
    ${loginMethods?.join(',')}
    ''');
  } else {
    throw AuthException(message: 'Erro ao realizar login');
  }
  
} 

  }
  
  @override
  Future<void>logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut(); 
  }
  
  @override
  Future<void> updateDisplayName(String name) async {
    final user =  _firebaseAuth.currentUser;
    if (user != null){
      await user.updateDisplayName(name);
      user.reload();
    }
  }
  
}