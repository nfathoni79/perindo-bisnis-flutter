import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyUtils {
  /// Show snackbar.
  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    ));
  }

  /// Format number with thousand separators.
  static String formatNumber(dynamic number) {
    return NumberFormat.decimalPattern('id_ID').format(number);
  }

  /// Format date and time.
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd('id_ID').add_Hm().format(dateTime.toLocal());
  }

  /// Format date and time with ago.
  static String formatDateAgo(DateTime dateTime, {bool withTime = false}) {
    Duration diff = DateTime.now().difference(dateTime.toLocal());

    if (diff.inDays > 1) {
      if (withTime) {
        return DateFormat.yMMMd('id_ID').add_Hm().format(dateTime.toLocal());
      }

      return DateFormat.yMMMd('id_ID').format(dateTime.toLocal());
    }

    if (diff.inDays > 0) {
      if (withTime) {
        return 'Kemarin ${DateFormat.Hm('id_ID').format(dateTime.toLocal())}';
      }

      return 'Kemarin';
    }

    if (diff.inHours > 0) {
      return '${diff.inHours} jam lalu';
    }

    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} menit lalu';
    }

    return 'Baru saja';
  }

  /// Capitalize first letter of text.
  static String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Show loading dialog.
  static Future showLoading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Memuat...'),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
        contentPadding: EdgeInsets.all(32),
      ),
      barrierDismissible: false,
    );
  }

  /// Show error dialog.
  static Future showErrorDialog(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(
          message ?? 'Terjadi kesalahan',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Show success dialog.
  static Future showSuccessDialog(BuildContext context,
      {String message = '', bool doublePop = false}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sukses'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (doublePop) Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }


  /// No empty form field validator.
  static String? noEmptyValidator(String? value) {
    if (value == null || value.isEmpty) return 'Harap diisi';
    return null;
  }

  /// Must select dropdown validator.
  static String? mustSelectValidator<T>(T? value) {
    if (value == null) return 'Harap dipilih';
    return null;
  }
}
