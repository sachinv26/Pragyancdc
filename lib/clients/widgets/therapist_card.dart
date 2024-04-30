import 'package:flutter/material.dart';
import 'package:pragyan_cdc/model/therapist_model.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

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

  const TherapistCard({
    required this.therapist,
    required this.onScheduleTherapyPressed,
    this.onBookConsultationPressed, required this.branchId, required this.parentId, required this.childId, required this.therapistId, required this.therapyId, required this.therapyAmount,
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
                  onPressed: onScheduleTherapyPressed,
                ),
                CustomButton(
                  text: 'Book Consultation',
                  onPressed: onBookConsultationPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
