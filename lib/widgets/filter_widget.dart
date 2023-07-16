import 'package:flutter/material.dart';
import 'package:flutter_blog_query/models/filter_options.dart';
import 'package:flutter_blog_query/providers/filter_provider.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  bool _hidden = false;
  TextEditingController? _controller;

  // we need these backing fields to generate a new FilterOptions object
  // so that the filter provider triggers a rebuild
  String _searchText = "";
  Map<String, bool> _categoryOptions = <String, bool>{};

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _searchText);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hidden ? _buildHiddenState() : _buildVisibleState();
  }

  Widget _buildHiddenState() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text("Filter options",
            style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(
              _hidden
                  ? Icons.keyboard_double_arrow_down
                  : Icons.keyboard_double_arrow_up,
              color: AppColors.primary),
          onPressed: () {
            setState(() {
              _hidden = !_hidden;
            });
          },
        )
      ])
    ]);
  }

  Widget _buildVisibleState() {
    _categoryOptions = ref.watch(filterProvider).categoryFilterStates;
    _searchText = ref.watch(filterProvider).searchText;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text("Filter options",
            style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(
              _hidden
                  ? Icons.keyboard_double_arrow_down
                  : Icons.keyboard_double_arrow_up,
              color: AppColors.primary),
          onPressed: () {
            setState(() {
              _hidden = !_hidden;
            });
          },
        )
      ]),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: ref
            .watch(filterProvider)
            .categoryFilterStates
            .entries
            .map((entry) => SizedBox(
                  width: 200,
                  child: SwitchListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      key: ValueKey(entry.key),
                      title: Text(entry.key,
                          style: const TextStyle(color: Colors.white)),
                      onChanged: (val) {
                        // update the switch in this widget
                        setState(() {
                          _categoryOptions[entry.key] =
                              !_categoryOptions[entry.key]!;
                        });

                        // update the filter globally
                        ref.read(filterProvider.notifier).state =
                            FilterOptions.fromSettings(
                                _categoryOptions, _searchText);
                      },
                      value: entry.value),
                ))
            .toList(),
      ),
      TextField(
        controller: _controller,
        style: TextStyle(color: AppColors.primary),
        onChanged: (val) async {
          setState(() {
            _searchText = val;
          });
          ref.read(filterProvider.notifier).state =
              FilterOptions.fromSettings(_categoryOptions, _searchText);
        },
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            labelText: "Enter text to search for matching articles",
            labelStyle:
                TextStyle(color: Colors.white38, fontWeight: FontWeight.w100)),
      )
    ]);
  }
}
