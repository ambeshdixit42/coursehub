import 'dart:convert';
import 'dart:io';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  AadOAuth oauth;

  LoginScreen({required this.oauth, super.key});

  Future<String?> getLogin() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "user");
    return value;
  }

  String nameCaper(String name) {
    name = name.toLowerCase();
    String newname = name[0].toUpperCase();
    for (var i = 1; i < name.length; i++) {
      newname = newname + name[i];
      if (name[i] == ' ') {
        newname = newname + name[i + 1].toUpperCase();
        i++;
      }
    }
    return newname;
  }

  void auth(BuildContext context) async {
    final storage = FlutterSecureStorage();
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        var response = await http.get(
            Uri.parse('https://graph.microsoft.com/v1.0/me'),
            headers: {HttpHeaders.authorizationHeader: accessToken});
        print(response.statusCode);
        if (response.statusCode != 200) {
          print("error");
          return;
        }
        var data = jsonDecode(response.body);
        var name = nameCaper(data['displayName']);
        print(name);
        var rollNumber = data['surname'];
        var email = data['userPrincipalName'];
        var id = data['id'];
        var course = data['jobTitle'];
        await storage.write(key: "user", value: id);
        /*FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');
        DocumentSnapshot snapshot = await users.doc(id).get();
        if (!snapshot.exists) {
          // New user
          //UserModel myUser = UserModel(id: id, name: name, email: email);
          //users.doc(id).set(myUser.toJson());
        } else {
          // Already there
          //UserModel myUser =
         // UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TabsScreen(oauth: oauth),
            ),
          );
        }
      } else {
        // TODO: error

      }*/
      }
    } catch (e) {
      // showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
          future: getLogin(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              /* SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TabsScreen(
                      oauth: oauth,
                    ),
                  ),
                );
              });*/
              return Text("Logged in!");
            } else {
              return Stack(
                children: [
                  Container(
                    height:double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/login_page.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                   child: SizedBox(
                    width: 120.0,
                    height: double.infinity,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Colors.black,
                      ),
                    ),
                  ),
                  ),
                   Container(
                     margin: const EdgeInsets.fromLTRB(0, 70, 20, 0),
                     alignment: Alignment.topRight,
                     child: RotatedBox(
                        quarterTurns: 1,
                         child: Text(
                             "CourseHub",
                         style: TextStyle(
                           fontFamily: "Proxima Nova",
                             fontSize: 57.87,
                             fontWeight: FontWeight.w700,
                             color: Colors.white
                         )
                          )
                       ),
                   ),
                  Column(
                    children:  <Widget>[
                      Container(
                          alignment: Alignment.topRight,
                         // margin: const EdgeInsets.fromLTRB(0, 482, 50, 0),
                          child:Text("by",
                              style:TextStyle(
                                  fontFamily: "Proxima Nova",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black
                              ))),

                      Expanded(
                        child: FittedBox(
                          child: FlutterLogo(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                  children:[
                    Container(
                     alignment: Alignment.topRight,
                     margin: const EdgeInsets.fromLTRB(0, 482, 50, 0),
                     child:Text("by",
                        style:TextStyle(
                            fontFamily: "Proxima Nova",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white
                        ))),
                    Container(
                      margin: const EdgeInsets.fromLTRB(275, 0, 0, 0),
                      height: 90,
                      width: 70,
                      child:Image(image: AssetImage("assets/img.png")),)
                  ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child :SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                            color : Color(0xffFECF6F)
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child :SizedBox(
                      height: 140,
                      width: 302,
                      child : Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Massa odio nibh eu eu nulla ac vestibulum amet. Ultrices magna ",
                          style:TextStyle(
                              fontFamily: "Proxima Nova",
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 750, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () => auth(context),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              width: 333,
                              height: 55,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                        child:
                                        Image.asset('assets/image 4.png')),
                                        Text("       Sign in with Microsoft",
                                        style:TextStyle(
                                            fontFamily: "Proxima Nova",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}