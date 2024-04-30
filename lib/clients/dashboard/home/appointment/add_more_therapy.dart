import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/widgets/service_item_card.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/api/therapy_api.dart'; // Import the API to fetch therapies
import 'package:pragyan_cdc/model/therapy_model.dart'; // Import the BranchTherapies screen

class AddTherapy extends StatefulWidget {
  final String branchId;
  final String parentId;
  final String childId;



  const AddTherapy({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
  }) : super(key: key);

  @override
  _AddTherapyState createState() => _AddTherapyState();
}

class _AddTherapyState extends State<AddTherapy> {
  late Future<List<Therapy>> _therapiesFuture;

  @override
  void initState() {
    super.initState();
    _therapiesFuture = _fetchTherapies();
  }

  Future<List<Therapy>> _fetchTherapies() async {
    return await TherapistApi().fetchTherapies(widget.branchId);
  }

  // Function to handle selected therapy
  void _handleTherapySelected(Therapy selectedTherapy) {
    // Pass the selected therapy back to the BookAppointment page
    Navigator.pop(context,selectedTherapy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Add More Therapy'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: _therapiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Therapy> therapies = snapshot.data as List<Therapy>;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: therapies.length,
                itemBuilder: (context, index) {
                  return ServiceItemCard(
                    branchId: widget.branchId,
                    branchName: '',
                    therapy: therapies[index],
                    userId: widget.parentId,
                    // Pass the callback function to the ServiceItemCard
                    onTherapySelected: _handleTherapySelected,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
