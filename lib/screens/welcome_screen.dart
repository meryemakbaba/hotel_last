import 'package:flutter/material.dart';
import 'package:serenadepalace/home.dart';
import 'package:serenadepalace/screens/signin_screen.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:serenadepalace/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        
                        TextSpan(
                            text:
                               '\n SERENADE PALACE HOTEL',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                               height: 0,
                               color: Color.fromARGB(255, 177, 166, 159),

                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child:  WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: HomePage(),
                      color: Color.fromARGB(255, 177, 166, 159).withOpacity(0.6),
                      textColor:Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
