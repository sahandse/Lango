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
  String normalize(String value)=>value.toLowerCase().replaceAll(RegExp(r'[.,!?¿¡]'),'').trim();
  Future<void> listen() async {
    if(busy)return;
    setState((){busy=true;heard='';message='';});
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
        setState((){heard=result.recognizedWords;if(result.finalResult){busy=false;message=normalize(heard)==normalize(widget.term)?'متن تشخیص داده شده با واژه مطابقت دارد.':'متن تشخیص داده شده متفاوت است؛ دوباره تلاش کن.';}});
      },listenFor:const Duration(seconds:10),pauseFor:const Duration(seconds:3),listenOptions:stt.SpeechListenOptions(onDevice:true,partialResults:true));
    } catch (_) {if(mounted)setState((){busy=false;message='تشخیص گفتار آفلاین برای این دستگاه یا زبان در دسترس نیست.';});}
  }
  @override void dispose(){speech.cancel();super.dispose();}
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    const Text('میکروفون فقط با لمس دکمه فعال می‌شود. تشخیص روی دستگاه درخواست می‌شود؛ پشتیبانی به موتور نصب‌شده بستگی دارد.'),
    const SizedBox(height:12),
    FilledButton.icon(onPressed:busy?() async {await speech.stop();if(mounted)setState(()=>busy=false);}:listen,icon:Icon(busy?Icons.stop:Icons.mic),label:Text(busy?'پایان شنیدن':'صحبت کن')),
    if(heard.isNotEmpty)Text(heard,textDirection:TextDirection.ltr,style:Theme.of(context).textTheme.titleLarge),
    if(message.isNotEmpty)Text(message),
    const Text('این تمرین تطبیق متن گفتار است، نه امتیازدهی آوایی یا سنجش دقیق لهجه.'),
  ]);
}
