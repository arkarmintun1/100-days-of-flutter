import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the browser (or the app that handles it).
/// Shows a SnackBar if it couldn't be opened.
Future<void> openLink(BuildContext context, String url) async {
  var opened = false;
  try {
    opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } on PlatformException {
    opened = false; // e.g. no app on the device can open this link
  }

  if (!opened && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Couldn't open the link.")));
  }
}
