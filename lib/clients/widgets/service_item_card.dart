import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/add_therapist.dart';

import '../../model/therapy_model.dart';
class ServiceItemCard extends StatelessWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;
  final String userId;
  final Function(Therapy) onTherapySelected;

  const ServiceItemCard({
    Key? key,
    required this.branchId,
    required this.branchName,
    required this.therapy,
    required this.userId, required this.onTherapySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddTherapist(
            branchId: branchId,
            therapy: therapy,
            branchName: branchName,
            parentId: userId,
          ),
        ));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
