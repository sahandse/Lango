import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'speech_match.dart';

class VoiceExercise extends StatefulWidget {
  final String term, locale;
  const VoiceExercise({super.key, required this.term, required this.locale});
  @override
  State<VoiceExercise> createState() => _VoiceExerciseState();
}

class _VoiceExerciseState extends State<VoiceExercise>
    with WidgetsBindingObserver {
  final speech = stt.SpeechToText();
  String heard = '', message = '';
  bool busy = false, finished = true;
  int? similarity, best;
  int attempts = 0, session = 0;
  Timer? deadline;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  bool active(int token) => mounted && token == session && !finished;

  void finish(int token) {
    if (!active(token)) return;
    deadline?.cancel();
    setState(() {
      finished = true;
      busy = false;
      if (heard.trim().isEmpty) {
        message = 'گفتاری تشخیص داده نشد. دوباره تلاش کن.';
        return;
      }
      similarity = transcriptSimilarity(widget.term, heard, widget.locale);
      attempts++;
      if (best == null || similarity! > best!) best = similarity;
      message = similarity == 100
          ? 'متن تشخیص داده شده مطابق است.'
          : 'متن تشخیص داده شده متفاوت است؛ الگو را دوباره گوش کن.';
    });
  }

  void fail(int token, String text) {
    if (!active(token)) return;
    deadline?.cancel();
    setState(() {
      finished = true;
      busy = false;
      message = text;
    });
  }

  Future<void> listen() async {
    if (busy) return;
    final token = ++session;
    setState(() {
      busy = true;
      finished = false;
      similarity = null;
      heard = '';
      message = '';
    });
    deadline = Timer(const Duration(seconds: 20), () {
      if (!active(token)) return;
      speech.cancel();
      fail(token, 'مهلت تشخیص گفتار تمام شد؛ دوباره تلاش کن.');
    });
    try {
      final available = await speech.initialize(
        onError: (error) =>
            fail(session, 'تشخیص گفتار در دسترس نیست یا متوقف شد.'),
        onStatus: (status) {
          // The plugin keeps initialization callbacks between listening sessions.
          if (status == 'done') finish(session);
        },
      );
      if (!active(token)) return;
      if (!available) {
        fail(token, 'موتور تشخیص گفتار یا مجوز میکروفون در دسترس نیست.');
        return;
      }
      final locales = await speech.locales();
      if (!active(token)) return;
      final wanted = widget.locale.replaceAll('_', '-').toLowerCase();
      final matches = locales.where(
        (l) => l.localeId.replaceAll('_', '-').toLowerCase() == wanted,
      );
      if (matches.isEmpty) {
        fail(token, 'تشخیص گفتار برای لهجه انتخابی در دستگاه موجود نیست.');
        return;
      }
      await speech.listen(
        localeId: matches.first.localeId,
        onResult: (result) {
          if (!active(token)) return;
          setState(() => heard = result.recognizedWords);
          if (result.finalResult) finish(token);
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        listenOptions: stt.SpeechListenOptions(
          onDevice: true,
          partialResults: true,
        ),
      );
    } catch (_) {
      fail(token, 'تشخیص گفتار آفلاین برای این دستگاه یا زبان در دسترس نیست.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final token = session;
      speech.cancel();
      fail(token, 'تمرین متوقف شد؛ برای ادامه دوباره میکروفون را لمس کن.');
    }
  }

  @override
  void dispose() {
    session++;
    deadline?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'میکروفون فقط با لمس دکمه فعال می‌شود. تشخیص روی دستگاه درخواست می‌شود؛ پشتیبانی به موتور نصب‌شده بستگی دارد.',
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: busy
            ? () async {
                final token = session;
                try {
                  await speech.stop();
                  finish(token);
                } catch (_) {
                  fail(token, 'توقف تشخیص گفتار ممکن نبود.');
                }
              }
            : listen,
        icon: Icon(busy ? Icons.stop : Icons.mic),
        label: Text(busy ? 'پایان شنیدن' : 'صحبت کن'),
      ),
      if (heard.isNotEmpty)
        Text(
          heard,
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      if (message.isNotEmpty) Text(message),
      if (similarity != null) ...[
        Text('شباهت نوشتاری گفتار: $similarity٪'),
        LinearProgressIndicator(value: similarity! / 100),
        Text('تلاش‌ها: $attempts • بهترین شباهت نوشتاری: $best٪'),
      ],
      const Text(
        'این تمرین تطبیق متن گفتار است، نه امتیازدهی آوایی یا سنجش دقیق لهجه.',
      ),
    ],
  );
}
