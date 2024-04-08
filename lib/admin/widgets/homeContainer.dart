import 'package:flutter/material.dart';

class AdminHomeContainer extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  const AdminHomeContainer({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green,
                spreadRadius: 1.0,
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
              )
            ],
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(18),
          ),
          height: screenSize.height*0.14,
          width: 30,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 50,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
