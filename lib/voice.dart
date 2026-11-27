import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceExercise extends StatefulWidget {
  final String term, locale;
  const VoiceExercise({super.key,required this.term,required this.locale});
  @override State<VoiceExercise> createState()=>_VoiceExerciseState();
}
class _VoiceExerciseState extends State<VoiceExercise> {
  final speech=stt.SpeechToText();
  String heard='',message='';
  bool busy=false;
  bool finished=false;
  int? similarity;
  int attempts=0;
  int? best;
  String normalize(String value)=>value.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡]'),'').trim();
  int distance(String a,String b){
    final x=a.runes.toList(),y=b.runes.toList();
    var previous=List<int>.generate(y.length+1,(i)=>i);
    for(var i=0;i<x.length;i++){
      final row=<int>[i+1];
      for(var j=0;j<y.length;j++){
        final candidates=[row[j]+1,previous[j+1]+1,previous[j]+(x[i]==y[j]?0:1)]..sort();
        row.add(candidates.first);
      }
      previous=row;
    }
    return previous.last;
  }
  void finish(){
    if(!mounted||finished)return;
    setState((){
      finished=true;busy=false;
      final expected=normalize(widget.term),actual=normalize(heard);
      if(actual.isEmpty){message='گفتاری تشخیص داده نشد.';return;}
      final length=expected.runes.length>actual.runes.length?expected.runes.length:actual.runes.length;
      similarity=length==0?100:((1-distance(expected,actual)/length)*100).round().clamp(0,100).toInt();
      attempts++;
      if(best==null||similarity!>best!)best=similarity;
      message=expected==actual?'متن تشخیص داده شده مطابق است.':'متن تشخیص داده شده متفاوت است؛ الگو را دوباره گوش کن.';
    });
  }
  Future<void> listen() async {
    if(busy)return;
    setState((){busy=true;finished=false;similarity=null;heard='';message='';});
    try {
      final available=await speech.initialize(onError:(error){if(mounted)setState((){busy=false;message='تشخیص گفتار در دسترس نیست یا متوقف شد.';});},onStatus:(status){if(mounted&&(status=='done'||status=='notListening'))setState(()=>busy=false);});
      if(!mounted)return;
      if(!available){setState((){busy=false;message='موتور تشخیص گفتار یا مجوز میکروفون در دسترس نیست.';});return;}
      final locales=await speech.locales();
      final wanted=widget.locale.replaceAll('_','-').toLowerCase();
      final matches=locales.where((l)=>l.localeId.replaceAll('_','-').toLowerCase()==wanted);
      if(!mounted)return;
      if(matches.isEmpty){setState((){busy=false;message='تشخیص گفتار برای لهجه انتخابی در دستگاه موجود نیست.';});return;}
      await speech.listen(localeId:matches.first.localeId,onResult:(result){
        if(!mounted)return;
        if(finished)return;
        setState(()=>heard=result.recognizedWords);
        if(result.finalResult)finish();
      },listenFor:const Duration(seconds:10),pauseFor:const Duration(seconds:3),listenOptions:stt.SpeechListenOptions(onDevice:true,partialResults:true));
    } catch (_) {if(mounted)setState((){busy=false;message='تشخیص گفتار آفلاین برای این دستگاه یا زبان در دسترس نیست.';});}
  }
  @override void dispose(){speech.cancel();super.dispose();}
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    const Text('میکروفون فقط با لمس دکمه فعال می‌شود. تشخیص روی دستگاه درخواست می‌شود؛ پشتیبانی به موتور نصب‌شده بستگی دارد.'),
    const SizedBox(height:12),
    FilledButton.icon(onPressed:busy?() async {await speech.stop();if(mounted)finish();}:listen,icon:Icon(busy?Icons.stop:Icons.mic),label:Text(busy?'پایان شنیدن':'صحبت کن')),
    if(heard.isNotEmpty)Text(heard,textDirection:TextDirection.ltr,style:Theme.of(context).textTheme.titleLarge),
    if(message.isNotEmpty)Text(message),
    if(similarity!=null)...[Text('شباهت نوشتاری گفتار: $similarity٪'),LinearProgressIndicator(value:similarity!/100),Text('تلاش‌ها: $attempts • بهترین شباهت نوشتاری: $best٪')],
    const Text('این تمرین تطبیق متن گفتار است، نه امتیازدهی آوایی یا سنجش دقیق لهجه.'),
  ]);
}
