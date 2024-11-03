import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

class StandardSearchBarWidget extends StatelessWidget {
  const StandardSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: const StandardSearchAnchor(
              searchBar: StandardSearchBar(
                bgColor: Color(0xFFF8F9FD),
              ),
              suggestions: StandardSuggestions(
                suggestions: [
                  StandardSuggestion(text: 'Ali Public School'),
                  StandardSuggestion(text: 'Ahmad Public School'),
                  StandardSuggestion(text: 'Ehsan Public School'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
