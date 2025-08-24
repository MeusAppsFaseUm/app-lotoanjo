import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lottery_result.dart';
import '../models/lottery_type.dart';

class LotteryService {
  static const String _baseUrl = 'https://loteriascaixa-api.herokuapp.com/api';
  static const String _megaHistoryUrl = 
      'https://raw.githubusercontent.com/guilhermeasn/loteria.json/master/data/megasena.json';

  static Future<List<int>> generateSmartNumbers(LotteryType type) async {
    if (type == LotteryType.mega) {
      try {
        final response = await http.get(Uri.parse(_megaHistoryUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final contests = data.values
              .map((contest) => (contest as List)
                  .map((num) => int.parse(num.toString()))
                  .toList())
              .toList();
          
          return _generateMegaIntelligent(contests, type.quantity);
        }
      } catch (e) {
        print('Erro ao carregar histórico da Mega-Sena: $e');
      }
    }
    
    return _generateRandomNumbers(type);
  }

  static List<int> _generateMegaIntelligent(List<List<int>> contests, int quantity) {
    final frequency = List.filled(60, 0);
    
    for (final contest in contests) {
      for (final number in contest) {
        if (number >= 1 && number <= 60) {
          frequency[number - 1]++;
        }
      }
    }
    
    final numberFrequency = <MapEntry<int, int>>[];
    for (int i = 0; i < frequency.length; i++) {
      numberFrequency.add(MapEntry(i + 1, frequency[i]));
    }
    
    numberFrequency.sort((a, b) => b.value.compareTo(a.value));
    
    final hotNumbers = numberFrequency.take(20).map((e) => e.key).toList();
    final coldNumbers = numberFrequency.skip(40).map((e) => e.key).toList();
    
    final selectedNumbers = <int>{};
    while (selectedNumbers.length < quantity) {
      final useHot = selectedNumbers.length < quantity * 0.6;
      final source = useHot ? hotNumbers : coldNumbers;
      if (source.isNotEmpty) {
        selectedNumbers.add(source[DateTime.now().millisecondsSinceEpoch % source.length]);
      }
    }
    
    final result = selectedNumbers.toList();
    result.sort();
    return result;
  }

  static List<int> _generateRandomNumbers(LotteryType type) {
    final numbers = <int>{};
    final random = DateTime.now().millisecondsSinceEpoch;
    
    while (numbers.length < type.quantity) {
      final number = (random + numbers.length) % type.maxNumber + 1;
      numbers.add(number);
    }
    
    final result = numbers.toList();
    result.sort();
    return result;
  }

  static Future<LotteryResult?> getLatestResult(LotteryType type) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/${type.apiKey}/latest'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return LotteryResult.fromJson({
          ...data,
          'loteria': type.displayName,
        });
      }
    } catch (e) {
      print('Erro ao buscar resultado de ${type.displayName}: $e');
    }
    return null;
  }

  static Future<List<LotteryResult>> getAllLatestResults() async {
    final results = <LotteryResult>[];
    
    for (final type in LotteryType.values) {
      final result = await getLatestResult(type);
      if (result != null) {
        results.add(result);
      }
    }
    
    return results;
  }
}
