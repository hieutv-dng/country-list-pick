import 'package:flutter/material.dart';

import 'country_selection_theme.dart';
import 'models/countries.dart';
import 'models/country.dart';
import 'models/country_utils.dart';

class CountrySelectionList extends StatefulWidget {
  CountrySelectionList({
    Key? key,
    this.initialSelection,
    this.theme,
    this.countryBuilder,
    this.isCurrency = false,
    this.isShowAlphabet = true,
  }) : super(key: key);

  final String? initialSelection;
  final CountryTheme? theme;
  final Widget Function(BuildContext context, Country)? countryBuilder;
  final bool isCurrency;
  final bool isShowAlphabet;

  @override
  _CountrySelectionListState createState() => _CountrySelectionListState();
}

class _CountrySelectionListState extends State<CountrySelectionList> {
  final _controller = TextEditingController();
  late final ScrollController _controllerScroll;

  final _listOriginal = <Country>[];
  final _listDataShow = <Country>[];

  var diff = 0.0;
  var posSelected = 0;
  late var _sizeheightcontainer;
  late var _heightscroller;
  var _text;
  var _oldtext;
  var _itemsizeheight = 50.0;
  double _offsetContainer = 0.0;

  Country? get _lastCountryPick {
    if (widget.initialSelection?.isEmpty ?? true) return null;
    try {
      return CountryUtils.getCountryByIsoCode(widget.initialSelection!);
    } catch (e) {
      return null;
    }
  }

  String get _title => widget.isCurrency ? 'Currencies' : 'Countries';
  String get _searchHintText => widget.isCurrency ? 'Search currency' : 'Search country';

  @override
  void initState() {
    countryList.sort((a, b) {
      return a.name.compareTo(b.name);
    });
    _listOriginal.addAll(countryList);
    _listDataShow.addAll(countryList);

    _controllerScroll = ScrollController();
    _controllerScroll.addListener(_scrollListener);
    super.initState();
  }

  void _sendDataBack(BuildContext context, Country selection) {
    Navigator.pop(context, selection);
  }

  List _alphabet = List.generate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i));

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: LayoutBuilder(builder: (context, contrainsts) {
            diff = mediaQuery.size.height - contrainsts.biggest.height;
            _heightscroller = (contrainsts.biggest.height) / _alphabet.length;
            _sizeheightcontainer = (contrainsts.biggest.height);
            return Stack(
              children: [
                CustomScrollView(
                  controller: _controllerScroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildFilterField(context),
                          _buildLastPick(context, _lastCountryPick),
                        ],
                      ),
                    ),
                    SliverPadding(padding: EdgeInsets.all(10)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return widget.countryBuilder != null
                            ? widget.countryBuilder!(context, _listDataShow.elementAt(index))
                            : _getListCountry(_listDataShow.elementAt(index));
                      }, childCount: _listDataShow.length),
                    )
                  ],
                ),
                if (widget.isShowAlphabet)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragStart: _onVerticalDragStart,
                      child: Container(
                        height: 22.0 * _alphabet.length,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(_alphabet.length, (index) {
                                return Expanded(child: _getAlphabetItem(index));
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFilterField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).cardTheme.color,
          child: TextField(
            controller: _controller,
            style: Theme.of(context).textTheme.titleMedium,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: widget.theme?.searchHintText ?? _searchHintText,
            ),
            onChanged: _filterElements,
          ),
        ),
      ],
    );
  }

  Widget _buildLastPick(BuildContext context, Country? lastPick) {
    if (lastPick == null) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            widget.theme?.lastPickText ?? 'LAST PICK',
            style: TextStyle(color: widget.theme?.labelColor),
          ),
        ),
        Container(
          color: Theme.of(context).cardTheme.color,
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    lastPick.flagUri,
                    package: 'country_list_pick',
                    width: 32.0,
                  ),
                ],
              ),
              title: Text(lastPick.name),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(Icons.check, color: Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getListCountry(Country e) {
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: EdgeInsets.only(right: 22),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                e.flagUri,
                package: 'country_list_pick',
                width: 30.0,
              ),
            ],
          ),
          title: Text(e.name),
          trailing: widget.isCurrency ? Text(e.currencyCode) : null,
          onTap: () {
            _sendDataBack(context, e);
          },
        ),
      ),
    );
  }

  Widget _getAlphabetItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          posSelected = index;
          _text = _alphabet[posSelected];
          if (_text != _oldtext) {
            for (var i = 0; i < _listDataShow.length; i++) {
              if (_text.toString().compareTo(_listDataShow[i].name.toString().toUpperCase()[0]) == 0) {
                _controllerScroll.jumpTo((i * _itemsizeheight) + 10);
                break;
              }
            }
            _oldtext = _text;
          }
        });
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                index == posSelected ? widget.theme?.alphabetSelectedBackgroundColor ?? Theme.of(context).colorScheme.primary : Colors.transparent,
            child: Text(
              _alphabet[index],
              textAlign: TextAlign.center,
              style: (index == posSelected)
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: widget.theme?.alphabetSelectedTextColor ?? Theme.of(context).colorScheme.background)
                  : Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: widget.theme?.alphabetTextColor),
            ),
          ),
        ],
      ),
    );
  }

  void _filterElements(String s) {
    setState(() {
      _listDataShow.clear();
      _listDataShow.addAll(_listOriginal.where((e) => e.filterWith(s, isCurrency: widget.isCurrency)));
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 && (_offsetContainer + details.delta.dy) <= (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected = ((_offsetContainer / _heightscroller) % _alphabet.length).round();
        _text = _alphabet[posSelected];
        if (_text != _oldtext) {
          for (var i = 0; i < _listDataShow.length; i++) {
            if (_text.toString().compareTo(_listDataShow[i].name.toString().toUpperCase()[0]) == 0) {
              _controllerScroll.jumpTo((i * _itemsizeheight) + 15);
              break;
            }
          }
          _oldtext = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _offsetContainer = details.globalPosition.dy - diff;
  }

  _scrollListener() {
    int scrollPosition = (_controllerScroll.position.pixels / _itemsizeheight).round();
    if (scrollPosition < _listDataShow.length && scrollPosition >= 0) {
      String? countryName = _listDataShow.elementAt(scrollPosition).name;
      setState(() {
        posSelected = countryName[0].toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
      });
    }

    if ((_controllerScroll.offset) >= (_controllerScroll.position.maxScrollExtent)) {}
    if (_controllerScroll.offset <= _controllerScroll.position.minScrollExtent && !_controllerScroll.position.outOfRange) {}
  }
}
