import 'dart:convert';
import 'package:flutter/services.dart';

class Word {
  final String term, meaning, example;
  final String? attribution;
  const Word(this.term, this.meaning, this.example,{this.attribution});
}

const baseDecks = <String, List<Word>>{
  'en': [Word('Hello','سلام','Hello, how are you?'), Word('Thank you','متشکرم','Thank you for your help.'), Word('Water','آب','I drink water.'), Word('Book','کتاب','This is my book.'), Word('Friend','دوست','She is my friend.')],
  'de': [Word('Hallo','سلام','Hallo, wie geht es dir?'), Word('Danke','متشکرم','Danke für deine Hilfe.'), Word('Wasser','آب','Ich trinke Wasser.'), Word('Buch','کتاب','Das ist mein Buch.')],
  'fr': [Word('Bonjour','سلام','Bonjour, comment ça va ?'), Word('Merci','متشکرم','Merci pour votre aide.'), Word('Eau','آب','Je bois de l’eau.'), Word('Livre','کتاب','Voici mon livre.')],
  'es': [Word('Hola','سلام','Hola, ¿cómo estás?'), Word('Gracias','متشکرم','Gracias por tu ayuda.'), Word('Agua','آب','Bebo agua.'), Word('Libro','کتاب','Este es mi libro.')],
  'tr': [Word('Merhaba','سلام','Merhaba, nasılsın?'), Word('Teşekkürler','متشکرم','Yardımın için teşekkürler.'), Word('Su','آب','Su içiyorum.'), Word('Kitap','کتاب','Bu benim kitabım.')]
};
const names = {'en':'English','de':'Deutsch','fr':'Français','es':'Español','tr':'Türkçe'};
const accents = {'en':['en-US','en-GB','en-AU'],'de':['de-DE','de-AT'],'fr':['fr-FR','fr-CA'],'es':['es-ES','es-MX'],'tr':['tr-TR']};


