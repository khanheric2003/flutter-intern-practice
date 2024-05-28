// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Based on https://github.com/firebase/FirebaseUI-Flutter/blob/main/packages/firebase_ui_auth/test/test_utils.dart

import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

class TestMaterialApp extends StatelessWidget {
  final Widget child;

  const TestMaterialApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}

class MockCredential extends Mock implements fba.UserCredential {}

class MockUserInfo extends Mock implements fba.UserInfo {
  @override
  final String providerId;

  MockUserInfo({required this.providerId});
}

class MockUser extends Mock implements fba.User {
  @override
  final List<fba.UserInfo> providerData;

  MockUser({this.providerData = const []});

  @override
  Future<fba.UserCredential> linkWithCredential(
    fba.AuthCredential? credential,
  ) async {
    return super.noSuchMethod(
      Invocation.method(
        #linkWithCredential,
        [credential],
      ),
      returnValue: MockCredential(),
      returnValueForMissingStub: MockCredential(),
    );
  }
}

class MockApp extends Mock implements FirebaseApp {}

class MockAuth extends Mock implements fba.FirebaseAuth {
  MockUser? user;

  @override
  fba.User? get currentUser => user;

  @override
  FirebaseApp get app => MockApp();

  List<FirebaseApp> get apps => [app];

  @override
  Future<fba.UserCredential> signInWithCredential(
    fba.AuthCredential? credential,
  ) async {
    return super.noSuchMethod(
      Invocation.method(
        #signInWithCredential,
        [credential],
      ),
      returnValue: MockCredential(),
      returnValueForMissingStub: MockCredential(),
    );
  }

  @override
  Future<fba.UserCredential> createUserWithEmailAndPassword({
    String? email,
    String? password,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#createUserWithEmailAndPassword, null, {
        #email: email,
        #password: password,
      }),
      returnValue: MockCredential(),
      returnValueForMissingStub: MockCredential(),
    );
  }
}

class TestException implements Exception {}
