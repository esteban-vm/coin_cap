import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:coincap/models/http_service.dart';
import 'package:coincap/pages/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HttpService _service;
  late double _deviceWidth;
  late double _deviceHeight;
  String _selectedCoin = 'bitcoin';

  @override
  void initState() {
    super.initState();
    _service = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_dropDown(), _apiData()],
          ),
        ),
      ),
    );
  }

  Widget _dropDown() {
    List<String> coins = ['bitcoin', 'ethereum', 'tether', 'cardano', 'ripple'];
    List<DropdownMenuItem<String>> items = coins.map(
      (item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    ).toList();
    return DropdownButton(
      items: items,
      value: _selectedCoin,
      onChanged: (value) {
        setState(() {
          _selectedCoin = value!;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      iconSize: 30.0,
      underline: Container(),
    );
  }

  Widget _apiData() {
    return FutureBuilder(
      future: _service.get('/coins/$_selectedCoin'),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          Map apiData = jsonDecode(snapshot.data.toString());
          String lgImage = apiData['image']['large'];
          Map exchangeRates = apiData['market_data']['current_price'];
          num usdPrice = apiData['market_data']['current_price']['usd'];
          num change24h = apiData['market_data']['price_change_percentage_24h'];
          String description = apiData['description']['en'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _coinImage(lgImage, exchangeRates),
              _currentPrice(usdPrice),
              _percentageChange(change24h),
              _descriptionCard(description),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }

  Widget _currentPrice(num rate) {
    return Text(
      '${rate.toStringAsFixed(2)} USD',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChange(num change) {
    return Text(
      '${change.toString()} %',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImage(String url, Map rates) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsPage(rates: rates)),
        );
      },
      child: Container(
        height: _deviceHeight * 0.15,
        width: _deviceWidth * 0.15,
        padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.02),
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(url)),
        ),
      ),
    );
  }

  Widget _descriptionCard(String desc) {
    return Container(
      height: _deviceHeight * 0.45,
      width: _deviceWidth * 0.90,
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.01,
        horizontal: _deviceHeight * 0.01,
      ),
      child: Text(desc, style: const TextStyle(color: Colors.white)),
    );
  }
}
