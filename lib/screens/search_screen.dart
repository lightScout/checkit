import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final double topBorderRadius;
  SearchScreen({this.topBorderRadius});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //* TextField Controller
  final textFieldController = TextEditingController();
  String newSearchName;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.topBorderRadius)),
          gradient: KMainLinearGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* Search textfield
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: textFieldController,
              style: Klogo.copyWith(
                fontSize: 13,
                color: Colors.white,
                shadows: [],
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Search here',
                hintStyle: TextStyle(
                  color: KMainPurple.withOpacity(.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  borderSide: BorderSide(color: Colors.white70, width: 5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 5.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  newSearchName = value;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            //* Search button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .12,
                    width: MediaQuery.of(context).size.height * .12,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: KTopLinearGradientColor,
                          offset: Offset(-10.0, -15.0), //(x,y)
                          blurRadius: 22.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                          heroTag: 'SEARCHCONTAINERFAB',
                          splashColor: KMainOrange,
                          backgroundColor: KMainPurple,
                          onPressed: () {
                            if (newSearchName == null ||
                                newSearchName.trim() == '') {
                              noNameAlert(context, 'Search');
                            }
                          },
                          child: Icon(
                            Icons.fingerprint,
                            size: MediaQuery.of(context).size.height * .08,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
