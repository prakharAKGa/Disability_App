import 'package:disability_app/components/already_have_an_account_acheck.dart';
import 'package:disability_app/components/rounded_button.dart';
import 'package:disability_app/components/rounded_input_field.dart';
import 'package:disability_app/components/rounded_password_field.dart';
import 'package:disability_app/screens/Login/login_screen.dart';
import 'package:disability_app/screens/Signup/components/background.dart';
import 'package:disability_app/screens/Signup/components/or_divider.dart';
import 'package:disability_app/screens/Signup/components/social_icon.dart';
import 'package:disability_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30,),

            Text(
              "SIGN UP",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),

            SizedBox(height: size.height * 0.03),

            SvgPicture.asset(
              "assets/icons/image3.svg",
              height: size.height * 0.25,
            ),

            RoundedInputField(
              hintText: "Your User Name",
              onChanged: (value) {},
            ),

            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),

            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03),

            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),

            OrDivider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
