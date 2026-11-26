import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'specialized_vocabulary.dart';
import 'vocabulary.dart';
import 'fsrs_review.dart';

class SpecializedPage extends StatefulWidget {
 final SharedPreferences prefs;
 const SpecializedPage({super.key,required this.prefs});
 @override State<SpecializedPage> createState()=>_SpecializedPageState();
}
class _SpecializedPageState extends State<SpecializedPage>{
 final tts=FlutterTts();
 String topic='واژگان عمومی',query='',filter='all';
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
 @override void dispose(){tts.stop();super.dispose();}
 @override Widget build(BuildContext context){
 final words=list;
 final offset=page*(cards?1:20);
 final visible=words.skip(offset).take(cards?1:20);
 return Scaffold(appBar:AppBar(title:const Text('واژگان تخصصی انگلیسی')),body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
 const Text('واژه‌های منتخب با تطبیق سرواژه در FarsiMatrix و ترجمه تألیفی Lango. سطح رسمی CEFR برای این مجموعه تعیین نشده است.'),
 const SizedBox(height:12),
 DropdownButtonFormField<String>(value:topic,items:specializedVocabulary.entries.map((e)=>DropdownMenuItem(value:e.key,child:Text('${e.key} (${e.value.length})'))).toList(),onChanged:(v){if(v!=null)setState((){topic=v;page=0;flipped=false;});}),
 Text('مرور شده در این دسته: ${specializedVocabulary[topic]!.where((w)=>progress.containsKey(key(w))).length} از ${specializedVocabulary[topic]!.length}'),
 TextField(onChanged:(v)=>setState((){query=v;page=0;flipped=false;}),decoration:const InputDecoration(labelText:'جستجوی فارسی یا انگلیسی',prefixIcon:Icon(Icons.search))),
 DropdownButton<String>(value:filter,items:const [DropdownMenuItem(value:'all',child:Text('همه واژه‌ها')),DropdownMenuItem(value:'due',child:Text('آماده مرور')),DropdownMenuItem(value:'star',child:Text('علاقه‌مندی‌ها'))],onChanged:(v){if(v!=null)setState((){filter=v;page=0;flipped=false;});}),
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
 ])));
 }
}
