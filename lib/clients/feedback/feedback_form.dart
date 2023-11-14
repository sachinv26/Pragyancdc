import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/Pragyan_Logo.png'),
              const Text(
                'Your Therapist Sessions Is Completed ',
                style: kTextStyle1,
              ),
              const Text(
                'Dr. Amrita Rao',
                style: kTextStyle1,
              ),
              const Text('Speech & Language Therapy'),
              const Text(
                'Google Link',
                style: kTextStyle1,
              ),
              const Text('Rate a Therapy'),
              const Text('⭐⭐⭐⭐'),
              const Text('Leave a feedback'),
              GridSelector(
                items: const [
                  "Effectiveness",
                  "Session Environment",
                  "Communication",
                  "Other"
                ],
                onSelected: (index) {
                  print(index);
                },
              ),
              const CustomTextFormField(
                hintText: 'Type your comment here',
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(170, 40)),
                  onPressed: () {},
                  child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}

class GridSelector extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const GridSelector({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<GridSelector> createState() => _GridSelectorState();
}

class _GridSelectorState extends State<GridSelector> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              widget.onSelected(index);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedIndex == index ? Colors.green : Colors.grey,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                widget.items[index],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
