import 'package:dio/dio.dart';
import 'package:one_debt/core/model/d_rate.dart';
import 'package:one_debt/core/model/d_rates.dart';

class RatesNetworkService {
  final Dio dio;

  RatesNetworkService({required this.dio});

  Future<DRates> getRatesToUsd(List<String> isoCodes) async {
    final response = await dio.request(
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json',
      options: Options(
        method: 'GET',
      ),
    );
    final map = (response.data as Map<String, dynamic>)['usd'];
    final List<DRate> all = (map as Map<String, dynamic>)
        .entries
        .where((element) => isoCodes.contains(element.key.toLowerCase()))
        .map((entry) => DRate(isoCode: entry.key.toUpperCase(), toUsd: entry.value as double))
        .toList();
    return DRates(rates: all);
  }
}
