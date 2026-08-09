
import 'package:flutter/material.dart';
import 'package:todo_app/core/widget/custom_text_form_feild.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserDetaisScreen extends StatefulWidget {
 
 const UserDetaisScreen({super.key, required this.userName, 
       required this.motivationQuote,
 });

  final String userName;
   final String? motivationQuote;

  @override
  State<UserDetaisScreen> createState() => _UserDetaisScreenState();
}

class _UserDetaisScreenState extends State<UserDetaisScreen> {
  final TextEditingController UserNameController = TextEditingController();

  final TextEditingController motivationController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();
 @override
 void initState() {
    
    super.initState();
    UserNameController.text = widget.userName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('User Details'),
      ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _key,
        child: Column(
          children: [
           CustomTextFormFeild(controller: UserNameController,
            hintText: 'lama sabaneh',
             title: 'User Name',
              validator : (value){
              if (value == null || value.isEmpty){
                return 'Enter User Name' ;
              }
                return null;
            }
           ),
          SizedBox(height: 20,),
          CustomTextFormFeild(controller: motivationController,
            hintText: 'one task at time, one step closer',
             title: 'Motivation Quote',
             maxLines: 5,
              validator : (value){
              if (value == null || value.isEmpty){
                return 'Enter Motivation Quote' ;
              }
                return null;
            }
           ),
          Spacer(),
          ElevatedButton(
             onPressed:() async{
              if(_key.currentState!.validate()){
                
                  //لتخزين الداتا الخاصة بالاسم الي رح يدخله المستخدم واستدعائها بأي مكان
                  final pref = await SharedPreferences.getInstance();
                  //احفضت الداتا اللي رح يدخلها المستخدم
                  await pref.setString('username' ,UserNameController.value.text);
                  await pref.setString('motivation_quote' ,motivationController.value.text);
                   //مشان اطلع المستخدم من الصفحة لما يكبر ع حفظ التعديلات
                     Navigator.pop(context,true);
             
              }
             },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 40)
              ),
             child: Text('Save Changed')
        )],
        ),
      ),
    ),
    );
  }
}