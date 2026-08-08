
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/screens/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});
   final TextEditingController controller =TextEditingController(); //controller on text writen inside textField
   final GlobalKey<FormState> _key= GlobalKey<FormState>() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(    // مشان يظهروا لصور والنصوص 
        backgroundColor: const Color(0xFF181818), // الشاشة كلها لونها اسود
        body: SafeArea( 
          // مشان تيجي تحت الرأس
          child: SingleChildScrollView(  // solve  renderFlex error
          child: Form( // make validation on textformField: جواتها بكون textFormFields 
           key: _key ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16), //مسافة بين الصورة والنص مع الرأس
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage('assets/images/logo.png'),
                      height: 42,
                      width: 42,
                    ),
                    const SizedBox(width: 16), //مسافة بين الصورة والنص
                    const Text(
                      "Tasky",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 108),
              Text("Welcom To Tasky",
              style: TextStyle(color: Color(0xFFFFFCFC),
              fontSize: 24,
              fontWeight: FontWeight.w400,
              ),
              
            ),
              SizedBox(height: 8,),
              Text("Your productivity start here",
              style: TextStyle(color: Color(0xFFFFFCFC),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              )
              ),
             SizedBox(height:24),
             Image(
                      image: const AssetImage('assets/images/welcome.png'),
                      height: 200,
                      width: 215,
                    ),
              SizedBox(height:24),
              ElevatedButton(  //add button
                style:ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF15B86C) ,//خلفيته
                  foregroundColor:Color(0xFFFFFCFC), // لون الخط
               fixedSize:Size(343,40) ,
                ),
                onPressed: () async{  // للانتقال بين الصفحات لما اكبس ع الباتون بعد التأكد انه المستخدم دخل قيمة في مربع النص
                 _key.currentState?.validate();
                 //منع الانتقال الى الصفحة التانية الا ادا دخا المستخدم اسم ومش مسافة كمان
                 if(_key.currentState?.validate() ?? false){ //if null so the condition false dont enter if stat
                  
                  //لتخزين الداتا الخاصة بالاسم الي رح يدخله المستخدم واستدعائها بأي مكان
                  final pref = await SharedPreferences.getInstance();
                  
                  await pref.setString('username' ,controller.value.text);
                  Navigator.pushReplacement( //لما اكتب اسمي واروح ع الهوم , ما رح يسمحلي ارجع ع الويلكم
                    context,  //وين انا واقفة
                    MaterialPageRoute(
                      builder:(BuildContext context){ //يعني رح تبني HomeScreen واروح عليها
                      return MainScreen(); //بتجيب الاسم الي داخل textformField وبتعطيه للهوم لما اتنادي عليها
                    },
                     ),
                     );
                 }
                 else { }
                }, child: Text("Lets get started"),
              ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //Full Name: تنكتب ع الشمال من البداية موقعها
                children: [
                  SizedBox(height:24),
               
                   
                Text("Full Name",
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                )
                ),
               SizedBox(height:16),
               TextFormField( // have a parent named form
                // كل ما يصير تعديل ع الاسم الي رح يدخله المستخدم بناديها ورح يخزن الاسم الجديد
               controller: controller, //بوخد controller الي اعملته
                style: TextStyle(  //تنسيقات النص
               
                  color: Colors.white , //لون النص الي رح يكتبه المستخدم
                ),
               
               validator: (String? value){
                if(value?.trim().isEmpty ?? false){ // ادا ما دخل المستخدم اسم وكبس ع الباتون
                  return "please enter your full name";
                }
                return null;
                
               },
               decoration: InputDecoration( //بسمح لللمستخدم يكتب جواته كانه textbox
               hintText: 'eng. lama sabbaneh' , //تلميحة للمستخدم ايش يكتب
               hintStyle: TextStyle(color: Color(0xFF6D6D6D)), // color of hint text
               
               filled: true, //سمحت اعطي الخلفية لون
               fillColor: Color(0xFF282828), // لون الخلفية لمربع النص
               border:OutlineInputBorder(
               borderRadius: BorderRadius.circular(16),
               borderSide: BorderSide.none
               )
               
               ),
               cursorColor: Colors.white,
               ),
               
               
                ],
               
               ),
             ),
             
             
             
              ],
            ),
          ),
       
        ),
      
        ),
      );
  }
}