import 'package:crypto_pricetracker/NetworkingLayer.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:crypto_pricetracker/NetworkingLayer.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String rate = "?";
  void getData() async {
    NetworkingLayer layer = NetworkingLayer(selectedCurrency);
    CurrencyData data = await layer.getCurrencyData();
    setState(() {
      rate = data.rate;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Initiallizing");
    getData();
  }

  Widget showPicker() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedCurrency = currenciesList[index];
            getData();
          });
        },
        children: currenciesList.map((e) => Text(e)).toList(),
      );
    } else {
      return DropdownButton(
        value: selectedCurrency,
        items: currenciesList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value ?? 'USD';
            getData();
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: showPicker()),
        ],
      ),
    );
  }
}
