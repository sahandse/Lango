import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'vocabulary.dart';

const lensAliases=<String,String>{'bike':'bicycle','aeroplane':'airplane','aircraft':'airplane','cell phone':'phone','mobile phone':'phone','smartphone':'phone','computer keyboard':'keyboard','laptop computer':'laptop','rucksack':'backpack','couch':'sofa','tv':'television','fridge':'refrigerator','wristwatch':'watch','eyeglasses':'glasses','spectacles':'glasses','motorbike':'motorcycle','automobile':'car','grape':'grapes','headset':'headphones','wall clock':'clock','note book':'notebook'};
String lensKey(String value)=>value.trim().toLowerCase().replaceAll(RegExp(r'[-_\s]+'),' ');
List<Word> matchLensWords(String label,List<Word> english,List<Word> target){
 final key=lensKey(label);
 final canonical=lensAliases[key]??key;
 final meanings=english.where((w)=>lensKey(w.term)==canonical).map((w)=>w.meaning.replaceAll('‌',' ').trim()).toSet();
 return target.where((w)=>meanings.contains(w.meaning.replaceAll('‌',' ').trim())).toList();
}

class LensPage extends StatefulWidget {
  final List<Word> english, target;
  const LensPage({super.key,required this.english,required this.target});
  @override State<LensPage> createState()=>_LensPageState();
}
class _LensPageState extends State<LensPage>{
  final picker=ImagePicker();
  final labeler=ImageLabeler(options:ImageLabelerOptions(confidenceThreshold:0.65));
  List<ImageLabel> labels=[];
  bool busy=false;
  String message='';
  Future<void> scan(ImageSource source) async {
    if(busy)return;
    setState((){busy=true;labels=[];message='';});
    try{
      final photo=await picker.pickImage(source:source,maxWidth:1600,maxHeight:1600);
      if(photo==null)return;
      if(!mounted)return;
      final results=await labeler.processImage(InputImage.fromFilePath(photo.path));
      if(mounted)setState((){labels=(results..sort((a,b)=>b.confidence.compareTo(a.confidence))).take(10).toList();message=results.isEmpty?'شیء قابل شناسایی پیدا نشد.':'';});
    }catch(_){if(mounted)setState(()=>message='پردازش تصویر یا دسترسی به دوربین امکان‌پذیر نبود.');}
    finally{if(mounted)setState(()=>busy=false);}
  }
  List<Word> matches(String label)=>matchLensWords(label,widget.english,widget.target);
  @override void dispose(){labeler.close();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Lango Lens')),
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(20),children:[
      const Text('تصویر یک شیء را انتخاب کن. مدل نام‌های احتمالی را پیشنهاد می‌دهد. تصویر به سرور برنامه ارسال نمی‌شود.'),
      const SizedBox(height:16),
      FilledButton.icon(onPressed:busy?null:()=>scan(ImageSource.camera),icon:const Icon(Icons.camera_alt_outlined),label:const Text('دوربین')),
      OutlinedButton.icon(onPressed:busy?null:()=>scan(ImageSource.gallery),icon:const Icon(Icons.photo_library_outlined),label:const Text('گالری')),
      if(busy)const LinearProgressIndicator(),
      if(message.isNotEmpty)Text(message),
      for(final label in labels) Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label.label,style:Theme.of(context).textTheme.titleLarge),
        Text('اطمینان مدل: ${(label.confidence*100).round()}٪'),
        if(matches(label.label).isEmpty)const Text('ترجمه تأییدشده در واژه‌نامه موجود نیست.'),
        for(final word in matches(label.label)) ListTile(title:Text(word.term),subtitle:Text(word.meaning),trailing:const Icon(Icons.bookmark_add_outlined),onTap:()=>Navigator.pop(context,word)),
      ])))
    ])));
}
