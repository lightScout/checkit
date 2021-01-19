import 'package:ciao_app/model/flags.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:ciao_app/widgets/simple_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchScreen extends StatefulWidget {
  final double topBorderRadius;
  SearchScreen({this.topBorderRadius});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //* TextField Controller
  final _textFieldController = TextEditingController();
  String newSearchName;
  bool isSearch = false;
  List<Task> searchResultsList = [];

  void search(String value) {
    searchResultsList.clear();
    List listOfKey = Hive.box('tasks').keys.toList();
    setState(() {
      isSearch = true;
    });

    listOfKey.forEach((element) {
      Task task = Hive.box('tasks').get(element) as Task;

      task.key = element;
      if ((Hive.box('tasks').get(element) as Task)
          .name
          .toLowerCase()
          .contains(value.toLowerCase())) {
        searchResultsList.add(task);
        print(task.key);
      }
    });
  }

  void checkState() {
    if (!(Hive.box('flags').getAt(1) as Flags).value) {
      if (!(Hive.box('flags').getAt(4) as Flags).value) {
        searchResultsList.clear();
        _textFieldController.clear();
        setState(() {
          isSearch = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double topBorderRadius = widget.topBorderRadius;
    checkState();
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(topBorderRadius)),
          gradient: KMainLinearGradient,
          image: DecorationImage(
            image: AssetImage('assets/textures/search_screen_texture.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* Search textfield
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _textFieldController,
              style: TextStyle(
                fontSize: 20,
                fontFamily: KTextFontFamily,
                color: KMainPurple,
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
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: Colors.white70, width: 5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 5.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
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
              height: 20,
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
                            } else {
                              search(newSearchName);
                              //* flag for search in progress
                              Hive.box('flags').putAt(
                                  4,
                                  Flags(
                                      name: 'searchInProgress',
                                      value: true,
                                      data: null));
                            }
                          },
                          child: Icon(
                            Icons.fingerprint,
                            size: MediaQuery.of(context).size.height * .07,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            isSearch
                ? searchResultsList.isEmpty
                    ? Container(
                        child: Text(
                          'Nothing found',
                          style: TextStyle(
                            fontSize: 22,
                            color: KMainPurple.withOpacity(.3),
                            fontFamily: KTextFontFamily,
                          ),
                        ),
                      )
                    : (Container(
                        child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ValueListenableBuilder(
                              valueListenable: Hive.box('tasks').listenable(),
                              builder: (context, box, widget) {
                                return SimpleListBuilder(
                                  taskList: searchResultsList,
                                  isBgGradientInverted: true,
                                  tasksBox: Hive.box('tasks'),
                                );
                              },
                            ),
                          ),
                        ),
                      )))
                : Container(),
          ],
        ),
      ),
    );
  }
}
