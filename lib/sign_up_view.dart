import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:travel_network/auth_service.dart';
import 'package:travel_network/checkNetwork.dart';
import 'package:travel_network/provider_widget.dart';
import 'package:travel_network/ui_curve_design.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum AuthFormType { signIn, signUp, reset }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});
  bool showSpinner = false;

  var reNumFieldController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  String _email,
      _password,
      _firstname,
      _lastname,
      _gender,
      _contact,
      _profileimg,
      _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  
  void submit() async {
    if (validate()) {
      setState(() {
        showSpinner = true;
      });

      try {
        final auth = Provider.of(context).auth;

        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signinWithEmailAndPassword(_email, _password);
          print("$uid");
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("password reset mail sent");
          _warning = "A Password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          String uid = await auth.createUserWithEmailAndPassword(_email,
              _password, _firstname, _lastname, _gender, _contact, _profileimg);
          print("$uid");
          final _userCollectionReference = Firestore.instance;

    DocumentReference interestid =
        await _userCollectionReference.collection('Interests').document(uid);

    interestid.setData({
      'beach': false,
      'mountain': false,
      'camp': false,
      'waterfall': false,
      'forest': false,
      'ancient': false,
      'park': false,
      'hotel': false,
    });
          Navigator.of(context).pushReplacementNamed('/home');
        }

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        print(e);
        // setState(() {
        _warning = e.message;
        //  });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return InternetOffiline();
          }
          return child;
        },
        child: Scaffold(
            // appBar: AppBar(
            //   iconTheme: new IconThemeData(color: Colors.black),
            //   title: Text('Travelo',
            //       style: TextStyle(
            //           color: Colors.black, fontWeight: FontWeight.bold)),
            //   backgroundColor: Colors.white30,
            //   elevation: 0,
            //   titleSpacing: 10,
            // ),
            body: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: GestureDetector(
                  onTap: () {
                    // call this method here to hide soft keyboard
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                    color: Colors.white,
                    height: _height,
                    width: _width,
                    child: authFormType == AuthFormType.signIn ||
                            authFormType == AuthFormType.reset
                        ? CustomPaint(
                            painter: CurvePainter(),
                            child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    showAlert(),
                                    SizedBox(
                                      height: _height * 0.06,
                                    ),
                                    buildHeaderText(),
                                    buildSubHeadText(),
                                    SizedBox(
                                      height: _height * 0.02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Form(
                                          key: formKey,
                                          child: Column(
                                              children: buildInputs() +
                                                  buildButtons())),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SafeArea(child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  showAlert(),
                                  SizedBox(
                                    height: _height * 0.06,
                                  ),
                                  buildHeaderText(),
                                  buildSubHeadText(),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Form(
                                        key: formKey,
                                        child: Column(
                                            children: buildInputs() +
                                                buildButtons())),
                                  )
                                ],
                              ),
                            ),
                          ),)
                  ),
                ))));
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: AutoSizeText(
              _warning,
              maxLines: 3,
            )),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                })
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Welcome !!";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Sign Up";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }

  AutoSizeText buildSubHeadText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign in to Continue";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "";
    } else {
      _headerText = "Create a new Account";
    }
    return AutoSizeText(_headerText,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800));
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          keyboardType: TextInputType.text,
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Email',
            errorMaxLines: 1,
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.email,
              color: Colors.blue,
            ),
          ),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(
        height: 8,
      ));

      return textFields;
    }

    //if were in the signup state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          keyboardType: TextInputType.text,
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'First Name',
            errorMaxLines: 1,
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
          ),
          onSaved: (value) => _firstname = value,
        ),
      );

      textFields.add(SizedBox(
        height: 8,
      ));

      textFields.add(
        TextFormField(
          keyboardType: TextInputType.text,
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Last Name',
            errorMaxLines: 1,
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
          ),
          onSaved: (value) => _lastname = value,
        ),
      );

      textFields.add(SizedBox(
        height: 8,
      ));

      textFields.add(
        DropdownButtonFormField<String>(
          validator: (value) {
            if (value == null) {
              return "gender can't be empty";
            }
          },
          value: _gender,
          items: [
            "Male",
            "Female",
          ]
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _gender = value);
          },
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          decoration: InputDecoration(
                        hintText: "Select Gender",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        prefixIcon: const Icon(
                          Icons.supervisor_account,
                          color: Colors.blue,
                        ),
                      ),
        ),
      );

      textFields.add(SizedBox(
        height: 8,
      ));

      textFields.add(
        TextFormField(
          keyboardType: TextInputType.phone,
          validator: ContactValidator.validate,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Contact Number',
            errorMaxLines: 1,
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.phone,
              color: Colors.blue,
            ),
          ),
          onSaved: (value) => _contact = value,
        ),
      );

      textFields.add(SizedBox(
        height: 8,
      ));
    }

    //add email and Password
    textFields.add(
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                      ),
        onSaved: (value) => _email = value,
      ),
    );

    textFields.add(SizedBox(
      height: 8,
    ));

    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .accentColor, width: 1.0)),
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          color: Colors.blue,
                        ),
                      ),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );

    return textFields;
  }

  List<Widget> buildButtons() {
    String _switchButton, _newFormState, _submitButtonText;
    bool _showForgotPasowrd = false;
    if (authFormType == AuthFormType.signIn) {
      _switchButton = "Don't have an account? | Sign Up";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPasowrd = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButton = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showForgotPasowrd = false;
    } else {
      _switchButton = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      SizedBox(
        height: 10,
      ),
      showForgotPassowrd(_showForgotPasowrd),
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: RaisedButton(
            onPressed: () {
              submit();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.black,
            textColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _submitButtonText,
                style: TextStyle(fontSize: 20),
              ),
            )),
      ),
      FlatButton(
          onPressed: () {
            switchFormState(_newFormState);
          },
          child: Text(
            _switchButton,
            style: TextStyle(color: Colors.black),
          )),
      SizedBox(
        height: 20,
      ),
    ];
  }

  Widget showForgotPassowrd(bool visibale) {
    return Visibility(
      child: FlatButton(
          onPressed: () {
            setState(() {
              authFormType = AuthFormType.reset;
            });
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue),
          )),
      visible: visibale,
    );
  }
}
