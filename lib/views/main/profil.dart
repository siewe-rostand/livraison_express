import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/string_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController= TextEditingController();
  TextEditingController fNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController tel1Controller= TextEditingController();
  TextEditingController tel2Controller= TextEditingController();
  late SharedPreferences sharedPreferences;
  String name= '';
  String initialName= '';
  String uid= '';
  String fullName= '';
  String fName= '';
  String email= '';
  String tel1= '';
  String tel2= '';
  initData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    String? userString =sharedPreferences.getString("userData");
    var extractedUserData =json.decode(userString!);
    AppUser1 user1=AppUser1.fromJson(extractedUserData);
    AppUser1? appUser1 = UserHelper.currentUser1??user1;
    setState(() {
      email =appUser1.email!;
      uid =appUser1.uid!;
      name =appUser1.firstname!;
      fName =appUser1.lastname!;
      tel1 =appUser1.telephone!;
      tel2 =appUser1.telephoneAlt??'';
      fullName =appUser1.fullname!;
      initialName =fullName.substring(0,1).toUpperCase();
    });

  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  color: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                       CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Text(initialName,style: const TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(fullName,style: const TextStyle(color: Colors.white,fontSize: 25),)
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Column(
                    children:  [
                      ListTile(
                        title: Text(
                            fullName,
                        ),
                        leading: const Icon(Icons.person_rounded),
                      ),
                      ListTile(
                        title: Text(email),
                        leading: const Icon(Icons.email),
                      ),
                      ListTile(
                        title: Text(tel1),
                        leading: const Icon(Icons.call),
                      ),
                      ListTile(
                        title: Text(tel2),
                        leading: const Icon(Icons.call),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.27,
            left: MediaQuery.of(context).size.width-60,
              child:  FractionalTranslation(
                translation: const Offset(0,0.5),
                child: FloatingActionButton(
                  child: const Icon(Icons.create),
                  onPressed: (){
                    setState(() {
                      nameController.text =name;
                      fNameController.text =fName;
                      emailController.text =email;
                      tel2Controller.text =tel2;
                      tel1Controller.text =tel1;
                    });
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            title: const Text( ' Modifier mon profil ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,color: primaryColor),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Nom'
                                      ),
                                      controller: nameController,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Prenom'
                                      ),
                                      controller: fNameController,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(color: Colors.black38),
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: StringManager.email
                                      ),
                                      controller: emailController,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(color: Colors.black38),
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: StringManager.phoneNumber
                                      ),
                                      controller: tel1Controller,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: '${StringManager.phoneNumber} 2'
                                      ),
                                      controller: tel2Controller,
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                SizedBox(
                                  width:double.infinity,
                                  height:45,
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        var data={
                                          "uid":uid,
                                          "firstname":nameController.text,
                                          'lastname':fNameController.text,
                                          "email":emailController.text,
                                          "telephone":tel1Controller.text,
                                          "telephone_alt":tel2Controller.text,
                                          "fullname":fNameController.text + " " + nameController.text,
                                          "is_guest":true
                                        };
                                        await ApiAuthService(context: context).edit(data: data).then((value){
                                          var res = json.decode(value.body);
                                          var msg =res['message'];
                                          var user= res['data'];
                                          setState(() {
                                            nameController.text =user['firstname'];
                                            fNameController.text =user['lastname'];
                                            emailController.text =user['email'];
                                            tel2Controller.text =user['telephone'];
                                            tel1Controller.text =user['telephone_alt'];
                                            fullName =user['fullname'];

                                            fName =fNameController.text;
                                          });
                                          var data2={
                                            "uid":uid,
                                            "firstname":nameController.text,
                                            'lastname':fNameController.text,
                                            "email":emailController.text,
                                            "telephone":tel1Controller.text,
                                            "telephone_alt":tel2Controller.text,
                                            "fullname":fNameController.text + " " + nameController.text,
                                            "is_guest":true
                                          };
                                          print({data2});
                                          var userData=json.encode(data2);
                                          // pref.reload();
                                          // pref.setString("userData", userData);
                                          UserHelper.currentUser1 =AppUser1.fromJson(data2);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                              msg: msg,
                                            backgroundColor: Colors.green
                                          );
                                        });
                                      },
                                      child: const Text(
                                        'ENREGISTRER',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold,),
                                      ),
                                    style: loginButtonStyle(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
          )
        ],
      ),
    );
  }
}
