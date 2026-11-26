import 'dart:typed_data';
import 'vocabulary.dart';
import 'games.dart';
import 'voice.dart';
import 'lango_theme.dart';
import 'fsrs_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await loadSentenceContent();
  for(final lang in names.keys){final items=jsonDecode(prefs.getString('personal:$lang')??'[]') as List;final seen=decks[lang]!.map((w)=>w.term).toSet();for(final row in items){if(seen.add(row['term'] as String))decks[lang]!.add(Word(row['term'] as String,row['meaning'] as String,row['example'] as String));}}
  final logo=base64Decode((await rootBundle.loadString('assets/brand/logo.webp.b64')).trim());
  runApp(Lango(prefs: prefs,logo:logo));
}

class Lango extends StatefulWidget {
  final SharedPreferences prefs;
  final Uint8List logo;
  const Lango({super.key, required this.prefs,required this.logo});
  @override State<Lango> createState() => _LangoState();
}
class _LangoState extends State<Lango> {
  late bool dark = widget.prefs.getBool('dark') ?? false;
  @override Widget build(BuildContext context) => MaterialApp(
    title:'Lango', debugShowCheckedModeBanner:false,
    locale:const Locale('fa'), supportedLocales:const [Locale('fa'),Locale('en')],
    localizationsDelegates:GlobalMaterialLocalizations.delegates,
    theme:langoTheme(Brightness.light),
    darkTheme:langoTheme(Brightness.dark),
    themeMode:dark?ThemeMode.dark:ThemeMode.light,
    home:Study(prefs:widget.prefs,logo:widget.logo,dark:dark,onTheme:() {setState(()=>dark=!dark);widget.prefs.setBool('dark',dark);}),
  );
}
class Study extends StatefulWidget {
  final SharedPreferences prefs;
  final bool dark;
  final VoidCallback onTheme;
  final Uint8List logo;
  const Study({super.key,required this.prefs,required this.dark,required this.onTheme,required this.logo});
  @override State<Study> createState()=>_StudyState();
}
class _StudyState extends State<Study> {
  final tts=FlutterTts();
  final answer=TextEditingController();
  late String language=widget.prefs.getString('language')??'en';
  late String accent=accents[language]!.contains(widget.prefs.getString('accent:$language')) ? widget.prefs.getString('accent:$language')! : accents[language]!.first;
  double speed=0.42;
    String mode='cards';
  int correct=0, attempted=0;
  late int dailyGoal=widget.prefs.getInt('dailyGoal')??20;
  String get today=>DateTime.now().toLocal().toIso8601String().substring(0,10);
  int get todayReviews=>widget.prefs.getInt('reviews:$today')??0;
  Future<void> settings() async {await showModalBottomSheet<void>(context:context,builder:(ctx)=>StatefulBuilder(builder:(ctx,update)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('تنظیمات یادگیری'),ListTile(title:const Text('هدف روزانه'),trailing:Text('$dailyGoal کارت')),Slider(value:dailyGoal.toDouble(),min:5,max:50,divisions:9,onChanged:(v){setState(()=>dailyGoal=v.round());update((){});widget.prefs.setInt('dailyGoal',dailyGoal);}),ListTile(title:const Text('لهجه'),trailing:DropdownButton<String>(value:accent,items:accents[language]!.map((a)=>DropdownMenuItem(value:a,child:Text(a))).toList(),onChanged:(v){if(v==null)return;setState(()=>accent=v);update((){});widget.prefs.setString('accent:$language',v);})),ListTile(title:const Text('تم روشن / تاریک'),trailing:IconButton(onPressed:widget.onTheme,icon:const Icon(Icons.brightness_6))) ])))));}
  Future<void> addCard() async {final term=TextEditingController(),meaning=TextEditingController(),example=TextEditingController();final lang=language;final result=await showDialog<Word>(context:context,builder:(ctx)=>AlertDialog(title:const Text('فلش‌کارت شخصی'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:term,decoration:const InputDecoration(labelText:'واژه یا جمله')),TextField(controller:meaning,decoration:const InputDecoration(labelText:'معنی فارسی')),TextField(controller:example,decoration:const InputDecoration(labelText:'مثال (اختیاری)'))])),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('انصراف')),FilledButton(onPressed:(){if(term.text.trim().isEmpty||meaning.text.trim().isEmpty)return;Navigator.pop(ctx,Word(term.text.trim(),meaning.text.trim(),example.text.trim()));},child:const Text('ذخیره'))]));if(result==null||!mounted)return;if(decks[lang]!.any((w)=>w.term==result.term)){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('این واژه قبلاً ثبت شده است.')));return;}final items=List<dynamic>.from(jsonDecode(widget.prefs.getString('personal:$lang')??'[]'));items.add({'term':result.term,'meaning':result.meaning,'example':result.example});await widget.prefs.setString('personal:$lang',jsonEncode(items));if(mounted)setState(()=>decks[lang]!.add(result));}

  List<Word> choices=[];
  late Set<String> mistakes=(widget.prefs.getStringList('mistakes')??[]).toSet();
  late int totalAnswers=widget.prefs.getInt('answers')??0;
  late int totalCorrect=widget.prefs.getInt('correct')??0;
  void reset(){index=0;flipped=false;feedback=null;answer.clear();choices=[];}
  void openMode(String value){setState((){tab=1;mode=value;reset();});}
  void checkAnswer(Word w,String value){if(feedback!=null)return;final ok=normalize(value)==normalize(w.term);setState((){feedback=ok?'درست است!':'پاسخ: ${w.term}';attempted++;totalAnswers++;if(ok){correct++;totalCorrect++;if(mode!='mistakes')mistakes.remove('$language:${w.term}');}else{mistakes.add('$language:${w.term}');}});widget.prefs.setInt('answers',totalAnswers);widget.prefs.setInt('correct',totalCorrect);widget.prefs.setStringList('mistakes',mistakes.toList());HapticFeedback.selectionClick();}
  String normalize(String s)=>s.trim().toLowerCase().replaceAll('’',"'").replaceAll(RegExp(r'^[¿¡]|[.!?]+$'),'');
  void advance(){setState((){if(mode=='mistakes'&&feedback=='درست است!'&&mistakes.isNotEmpty){final list=decks[language]!.where((w)=>mistakes.contains('$language:${w.term}')).toList();if(list.isNotEmpty)mistakes.remove('$language:${list[index%list.length].term}');}else{index++;}answer.clear();feedback=null;choices=[];});widget.prefs.setStringList('mistakes',mistakes.toList());}
  List<Word> options(Word w){if(choices.isEmpty){final others=decks[language]!.where((x)=>x.term!=w.term&&x.meaning!=w.meaning).toList()..shuffle(Random());choices=[w,...others.take(3)]..shuffle(Random());}return choices;}
  Widget skill(String label,IconData icon,String value)=>Card(child:InkWell(borderRadius:BorderRadius.circular(16),onTap:()=>openMode(value),child:Padding(padding:const EdgeInsets.all(12),child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(icon,size:26,color:Theme.of(context).colorScheme.primary),const SizedBox(height:8),Text(label)]))));
  late Map<String,dynamic> progress=Map<String,dynamic>.from(jsonDecode(widget.prefs.getString('progress')??'{}'));
  int tab=0, index=0;
  late Set<String> favorites=(widget.prefs.getStringList('favorites')??[]).toSet();
  String search='';
  bool onlyFavorites=false;
  void toggleFavorite(Word w){final key='$language:${w.term}';setState((){if(!favorites.add(key))favorites.remove(key);});widget.prefs.setStringList('favorites',favorites.toList());}
  bool flipped=false;
  String? feedback;
  List<Word> get due => decks[language]!.where((w) => (progress['$language:${w.term}']?['due']??0)<=DateTime.now().millisecondsSinceEpoch).toList();
  Future<void> speak(String value) async {
    try {
      final available=await tts.isLanguageAvailable(accent);
      if(available!=true) throw StateError('voice unavailable');
      await tts.setLanguage(accent); await tts.setSpeechRate(speed); await tts.speak(value);
    } catch (_) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('صدای این زبان در دستگاه موجود نیست.')));}
  }
  Future<void> rate(Word word,int days) async {
    final key='$language:${word.term}';
    final previous=progress[key];
    final updated=scheduleReview(previous is Map?Map<String,dynamic>.from(previous):null,days,key.codeUnits.fold<int>(0,(h,c)=>(h*31+c)&0x7fffffff));
    setState(() {
      progress[key]=updated;
      index=0;flipped=false;feedback=null;answer.clear();
    });
    await widget.prefs.setString('progress',jsonEncode(progress));
    await widget.prefs.setInt('reviews:$today',todayReviews+1);
    if(mounted)setState((){});
  }
  @override void dispose(){tts.stop();answer.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    final queue=tab==1&&mode!='cards'?(mode=='mistakes'?decks[language]!.where((w)=>mistakes.contains('$language:${w.term}')).toList():decks[language]!):due;
    final word=queue.isEmpty?null:queue[index%queue.length];
    final colors=Theme.of(context).colorScheme;
    return Scaffold(
      appBar:AppBar(title:Row(mainAxisSize:MainAxisSize.min,children:[ClipRRect(borderRadius:BorderRadius.circular(10),child:Image.memory(widget.logo,width:36,height:36,fit:BoxFit.cover)),const SizedBox(width:10),const Text('Lango',style:TextStyle(fontWeight:FontWeight.w900))]),actions:[IconButton(onPressed:settings,icon:const Icon(Icons.settings_outlined))]),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState((){tab=i;mode='cards';reset();}),destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),label:'خانه'),
        NavigationDestination(icon:Icon(Icons.style_outlined),label:'یادگیری'),
        NavigationDestination(icon:Icon(Icons.search),label:'واژه‌نامه'),
        NavigationDestination(icon:Icon(Icons.insights_outlined),label:'پیشرفت')
      ]),
      body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:620),child:ListView(padding:const EdgeInsets.all(24),children:[
        DropdownButtonFormField<String>(value:language,decoration:const InputDecoration(labelText:'زبان یادگیری',border:OutlineInputBorder()),items:names.entries.map((e)=>DropdownMenuItem(value:e.key,child:Text(e.value))).toList(),onChanged:(v){if(v==null)return;setState((){language=v;accent=accents[v]!.contains(widget.prefs.getString('accent:$v'))?widget.prefs.getString('accent:$v')!:accents[v]!.first;reset();});widget.prefs.setString('language',v);}),
        const SizedBox(height:20),
        if(tab==0)...[
          const Text('هر کلمه، یک دنیای جدید',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
          const SizedBox(height:12),
          Card(clipBehavior:Clip.antiAlias,child:Container(decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xff7045ed),Color(0xff345fdb)])),child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Icon(Icons.layers_rounded,color:Colors.white,size:44),const SizedBox(height:16),Text('${queue.length} کارت آماده مرور',style:const TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:Colors.white)),
            const SizedBox(height:16),
            FilledButton(onPressed:()=>openMode('cards'),child:const Text('شروع یادگیری'))
          ])))),
          const SizedBox(height:12),
          Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('هدف امروز: $todayReviews از $dailyGoal'),const SizedBox(height:8),LinearProgressIndicator(value:(todayReviews/dailyGoal).clamp(0.0,1.0).toDouble())]))),
          const SizedBox(height:12),
          const Text('تمرین مهارت‌ها',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
          const SizedBox(height:10),
          GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),childAspectRatio:1.15,children:[
            skill('نوشتاری',Icons.edit_outlined,'writing'),
            skill('شنیداری',Icons.headphones,'listening'),
            skill('چهارگزینه‌ای',Icons.extension_outlined,'quiz'),
            skill('تلفظ و تکرار',Icons.record_voice_over_outlined,'voice'),
          ]),
          const SizedBox(height:16),
          Card(child:ListTile(leading:const Icon(Icons.sports_esports_outlined),title:const Text('Lango Games'),subtitle:const Text('تطبیق واژه و جمله‌سازی'),trailing:const Icon(Icons.chevron_left),onTap:() async {await Navigator.push(context,MaterialPageRoute<void>(builder:(_)=>GamesPage(words:decks[language]!,prefs:widget.prefs,language:language)));if(mounted)setState((){});})),
          Card(child:ListTile(title:const Text('کلمه روز'),subtitle:Text(decks[language]![DateTime.now().difference(DateTime(2020)).inDays%decks[language]!.length].term),trailing:IconButton(icon:const Icon(Icons.volume_up),onPressed:()=>speak(decks[language]![DateTime.now().difference(DateTime(2020)).inDays%decks[language]!.length].term)))),
        ] else if(tab==2)...[
          OutlinedButton.icon(onPressed:addCard,icon:const Icon(Icons.add),label:const Text('فلش‌کارت شخصی')),
          TextField(onChanged:(v)=>setState(()=>search=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'جستجوی کلمه یا معنی',border:OutlineInputBorder())),
          SwitchListTile(title:const Text('فقط علاقه‌مندی‌ها'),value:onlyFavorites,onChanged:(v)=>setState(()=>onlyFavorites=v)),
          for(final w in decks[language]!.where((w)=>(!onlyFavorites||favorites.contains('$language:${w.term}'))&&(w.term.toLowerCase().contains(search.toLowerCase())||w.meaning.contains(search))))
            Card(child:ListTile(title:Text(w.term,textDirection:TextDirection.ltr),subtitle:Text(w.meaning),leading:IconButton(onPressed:()=>speak(w.term),icon:const Icon(Icons.volume_up)),trailing:IconButton(onPressed:()=>toggleFavorite(w),icon:Icon(favorites.contains('$language:${w.term}')?Icons.favorite:Icons.favorite_border)),onTap:()=>showModalBottomSheet(context:context,builder:(ctx)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[Text(w.term,style:const TextStyle(fontSize:30,fontWeight:FontWeight.bold)),Text(w.meaning),const SizedBox(height:16),if(w.example.isNotEmpty) Text(w.example,textDirection:TextDirection.ltr),if(w.example.isNotEmpty) TextButton(onPressed:()=>speak(w.example),child:const Text('شنیدن مثال')),if(w.attribution!=null) Text(w.attribution!,style:Theme.of(context).textTheme.bodySmall)]))))))
        ] else if(tab==3)...[
          const Text('پیشرفت یادگیری',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),
          Card(child:ListTile(leading:const Icon(Icons.sports_esports_outlined),title:const Text('نتایج بازی آموزشی'),subtitle:Text('${widget.prefs.getInt("games:$language:correct")??0} پاسخ صحیح از ${widget.prefs.getInt("games:$language:attempts")??0}'))),
          Card(child:ListTile(title:Text('پاسخ صحیح: $totalCorrect از $totalAnswers'),subtitle:LinearProgressIndicator(value:totalAnswers==0?0:totalCorrect/totalAnswers))),
          OutlinedButton.icon(onPressed:()=>openMode('mistakes'),icon:const Icon(Icons.history),label:Text('دفترچه اشتباهات (${mistakes.length})')),
          const SizedBox(height:16),
          for(final e in names.entries) ListTile(title:Text(e.value),subtitle:LinearProgressIndicator(value:progress.keys.where((k)=>k.startsWith('${e.key}:')).length/decks[e.key]!.length),trailing:Text('${progress.keys.where((k)=>k.startsWith('${e.key}:')).length}/${decks[e.key]!.length}'))
        ] else if(word==null)...[
          const Icon(Icons.check_circle_outline,size:72),const SizedBox(height:16),Center(child:Text(mode=='mistakes'?'اشتباهی برای مرور نیست.':'مرور امروز کامل شد.'))
        ] else ...[
          Row(children:[Expanded(child:Text('${queue.length} کارت باقی مانده')),IconButton(onPressed:()=>toggleFavorite(word),icon:Icon(favorites.contains('$language:${word.term}')?Icons.favorite:Icons.favorite_border))]),
          const SizedBox(height:12),
          if(mode=='cards')...[
            GestureDetector(onTap:()=>setState(()=>flipped=!flipped),child:AnimatedSwitcher(duration:const Duration(milliseconds:220),child:Card(key:ValueKey(flipped),color:colors.primaryContainer,child:Container(height:260,width:double.infinity,padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
              Flexible(child:SingleChildScrollView(child:Text(flipped?word.meaning:word.term,textAlign:TextAlign.center,style:const TextStyle(fontSize:32,fontWeight:FontWeight.bold)))),
              if(flipped && word.example.isNotEmpty) Padding(padding:const EdgeInsets.only(top:16),child:Text(word.example,textDirection:TextDirection.ltr,textAlign:TextAlign.center)),
              const SizedBox(height:20),const Text('برای چرخاندن لمس کنید')
            ]))))),
            const SizedBox(height:12),
            DropdownButton<String>(value:accent,items:accents[language]!.map((a)=>DropdownMenuItem(value:a,child:Text(a))).toList(),onChanged:(v){if(v==null)return;setState(()=>accent=v);widget.prefs.setString('accent:$language',v);}),
            OutlinedButton.icon(onPressed:()=>speak(word.term),icon:const Icon(Icons.volume_up),label:const Text('تلفظ')),
            Row(children:[const Icon(Icons.speed),Expanded(child:Slider(value:speed,min:0.25,max:0.65,onChanged:(v)=>setState(()=>speed=v)))]),
            if(flipped && word.example.isNotEmpty) OutlinedButton.icon(onPressed:()=>speak(word.example),icon:const Icon(Icons.record_voice_over),label:const Text('شنیدن مثال')),
            if(flipped && word.attribution!=null) Text(word.attribution!,style:Theme.of(context).textTheme.bodySmall),
            if(flipped) Wrap(spacing:8,runSpacing:8,children:[for(final item in const [('دوباره',0),('سخت',1),('خوب',3),('آسان',7)]) FilledButton.tonal(onPressed:()=>rate(word,item.$2),child:Text(item.$1))])
          ] else ...[
            if(mode=='listening') FilledButton.icon(onPressed:()=>speak(word.term),icon:const Icon(Icons.headphones),label:const Text('گوش کن و بنویس')) else Text(word.meaning,style:const TextStyle(fontSize:32,fontWeight:FontWeight.bold)),
            const SizedBox(height:16),
            if(mode=='voice')...[
              Text(word.term,style:const TextStyle(fontSize:32,fontWeight:FontWeight.bold)),
              FilledButton.icon(onPressed:()=>speak(word.term),icon:const Icon(Icons.volume_up),label:const Text('بشنو و تکرار کن')),
              VoiceExercise(key:ValueKey('$accent:${word.term}'),term:word.term,locale:accent),
              OutlinedButton(onPressed:advance,child:const Text('کلمه بعدی'))
            ] else if(mode=='quiz')...[
              for(final option in options(word)) OutlinedButton(onPressed:feedback==null?()=>checkAnswer(word,option.term):null,child:Text(option.term)),
              if(feedback!=null)...[Text(feedback!),FilledButton(onPressed:advance,child:const Text('بعدی'))]
            ] else ...[
            TextField(controller:answer,textDirection:TextDirection.ltr,decoration:const InputDecoration(labelText:'کلمه را بنویسید',border:OutlineInputBorder())),
            const SizedBox(height:12),
            FilledButton(onPressed:feedback==null?()=>checkAnswer(word,answer.text):null,child:const Text('بررسی پاسخ')),
            if(feedback!=null)...[Text(feedback!),OutlinedButton(onPressed:advance,child:const Text('کلمه بعدی'))]
            ]
          ]
        ]
      ]))))
    );
  }
}
