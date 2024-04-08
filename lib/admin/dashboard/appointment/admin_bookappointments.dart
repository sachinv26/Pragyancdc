import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/dashboard/appointment/branch_therapy.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AdminBookingAppointments extends StatefulWidget {
  const AdminBookingAppointments({super.key});

  @override
  State<AdminBookingAppointments> createState() =>
      _AdminBookingAppointmentsState();
}

class _AdminBookingAppointmentsState extends State<AdminBookingAppointments> {
  String _selectedBranch = 'Basavangudi Branch';
  String _selectedTherapist = 'Dr. Amrita Rao';
  bool _loadingAppointments = false;
  bool _showDropdowns = true;
  double _dropdownHeight = 180; // Initial height when dropdowns are shown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: const Text(
          'Book Appointments',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/children.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 10,
                  child: Image.asset(
                    'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: DropdownButton<String>(
                hint: Text('Choose a branch'),
                isExpanded: true,
                elevation: 5,
                value: _selectedBranch,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBranch = newValue!;
                  });
                },
                items: [
                  'Basavangudi Branch',
                  'Rajajinagar Branch',
                  'Nagarbhavi Branch',
                  'Marathahalli Branch'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      // You can apply your desired style here
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Container for therapy names and images
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTherapyContainer(
                  therapyName: 'Speech Therapy',
                  imagePath: 'assets/images/service-1.png',
                ),
                _buildTherapyContainer(
                  therapyName: 'Occupational Therapy',
                  imagePath: 'assets/images/service-2.png',
                ),
                _buildTherapyContainer(
                  therapyName: 'Physical Therapy',
                  imagePath: 'assets/images/service-3.png',
                ),
              ],
            ),
            kheight30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTherapyContainer(
                  therapyName: 'Behavioral Therapy',
                  imagePath: 'assets/images/service-4.png',
                ),
                _buildTherapyContainer(
                  therapyName: 'Play Therapy',
                  imagePath: 'assets/images/service-5.png',
                ),
                _buildTherapyContainer(
                  therapyName: 'Music Therapy',
                  imagePath: 'assets/images/service-6.png',
                ),
              ],
            ),
            kheight30,
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/children-learning-globe-with-woman-bedroom 1.png',fit: BoxFit.contain,),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 5,
                  child: Image.asset(
                    'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/fb.png'),
                            kwidth10,
                            const Text(
                              'Pragyan CDC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Image.asset('assets/images/insta.png'),
                            kwidth10,
                            const Text(
                              'Pragyan CDC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapyContainer({required String therapyName, required String imagePath}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>BranchTherapy()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        margin: const EdgeInsets.only(top: 6),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              child: Text(
                therapyName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

