import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const _baseUrl = 'https://quotes.liupurnomo.com/api';

  static Future<Map<String, String>> fetchQuoteOfTheDay() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/quotes/random'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'SUCCESS' && data['data'] != null) {
          final q = data['data'] as Map<String, dynamic>;
          return {
            'quote': q['text']?.toString() ?? '',
            'author': q['author']?.toString() ?? '',
          };
        }
      }
    } catch (_) {}
    return _fallback;
  }

  static const _fallback = {
    'quote': 'Simpan perasaan dan momenmu hari ini',
    'author': '',
  };
}
