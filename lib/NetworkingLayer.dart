import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkingLayer {
  final baseUrl = "rest.coinapi.io";
  String curreny;
  late var path = "/v1/exchangerate/BTC/$curreny";
  final _header = {"X-CoinAPI-Key": "0A3E0A50-A60C-4383-A2BF-4BA0A56F32CC"};
  final _query = {"invert": "false"};
  NetworkingLayer(this.curreny);

  Future<CurrencyData> getCurrencyData() async {
    Uri url = Uri(host: baseUrl, scheme: "https", path: path);
    http.Response response = await http.get(url, headers: _header);
    final jsonBody = json.decode(response.body) as Map<String, dynamic>;
    final data = CurrencyData(jsonBody);
    return data;
  }
}

class CurrencyData {
  late String assedID;
  late String assetQuote;
  late String rate;
  CurrencyData(Map<String, dynamic> dict) {
    assedID = dict["asset_id_base"] as String;
    assetQuote = dict["asset_id_quote"] as String;
    double rate = dict["rate"] as double;
    this.rate = rate.toStringAsFixed(1).toString();
  }
}
