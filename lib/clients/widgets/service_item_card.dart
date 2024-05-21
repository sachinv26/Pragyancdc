import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/add_therapist.dart';

import '../../model/therapy_model.dart';

class ServiceItemCard extends StatelessWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;
  final String parentId;
  final String therapyId;
  final String childId;
  final String childname;
  final String therapistName;
  final String therapistId;

  final Function(Therapy) onTherapySelected;

  const ServiceItemCard({
    Key? key,
    required this.branchId,
    required this.branchName,
    required this.therapy,
    required this.parentId,
    required this.onTherapySelected,
    required this.therapyId,
    required this.childId,
    required this.childname,
    required this.therapistName,
    required this.therapistId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddTherapist(
            branchId: branchId,
            therapyName: therapy.therapyName,
            branchName: branchName,
            parentId: parentId,
            childId:childId,
            therapistId: therapistId,
            therapyId: therapyId,
            childname: childname,
            therapistName: childname,
          ),
        ));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  therapy.therapyIcon,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                therapy.therapyName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
