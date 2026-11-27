import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'level_lessons.dart';

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
 if(levelLessons[widget.language]?[level]!=null) ListTile(contentPadding:EdgeInsets.zero,title:Text(levelLessons[widget.language]![level]!.title),subtitle:Text(widget.prefs.getBool('lesson:${widget.language}:$level')==true?'تمرین تکمیل شده':'۴ جمله و آزمون'),trailing:const Icon(Icons.chevron_left),onTap:() async {await Navigator.push(context,MaterialPageRoute<void>(builder:(_)=>LevelLessonPage(prefs:widget.prefs,language:widget.language,level:level,lesson:levelLessons[widget.language]![level]!)));if(mounted)setState((){});}),
 ]))),
 const Text('این درس‌های آغازین تألیفی هستند؛ برای پوشش کامل CEFR و تعیین سطح معتبر کافی نیستند.'),
 ])));
}

class LevelLessonPage extends StatefulWidget {
 final SharedPreferences prefs;
 final String language,level;
 final LevelLesson lesson;
 const LevelLessonPage({super.key,required this.prefs,required this.language,required this.level,required this.lesson});
 @override State<LevelLessonPage> createState()=>_LevelLessonPageState();
}
class _LevelLessonPageState extends State<LevelLessonPage>{
 final tts=FlutterTts();
 bool quiz=false;
 int index=0,score=0;
 String? selected;
 List<String> choices=[];
 late final List<LessonPhrase> questions=List.of(widget.lesson.phrases)..shuffle();
 void prepare(){selected=null;if(index<questions.length){choices=questions.map((p)=>p.meaning).toList()..shuffle();}}
 Future<void> speak(String text) async {
 final locales={'en':'en-US','de':'de-DE','fr':'fr-FR','es':'es-ES','tr':'tr-TR'};
 try{await tts.setLanguage(widget.prefs.getString('accent:${widget.language}')??locales[widget.language]!);await tts.speak(text);}catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تلفظ در دستگاه در دسترس نیست.')));}
 }
 Future<void> next() async {
 setState((){index++;prepare();});
 if(index==questions.length){
 final key='lesson:${widget.language}:${widget.level}';
 final best=widget.prefs.getInt('$key:best')??0;
 if(score>best)await widget.prefs.setInt('$key:best',score);
 if(score==questions.length)await widget.prefs.setBool(key,true);
 }
 }
 @override void dispose(){tts.stop();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text('${widget.level} • ${widget.lesson.title}')),body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
 if(!quiz)...[
 Text(widget.lesson.note),
 for(final p in widget.lesson.phrases)Card(child:ListTile(title:Text(p.text,textDirection:TextDirection.ltr),subtitle:Text(p.meaning),trailing:IconButton(icon:const Icon(Icons.volume_up),onPressed:()=>speak(p.text)))),
 FilledButton(onPressed:()=>setState((){quiz=true;prepare();}),child:const Text('شروع آزمون'))
 ]else if(index>=questions.length)...[
 Text('نتیجه: $score از ${questions.length}',style:Theme.of(context).textTheme.headlineSmall),
 Text(score==questions.length?'تمرین تکمیل شد.':'درس را مرور و دوباره تمرین کن.'),
 FilledButton(onPressed:()=>setState((){quiz=false;index=0;score=0;selected=null;questions.shuffle();}),child:const Text('مرور دوباره')),
 TextButton(onPressed:()=>Navigator.pop(context),child:const Text('بازگشت به مسیر'))
 ]else...[
 LinearProgressIndicator(value:index/questions.length),
 Text('سؤال ${index+1} از ${questions.length}'),
 Text(questions[index].text,textDirection:TextDirection.ltr,style:Theme.of(context).textTheme.titleLarge),
 for(final c in choices)OutlinedButton(onPressed:selected==null?()=>setState((){selected=c;if(c==questions[index].meaning)score++;}):null,child:Text(c)),
 if(selected!=null)...[Text('پاسخ درست: ${questions[index].meaning}'),FilledButton(onPressed:next,child:const Text('ادامه'))]
 ]
 ])));
}
