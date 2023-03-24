import 'package:flutter/material.dart';

import 'country_selection_list.dart';
import 'country_selection_theme.dart';
import 'models/country.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick({
    this.onChanged,
    this.initialSelection,
    this.appBar,
    this.pickerBuilder,
    this.countryBuilder,
    this.theme,
    this.isCurrency = false,
  });

  final String? initialSelection;
  final ValueChanged<Country?>? onChanged;
  final PreferredSizeWidget? appBar;
  final Widget Function(BuildContext context, Country? country)? pickerBuilder;
  final CountryTheme? theme;
  final Widget Function(BuildContext context, Country country)? countryBuilder;
  final bool isCurrency;

  @override
  _CountryListPickState createState() => _CountryListPickState();
}

class _CountryListPickState extends State<CountryListPick> {
  _CountryListPickState();

  Country? selectedItem;

  @override
  void initState() {
    super.initState();
  }

  void _awaitFromSelectScreen(BuildContext context, CountryTheme? theme) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountrySelectionList(
            initialSelection: selectedItem,
            theme: theme,
            countryBuilder: widget.countryBuilder,
            isCurrency: widget.isCurrency,
          ),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged!(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _awaitFromSelectScreen(context, widget.theme);
      },
      child: widget.pickerBuilder != null
          ? widget.pickerBuilder!(context, selectedItem)
          : Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedItem != null && (widget.theme?.isShowFlag ?? true))
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        selectedItem!.flagUri,
                        package: 'country_list_pick',
                        width: 32.0,
                      ),
                    ),
                  ),
                if (widget.theme?.isShowCode ?? true)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(selectedItem.toString()),
                    ),
                  ),
                if (selectedItem != null && (widget.theme?.isShowTitle ?? true))
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(selectedItem!.toCountryStringOnly()),
                    ),
                  ),
                if (widget.theme?.isDownIcon ?? true)
                  Flexible(
                    child: Icon(Icons.keyboard_arrow_down),
                  )
              ],
            ),
    );
  }
}
