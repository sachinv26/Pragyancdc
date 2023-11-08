import 'package:flutter/material.dart';
import 'package:pragyan_cdc/view/dashboard/home/speech_therapy.dart';

class LocationSearch extends StatelessWidget {
  final List<String> suggestions = [
    'Rajajinagar Branch',
    'Nagarbhavi Branch',
    'HSR Branch',
    'Marathahalli Branch',
    'Nagasandra Branch'
  ];

  LocationSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return suggestions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SpeechTherapy()));
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Card(
          elevation: 4,
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search here locations',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              option,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 175, 174, 174),
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
