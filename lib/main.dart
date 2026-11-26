import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(Lango(prefs: prefs));
}

class Word {
  final String term, meaning, example;
  const Word(this.term, this.meaning, this.example);
}

const decks = <String, List<Word>>{
  'en': [Word('Hello','سلام','Hello, how are you?'), Word('Thank you','متشکرم','Thank you for your help.'), Word('Water','آب','I drink water.'), Word('Book','کتاب','This is my book.'), Word('Friend','دوست','She is my friend.')],
  'de': [Word('Hallo','سلام','Hallo, wie geht es dir?'), Word('Danke','متشکرم','Danke für deine Hilfe.'), Word('Wasser','آب','Ich trinke Wasser.'), Word('Buch','کتاب','Das ist mein Buch.')],
  'fr': [Word('Bonjour','سلام','Bonjour, comment ça va ?'), Word('Merci','متشکرم','Merci pour votre aide.'), Word('Eau','آب','Je bois de l’eau.'), Word('Livre','کتاب','Voici mon livre.')],
  'es': [Word('Hola','سلام','Hola, ¿cómo estás?'), Word('Gracias','متشکرم','Gracias por tu ayuda.'), Word('Agua','آب','Bebo agua.'), Word('Libro','کتاب','Este es mi libro.')],
  'tr': [Word('Merhaba','سلام','Merhaba, nasılsın?'), Word('Teşekkürler','متشکرم','Yardımın için teşekkürler.'), Word('Su','آب','Su içiyorum.'), Word('Kitap','کتاب','Bu benim kitabım.')]
};
const names = {'en':'English','de':'Deutsch','fr':'Français','es':'Español','tr':'Türkçe'};
const accents = {'en':['en-US','en-GB','en-AU'],'de':['de-DE','de-AT'],'fr':['fr-FR','fr-CA'],'es':['es-ES','es-MX'],'tr':['tr-TR']};

