import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Create Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'First name',
                                      labelText: 'First name',
                                      errorStyle: TextStyle(fontSize: 18.0),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9.0)))))),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Last name',
                                labelText: 'Last name',
                                errorStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Container(
                              child: ElevatedButton(
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/third');
                                  if (_formkey.currentState!.validate()) {
                                    print('form submiitted');
                                  }
                                },
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                            ),
                          ),
                        ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
