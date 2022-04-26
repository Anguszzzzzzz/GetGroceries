import 'dart:async';

import 'package:checklist_app/controllers/auth_controller.dart';
import 'package:checklist_app/general_providers.dart';
import 'package:checklist_app/repositories/auth_repository.dart';
import 'package:checklist_app/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'home.dart';

class LoginScreen extends HookWidget {
  // late final Reader _read;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // loginStateSubscription = authBlock.currentUser.listen((fbUser) {
  //   //   if (fbUser != null) {
  //   //     Navigator.of(context).pushReplacement(
  //   //         MaterialPageRoute(builder: (context) => HomeScreen()));
  //   //   }
  //   // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final authControllerState = useProvider(authControllerProvider.state);

    // final authRepositoryProvider =
    //     Provider<AuthRepository>((ref) => AuthRepository(ref.read));

    // final user = _read(authRepositoryProvider).getCurrentUser();

    return Scaffold(
      backgroundColor: primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
            Image(
              height: MediaQuery.of(context).size.height * 0.4,
                image: AssetImage('lib/images/bg.png')),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              child: SignInButton(
                Buttons.Google,
                padding: EdgeInsets.all(3),
                elevation: 5,
                onPressed: () => {
                  context.read(authControllerProvider).logInWithGoogle(),
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
