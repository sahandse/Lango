import 'level_lessons.dart';

// Original Lango teaching material. Indicative levels, not certified CEFR coverage.
const practiceLessons = <String, Map<String, LevelLesson>>{
  "en": {
    "A1": LevelLesson(
      "خرید و قیمت",
      "درخواست، تعداد و قیمت را با عبارت‌های کوتاه تمرین کن.",
      [
        LessonPhrase("How much is this?", "این چقدر است؟"),
        LessonPhrase("I would like two apples.", "دو سیب می‌خواهم."),
        LessonPhrase("Can I pay by card?", "می‌توانم با کارت پرداخت کنم؟"),
        LessonPhrase("The receipt, please.", "رسید را لطفاً بدهید."),
      ],
    ),
    "A2": LevelLesson(
      "سفر و حل مشکل",
      "درخواست مؤدبانه و توضیح مشکل در سفر را تمرین کن.",
      [
        LessonPhrase("I have booked a room.", "اتاق رزرو کرده‌ام."),
        LessonPhrase(
          "There is no hot water in the room.",
          "در اتاق آب گرم نیست.",
        ),
        LessonPhrase(
          "Could you give me another room?",
          "ممکن است اتاق دیگری به من بدهید؟",
        ),
        LessonPhrase(
          "What time does the next bus leave?",
          "اتوبوس بعدی چه ساعتی حرکت می‌کند؟",
        ),
      ],
    ),
    "B1": LevelLesson(
      "کار و همکاری",
      "پیشنهاد، توافق و توضیح مسئولیت را در محیط کار تمرین کن.",
      [
        LessonPhrase(
          "I can finish the report by Friday.",
          "می‌توانم گزارش را تا جمعه تمام کنم.",
        ),
        LessonPhrase(
          "Let's divide the tasks fairly.",
          "بیا کارها را منصفانه تقسیم کنیم.",
        ),
        LessonPhrase(
          "If you need help, let me know.",
          "اگر کمک لازم داشتی، به من بگو.",
        ),
        LessonPhrase(
          "We should talk to the team before making a decision.",
          "پیش از تصمیم‌گیری باید با تیم صحبت کنیم.",
        ),
      ],
    ),
    "B2": LevelLesson(
      "خبر و منبع",
      "اعتبار منبع و تفاوت ادعا با شاهد را بررسی کن.",
      [
        LessonPhrase(
          "The author provides no source for this claim.",
          "نویسنده منبعی برای این ادعا ارائه نمی‌کند.",
        ),
        LessonPhrase(
          "The sample size may affect the reliability of the results.",
          "اندازه نمونه ممکن است بر پایایی نتایج اثر بگذارد.",
        ),
        LessonPhrase(
          "Independent evidence supports this conclusion.",
          "شاهد مستقل از این نتیجه‌گیری پشتیبانی می‌کند.",
        ),
        LessonPhrase(
          "We should check the information before sharing the news.",
          "پیش از بازنشر خبر باید اطلاعات را بررسی کنیم.",
        ),
      ],
    ),
    "C1": LevelLesson(
      "گفت‌وگوی دانشگاهی",
      "محدوده ادعا، نقد و پاسخ مستدل را تمرین کن.",
      [
        LessonPhrase(
          "This interpretation is plausible, though it is not the only possible one.",
          "این تفسیر پذیرفتنی است، هرچند تنها تفسیر ممکن نیست.",
        ),
        LessonPhrase(
          "Our analysis depends on the assumptions stated earlier.",
          "تحلیل ما به فرضیاتی وابسته است که پیش‌تر بیان کردیم.",
        ),
        LessonPhrase(
          "A single counterexample is enough to refute a universal claim.",
          "یک مثال نقض برای رد ادعای کلی کافی است.",
        ),
        LessonPhrase(
          "The question is whether this distinction holds in practice as well.",
          "پرسش این است که آیا این تمایز در عمل نیز برقرار می‌ماند.",
        ),
      ],
    ),
    "C2": LevelLesson(
      "لحن و مذاکره",
      "تفاوت پذیرش، تردید و مخالفت غیرمستقیم را تمرین کن.",
      [
        LessonPhrase(
          "I agree in principle, but the implementation remains open to debate.",
          "با اصل موضوع موافقم، اما نحوه اجرای آن همچنان جای بحث دارد.",
        ),
        LessonPhrase(
          "Her silence should not be taken as a sign of consent.",
          "نباید سکوت او را نشانه رضایت دانست.",
        ),
        LessonPhrase(
          "With all due respect, this proposal fails to address the underlying issue.",
          "با تمام احترامی که قائلم، این پیشنهاد به اصل مسئله نمی‌پردازد.",
        ),
        LessonPhrase(
          "A workable compromise must safeguard the interests of both parties.",
          "یک مصالحه قابل‌قبول باید منافع هر دو طرف را حفظ کند.",
        ),
      ],
    ),
  },
  "de": {
    "A1": LevelLesson(
      "خرید و قیمت",
      "درخواست، تعداد و قیمت را با عبارت‌های کوتاه تمرین کن.",
      [
        LessonPhrase("Wie viel kostet das?", "این چقدر است؟"),
        LessonPhrase("Ich hätte gern zwei Äpfel.", "دو سیب می‌خواهم."),
        LessonPhrase(
          "Kann ich mit Karte bezahlen?",
          "می‌توانم با کارت پرداخت کنم؟",
        ),
        LessonPhrase("Den Kassenbon bitte.", "رسید را لطفاً بدهید."),
      ],
    ),
    "A2": LevelLesson(
      "سفر و حل مشکل",
      "درخواست مؤدبانه و توضیح مشکل در سفر را تمرین کن.",
      [
        LessonPhrase("Ich habe ein Zimmer gebucht.", "اتاق رزرو کرده‌ام."),
        LessonPhrase(
          "Im Zimmer gibt es kein warmes Wasser.",
          "در اتاق آب گرم نیست.",
        ),
        LessonPhrase(
          "Könnten Sie mir ein anderes Zimmer geben?",
          "ممکن است اتاق دیگری به من بدهید؟",
        ),
        LessonPhrase(
          "Wann fährt der nächste Bus ab?",
          "اتوبوس بعدی چه ساعتی حرکت می‌کند؟",
        ),
      ],
    ),
    "B1": LevelLesson(
      "کار و همکاری",
      "پیشنهاد، توافق و توضیح مسئولیت را در محیط کار تمرین کن.",
      [
        LessonPhrase(
          "Ich kann den Bericht bis Freitag fertigstellen.",
          "می‌توانم گزارش را تا جمعه تمام کنم.",
        ),
        LessonPhrase(
          "Teilen wir die Aufgaben gerecht auf.",
          "بیا کارها را منصفانه تقسیم کنیم.",
        ),
        LessonPhrase(
          "Wenn du Hilfe brauchst, sag mir Bescheid.",
          "اگر کمک لازم داشتی، به من بگو.",
        ),
        LessonPhrase(
          "Wir sollten mit dem Team sprechen, bevor wir eine Entscheidung treffen.",
          "پیش از تصمیم‌گیری باید با تیم صحبت کنیم.",
        ),
      ],
    ),
    "B2": LevelLesson(
      "خبر و منبع",
      "اعتبار منبع و تفاوت ادعا با شاهد را بررسی کن.",
      [
        LessonPhrase(
          "Der Autor nennt keine Quelle für diese Behauptung.",
          "نویسنده منبعی برای این ادعا ارائه نمی‌کند.",
        ),
        LessonPhrase(
          "Die Stichprobengröße kann die Zuverlässigkeit der Ergebnisse beeinflussen.",
          "اندازه نمونه ممکن است بر پایایی نتایج اثر بگذارد.",
        ),
        LessonPhrase(
          "Unabhängige Belege stützen diese Schlussfolgerung.",
          "شاهد مستقل از این نتیجه‌گیری پشتیبانی می‌کند.",
        ),
        LessonPhrase(
          "Wir sollten die Informationen prüfen, bevor wir die Nachricht weitergeben.",
          "پیش از بازنشر خبر باید اطلاعات را بررسی کنیم.",
        ),
      ],
    ),
    "C1": LevelLesson(
      "گفت‌وگوی دانشگاهی",
      "محدوده ادعا، نقد و پاسخ مستدل را تمرین کن.",
      [
        LessonPhrase(
          "Diese Interpretation ist plausibel, aber nicht die einzig mögliche.",
          "این تفسیر پذیرفتنی است، هرچند تنها تفسیر ممکن نیست.",
        ),
        LessonPhrase(
          "Unsere Analyse hängt von den zuvor genannten Annahmen ab.",
          "تحلیل ما به فرضیاتی وابسته است که پیش‌تر بیان کردیم.",
        ),
        LessonPhrase(
          "Ein einziges Gegenbeispiel genügt, um eine allgemeine Behauptung zu widerlegen.",
          "یک مثال نقض برای رد ادعای کلی کافی است.",
        ),
        LessonPhrase(
          "Die Frage ist, ob diese Unterscheidung auch in der Praxis Bestand hat.",
          "پرسش این است که آیا این تمایز در عمل نیز برقرار می‌ماند.",
        ),
      ],
    ),
    "C2": LevelLesson(
      "لحن و مذاکره",
      "تفاوت پذیرش، تردید و مخالفت غیرمستقیم را تمرین کن.",
      [
        LessonPhrase(
          "Ich stimme grundsätzlich zu, doch die Umsetzung bleibt diskussionswürdig.",
          "با اصل موضوع موافقم، اما نحوه اجرای آن همچنان جای بحث دارد.",
        ),
        LessonPhrase(
          "Ihr Schweigen sollte nicht als Zeichen der Zustimmung gewertet werden.",
          "نباید سکوت او را نشانه رضایت دانست.",
        ),
        LessonPhrase(
          "Bei allem Respekt geht dieser Vorschlag am eigentlichen Problem vorbei.",
          "با تمام احترامی که قائلم، این پیشنهاد به اصل مسئله نمی‌پردازد.",
        ),
        LessonPhrase(
          "Ein tragfähiger Kompromiss muss die Interessen beider Parteien wahren.",
          "یک مصالحه قابل‌قبول باید منافع هر دو طرف را حفظ کند.",
        ),
      ],
    ),
  },
  "fr": {
    "A1": LevelLesson(
      "خرید و قیمت",
      "درخواست، تعداد و قیمت را با عبارت‌های کوتاه تمرین کن.",
      [
        LessonPhrase("Combien ça coûte ?", "این چقدر است؟"),
        LessonPhrase("Je voudrais deux pommes.", "دو سیب می‌خواهم."),
        LessonPhrase(
          "Est-ce que je peux payer par carte ?",
          "می‌توانم با کارت پرداخت کنم؟",
        ),
        LessonPhrase("Le reçu, s’il vous plaît.", "رسید را لطفاً بدهید."),
      ],
    ),
    "A2": LevelLesson(
      "سفر و حل مشکل",
      "درخواست مؤدبانه و توضیح مشکل در سفر را تمرین کن.",
      [
        LessonPhrase("J’ai réservé une chambre.", "اتاق رزرو کرده‌ام."),
        LessonPhrase(
          "Il n’y a pas d’eau chaude dans la chambre.",
          "در اتاق آب گرم نیست.",
        ),
        LessonPhrase(
          "Pourriez-vous me donner une autre chambre ?",
          "ممکن است اتاق دیگری به من بدهید؟",
        ),
        LessonPhrase(
          "À quelle heure part le prochain bus ?",
          "اتوبوس بعدی چه ساعتی حرکت می‌کند؟",
        ),
      ],
    ),
    "B1": LevelLesson(
      "کار و همکاری",
      "پیشنهاد، توافق و توضیح مسئولیت را در محیط کار تمرین کن.",
      [
        LessonPhrase(
          "Je peux terminer le rapport d’ici vendredi.",
          "می‌توانم گزارش را تا جمعه تمام کنم.",
        ),
        LessonPhrase(
          "Répartissons les tâches équitablement.",
          "بیا کارها را منصفانه تقسیم کنیم.",
        ),
        LessonPhrase(
          "Si tu as besoin d’aide, dis-le-moi.",
          "اگر کمک لازم داشتی، به من بگو.",
        ),
        LessonPhrase(
          "Nous devrions parler à l’équipe avant de prendre une décision.",
          "پیش از تصمیم‌گیری باید با تیم صحبت کنیم.",
        ),
      ],
    ),
    "B2": LevelLesson(
      "خبر و منبع",
      "اعتبار منبع و تفاوت ادعا با شاهد را بررسی کن.",
      [
        LessonPhrase(
          "L’auteur ne cite aucune source à l’appui de cette affirmation.",
          "نویسنده منبعی برای این ادعا ارائه نمی‌کند.",
        ),
        LessonPhrase(
          "La taille de l’échantillon peut affecter la fiabilité des résultats.",
          "اندازه نمونه ممکن است بر پایایی نتایج اثر بگذارد.",
        ),
        LessonPhrase(
          "Des éléments indépendants étayent cette conclusion.",
          "شاهد مستقل از این نتیجه‌گیری پشتیبانی می‌کند.",
        ),
        LessonPhrase(
          "Nous devrions vérifier les informations avant de partager la nouvelle.",
          "پیش از بازنشر خبر باید اطلاعات را بررسی کنیم.",
        ),
      ],
    ),
    "C1": LevelLesson(
      "گفت‌وگوی دانشگاهی",
      "محدوده ادعا، نقد و پاسخ مستدل را تمرین کن.",
      [
        LessonPhrase(
          "Cette interprétation est plausible, mais ce n’est pas la seule possible.",
          "این تفسیر پذیرفتنی است، هرچند تنها تفسیر ممکن نیست.",
        ),
        LessonPhrase(
          "Notre analyse dépend des hypothèses énoncées précédemment.",
          "تحلیل ما به فرضیاتی وابسته است که پیش‌تر بیان کردیم.",
        ),
        LessonPhrase(
          "Un seul contre-exemple suffit à réfuter une affirmation universelle.",
          "یک مثال نقض برای رد ادعای کلی کافی است.",
        ),
        LessonPhrase(
          "La question est de savoir si cette distinction tient également dans la pratique.",
          "پرسش این است که آیا این تمایز در عمل نیز برقرار می‌ماند.",
        ),
      ],
    ),
    "C2": LevelLesson(
      "لحن و مذاکره",
      "تفاوت پذیرش، تردید و مخالفت غیرمستقیم را تمرین کن.",
      [
        LessonPhrase(
          "Je suis d’accord sur le principe, mais la mise en œuvre reste sujette à débat.",
          "با اصل موضوع موافقم، اما نحوه اجرای آن همچنان جای بحث دارد.",
        ),
        LessonPhrase(
          "Son silence ne doit pas être interprété comme un signe de consentement.",
          "نباید سکوت او را نشانه رضایت دانست.",
        ),
        LessonPhrase(
          "Avec tout le respect que je vous dois, cette proposition ne traite pas le fond du problème.",
          "با تمام احترامی که قائلم، این پیشنهاد به اصل مسئله نمی‌پردازد.",
        ),
        LessonPhrase(
          "Un compromis viable doit préserver les intérêts des deux parties.",
          "یک مصالحه قابل‌قبول باید منافع هر دو طرف را حفظ کند.",
        ),
      ],
    ),
  },
  "es": {
    "A1": LevelLesson(
      "خرید و قیمت",
      "درخواست، تعداد و قیمت را با عبارت‌های کوتاه تمرین کن.",
      [
        LessonPhrase("¿Cuánto cuesta esto?", "این چقدر است؟"),
        LessonPhrase("Quisiera dos manzanas.", "دو سیب می‌خواهم."),
        LessonPhrase(
          "¿Puedo pagar con tarjeta?",
          "می‌توانم با کارت پرداخت کنم؟",
        ),
        LessonPhrase("El recibo, por favor.", "رسید را لطفاً بدهید."),
      ],
    ),
    "A2": LevelLesson(
      "سفر و حل مشکل",
      "درخواست مؤدبانه و توضیح مشکل در سفر را تمرین کن.",
      [
        LessonPhrase("He reservado una habitación.", "اتاق رزرو کرده‌ام."),
        LessonPhrase(
          "No hay agua caliente en la habitación.",
          "در اتاق آب گرم نیست.",
        ),
        LessonPhrase(
          "¿Podría darme otra habitación?",
          "ممکن است اتاق دیگری به من بدهید؟",
        ),
        LessonPhrase(
          "¿A qué hora sale el próximo autobús?",
          "اتوبوس بعدی چه ساعتی حرکت می‌کند؟",
        ),
      ],
    ),
    "B1": LevelLesson(
      "کار و همکاری",
      "پیشنهاد، توافق و توضیح مسئولیت را در محیط کار تمرین کن.",
      [
        LessonPhrase(
          "Puedo terminar el informe para el viernes.",
          "می‌توانم گزارش را تا جمعه تمام کنم.",
        ),
        LessonPhrase(
          "Repartamos las tareas de forma justa.",
          "بیا کارها را منصفانه تقسیم کنیم.",
        ),
        LessonPhrase(
          "Si necesitas ayuda, dímelo.",
          "اگر کمک لازم داشتی، به من بگو.",
        ),
        LessonPhrase(
          "Deberíamos hablar con el equipo antes de tomar una decisión.",
          "پیش از تصمیم‌گیری باید با تیم صحبت کنیم.",
        ),
      ],
    ),
    "B2": LevelLesson(
      "خبر و منبع",
      "اعتبار منبع و تفاوت ادعا با شاهد را بررسی کن.",
      [
        LessonPhrase(
          "El autor no aporta ninguna fuente para esta afirmación.",
          "نویسنده منبعی برای این ادعا ارائه نمی‌کند.",
        ),
        LessonPhrase(
          "El tamaño de la muestra puede afectar a la fiabilidad de los resultados.",
          "اندازه نمونه ممکن است بر پایایی نتایج اثر بگذارد.",
        ),
        LessonPhrase(
          "Pruebas independientes respaldan esta conclusión.",
          "شاهد مستقل از این نتیجه‌گیری پشتیبانی می‌کند.",
        ),
        LessonPhrase(
          "Deberíamos comprobar la información antes de compartir la noticia.",
          "پیش از بازنشر خبر باید اطلاعات را بررسی کنیم.",
        ),
      ],
    ),
    "C1": LevelLesson(
      "گفت‌وگوی دانشگاهی",
      "محدوده ادعا، نقد و پاسخ مستدل را تمرین کن.",
      [
        LessonPhrase(
          "Esta interpretación es plausible, aunque no es la única posible.",
          "این تفسیر پذیرفتنی است، هرچند تنها تفسیر ممکن نیست.",
        ),
        LessonPhrase(
          "Nuestro análisis depende de los supuestos expuestos anteriormente.",
          "تحلیل ما به فرضیاتی وابسته است که پیش‌تر بیان کردیم.",
        ),
        LessonPhrase(
          "Un solo contraejemplo basta para refutar una afirmación universal.",
          "یک مثال نقض برای رد ادعای کلی کافی است.",
        ),
        LessonPhrase(
          "La cuestión es si esta distinción se mantiene también en la práctica.",
          "پرسش این است که آیا این تمایز در عمل نیز برقرار می‌ماند.",
        ),
      ],
    ),
    "C2": LevelLesson(
      "لحن و مذاکره",
      "تفاوت پذیرش، تردید و مخالفت غیرمستقیم را تمرین کن.",
      [
        LessonPhrase(
          "Estoy de acuerdo en principio, pero la aplicación sigue abierta al debate.",
          "با اصل موضوع موافقم، اما نحوه اجرای آن همچنان جای بحث دارد.",
        ),
        LessonPhrase(
          "Su silencio no debe interpretarse como una señal de consentimiento.",
          "نباید سکوت او را نشانه رضایت دانست.",
        ),
        LessonPhrase(
          "Con todo el respeto, esta propuesta no aborda el fondo del problema.",
          "با تمام احترامی که قائلم، این پیشنهاد به اصل مسئله نمی‌پردازد.",
        ),
        LessonPhrase(
          "Un compromiso viable debe proteger los intereses de ambas partes.",
          "یک مصالحه قابل‌قبول باید منافع هر دو طرف را حفظ کند.",
        ),
      ],
    ),
  },
  "tr": {
    "A1": LevelLesson(
      "خرید و قیمت",
      "درخواست، تعداد و قیمت را با عبارت‌های کوتاه تمرین کن.",
      [
        LessonPhrase("Bu ne kadar?", "این چقدر است؟"),
        LessonPhrase("İki elma istiyorum.", "دو سیب می‌خواهم."),
        LessonPhrase(
          "Kartla ödeyebilir miyim?",
          "می‌توانم با کارت پرداخت کنم؟",
        ),
        LessonPhrase("Fişi alabilir miyim, lütfen?", "رسید را لطفاً بدهید."),
      ],
    ),
    "A2": LevelLesson(
      "سفر و حل مشکل",
      "درخواست مؤدبانه و توضیح مشکل در سفر را تمرین کن.",
      [
        LessonPhrase("Bir oda ayırttım.", "اتاق رزرو کرده‌ام."),
        LessonPhrase("Odada sıcak su yok.", "در اتاق آب گرم نیست."),
        LessonPhrase(
          "Bana başka bir oda verebilir misiniz?",
          "ممکن است اتاق دیگری به من بدهید؟",
        ),
        LessonPhrase(
          "Sonraki otobüs saat kaçta kalkıyor?",
          "اتوبوس بعدی چه ساعتی حرکت می‌کند؟",
        ),
      ],
    ),
    "B1": LevelLesson(
      "کار و همکاری",
      "پیشنهاد، توافق و توضیح مسئولیت را در محیط کار تمرین کن.",
      [
        LessonPhrase(
          "Raporu cumaya kadar bitirebilirim.",
          "می‌توانم گزارش را تا جمعه تمام کنم.",
        ),
        LessonPhrase(
          "Görevleri adil bir şekilde paylaşalım.",
          "بیا کارها را منصفانه تقسیم کنیم.",
        ),
        LessonPhrase(
          "Yardıma ihtiyacın olursa bana haber ver.",
          "اگر کمک لازم داشتی، به من بگو.",
        ),
        LessonPhrase(
          "Karar vermeden önce ekiple konuşmalıyız.",
          "پیش از تصمیم‌گیری باید با تیم صحبت کنیم.",
        ),
      ],
    ),
    "B2": LevelLesson(
      "خبر و منبع",
      "اعتبار منبع و تفاوت ادعا با شاهد را بررسی کن.",
      [
        LessonPhrase(
          "Yazar bu iddia için kaynak göstermiyor.",
          "نویسنده منبعی برای این ادعا ارائه نمی‌کند.",
        ),
        LessonPhrase(
          "Örneklem büyüklüğü sonuçların güvenilirliğini etkileyebilir.",
          "اندازه نمونه ممکن است بر پایایی نتایج اثر بگذارد.",
        ),
        LessonPhrase(
          "Bağımsız kanıtlar bu sonucu destekliyor.",
          "شاهد مستقل از این نتیجه‌گیری پشتیبانی می‌کند.",
        ),
        LessonPhrase(
          "Haberi paylaşmadan önce bilgileri kontrol etmeliyiz.",
          "پیش از بازنشر خبر باید اطلاعات را بررسی کنیم.",
        ),
      ],
    ),
    "C1": LevelLesson(
      "گفت‌وگوی دانشگاهی",
      "محدوده ادعا، نقد و پاسخ مستدل را تمرین کن.",
      [
        LessonPhrase(
          "Bu yorum makul olsa da mümkün olan tek yorum değildir.",
          "این تفسیر پذیرفتنی است، هرچند تنها تفسیر ممکن نیست.",
        ),
        LessonPhrase(
          "Analizimiz daha önce belirtilen varsayımlara bağlıdır.",
          "تحلیل ما به فرضیاتی وابسته است که پیش‌تر بیان کردیم.",
        ),
        LessonPhrase(
          "Tek bir karşı örnek, evrensel bir iddiayı çürütmek için yeterlidir.",
          "یک مثال نقض برای رد ادعای کلی کافی است.",
        ),
        LessonPhrase(
          "Asıl soru, bu ayrımın uygulamada da geçerli olup olmadığıdır.",
          "پرسش این است که آیا این تمایز در عمل نیز برقرار می‌ماند.",
        ),
      ],
    ),
    "C2": LevelLesson(
      "لحن و مذاکره",
      "تفاوت پذیرش، تردید و مخالفت غیرمستقیم را تمرین کن.",
      [
        LessonPhrase(
          "İlke olarak katılıyorum, ancak uygulama hâlâ tartışmaya açık.",
          "با اصل موضوع موافقم، اما نحوه اجرای آن همچنان جای بحث دارد.",
        ),
        LessonPhrase(
          "Onun sessizliği bir rıza işareti olarak görülmemelidir.",
          "نباید سکوت او را نشانه رضایت دانست.",
        ),
        LessonPhrase(
          "Tüm saygımla, bu öneri meselenin özünü ele almıyor.",
          "با تمام احترامی که قائلم، این پیشنهاد به اصل مسئله نمی‌پردازد.",
        ),
        LessonPhrase(
          "Uygulanabilir bir uzlaşma her iki tarafın çıkarlarını korumalıdır.",
          "یک مصالحه قابل‌قبول باید منافع هر دو طرف را حفظ کند.",
        ),
      ],
    ),
  },
};
