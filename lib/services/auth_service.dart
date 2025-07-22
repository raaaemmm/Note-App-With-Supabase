import 'package:flutter/material.dart';
import 'package:note/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  
  final _client = Supabase.instance.client;

  // sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return UserModel.fromSupabaseUser(response.user!);
      }

      return null;
    } catch (e) {
      _handleAuthException(e, 'Sign in failed');
    }
    return null;
  }

  // sign up with email confirmation
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
    String? gender,
    String? shortBio,
    DateTime? dateOfBirth,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'supabase.noteapp://confirm-email', // deep link for email confirmation
        data: {
          if (displayName != null) 'full_name': displayName,
          if (gender != null) 'gender': gender,
          if (shortBio != null) 'short_bio': shortBio,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
        },
      );

      // Return the full response so we can check if email confirmation is needed
      return response;
    } catch (e) {
      _handleAuthException(e, 'Sign up failed');
      rethrow;
    }
  }

  // update user 
  Future<UserModel?> updateUser({
    String? displayName,
    String? gender,
    String? shortBio,
    DateTime? dateOfBirth,
  }) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(
          data: {
            if (displayName != null) 'full_name': displayName,
            if (gender != null) 'gender': gender,
            if (shortBio != null) 'short_bio': shortBio,
            if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
          },
        ),
      );

      if (response.user != null) {
        return UserModel.fromSupabaseUser(response.user!);
      }
      return null;
    } catch (e) {
      debugPrint('Oops! Failed to update user: 👉 $e');
      return null;
    }
  }

  // resend email confirmation
  Future<void> resendEmailConfirmation({
    required String email,
  }) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: 'supabase.noteapp://confirm-email',
      );
      debugPrint('Email confirmation resent to $email');
    } catch (e) {
      _handleAuthException(e, 'Failed to resend email confirmation');
    }
  }

  // listen for auth state changes
  Stream<User?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  // fetch current user with metadata
  UserModel? getCurrentUserModel() {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return UserModel.fromSupabaseUser(currentUser);
  }

  // delete the current user (requires Supabase function) | not configure yet
  Future<void> deleteAccount() async {
    try {
      debugPrint('Delete user feature requires backend function.');
    } catch (e) {
      debugPrint('Oops! Failed to delete account: 👉 $e');
    }
  }

  // send password reset email with deep link concept
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'supabase.noteapp://reset-password',
      );
      debugPrint('Password reset email sent to $email.');
    } catch (e) {
      _handleAuthException(e, 'Failed to send reset password email');
    }
  }

  // handle password reset after redirect
  Future<void> handlePasswordReset({
    required String newPassword,
  }) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        debugPrint('Password reset successfully!');
      } else {
        debugPrint('Failed to reset the password.');
      }
    } catch (e) {
      _handleAuthException(e, 'Failed to reset the password');
    }
  }

  // sign out the user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      debugPrint('User signed out successfully!');
    } catch (e) {
      debugPrint('Oops! Failed to sign out: 👉 $e');
    }
  }

  // private method to handle auth exceptions
  void _handleAuthException(Object e, String defaultMessage) {
    if (e is AuthException) {
      debugPrint('$defaultMessage: ${e.message}');
      throw e.message;
    }
    debugPrint('$defaultMessage: Unexpected error: $e');
    throw 'An unexpected error occurred. Please try again.';
  }
}