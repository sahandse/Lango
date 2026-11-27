import 'package:flutter/material.dart';

import 'ipa.dart';

class PronunciationInfo extends StatelessWidget {
  final String locale, term;
  const PronunciationInfo({
    super.key,
    required this.locale,
    required this.term,
  });
  @override
  Widget build(BuildContext context) {
    final ipa = ipaFor(locale, term);
    return Column(
      children: [
        if (ipa != null)
          Text(
            '/$ipa/',
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        Text(
          ipa == null
              ? 'آوانویسی بررسی‌شده برای این واژه و لهجه موجود نیست.'
              : 'IPA مرجع عمومی • $locale • تألیف Lango',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
