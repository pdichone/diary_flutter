import 'package:diary/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GettingStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: HexColor('#F5F6F8'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'DiaryBook.',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                '"Document your life!"',
                style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black26),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 220,
                height: 40,
                child: TextButton.icon(
                  label: Text('Sign in to Get Started'),
                  icon: Icon(Icons.login_rounded),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: HexColor('#69639F'),
                    textStyle: TextStyle(fontSize: 18),
                    onSurface: Colors.grey,
                  ),
                  onPressed: () {
                    //open login page
                    //open login page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Text('Or'),
              // SizedBox(
              //   height: 10,
              // ),
              // TextButton.icon(
              //   label: Text('Create an account'),
              //   icon: Icon(Icons.account_box_sharp),
              //   style: TextButton.styleFrom(
              //     primary: Colors.black,
              //     textStyle: TextStyle(fontSize: 18),
              //     onSurface: Colors.grey,
              //   ),
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => CreateAccountPage(),
              //         ));
              //   },
              // ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
