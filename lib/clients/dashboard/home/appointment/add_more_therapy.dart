import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/widgets/service_item_card.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/api/therapy_api.dart'; // Import the API to fetch therapies
import 'package:pragyan_cdc/model/therapy_model.dart'; // Import the BranchTherapies screen

class AddTherapy extends StatefulWidget {
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String branchName;
  final String childname;
  final String therapistName;
  final String therapyName;

  const AddTherapy({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.branchName,
    required this.therapistId,
    required this.therapyId,
    required this.childname,
    required this.therapistName,
    required this.therapyName,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.branchName),
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
                    branchName: widget.branchName,
                    therapy: therapies[index],
                    parentId: widget.parentId,
                    // onTherapySelected: _handleTherapySelected,
                    therapyId: therapies[index].therapyId,
                    childId: widget.childId,
                    therapistName: widget.therapistName,
                    childname: widget.childname,
                    therapistId:widget.therapistId,
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