final decks = <String,List<Word>>{
  'en': [...baseDecks['en']!, Word("Good morning","صبح بخیر","Good morning, everyone."),
Word("Please","لطفاً","Please sit down."),
Word("Bread","نان","I buy bread."),
Word("Milk","شیر","I drink milk."),
Word("House","خانه","This is my house."),
Word("School","مدرسه","I go to school."),
Word("Today","امروز","I work today."),
Word("Tomorrow","فردا","See you tomorrow."),
Word("Train","قطار","The train arrives."),
Word("Where?","کجا؟","Where is the station?"),
Word("Coffee","قهوه","I would like coffee."),
Word("Money","پول","I need money."),
Word("Happy","خوشحال","I am happy."),
Word("Goodbye","خداحافظ","Goodbye, see you soon."),
Word("Help","کمک","I need help.")],
  'de': [...baseDecks['de']!, Word("Guten Morgen","صبح بخیر","Guten Morgen, alle zusammen!"),
Word("Bitte","لطفاً","Bitte setzen Sie sich."),
Word("Brot","نان","Ich kaufe Brot."),
Word("Milch","شیر","Ich trinke Milch."),
Word("Haus","خانه","Das ist mein Haus."),
Word("Schule","مدرسه","Ich gehe zur Schule."),
Word("Heute","امروز","Ich arbeite heute."),
Word("Morgen","فردا","Bis morgen."),
Word("Zug","قطار","Der Zug kommt an."),
Word("Wo?","کجا؟","Wo ist der Bahnhof?"),
Word("Kaffee","قهوه","Ich möchte Kaffee."),
Word("Geld","پول","Ich brauche Geld."),
Word("Glücklich","خوشحال","Ich bin glücklich."),
Word("Auf Wiedersehen","خداحافظ","Auf Wiedersehen, bis bald."),
Word("Hilfe","کمک","Ich brauche Hilfe.")],
  'fr': [...baseDecks['fr']!, Word("Bonsoir","عصر بخیر","Bonsoir à tous !"),
Word("S’il vous plaît","لطفاً","Asseyez-vous, s’il vous plaît."),
Word("Pain","نان","J’achète du pain."),
Word("Lait","شیر","Je bois du lait."),
Word("Maison","خانه","C’est ma maison."),
Word("École","مدرسه","Je vais à l’école."),
Word("Aujourd’hui","امروز","Je travaille aujourd’hui."),
Word("Demain","فردا","À demain."),
Word("Train","قطار","Le train arrive."),
Word("Où ?","کجا؟","Où est la gare ?"),
Word("Café","قهوه","Je voudrais du café."),
Word("Argent","پول","J’ai besoin d’argent."),
Word("Heureux","خوشحال","Je suis heureux."),
Word("Au revoir","خداحافظ","Au revoir, à bientôt."),
Word("Aide","کمک","J’ai besoin d’aide.")],
  'es': [...baseDecks['es']!, Word("Buenos días","صبح بخیر","Buenos días a todos."),
Word("Por favor","لطفاً","Siéntate, por favor."),
Word("Pan","نان","Compro pan."),
Word("Leche","شیر","Bebo leche."),
Word("Casa","خانه","Esta es mi casa."),
Word("Escuela","مدرسه","Voy a la escuela."),
Word("Hoy","امروز","Trabajo hoy."),
Word("Mañana","فردا","Hasta mañana."),
Word("Tren","قطار","El tren llega."),
Word("¿Dónde?","کجا؟","¿Dónde está la estación?"),
Word("Café","قهوه","Quisiera café."),
Word("Dinero","پول","Necesito dinero."),
Word("Feliz","خوشحال","Estoy feliz."),
Word("Adiós","خداحافظ","Adiós, hasta pronto."),
Word("Ayuda","کمک","Necesito ayuda.")],
  'tr': [...baseDecks['tr']!, Word("Günaydın","صبح بخیر","Herkese günaydın."),
Word("Lütfen","لطفاً","Lütfen oturun."),
Word("Ekmek","نان","Ekmek alıyorum."),
Word("Süt","شیر","Süt içiyorum."),
Word("Ev","خانه","Bu benim evim."),
Word("Okul","مدرسه","Okula gidiyorum."),
Word("Bugün","امروز","Bugün çalışıyorum."),
Word("Yarın","فردا","Yarın görüşürüz."),
Word("Tren","قطار","Tren geliyor."),
Word("Nerede?","کجا؟","İstasyon nerede?"),
Word("Kahve","قهوه","Kahve istiyorum."),
Word("Para","پول","Paraya ihtiyacım var."),
Word("Mutlu","خوشحال","Mutluyum."),
Word("Hoşça kal","خداحافظ","Hoşça kal, görüşürüz."),
Word("Yardım","کمک","Yardıma ihtiyacım var.")],
};

