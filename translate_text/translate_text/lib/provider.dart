import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TranslatorProvider extends ChangeNotifier {
  String _recognizedText = "";
  String _translatedText = "";
  bool _isLoading = false;

  String get recognizedText => _recognizedText;
  String get translatedText => _translatedText;
  bool get isLoading => _isLoading;

  final String apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';

  Future<void> translateText(String text) async {
    _recognizedText = text;
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?key=$apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': 'en',
          'target': 'bn',
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _translatedText = data['data']['translations'][0]['translatedText'];
      } else {
        _translatedText = "অনুবাদ করা সম্ভব হয়নি";
      }
    } catch (error) {
      _translatedText = "সমস্যা হয়েছে: ${error.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }
}


// হ্যাঁ, Google Cloud API Key ব্যবহার করলে কিছু খরচ হতে পারে, কারণ গুগল ক্লাউড পরিষেবাগুলি পেমেন্ট-ভিত্তিক। তবে গুগল কিছু ফ্রি ক্রেডিট এবং ফ্রি টিয়ার প্রদান করে, যা ছোট প্রোজেক্টের জন্য যথেষ্ট হতে পারে।

// Google Cloud Translation API এর জন্য খরচ:
// ফ্রি ক্রেডিট:
// গুগল ক্লাউড আপনাকে $300 এর ফ্রি ক্রেডিট দেয়, যা আপনি প্রথম 90 দিনে ব্যবহার করতে পারেন। এই ক্রেডিট দিয়ে আপনি বিভিন্ন Google Cloud পরিষেবা ব্যবহার করতে পারবেন।
// ফ্রি টিয়ার:
// গুগল ট্রান্সলেশন API-র জন্য 500,000 অক্ষর (characters) পর্যন্ত প্রতি মাসে ফ্রি ট্রান্সলেশন সুবিধা পাওয়া যায়। এর পর আপনি প্রতি 1 মিলিয়ন অক্ষরের জন্য $20 খরচ পাবেন।
// খরচের বিবরণ:
// 500,000 অক্ষর প্রতি মাসে ফ্রি: গুগল আপনাকে প্রতি মাসে 500,000 অক্ষর ট্রান্সলেট করার সুযোগ দেয়। যদি আপনি এই সীমার মধ্যে থাকেন, তাহলে কোন খরচ হবে না।
// পরবর্তী অক্ষর প্রতি $20 প্রতি মিলিয়ন অক্ষর: যদি আপনি 500,000 অক্ষরের বেশি ট্রান্সলেট করেন, তবে প্রতি মিলিয়ন অক্ষরের জন্য $20 খরচ হবে।
// কিভাবে আপনি খরচ নিয়ন্ত্রণ করবেন?
// আপনি Google Cloud Console-এ Billing Alerts সেট করতে পারেন, যাতে আপনি জানেন যখন আপনার খরচ কিছু নির্দিষ্ট পরিমাণে পৌঁছাবে।
// ফ্রি ক্রেডিট বা ফ্রি টিয়ার ব্যবহারের মধ্যে থাকলে, আপনি কোন খরচ ছাড়াই API ব্যবহার করতে পারবেন।
// সংক্ষেপে:
// যদি আপনি ফ্রি টিয়ার বা ফ্রি ক্রেডিটের মধ্যে থাকেন, তাহলে কোনো খরচ হবে না।
// তারপরে, যদি আপনি সীমা অতিক্রম করেন, তবে প্রতি মিলিয়ন অক্ষরের জন্য খরচ হবে $20।
// এখন আপনি যদি ছোট প্রোজেক্টে কাজ করেন, তবে ফ্রি টিয়ার বা ক্রেডিটের মধ্যে আপনার কাজ চলে যাবে।

// ▶ https://youtu.be/brCkpzAD0gc?si=XehJjc5iH46ZdzfA