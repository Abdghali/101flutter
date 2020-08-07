import 'package:flutter/material.dart';
import 'package:flutter_app/Company.dart';
import 'package:flutter_app/Servise.dart';
import 'package:flutter_app/api_response.dart';
import 'package:pagination_view/pagination_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CompanyService _companyService = new CompanyService();
  List<Companies> listOfAllCompany;

  /// isloging variable for CircularProgressIndicator
  bool _isLoding = false;
  int page;
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  var _token;
  APIResponse<List<Companies>> _apiResposn;

  @override
  void initState() {
    page = -1;
    paginationViewType = PaginationViewType.listView;
    key = GlobalKey<PaginationViewState>();
    _fetchAllCompanysData();
    super.initState();
  }

  /// to fetch companys list from api and store it in apiresponse
  _fetchAllCompanysData() async {
    setState(() {
      _isLoding = true;
    });
    await getTokenFromSF();
    _apiResposn = await _companyService.getClassDataList(_token, page);
    listOfAllCompany = _apiResposn.data;

    ///to store list of companys
    setState(() {
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var heightOfCard = height / 8;
    return Scaffold(
      appBar: null,
      body: Builder(
        builder: (_) {
          if (_isLoding) {
            return Center(child: CircularProgressIndicator());
          }
          if (_apiResposn.error) {
            return Center(child: Text(_apiResposn.errorMessage));
          }

          return PaginationView<Companies>(
            key: key,
            preloadedItems: listOfAllCompany,
            paginationViewType: paginationViewType,
            itemBuilder: (BuildContext context, Companies company,
                    int index) =>
                (paginationViewType == PaginationViewType.listView)
                    ? InkWell(
                        onTap: () {
                          // go to details page
                        },
                        child: Container(
                          height: heightOfCard,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              elevation: 1.6,
                              child: Row(children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage('${company.image}'),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                      width: width / 2.2,
                                      height: heightOfCard,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ListTile(
                                          title: Text(company.name ?? ""),
                                          subtitle:
                                              Text(company.orderCount.toString() ?? ""),
                                        ),
                                      )),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      )
                    : Card(),
            pageFetch: pageFetch,
            pageRefresh: pageRefresh,
            pullToRefresh: true,
            onError: (dynamic error) => Center(
              child: Text('Some error occured'),
            ),
            onEmpty: Center(
              child: Text('Sorry! This is empty'),
            ),
            bottomLoader: Center(
              child: CircularProgressIndicator(),
            ),
            initialLoader: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Companies>> pageFetch(int currentListSize) async {
    setState(() {
      page++;
    });
    APIResponse<List<Companies>> apiresponse =
        await _companyService.getClassDataList(_token, page);
    final List<Companies> nextUsersList = await apiresponse.data;
    await Future<List<Companies>>.delayed(Duration(seconds: 1));
    return page == 7 ? [] : nextUsersList;
  }

  Future<List<Companies>> pageRefresh(int offset) async {
    page = -1;
    return pageFetch(offset);
  }

  getTokenFromSF() async {
    _token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODc5OTM0MzczZjY0MDRlMjRhOTY2OTM2OTZhNWI2ODZkY2Y3MzA4OGNkNjUwOTNjYzZhMjAwODdhN2JkZDc3MTM3M2FiZTA2N2U5Mzc5ZDAiLCJpYXQiOjE1OTY4MzY2NTMsIm5iZiI6MTU5NjgzNjY1MywiZXhwIjoxNjI4MzcyNjUzLCJzdWIiOiIxNCIsInNjb3BlcyI6W119.Jz3XJ9toaNA7tx3vuPu27rtZ0XxZyHw-hZ4RcNy_NfVYZbzkfIOtcKUMM1dUPLSw3dK_ZneUQX8P4XF2T2klKFZ4mstSpD9BUx72qHmxzPx6yjULRcAzvneawtvGKM-tsrSA0vpLkafgYud-Q8OygDc9ZImfazntCBmssbC9TMGDDwYC1Rt_wRGWGJ9oOUJWmMnISa7ylR2QPr5WCvytZ1U1InWjZV7TdxydHgivQe_cFPgjo5zhoLQSiPXJf_hKT-hoBLCigBKbrPYycniHS0IJEjsv1GPNSr1e3DOTt3mfGANoNtAmh2YHNYPhm252fPJr0rognNEsfMgSioDRD7_8sVkvmQ0EOZvhvsZ6DOaOyYc9Wdpbjv4HmipI5O_rDZNvcGJJwxOpgEDyap91GpLyeiLqr8H2cGuKTjq-rr93dOIDK7gh2yzEq2jDepTjEIyBo3M7HtIg5hGRC9VxJLn-SuJ8ozQx52Y9yv_HI2PAK5Sr7Upj2uQK34vJufgaEbW8QRtO1Pw7sIWIsrUDI8ZV0ysHV133Bo-x02dz_3tqgzcjBAY1BvsgYLBqvpe6rPGAa7kbh6i8QPtuc5wRyjEcag60RH8CzvTY3c--wNsipM_7RcjEq7fdEkMEixKAHQw8B_51AykaZzAkHPtXZ55USUoJtZFmbutsUcltuCs';
  }
}
