import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/screens/login_screen.dart';
import 'firebase_options.dart';
//import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final Config config = Config(
    tenant: "850aa78d-94e1-4bc6-9cf3-8c11b530701c",
    clientId: "62b84924-8e2d-46d8-b1ed-5dee3806e650",
    scope: "user.read openid profile offline_access",
    redirectUri:
    "https://coursehub-56aac.firebaseapp.com/__/auth/handler",
    webUseRedirect: true,
    navigatorKey: navigatorKey,
  );
  final AadOAuth oauth = AadOAuth(config);

  MyApp({super.key});

  Future<String?> getLogin() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "user");
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: LoginScreen(
        oauth: oauth,
      ),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Plugin example app'),
      //   ),
      //   body: FutureBuilder<String?>(
      //     future: getLogin(),
      //     builder: (context, snapshot) => (snapshot.hasData)
      //         ? Text(snapshot.data!)
      //         : Column(
      //                 children: [
      //                   ElevatedButton(
      //                     child: const Text('ms login'),
      //                     onPressed: () async {
      //                       const storage =  FlutterSecureStorage();
      //                       try {
      //                         await oauth.login();
      //                         var accessToken = await oauth.getAccessToken();
      //                         if (accessToken != null) {
      //                           final storage = FlutterSecureStorage();
      //                           var response = await http.get(
      //                               Uri.parse(
      //                                   'https://graph.microsoft.com/v1.0/me'),
      //                               headers: {
      //                                 HttpHeaders.authorizationHeader:
      //                                     accessToken
      //                               });
      //                           print(response.statusCode);
      //                           if (response.statusCode != 200) {
      //                             print("error");

      //                             return;
      //                           }
      //                           var data = jsonDecode(response.body);
      //                           var name = nameCaper(data['displayName']);
      //                           var rollNumber = data['surname'];
      //                           var email = data['userPrincipalName'];
      //                           var uid = data['id'];
      //                           var course = data['jobTitle'];
      //                           await storage.write(key: "user", value: uid);
      //                         } else {
      //                           // TODO: error

      //                         }
      //                       } catch (e) {
      //                         // showError(e);
      //                       }
      //                     },
      //                   ),
      //                 ],
      //                 //],
      //               ),
      //   ),
      // ),
    );
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

  void showMessage(String text, BuildContext context) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}