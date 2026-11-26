import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const levels=['A1','A2','B1','B2','C1','C2'];
const goals=<String,List<String>>{
'A1':['معرفی خود و پرسیدن اطلاعات ساده','درک عبارت‌های روزمره و نیازهای اولیه'],
'A2':['گفت‌وگو درباره خرید، خانواده و محیط اطراف','توصیف ساده تجربه‌ها و برنامه‌ها'],
'B1':['بیان نظر و توضیح تجربه‌ها','درک نکات اصلی گفتار روشن درباره موضوعات آشنا'],
'B2':['بحث درباره موضوعات مشخص و انتزاعی','توضیح دیدگاه و مقایسه مزایا و معایب'],
'C1':['استفاده منعطف از زبان در محیط آموزشی و اجتماعی','درک معنای ضمنی متن‌های پیچیده'],
'C2':['درک و ترکیب اطلاعات منابع مختلف','بیان دقیق و روان تفاوت‌های ظریف معنایی'],
};

class CurriculumPage extends StatefulWidget{
 final SharedPreferences prefs;
 final String language;
 const CurriculumPage({super.key,required this.prefs,required this.language});
 @override State<CurriculumPage> createState()=>_CurriculumPageState();
}
class _CurriculumPageState extends State<CurriculumPage>{
 String get key=>'target-level:${widget.language}';
 late String target=widget.prefs.getString(key)??'A1';
 @override Widget build(BuildContext context)=>Scaffold(
 appBar:AppBar(title:const Text('مسیر یادگیری')),
 body:SafeArea(child:ListView(padding:const EdgeInsets.all(20),children:[
 const Text('هدف آموزشی خود را انتخاب کن. این انتخاب تعیین سطح یا گواهی CEFR نیست.'),
 const SizedBox(height:12),
 for(final level in levels) Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Row(children:[Text(level,style:Theme.of(context).textTheme.headlineSmall),const Spacer(),if(target==level)const Icon(Icons.check_circle)]),
 for(final goal in goals[level]!) Padding(padding:const EdgeInsets.symmetric(vertical:4),child:Text(goal)),
 TextButton(onPressed:() async {await widget.prefs.setString(key,level);if(mounted)setState(()=>target=level);},child:Text(target==level?'هدف فعلی':'انتخاب هدف')),
 ]))),
 const Text('اهداف به‌صورت خلاصه و آموزشی بر اساس چارچوب CEFR هستند. محتوای کامل و آزمون معتبر هر سطح هنوز در برنامه وجود ندارد.'),
 ])));
}
