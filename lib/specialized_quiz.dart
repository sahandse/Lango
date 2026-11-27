import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vocabulary.dart';

class SpecializedQuiz extends StatefulWidget {
 final List<Word> words;
 final SharedPreferences prefs;
 final String topic;
 final bool reverse;
 const SpecializedQuiz({super.key,required this.words,required this.prefs,required this.topic,required this.reverse});
 @override State<SpecializedQuiz> createState()=>_SpecializedQuizState();
}
class _SpecializedQuizState extends State<SpecializedQuiz>{
 late final List<Word> questions;
 List<String> options=[];
 final mistakes=<Word>[];
 int index=0,correct=0;
 String? selected;
 String answer(Word w)=>widget.reverse?w.term:w.meaning;
 @override void initState(){super.initState();final seen=<String>{};questions=(widget.words.where((w)=>seen.add(answer(w))).toList()..shuffle()).take(10).toList();prepare();}
 void prepare(){
 selected=null;options=[];
 if(index>=questions.length)return;
 final right=answer(questions[index]);
 final others=widget.words.map(answer).where((v)=>v!=right).toSet().toList()..shuffle();
 options=[right,...others.take(3)]..shuffle();
 }
 void choose(String value){
 if(selected!=null)return;
 final ok=value==answer(questions[index]);
 setState((){selected=value;if(ok){correct++;}else{mistakes.add(questions[index]);}});
 final base='specialized-quiz:${widget.topic}';
 widget.prefs.setInt('$base:attempts',(widget.prefs.getInt('$base:attempts')??0)+1);
 if(ok)widget.prefs.setInt('$base:correct',(widget.prefs.getInt('$base:correct')??0)+1);
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('آزمون تخصصی')),body:SafeArea(child:ListView(padding:const EdgeInsets.all(20),children:[
 if(questions.length<4)const Text('برای آزمون حداقل چهار پاسخ متفاوت لازم است.')
 else if(index>=questions.length)...[
 Text('نتیجه: $correct از ${questions.length}',style:Theme.of(context).textTheme.headlineSmall),
 for(final w in mistakes)ListTile(title:Text(w.term),subtitle:Text(w.meaning)),
 FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('پایان'))
 ]else...[
 Text('سؤال ${index+1} از ${questions.length}'),
 LinearProgressIndicator(value:index/questions.length),
 const SizedBox(height:20),
 Text(widget.reverse?questions[index].meaning:questions[index].term,style:Theme.of(context).textTheme.headlineSmall),
 for(final option in options)OutlinedButton(onPressed:selected==null?()=>choose(option):null,child:Text(option)),
 if(selected!=null)...[Text(selected==answer(questions[index])?'پاسخ صحیح':'پاسخ درست: ${answer(questions[index])}'),FilledButton(onPressed:()=>setState((){index++;prepare();}),child:const Text('ادامه'))]
 ]
 ])));
}
