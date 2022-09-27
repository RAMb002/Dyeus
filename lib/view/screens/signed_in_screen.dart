import 'package:dyeus/view/css/css.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignedInScreen extends StatelessWidget {
  const SignedInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Text("You are signed in successfully",style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),)),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 100),
            child: AuthButton(
                color: kPrimaryColor,
                text: "Sign out",
                iconVisibility: true,
                fontSize: 18,
                icon: const Icon(Icons.logout),
                secondaryText: "", onTap: (){
                  FirebaseAuth.instance.signOut();
            }),
          )
        ],
      ),
    );
  }
}
