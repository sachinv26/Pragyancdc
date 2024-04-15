import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_consultation.dart';

import 'package:pragyan_cdc/clients/widgets/therapist_card.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/model/therapist_model.dart';
import 'package:pragyan_cdc/model/therapy_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_therapy.dart';

class BranchTherapies extends StatefulWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;
  final String parentid;

  const BranchTherapies({
    required this.therapy,
    required this.branchId,
    required this.branchName,
    required this.parentid,
    Key? key,
  }) : super(key: key);

  @override
  State<BranchTherapies> createState() => _BranchTherapiesState();
}

class _BranchTherapiesState extends State<BranchTherapies> {
  String? _selectedChildId;

  Future<void> showChildSelectionDialog(
      String branchId,
      String parentId,
      String childId,
      String therapistId,
      String therapyId,
      String therapyCost,
      String buttonPressed,
      ) async {
    try {
      final userId = await FlutterSecureStorage().read(key: 'userId');
      final token = await FlutterSecureStorage().read(key: 'authToken');
      final List<ChildModel> childList =
      await ChildApi().getChildList(userId.toString(), token.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 200)),
            builder: (context, snapshot) {
              return StatefulBuilder(
                builder: (context, setState) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return AlertDialog(
                      title: const Text(
                        'Choose your child',
                        style: kTextStyle1,
                      ),
                      content: Container(
                        height: 100,
                        child: Column(
                          children: childList.map((child) {
                            return Row(
                              children: [
                                Radio(
                                  value: child.childId,
                                  groupValue: _selectedChildId,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedChildId = value as String?;
                                    });
                                  },
                                ),
                                Text(
                                  child.childName,
                                  style: kTextStyle1,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        CustomButton(
                          text: 'Done',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  if (buttonPressed == 'consultation') {
                                    return ConsultationAppointment(
                                      branchId: branchId,
                                      parentId: parentId,
                                      childId: _selectedChildId ?? '',
                                      therapyCost: therapyCost,
                                      therapistId: therapistId,
                                      therapyId: therapyId,
                                    );
                                  } else {
                                    // Navigate to some other page for booking a consultation
                                    return  ScheduleTherapy(
                                      branchId: branchId,
                                      parentId: parentId,
                                      childId: _selectedChildId ?? '',
                                      therapyCost: therapyCost,
                                      therapistId: therapistId,
                                      therapyId: therapyId,
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          width: 50,
                        ),
                      ],
                    );
                  }
                },
              );
            },
          );
        },
      );
    } catch (error) {
      print('Error fetching child list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: widget.therapy.therapyName,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  widget.branchName,
                  style: kTextStyle1,
                )
              ],
            ),
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
                          parentId: widget.parentid,
                          childId: _selectedChildId ?? '',
                          therapistId: therapist.id,
                          therapyId: widget.therapy.therapyId,
                          onScheduleTherapyPressed: () {
                            showChildSelectionDialog(
                              widget.branchId,
                              widget.parentid,
                              _selectedChildId ?? '',
                              therapist.id,
                              widget.therapy.therapyId,
                              widget.therapy.cost,
                              'schedule',
                            );
                          },
                          onBookConsultationPressed: () {
                            showChildSelectionDialog(
                              widget.branchId,
                              widget.parentid,
                              _selectedChildId ?? '',
                              therapist.id,
                              widget.therapy.therapyId,
                              widget.therapy.cost,
                              'consultation',
                            );
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
