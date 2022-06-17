import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';
import 'package:ParkShield/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);
  final num screenHeight, screenWidth;

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  String errorTextEmail = '', errorTextPassword = '';
  bool isHidden = true;
  Icon visibilityIcon = const Icon(Icons.visibility);

  @override
  void initState() {
    super.initState();
  }

  changeHidden() {
    isHidden = !isHidden;
    visibilityIcon = isHidden
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);

    setState(() {});
  }

  Future<void> signIn() async {
    if (emailController.text == '' || passwordController.text == '') {
      return;
    }
    List<dynamic> result = await signInUser(
        email: emailController.text, password: passwordController.text);

    print(result);

    if (result[0] == 1) {
      errorTextEmail = result[1];
    } else if (result[0] == 2) {
      errorTextPassword = result[1];
    } else if (result[0] == 0) {
      if (checkLoggedIn()) {
        Navigator.pushReplacementNamed(context, '/profile_page');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.screenHeight / 100,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Column(
                children: [
                  // Email input field
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.screenWidth / 40,
                    ),
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: const Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                      title: TextField(
                        obscureText: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                          errorText:
                              errorTextEmail == '' ? null : errorTextEmail,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                    indent: widget.screenWidth / 40,
                    endIndent: widget.screenWidth / 40,
                  ),

                  // Password input field
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.screenWidth / 40,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      trailing: InkWell(
                        child: visibilityIcon,
                        onTap: () {
                          changeHidden();
                        },
                      ),
                      title: TextField(
                        obscureText: isHidden,
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                          errorText: errorTextPassword == ''
                              ? null
                              : errorTextPassword,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.center,
            child: InkWell(
              child: Ink(
                width: double.parse('${widget.screenWidth}') -
                    widget.screenWidth / 2,
                height: double.parse('${widget.screenHeight}') / 17.5,
                decoration: BoxDecoration(
                  color: MAIN_COLOR_THEME['primary'],
                  borderRadius: BorderRadius.circular(widget.screenWidth / 50),
                ),
                child: Center(
                  child: Text(
                    "LOGIN",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () async {
                await signIn();
              },
            ),
          ),
        ),
        Divider(
          thickness: 2,
          indent: widget.screenWidth / 10,
          endIndent: widget.screenWidth / 10,
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.center,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.google),
                onPressed: () async {
                  if (await signInWithGoogle()) {
                    Navigator.pushReplacementNamed(context, '/profile_page');
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