final basicVocabulary = <String,List<Word>>{
  'en': [Word("I","من",''),Word("You","تو",''),Word("We","ما",''),Word("Yes","بله",''),Word("No","نه",''),Word("One","یک",''),Word("Two","دو",''),Word("Three","سه",''),Word("Four","چهار",''),Word("Five","پنج",''),Word("Six","شش",''),Word("Seven","هفت",''),Word("Eight","هشت",''),Word("Nine","نه (عدد)",''),Word("Ten","ده",''),Word("Monday","دوشنبه",''),Word("Tuesday","سه‌شنبه",''),Word("Wednesday","چهارشنبه",''),Word("Thursday","پنجشنبه",''),Word("Friday","جمعه",''),Word("Saturday","شنبه",''),Word("Sunday","یکشنبه",''),Word("Red","قرمز",''),Word("Blue","آبی",''),Word("Green","سبز",''),Word("Black","سیاه",''),Word("White","سفید",''),Word("Yellow","زرد",''),Word("Apple","سیب",''),Word("Orange","پرتقال",''),Word("Banana","موز",''),Word("Rice","برنج",''),Word("Egg","تخم‌مرغ",''),Word("Tea","چای",''),Word("Salt","نمک",''),Word("Sugar","شکر",''),Word("Mother","مادر",''),Word("Father","پدر",''),Word("Sister","خواهر",''),Word("Brother","برادر",''),Word("City","شهر",''),Word("Street","خیابان",''),Word("Airport","فرودگاه",''),Word("Hotel","هتل",''),Word("Ticket","بلیط",''),Word("Window","پنجره",''),Word("Door","در",''),Word("Chair","صندلی",''),Word("Table","میز",''),Word("Phone","تلفن",'')],
  'de': [Word("Ich","من",''),Word("Du","تو",''),Word("Wir","ما",''),Word("Ja","بله",''),Word("Nein","نه",''),Word("Eins","یک",''),Word("Zwei","دو",''),Word("Drei","سه",''),Word("Vier","چهار",''),Word("Fünf","پنج",''),Word("Sechs","شش",''),Word("Sieben","هفت",''),Word("Acht","هشت",''),Word("Neun","نه (عدد)",''),Word("Zehn","ده",''),Word("Montag","دوشنبه",''),Word("Dienstag","سه‌شنبه",''),Word("Mittwoch","چهارشنبه",''),Word("Donnerstag","پنجشنبه",''),Word("Freitag","جمعه",''),Word("Samstag","شنبه",''),Word("Sonntag","یکشنبه",''),Word("Rot","قرمز",''),Word("Blau","آبی",''),Word("Grün","سبز",''),Word("Schwarz","سیاه",''),Word("Weiß","سفید",''),Word("Gelb","زرد",''),Word("Apfel","سیب",''),Word("Orange","پرتقال",''),Word("Banane","موز",''),Word("Reis","برنج",''),Word("Ei","تخم‌مرغ",''),Word("Tee","چای",''),Word("Salz","نمک",''),Word("Zucker","شکر",''),Word("Mutter","مادر",''),Word("Vater","پدر",''),Word("Schwester","خواهر",''),Word("Bruder","برادر",''),Word("Stadt","شهر",''),Word("Straße","خیابان",''),Word("Flughafen","فرودگاه",''),Word("Hotel","هتل",''),Word("Fahrkarte","بلیط",''),Word("Fenster","پنجره",''),Word("Tür","در",''),Word("Stuhl","صندلی",''),Word("Tisch","میز",''),Word("Telefon","تلفن",'')],
  'fr': [Word("Je","من",''),Word("Tu","تو",''),Word("Nous","ما",''),Word("Oui","بله",''),Word("Non","نه",''),Word("Un","یک",''),Word("Deux","دو",''),Word("Trois","سه",''),Word("Quatre","چهار",''),Word("Cinq","پنج",''),Word("Six","شش",''),Word("Sept","هفت",''),Word("Huit","هشت",''),Word("Neuf","نه (عدد)",''),Word("Dix","ده",''),Word("Lundi","دوشنبه",''),Word("Mardi","سه‌شنبه",''),Word("Mercredi","چهارشنبه",''),Word("Jeudi","پنجشنبه",''),Word("Vendredi","جمعه",''),Word("Samedi","شنبه",''),Word("Dimanche","یکشنبه",''),Word("Rouge","قرمز",''),Word("Bleu","آبی",''),Word("Vert","سبز",''),Word("Noir","سیاه",''),Word("Blanc","سفید",''),Word("Jaune","زرد",''),Word("Pomme","سیب",''),Word("Orange","پرتقال",''),Word("Banane","موز",''),Word("Riz","برنج",''),Word("Œuf","تخم‌مرغ",''),Word("Thé","چای",''),Word("Sel","نمک",''),Word("Sucre","شکر",''),Word("Mère","مادر",''),Word("Père","پدر",''),Word("Sœur","خواهر",''),Word("Frère","برادر",''),Word("Ville","شهر",''),Word("Rue","خیابان",''),Word("Aéroport","فرودگاه",''),Word("Hôtel","هتل",''),Word("Billet","بلیط",''),Word("Fenêtre","پنجره",''),Word("Porte","در",''),Word("Chaise","صندلی",''),Word("Table","میز",''),Word("Téléphone","تلفن",'')],
  'es': [Word("Yo","من",''),Word("Tú","تو",''),Word("Nosotros","ما",''),Word("Sí","بله",''),Word("No","نه",''),Word("Uno","یک",''),Word("Dos","دو",''),Word("Tres","سه",''),Word("Cuatro","چهار",''),Word("Cinco","پنج",''),Word("Seis","شش",''),Word("Siete","هفت",''),Word("Ocho","هشت",''),Word("Nueve","نه (عدد)",''),Word("Diez","ده",''),Word("Lunes","دوشنبه",''),Word("Martes","سه‌شنبه",''),Word("Miércoles","چهارشنبه",''),Word("Jueves","پنجشنبه",''),Word("Viernes","جمعه",''),Word("Sábado","شنبه",''),Word("Domingo","یکشنبه",''),Word("Rojo","قرمز",''),Word("Azul","آبی",''),Word("Verde","سبز",''),Word("Negro","سیاه",''),Word("Blanco","سفید",''),Word("Amarillo","زرد",''),Word("Manzana","سیب",''),Word("Naranja","پرتقال",''),Word("Plátano","موز",''),Word("Arroz","برنج",''),Word("Huevo","تخم‌مرغ",''),Word("Té","چای",''),Word("Sal","نمک",''),Word("Azúcar","شکر",''),Word("Madre","مادر",''),Word("Padre","پدر",''),Word("Hermana","خواهر",''),Word("Hermano","برادر",''),Word("Ciudad","شهر",''),Word("Calle","خیابان",''),Word("Aeropuerto","فرودگاه",''),Word("Hotel","هتل",''),Word("Billete","بلیط",''),Word("Ventana","پنجره",''),Word("Puerta","در",''),Word("Silla","صندلی",''),Word("Mesa","میز",''),Word("Teléfono","تلفن",'')],
  'tr': [Word("Ben","من",''),Word("Sen","تو",''),Word("Biz","ما",''),Word("Evet","بله",''),Word("Hayır","نه",''),Word("Bir","یک",''),Word("İki","دو",''),Word("Üç","سه",''),Word("Dört","چهار",''),Word("Beş","پنج",''),Word("Altı","شش",''),Word("Yedi","هفت",''),Word("Sekiz","هشت",''),Word("Dokuz","نه (عدد)",''),Word("On","ده",''),Word("Pazartesi","دوشنبه",''),Word("Salı","سه‌شنبه",''),Word("Çarşamba","چهارشنبه",''),Word("Perşembe","پنجشنبه",''),Word("Cuma","جمعه",''),Word("Cumartesi","شنبه",''),Word("Pazar","یکشنبه",''),Word("Kırmızı","قرمز",''),Word("Mavi","آبی",''),Word("Yeşil","سبز",''),Word("Siyah","سیاه",''),Word("Beyaz","سفید",''),Word("Sarı","زرد",''),Word("Elma","سیب",''),Word("Portakal","پرتقال",''),Word("Muz","موز",''),Word("Pirinç","برنج",''),Word("Yumurta","تخم‌مرغ",''),Word("Çay","چای",''),Word("Tuz","نمک",''),Word("Şeker","شکر",''),Word("Anne","مادر",''),Word("Baba","پدر",''),Word("Kız kardeş","خواهر",''),Word("Erkek kardeş","برادر",''),Word("Şehir","شهر",''),Word("Sokak","خیابان",''),Word("Havalimanı","فرودگاه",''),Word("Otel","هتل",''),Word("Bilet","بلیط",''),Word("Pencere","پنجره",''),Word("Kapı","در",''),Word("Sandalye","صندلی",''),Word("Masa","میز",''),Word("Telefon","تلفن",'')],
};

Future<void> loadSentenceContent() async {
  for(final entry in basicVocabulary.entries){
    final deck=decks[entry.key]!;
    final known=deck.map((w)=>w.term).toSet();
    deck.addAll(entry.value.where((w)=>known.add(w.term)));
  }
  final data=jsonDecode(await rootBundle.loadString('assets/content/sentences.json')) as Map<String,dynamic>;
  for(final entry in data.entries){
    final deck=decks[entry.key];
    if(deck==null) continue;
    final known=deck.map((w)=>w.term).toSet();
    for(final row in entry.value as List){
      final term=row['term'] as String;
      if(!known.add(term)) continue;
      deck.add(Word(term,row['meaning'] as String,term,attribution:
        'Tatoeba · ${row['author']} (#${row['sourceId']}) / ${row['translator']} (#${row['translationId']}) · CC BY 2.0 FR'));
    }
  }
}
