
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/services/preferece_manager.dart' show PreferencesManager;
import 'package:todo_app/core/theme/theme_controller.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/user_detais_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
class ProfileScreen extends StatefulWidget {
const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //مشان يوخد الاسم الي بدخله المستخدم
   late  String username;
   bool isloading =true;
   
    String? motivationQuote;
    File? _selectedImage;


   @override
  //رح تتنفذ بالبداية
  void initState() {
    super.initState();
    _loadData();
  
  }
 void _loadData() async{
      final pref = await SharedPreferences.getInstance();
  
  setState(() {
    //جاب اسم المستخدم
    username= pref.getString('username') ?? '';
   motivationQuote= pref.getString('motivation_quote');

     isloading = false;
  });
 
  }
  @override
  Widget build(BuildContext context) {
    return isloading ? CircularProgressIndicator()

      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("My Profile",
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 20,
              ),),
            ),
            //جايية الصورة والاسم والكتابة بالنص
          
            SizedBox(height: 16,),
            Center(
              child: Column(
                children: [
                   Stack( //dont acke mainAxisAlig: لانه العناصر الي جواتها تحت بعض
                   alignment: Alignment.bottomRight ,
                     children: [
                       CircleAvatar(
                                     backgroundImage:
                                        _selectedImage ==null?
                                      AssetImage('assets/images/person.png')
                                      : FileImage(_selectedImage!),
                                     radius: 60,
                                     backgroundColor: Colors.transparent, //شال خلفية الصورة
                                   ),
                               GestureDetector( //make it clickabale
                                 onTap:() async {
                                  showImageSourceDialog(context,
                                   (XFile file){
                                    setState(() {
                                      _selectedImage = File(file.path);
                                    });
                                   }
                                  );
                                    //بلتقط الصورة من خلاله
                                 // XFile? image =await ImagePicker().pickImage(source:ImageSource.gallery);
                                 
                                   //if(image!=null){
                                   // _selectedImage = File(image.path);
                                  // }
                                 
                                 },
                                 child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xFF282828),
                                  ) ,
                                 child: Icon(Icons.camera_alt,
                                 color: Color(0xFFFFFCFC),
                                 size: 26,
                                 ),
                                 ),
                               )
                     ],       
                   ),
                      SizedBox(height:6 ,),
                       
                       Text( username ,
                        style:TextStyle(
                          color: Color(0xFFFFFCFC),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ) ,
                       ) ,  
               
                          Text( username ,
                        style:TextStyle(
                          color: Color(0xFFFFFCFC),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ) ,
                       ) ,
                          Text(
                            motivationQuote ?? 'One task at a time. One step closer ' ,
                           style:TextStyle(
                          color: Color(0xFFC6C6C6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ) ,
                       )   
                ],
              ),
            ),
          SizedBox(height: 24,),
          Text( 'Profile Info',
                        
                        style:TextStyle(
                          color: Color(0xFFFFFCFC),
                          fontSize: 20,
                          //fontWeight: FontWeight.w400,
                        ) ,
                       ) ,  
         
                      // 3 widget جنب بعض
                      ListTile(
                       onTap: () async{
                        final result =await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          return UserDetaisScreen(
                            userName: username,
                            motivationQuote: motivationQuote,
                          );
                        },));
                        if( result!=null && result){
                          _loadData();
                        }
                       },
                       contentPadding: EdgeInsets.zero,
                       title: Text('User Details',
                       style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontSize: 16,
                       )
                       ),
                         
                         leading:  Icon(
                         Icons.person_outline,
                        color: Colors.white,
                        ),
                         trailing: Icon(
                        Icons.arrow_forward_ios,
                     color: Colors.white70,
                      size: 18,
                       ),
                      
                      ),
                      Divider(
                        color: Color(0xFF6E6E6E),
                        thickness: 1,
                      ),
         
                      ListTile(
                       
                       contentPadding: EdgeInsets.zero,
                       title: Text('Dark Mode',
                       style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontSize: 16,
                       )
                       ),
                         
                         leading:  Icon(
                         Icons.dark_mode_outlined,
                        color: Colors.white,
                        ),
                         trailing: 
                        ValueListenableBuilder(
                          valueListenable: ThemeController.themeNotifier,
                          builder: (BuildContext context, value, Widget? child){
                            return Switch(
                            value: value ==ThemeMode.dark,
                           onChanged:(bool value) async{
                           ThemeController.toggleTheme();
                            
                           },
                           activeTrackColor: Color(0xFF15B86C),
                           );
                        
                          } ,
                           ),
                     
                       ),
                      
                      Divider(
                        color: Color(0xFF6E6E6E),
                        thickness: 1,
                      ),
                  ListTile(
                       onTap: () async {
                            final pref = await SharedPreferences.getInstance();
                            pref.remove("username");
                            pref.remove("motivation_quote");
                            pref.remove("tasks");
                            Navigator.pushAndRemoveUntil(context,
                             MaterialPageRoute(
                              builder: (BuildContext context){
                                return WelcomeScreen();
                              },),
                                    (Route<dynamic>route)=>false,
                            );
                       },    

                       contentPadding: EdgeInsets.zero,
                       title: Text('Log Outq',
                       style: TextStyle(
                        color: Color(0xFFFFFCFC),
                        fontSize: 16,
                       )
                       ),
                         
                         leading:  Icon(
                         Icons.logout_outlined,
                        color: Colors.white,
                        ),
                         trailing: Icon(
                        Icons.arrow_forward_ios,
                     color: Colors.white70,
                      size: 18,
                       ),
                      
                      ),    
          ],
        
            ),
      );
  }
}
void showImageSourceDialog(BuildContext context, Function (XFile) selectedFile){
    showDialog(context: context,
     builder: (BuildContext context){
      return SimpleDialog(
        title: Text("chose Image souce",
        style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async{
              Navigator.pop(context);
              //بلتقط الصورة من خلاله
            XFile? image =await ImagePicker().pickImage(source:ImageSource.camera);
                                 
            if(image!=null){
             selectedFile(image);
            }                    
            },                    
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("camera"),
              ],
            ),
          ),
            SimpleDialogOption(
            onPressed: () async{
              Navigator.pop(context);
              //بلتقط الصورة من خلاله
         XFile? image =await ImagePicker().pickImage(source:ImageSource.gallery);
                                 
        if(image!=null){
         selectedFile(image);
     }
     },
            child: Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text("Galary"),
              ],
            ),
          )
        
        ],
      );
     },)
}