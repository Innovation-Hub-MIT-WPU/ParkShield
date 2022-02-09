import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Authentication/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:ParkShield/widgets/alerts.dart';

class RegisterTab extends StatefulWidget {
  const RegisterTab({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);
  final num screenHeight, screenWidth;

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();
  String errorTextEmail = '', errorTextPassword = '';

  List<bool> isHidden = [
    true,
    true,
  ];
  List<Icon> visibilityIcon = [
    const Icon(Icons.visibility),
    const Icon(Icons.visibility),
  ];
  AuthService auth = AuthService();

  changeHidden({required int value}) {
    isHidden[value] = !isHidden[value];
    visibilityIcon[value] = isHidden[value]
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    setState(() {});
  }

  Future<void> register() async {
    List<dynamic> result = await auth.registerUser(
        email: emailController.text, password: passwordController.text);
    print(result);
    if (result[0] == 1) {
      errorTextEmail = result[1];
    } else if (result[0] == 2) {
      errorTextPassword = result[1];
    } else if (result[0] == -1) {
      AlertDialog(
        title: const Text('Error occurred!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(result[1]),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else if (result[0] == 0) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return const MyAlertDialog(
            title: 'You are now registered! \nNow please sign in',
            content: 'Okay',
            singleButton: 'popBack',
          );
        },
      );
      passwordController.text =
          confirmPasswordController.text = emailController.text = '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Divider divider = Divider(
      color: Colors.grey.shade400,
      indent: widget.screenWidth / 40,
      endIndent: widget.screenWidth / 40,
    );

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
              elevation: 10,
              child: Column(
                children: [
                  // Email input field
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.screenWidth / 40,
                    ),
                    child: ListTile(
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
                  divider,

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
                        child: visibilityIcon[0],
                        onTap: () {
                          changeHidden(value: 0);
                        },
                      ),
                      title: TextField(
                        obscureText: isHidden[0],
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
                  divider,

                  // Confirm password input field
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
                        child: visibilityIcon[1],
                        onTap: () {
                          changeHidden(value: 1);
                        },
                      ),
                      title: TextField(
                        obscureText: isHidden[1],
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Confirm password',
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
            alignment: FractionalOffset.bottomCenter,
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
                    "REGISTER",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () {
                register();
              },
            ),
          ),
        ),
      ],
    );
  }
}
