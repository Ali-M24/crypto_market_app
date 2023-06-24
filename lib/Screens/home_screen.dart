import 'package:crypto_market/Data/Model/crypto.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.cryptoList});

  List<Crypto>? cryptoList;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Crypto>? cryptoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: cryptoList!.length,
        itemBuilder: (context, index) {
          return Container(
            child: Center(
              child: Text(cryptoList![index].name),
            ),
          );
        },
      ),
    );
  }
}
