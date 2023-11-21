import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class GroupTherapy extends StatefulWidget {
  const GroupTherapy({super.key});

  @override
  State<GroupTherapy> createState() => _GroupTherapyState();
}

class _GroupTherapyState extends State<GroupTherapy>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedRadioValue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Group Therapy'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          LocationSearch(),
          kheight10,
          const Text('Appointment for this week'),
          kheight10,
          TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              controller: _tabController,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  //  color: Colors.green,
                  borderRadius: BorderRadius.circular(5)),
              tabs: const <Widget>[
                Tab(
                  text: 'Child Details ',
                ),
                Tab(
                  text: 'Therapists',
                ),
                Tab(
                  text: 'Group Details',
                )
              ]),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text('${index + 1}'),
                      kwidth30,
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/cute_little_girl.png'),
                      ),
                      kwidth30,
                      const Text('Arun Gawtham'),
                      const SizedBox(
                        width: 50,
                      ),
                      Radio(
                        value: false,
                        groupValue: _selectedRadioValue,
                        onChanged: (value) => setState(() {
                          _selectedRadioValue = value as int;
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text('${index + 1}'),
                      kwidth30,
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                      ),
                      kwidth30,
                      const Text('Amrita Rao'),
                      const SizedBox(
                        width: 50,
                      ),
                      Radio(
                        value: false,
                        groupValue: _selectedRadioValue,
                        onChanged: (value) => setState(() {
                          _selectedRadioValue = value as int;
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
            // const Center(
            //   child: Text('Therapist Details'),
            // ),
            const Center(
              child: Text('Group Details'),
            ),
          ]))
        ]),
      ),
    );
  }
}
