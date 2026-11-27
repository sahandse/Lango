import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'specialized_vocabulary.dart';
import 'vocabulary.dart';
import 'fsrs_review.dart';
import 'specialized_backup.dart';
import 'specialized_quiz.dart';

class SpecializedPage extends StatefulWidget {
 final SharedPreferences prefs;
 const SpecializedPage({super.key,required this.prefs});
 @override State<SpecializedPage> createState()=>_SpecializedPageState();
}
class _SpecializedPageState extends State<SpecializedPage>{
 final tts=FlutterTts();
 String topic='واژگان عمومی',query='',filter='all';
 String difficulty='all';
 static const topicDifficulty={'واژگان عمومی':'basic','فناوری':'intermediate','گرافیک':'advanced','نجوم':'advanced',"آمار":"intermediate","زیست‌شناسی":"intermediate","اینترنت":"basic","مدیریت":"intermediate","سینما":"basic","الگوریتم":"advanced","فناوری اطلاعات":"intermediate"};
 List<String> get topics=>specializedVocabulary.keys.where((t)=>difficulty=='all'||topicDifficulty[t]==difficulty).toList();
 bool cards=false,flipped=false;
 int page=0;
 late Map<String,dynamic> progress=Map<String,dynamic>.from(jsonDecode(widget.prefs.getString('specialized-progress')??'{}'));
 late Set<String> stars=(widget.prefs.getStringList('specialized-stars')??[]).toSet();
 String key(Word w)=>'$topic:${w.term}';
 List<Word> get list=>specializedVocabulary[topic]!.where((w){
  final k=key(w);final p=progress[k];
  return (w.term.toLowerCase().contains(query.toLowerCase())||w.meaning.contains(query))&&(filter=='all'||(filter=='star'&&stars.contains(k))||(filter=='due'&&(p?['due']??0)<=DateTime.now().millisecondsSinceEpoch));
 }).toList();
 Future<void> speak(String text) async {try{await tts.setLanguage('en-US');await tts.speak(text);}catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('صدای انگلیسی در دسترس نیست.')));}}
 Future<void> rate(Word w,int rating) async {
 final k=key(w);final p=progress[k];
 final next=scheduleReview(p is Map?Map<String,dynamic>.from(p):null,rating,k.codeUnits.fold<int>(0,(h,c)=>(h*31+c)&0x7fffffff));
 setState((){progress[k]=next;flipped=false;page=0;});
 await widget.prefs.setString('specialized-progress',jsonEncode(progress));
 }
 void star(Word w){setState((){if(!stars.add(key(w)))stars.remove(key(w));page=0;});widget.prefs.setStringList('specialized-stars',stars.toList());}
 Future<void> restore() async {
 try{
 final raw=(await Clipboard.getData(Clipboard.kTextPlain))?.text;
 if(raw==null)throw const FormatException('Empty backup');
 final backup=SpecializedBackup.parse(raw);
 if(!mounted)return;
 final confirmed=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('بازیابی پشتیبان'),content:const Text('پیشرفت و علاقه‌مندی‌های بخش تخصصی با اطلاعات پشتیبان جایگزین می‌شوند.'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('انصراف')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('بازیابی'))]));
 if(confirmed!=true||!mounted)return;
 await widget.prefs.setString('specialized-progress',jsonEncode(backup.progress));
 await widget.prefs.setStringList('specialized-stars',backup.stars.toList());
 if(mounted)setState((){progress=backup.progress;stars=backup.stars;page=0;flipped=false;});
 }catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('پشتیبان نامعتبر است؛ اطلاعات قبلی حفظ شدند.')));}
 }
 Future<void> quiz(bool reverse) async {
 await Navigator.push(context,MaterialPageRoute<void>(builder:(_)=>SpecializedQuiz(words:list,prefs:widget.prefs,topic:topic,reverse:reverse)));
 if(mounted)setState((){});
 }
 @override void dispose(){tts.stop();super.dispose();}
 @override Widget build(BuildContext context){
 final words=list;
 final offset=page*(cards?1:20);
 final visible=words.skip(offset).take(cards?1:20);
 return Scaffold(appBar:AppBar(title:const Text('واژگان تخصصی انگلیسی')),body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
 const Text('واژه‌های منتخب با تطبیق سرواژه در FarsiMatrix و ترجمه تألیفی Lango. سطح رسمی CEFR برای این مجموعه تعیین نشده است.'),
 const SizedBox(height:12),
 DropdownButton<String>(value:difficulty,items:const [DropdownMenuItem(value:'all',child:Text('تمام دشواری‌ها')),DropdownMenuItem(value:'basic',child:Text('عمومی / مقدماتی')),DropdownMenuItem(value:'intermediate',child:Text('موضوعی / متوسط')),DropdownMenuItem(value:'advanced',child:Text('تخصصی / پیشرفته'))],onChanged:(v){if(v!=null)setState((){difficulty=v;topic=topics.first;page=0;flipped=false;});}),
 DropdownButtonFormField<String>(key:ValueKey(difficulty),value:topic,items:topics.map((t)=>DropdownMenuItem(value:t,child:Text('$t (${specializedVocabulary[t]!.length})'))).toList(),onChanged:(v){if(v!=null)setState((){topic=v;page=0;flipped=false;});}),
 Text('مرور شده در این دسته: ${specializedVocabulary[topic]!.where((w)=>progress.containsKey(key(w))).length} از ${specializedVocabulary[topic]!.length}'),
 TextField(onChanged:(v)=>setState((){query=v;page=0;flipped=false;}),decoration:const InputDecoration(labelText:'جستجوی فارسی یا انگلیسی',prefixIcon:Icon(Icons.search))),
 DropdownButton<String>(value:filter,items:const [DropdownMenuItem(value:'all',child:Text('همه واژه‌ها')),DropdownMenuItem(value:'due',child:Text('آماده مرور')),DropdownMenuItem(value:'star',child:Text('علاقه‌مندی‌ها'))],onChanged:(v){if(v!=null)setState((){filter=v;page=0;flipped=false;});}),
 Text('نتیجه آزمون: ${widget.prefs.getInt('specialized-quiz:$topic:correct')??0} پاسخ صحیح از ${widget.prefs.getInt('specialized-quiz:$topic:attempts')??0}'),
 Wrap(spacing:8,children:[OutlinedButton(onPressed:words.map((w)=>w.meaning).toSet().length>=4?()=>quiz(false):null,child:const Text('آزمون انگلیسی به فارسی')),OutlinedButton(onPressed:words.map((w)=>w.term).toSet().length>=4?()=>quiz(true):null,child:const Text('آزمون فارسی به انگلیسی'))]),
 SwitchListTile(title:const Text('حالت فلش‌کارت'),value:cards,onChanged:(v)=>setState((){cards=v;page=0;flipped=false;})),
 if(words.isEmpty)const Text('واژه‌ای با این فیلتر پیدا نشد.'),
 for(final w in visible) Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(children:[
 ListTile(title:Text(w.term,textDirection:TextDirection.ltr),subtitle:!cards||flipped?Text(w.meaning):null,leading:IconButton(onPressed:()=>speak(w.term),icon:const Icon(Icons.volume_up)),trailing:IconButton(onPressed:()=>star(w),icon:Icon(stars.contains(key(w))?Icons.star:Icons.star_border))),
 if(cards&&!flipped)FilledButton(onPressed:()=>setState(()=>flipped=true),child:const Text('نمایش معنی')),
 if(cards&&flipped)Wrap(spacing:6,children:[for(final item in const [('دوباره',0),('سخت',1),('خوب',3),('آسان',7)]) OutlinedButton(onPressed:()=>rate(w,item.$2),child:Text(item.$1))]),
 if(!cards||flipped) Text(w.attribution??'',style:Theme.of(context).textTheme.bodySmall),
 ]))),
 Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[TextButton(onPressed:page>0?()=>setState((){page--;flipped=false;}):null,child:const Text('قبلی')),Text('${words.isEmpty?0:offset+1} / ${words.length}'),TextButton(onPressed:offset+(cards?1:20)<words.length?()=>setState((){page++;flipped=false;}):null,child:const Text('بعدی'))]),
 OutlinedButton.icon(onPressed:() async {await Clipboard.setData(ClipboardData(text:jsonEncode({'version':1,'progress':progress,'stars':stars.toList()})));if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('پشتیبان در کلیپ‌بورد کپی شد.')));},icon:const Icon(Icons.copy),label:const Text('کپی پشتیبان پیشرفت')),
 OutlinedButton.icon(onPressed:restore,icon:const Icon(Icons.restore),label:const Text('بازیابی پشتیبان از کلیپ‌بورد')),
 ])));
 }
}
