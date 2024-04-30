import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_therapy.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/model/therapist_model.dart';
import 'package:pragyan_cdc/model/therapy_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddTherapist extends StatefulWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;
  final String parentId;

  const AddTherapist({
    required this.therapy,
    required this.branchId,
    required this.branchName,
    required this.parentId,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTherapist> createState() => _AddTherapistState();
}

class _AddTherapistState extends State<AddTherapist> {

  Therapist? _selectedTherapist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.therapy.therapyName),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/womentherapy.png",
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Therapists',
                    style: kTextStyle1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: TherapistApi()
                  .fetchTherapists(widget.branchId, widget.therapy.therapyId),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Loading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData &&
                    snapshot.data!['status'] == 1 &&
                    snapshot.data!['therapiest'] != null &&
                    (snapshot.data!['therapiest'] as List).isNotEmpty) {
                  List therapistData = snapshot.data!['therapiest'];
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: therapistData.length,
                      itemBuilder: (BuildContext context, int index) {
                        Therapist therapist =
                        Therapist.fromJson(therapistData[index]);
                        return TherapistCard(
                          therapist: therapist,
                          therapyAmount: widget.therapy.cost,
                          branchId: widget.branchId,
                          parentId: widget.parentId,
                          therapyId: widget.therapy.therapyId,
                          childId: '',
                          therapistId: '',
                          onScheduleTherapyPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ScheduleTherapy(
                            //       branchId: widget.branchId,
                            //       parentId: widget.parentId,
                            //       childId: '',
                            //       therapyCost: widget.therapy.cost,
                            //       therapistId: therapist.id,
                            //       therapyId: widget.therapy.therapyId,
                            //
                            //     ),
                            //   ),
                            // );
                          }, onTherapistSelected: (selectedTherapist) {
                          setState(() {
                            _selectedTherapist = selectedTherapist;
                          });
                        },
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No therapists available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



class TherapistCard extends StatelessWidget {
  final Therapist therapist;
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyAmount;
  final VoidCallback onScheduleTherapyPressed;
  final VoidCallback? onBookConsultationPressed;
  final Function(Therapist) onTherapistSelected;

  const TherapistCard({
    required this.therapist,
    required this.onScheduleTherapyPressed,
    this.onBookConsultationPressed, required this.branchId, required this.parentId, required this.childId, required this.therapistId, required this.therapyId, required this.therapyAmount, required this.onTherapistSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white70,
          border: Border(
            top: BorderSide(
              color: Colors.green.shade700,
              width: 4.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://app.cdcconnect.in/${therapist.image}",
                      fit: BoxFit.cover,
                      height: 80,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        therapist.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Specialization: ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              therapist.description,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: 'Schedule Therapy',
                  width: 380,
                  onPressed: onScheduleTherapyPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