class Lango extends StatefulWidget {
  final SharedPreferences prefs;
  const Lango({super.key, required this.prefs});
  @override State<Lango> createState() => _LangoState();
}
class _LangoState extends State<Lango> {
  late bool dark = widget.prefs.getBool('dark') ?? false;
  @override Widget build(BuildContext context) => MaterialApp(
    title:'Lango', debugShowCheckedModeBanner:false,
    locale:const Locale('fa'), supportedLocales:const [Locale('fa'),Locale('en')],
    localizationsDelegates:GlobalMaterialLocalizations.delegates,
    theme:ThemeData(colorSchemeSeed:const Color(0xff7051ed),useMaterial3:true,brightness:Brightness.light),
    darkTheme:ThemeData(colorSchemeSeed:const Color(0xff7051ed),useMaterial3:true,brightness:Brightness.dark),
    themeMode:dark?ThemeMode.dark:ThemeMode.light,
    home:Study(prefs:widget.prefs,dark:dark,onTheme:() {setState(()=>dark=!dark);widget.prefs.setBool('dark',dark);}),
  );
}
class Study extends StatefulWidget {
  final SharedPreferences prefs;
  final bool dark;
  final VoidCallback onTheme;
  const Study({super.key,required this.prefs,required this.dark,required this.onTheme});
  @override State<Study> createState()=>_StudyState();
}
class _StudyState extends State<Study> {
  final tts=FlutterTts();
  final answer=TextEditingController();
  late String language=widget.prefs.getString('language')??'en';
  late String accent=accents[language]!.first;
  late Map<String,dynamic> progress=Map<String,dynamic>.from(jsonDecode(widget.prefs.getString('progress')??'{}'));
  int tab=0, index=0;
  bool flipped=false;
  String? feedback;
  List<Word> get due => decks[language]!.where((w) => (progress['$language:${w.term}']?['due']??0)<=DateTime.now().millisecondsSinceEpoch).toList();
  Future<void> speak(String value) async {
    try {
      final available=await tts.isLanguageAvailable(accent);
      if(available!=true) throw StateError('voice unavailable');
      await tts.setLanguage(accent); await tts.setSpeechRate(0.42); await tts.speak(value);
    } catch (_) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('صدای این زبان در دستگاه موجود نیست.')));}
  }
  Future<void> rate(Word word,int days) async {
    final key='$language:${word.term}';
    final old=progress[key]?['reviews']??0;
    setState(() {
      progress[key]={'reviews':old+1,'due':DateTime.now().add(Duration(days:days,minutes:days==0?1:0)).millisecondsSinceEpoch};
      index=0;flipped=false;feedback=null;answer.clear();
    });
    await widget.prefs.setString('progress',jsonEncode(progress));
  }
  @override void dispose(){tts.stop();answer.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    final queue=due;
    final word=queue.isEmpty?null:queue[index%queue.length];
    final colors=Theme.of(context).colorScheme;
    return Scaffold(
      appBar:AppBar(title:const Text('Lango',style:TextStyle(fontWeight:FontWeight.w900)),actions:[IconButton(onPressed:widget.onTheme,icon:Icon(widget.dark?Icons.light_mode:Icons.dark_mode))]),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState((){tab=i;flipped=false;feedback=null;answer.clear();}),destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),label:'خانه'),
        NavigationDestination(icon:Icon(Icons.style_outlined),label:'کارت‌ها'),
        NavigationDestination(icon:Icon(Icons.edit_outlined),label:'نوشتاری'),
        NavigationDestination(icon:Icon(Icons.insights_outlined),label:'پیشرفت')
      ]),
      body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:620),child:ListView(padding:const EdgeInsets.all(24),children:[
        DropdownButtonFormField<String>(value:language,decoration:const InputDecoration(labelText:'زبان یادگیری',border:OutlineInputBorder()),items:names.entries.map((e)=>DropdownMenuItem(value:e.key,child:Text(e.value))).toList(),onChanged:(v){if(v==null)return;setState((){language=v;accent=accents[v]!.first;index=0;flipped=false;feedback=null;answer.clear();});widget.prefs.setString('language',v);}),
        const SizedBox(height:24),
        if(tab==0)...[
          const Text('هر کلمه، یک دنیای جدید',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
          const SizedBox(height:12),
          Card(color:colors.primaryContainer,child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('${queue.length} کارت آماده مرور',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
            const SizedBox(height:16),
            FilledButton(onPressed:()=>setState(()=>tab=1),child:const Text('شروع یادگیری'))
          ]))),
          const SizedBox(height:12),
          OutlinedButton.icon(onPressed:()=>setState(()=>tab=2),icon:const Icon(Icons.edit),label:const Text('تمرین نوشتاری'))
        ] else if(tab==3)...[
          const Text('پیشرفت یادگیری',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),
          const SizedBox(height:16),
          for(final e in names.entries) ListTile(title:Text(e.value),subtitle:LinearProgressIndicator(value:progress.keys.where((k)=>k.startsWith('${e.key}:')).length/decks[e.key]!.length),trailing:Text('${progress.keys.where((k)=>k.startsWith('${e.key}:')).length}/${decks[e.key]!.length}'))
        ] else if(word==null)...[
          const Icon(Icons.check_circle_outline,size:72),const SizedBox(height:16),const Center(child:Text('مرور امروز کامل شد.'))
        ] else ...[
          Text('${queue.length} کارت باقی مانده'),
          const SizedBox(height:12),
          if(tab==1)...[
            GestureDetector(onTap:()=>setState(()=>flipped=!flipped),child:AnimatedSwitcher(duration:const Duration(milliseconds:220),child:Card(key:ValueKey(flipped),color:colors.primaryContainer,child:Container(height:260,width:double.infinity,padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
              Text(flipped?word.meaning:word.term,textAlign:TextAlign.center,style:const TextStyle(fontSize:36,fontWeight:FontWeight.bold)),
              if(flipped) Padding(padding:const EdgeInsets.only(top:16),child:Text(word.example,textDirection:TextDirection.ltr,textAlign:TextAlign.center)),
              const SizedBox(height:20),const Text('برای چرخاندن لمس کنید')
            ]))))),
            const SizedBox(height:12),
            DropdownButton<String>(value:accent,items:accents[language]!.map((a)=>DropdownMenuItem(value:a,child:Text(a))).toList(),onChanged:(v)=>setState(()=>accent=v!)),
            OutlinedButton.icon(onPressed:()=>speak(word.term),icon:const Icon(Icons.volume_up),label:const Text('تلفظ')),
            if(flipped) Wrap(spacing:8,runSpacing:8,children:[for(final item in const [('دوباره',0),('سخت',1),('خوب',3),('آسان',7)]) FilledButton.tonal(onPressed:()=>rate(word,item.$2),child:Text(item.$1))])
          ] else ...[
            Text(word.meaning,style:const TextStyle(fontSize:32,fontWeight:FontWeight.bold)),
            const SizedBox(height:16),
            TextField(controller:answer,textDirection:TextDirection.ltr,decoration:const InputDecoration(labelText:'کلمه را بنویسید',border:OutlineInputBorder())),
            const SizedBox(height:12),
            FilledButton(onPressed:()=>setState(()=>feedback=answer.text.trim().toLowerCase()==word.term.toLowerCase()?'درست است!':'پاسخ: ${word.term}'),child:const Text('بررسی پاسخ')),
            if(feedback!=null)...[Text(feedback!),OutlinedButton(onPressed:()=>setState((){index++;answer.clear();feedback=null;}),child:const Text('کلمه بعدی'))]
          ]
        ]
      ]))))
    );
  }
}
