import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List cryptoCurrency;
  String cryptoUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  List<MaterialColor> colors = [Colors.blue, Colors.indigo, Colors.purple];

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<String> getData() async {
    var response = await http.get(cryptoUrl);
    print(response.body);
    setState(() {
      cryptoCurrency = json.decode(response.body);
      isLoading = false;
    });

    print('hello');
    return 'succes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto App',style:TextStyle(color:Colors.white))),
      body: _displayData(),
    );
  }

  Widget _displayData() {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    :ListView.builder(
                itemCount: cryptoCurrency==null?0:cryptoCurrency.length,
                itemBuilder: (BuildContext context, int index) {
                        final Map currency = cryptoCurrency[index];
                        final MaterialColor color = colors[index % colors.length];
                        return _getTile(currency, color);
                      }),
          ),
        ],
      ),
    );
  }

  ListTile _getTile(Map currency, Color color) {
    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
          backgroundColor: color, child: Text(currency['name'][0])),
      title:
          Text(currency['name'], style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          _getSubTitle(currency['price_usd'], currency['percent_change_1h']),
    );
  }

  Widget _getSubTitle(String priceUSD, String percentChange) {
    TextSpan priceTextWidget = TextSpan(text: '\$$priceUSD\n',style: TextStyle(color:Colors.black));
    TextSpan percentChangeWidget = TextSpan(
        text: '1 hour :$percentChange%',
        style: TextStyle(
          color: double.parse(percentChange) < 0 ? Colors.red : Colors.green,
        ));
        return RichText(text: TextSpan(children:[priceTextWidget,percentChangeWidget] ));
  }
}
