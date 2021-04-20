// import 'package:diary/widgets/create_account_form.dart';
// import 'package:diary/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:diary/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();
  bool isCreateAccountClicked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: HexColor('#B9C2D1'),
                )),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: isCreateAccountClicked != true
                      ? LoginForm(
                          formKey: _formKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)
                      : CreateAccountForm(
                          formKey: _formKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController,
                        ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.portrait_rounded),
                  label: Text(isCreateAccountClicked
                      ? 'Already have an account?'
                      : 'Create Account'),
                  style: TextButton.styleFrom(
                    primary: HexColor('#FD5B28'),
                    textStyle:
                        TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    onSurface: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isCreateAccountClicked) {
                        isCreateAccountClicked = true;
                      } else
                        isCreateAccountClicked = false;
                    });
                  },
                ),
              ],
            ),
            Expanded(
                flex: 2,
                child: Container(
                  color: HexColor('#B9C2D1'),
                )),
          ],
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  //source: https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
