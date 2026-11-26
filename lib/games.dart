import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vocabulary.dart';

class GamesPage extends StatefulWidget {
  final List<Word> words;
  final SharedPreferences prefs;
  final String language;
  const GamesPage({super.key,required this.words,required this.prefs,required this.language});
  @override State<GamesPage> createState()=>_GamesPageState();
}
class _GamesPageState extends State<GamesPage> {
  int mode=0, rounds=0, correct=0, current=0;
  late List<Word> pairs;
  late List<int> left,right;
  final matched=<int>{};
  int? selected;
  late List<String> sentences;
  List<int> chosen=[];
  List<String> tokens=[];
  List<int> order=[];
  String? result;
  @override void initState(){super.initState();restart();}
  void restart(){
    final unique=<String>{};
    pairs=(List<Word>.of(widget.words)..shuffle()).where((w)=>unique.add(w.meaning)).take(5).toList();
    left=List.generate(pairs.length,(i)=>i)..shuffle();
    right=List.generate(pairs.length,(i)=>i)..shuffle();
    matched.clear();selected=null;rounds=0;correct=0;current=0;
    sentences=widget.words.map((w)=>w.example.trim()).where((s)=>s.split(RegExp(r'\s+')).length>=3).toSet().toList()..shuffle();
    nextSentence();
  }
  void nextSentence(){
    chosen=[];result=null;
    tokens=sentences.isEmpty?[]:sentences[current%sentences.length].split(RegExp(r'\s+'));
    order=List.generate(tokens.length,(i)=>i)..shuffle(Random());
  }
  void score(bool ok){
    rounds++;if(ok)correct++;
    final key='games:${widget.language}';
    widget.prefs.setInt('$key:attempts',(widget.prefs.getInt('$key:attempts')??0)+1);
    if(ok)widget.prefs.setInt('$key:correct',(widget.prefs.getInt('$key:correct')??0)+1);
  }
  void match(int i){
    if(selected==null||matched.contains(i))return;
    setState((){final ok=selected==i;score(ok);if(ok)matched.add(i);selected=null;result=ok?'درست است!':'دوباره تلاش کن';});
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Lango Games')),
    body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:600),child:ListView(padding:const EdgeInsets.all(20),children:[
      SegmentedButton<int>(segments:const [ButtonSegment(value:0,label:Text('تطبیق واژه')),ButtonSegment(value:1,label:Text('جمله‌سازی'))],selected:{mode},onSelectionChanged:(v)=>setState((){mode=v.first;restart();})),
      const SizedBox(height:20),
      Text('پاسخ صحیح: $correct از $rounds',style:Theme.of(context).textTheme.titleLarge),
      const SizedBox(height:16),
      if(mode==0)...[
        const Text('واژه و معنی درست را انتخاب کن.'),
        const SizedBox(height:12),
        Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Expanded(child:Column(children:[for(final i in left) Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton(onPressed:matched.contains(i)?null:()=>setState(()=>selected=i),style:OutlinedButton.styleFrom(backgroundColor:selected==i?Theme.of(context).colorScheme.primaryContainer:null,minimumSize:const Size.fromHeight(54)),child:Text(pairs[i].term)))])),
          const SizedBox(width:12),
          Expanded(child:Column(children:[for(final i in right) Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton(onPressed:matched.contains(i)||selected==null?null:()=>match(i),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(54)),child:Text(pairs[i].meaning)))])),
        ]),
        if(result!=null)Text(result!),
        if(matched.length==pairs.length)FilledButton(onPressed:()=>setState(restart),child:const Text('دور جدید'))
      ] else if(sentences.isEmpty)...[
        const Text('برای این زبان هنوز جمله کافی وجود ندارد.')
      ] else ...[
        const Text('کلمات را به ترتیب درست قرار بده.'),
        const SizedBox(height:12),
        Card(child:Padding(padding:const EdgeInsets.all(16),child:Wrap(textDirection:TextDirection.ltr,spacing:6,children:[for(final i in chosen) ActionChip(label:Text(tokens[i]),onPressed:result!=null?null:()=>setState(()=>chosen.remove(i)))]))),
        const SizedBox(height:12),
        Wrap(textDirection:TextDirection.ltr,spacing:6,children:[for(final i in order) if(!chosen.contains(i)) ActionChip(label:Text(tokens[i]),onPressed:result!=null?null:()=>setState(()=>chosen.add(i)))]),
        if(result==null)FilledButton(onPressed:chosen.length!=tokens.length?null:()=>setState((){final ok=chosen.map((i)=>tokens[i]).join(' ')==tokens.join(' ');score(ok);result=ok?'درست است!':tokens.join(' ');}),child:const Text('بررسی')),
        if(result!=null)...[Text(result!),FilledButton(onPressed:()=>setState((){current++;nextSentence();}),child:const Text('جمله بعدی'))]
      ]
    ])))));
}
