import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningSources extends StatelessWidget {
 const LearningSources({super.key});
 static const resources=[
 ('چارچوب رسمی CEFR','راهنمای سطح‌ها و خودارزیابی','https://www.coe.int/en/web/portfolio/self%20-assessment-grid'),
 ('Tatoeba','جملات و ترجمه‌ها؛ داده‌های بیرونی نیازمند بررسی','https://tatoeba.org/en/downloads'),
 ('Wiktionary dictionaries','واژه‌نامه‌های آفلاین و مجوزهای باز','https://github.com/open-dsl-dict/wiktionary-dict'),
 ('Open Dict Data','منابع واژه‌نامه چندزبانه','https://open-dict-data.github.io/'),
 ];
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('منابع آموزشی')),body:ListView(padding:const EdgeInsets.all(20),children:[
 const Text('مراجع پروژه؛ مشاهده سایت‌ها نیازمند اینترنت است. این فهرست به معنی وارد شدن تمام داده‌های منابع نیست.'),
 for(final item in resources) Card(child:ListTile(title:Text(item.$1),subtitle:Text(item.$2),trailing:const Icon(Icons.open_in_new),onTap:() async {
 try{if(await launchUrl(Uri.parse(item.$3),mode:LaunchMode.externalApplication))return;}catch(_){}
 if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('باز کردن منبع ممکن نبود.')));
 })),
 ]));
}
