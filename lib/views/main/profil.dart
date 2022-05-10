import 'package:flutter/material.dart';

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
  var name= 'Rostand';
  var fullName= 'Guy Rostand';
  var fName= 'Guy';
  String email= 'rostand.siewe9@gmail.com';
  var tel1= '+237678312256';
  var tel2= '+237655418165';

  @override
  Widget build(BuildContext context) {
    var v=MediaQuery.of(context).size.height*.2;
    print(v);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  color: Colors.blue.shade800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Text('G',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Guy Rostand',style: TextStyle(color: Colors.white,fontSize: 25),)
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
                        leading: Icon(Icons.person_rounded),
                      ),
                      ListTile(
                        title: Text(email),
                        leading: Icon(Icons.email),
                      ),
                      ListTile(
                        title: Text(tel1),
                        leading: Icon(Icons.call),
                      ),
                      ListTile(
                        title: Text(tel2),
                        leading: Icon(Icons.call),
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
                                  fontWeight: FontWeight.bold,color: Colors.blue),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                          labelText: 'Email'
                                      ),
                                      controller: emailController,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(color: Colors.black38),
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: 'Telephone'
                                      ),
                                      controller: tel1Controller,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Telephone 2'
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
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'ENREGISTRER',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold,),
                                      ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                      ))
                                    ),
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
