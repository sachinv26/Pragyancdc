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
  String? _selectedChildName;


  Future<void> showChildSelectionDialog(
      String branchId,
      String parentId,
      String childId,
      String therapistId,
      String therapyId,
      String therapyCost,
      String buttonPressed,
      String therapistName,
      String childname,
      ) async {
    try {
      final userId = await FlutterSecureStorage().read(key: 'userId');
      final token = await FlutterSecureStorage().read(key: 'authToken');
      final List<ChildModel> childList =
      await ChildApi().getChildList(userId.toString(), token.toString());

      if (childList.length == 1) {
        _selectedChildId = childList.first.childId;
        _selectedChildName = childList.first.childName;
        navigateToNextPage(
          branchId,
          parentId,
          therapistId,
          therapyId,
          therapyCost,
          buttonPressed,
          therapistName,
          childname,
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  'Choose your child',
                  style: kTextStyle1,
                ),
                content: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
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
                                  _selectedChildName = child.childName;
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
                      Navigator.pop(context);
                      navigateToNextPage(
                        branchId,
                        parentId,
                        therapistId,
                        therapyId,
                        therapyCost,
                        buttonPressed,
                        therapistName,
                        childname,
                      );
                    },
                    width: 50,
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (error) {
      print('Error fetching child list: $error');
    }
  }

  void navigateToNextPage(
      String branchId,
      String parentId,
      String therapistId,
      String therapyId,
      String therapyCost,
      String buttonPressed,
      String therapistName,
      String childname,
      ) {
    Navigator.pushReplacement(
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
              branchName: widget.branchName,
              childname: _selectedChildName ?? '',
              therapyName: widget.therapy.therapyName,
              therapistName: therapistName,
            );
          } else {
            // Navigate to some other page for booking a consultation
            return ScheduleTherapy(
              branchId: branchId,
              parentId: parentId,
              childId: _selectedChildId ?? '',
              therapistId: therapistId,
              therapyId: therapyId,
              branchName: widget.branchName,
              childname: _selectedChildName ?? '',
              therapyName: widget.therapy.therapyName,
              therapistName: therapistName,
            );
          }
        },
      ),
    );
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
                  width: 400,
                  height: 180,
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
                              therapist.name,
                                _selectedChildName??''
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
                              therapist.name,
                              _selectedChildName??''
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
