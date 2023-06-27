import 'package:crypto_market/Constant/Colors.dart';
import 'package:crypto_market/Data/Model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptoList});

  List<Crypto>? cryptoList;

  @override
  State<CoinListScreen> createState() => CoinListScreenState();
}

class CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isSearchLoadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: blackColor,
        appBar: AppBar(
          backgroundColor: blackColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'کریپتو بازار',
            style: TextStyle(color: Colors.white, fontFamily: 'Moraba'),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      onChanged: (value) {
                        _filtredList(value);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          hintText: 'اسم رمز ارز معتبر را سرچ کنید',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Moraba',
                          ),
                          filled: true,
                          fillColor: greenColor),
                    ),
                  ),
                ),
                Visibility(
                  visible: isSearchLoadingVisible,
                  child: Text(
                    '...درحال آپدیت رمز ارزها',
                    style: TextStyle(
                      color: greenColor,
                      fontFamily: 'Moraba',
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: greenColor,
                    color: blackColor,
                    onRefresh: () async {
                      List<Crypto> freshData = await _getData();
                      setState(() {
                        cryptoList = freshData;
                      });
                    },
                    child: ListView.builder(
                      itemCount: cryptoList!.length,
                      itemBuilder: (context, index) {
                        return _getListTileItems(cryptoList![index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _getListTileItems(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 24.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 120.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 18.0),
                ),
                Text(
                  '% ' + crypto.changePercent24Hr.toStringAsFixed(2),
                  style: _getPercentColor(crypto.changePercent24Hr),
                ),
              ],
            ),
            SizedBox(
              width: 16.0,
            ),
            _getTrendingIcons(crypto.changePercent24Hr),
          ],
        ),
      ),
    );
  }

  Icon _getTrendingIcons(double percentChange) {
    return percentChange <= 0
        ? Icon(Icons.trending_up, color: redColor)
        : Icon(Icons.trending_up, color: greenColor);
  }

  TextStyle _getPercentColor(double percentChange) {
    return percentChange <= 0
        ? TextStyle(color: redColor)
        : TextStyle(color: greenColor);
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>(
          (jsonMapObject) => Crypto.fromMapJson(jsonMapObject),
        )
        .toList();
    return cryptoList;
  }

  Future<void> _filtredList(String entredKeyWord) async {
    List<Crypto> cryptoResultList = [];
    if (entredKeyWord.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }
    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(entredKeyWord.toLowerCase());
    }).toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
