
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
   bool isDarkMode = true;
    String? motivationQuote;


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
                                     backgroundImage: AssetImage('assets/images/person.png'),
                                     radius: 60,
                                     backgroundColor: Colors.transparent, //شال خلفية الصورة
                                   ),
                               GestureDetector( //make it clickabale
                                 onTap: () {},
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
                        Switch(value:true ,
                         onChanged:(bool value) {
                          setState((){
                          isDarkMode = value;
                          });
                         },
                         activeTrackColor: Color(0xFF15B86C),
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