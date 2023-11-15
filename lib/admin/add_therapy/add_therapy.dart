import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddTherapy extends StatefulWidget {
  const AddTherapy({super.key});

  @override
  State<AddTherapy> createState() => _AddTherapyState();
}

class _AddTherapyState extends State<AddTherapy>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Add therapy'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              LocationSearch(),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    kheight10,
                    //const SizedBox(height: 50),
                    TabBar(
                        labelColor: Colors.black,
                        controller: _tabController,
                        tabs: const <Widget>[
                          Tab(
                            text: 'Therapy List',
                          ),
                          Tab(
                            text: 'Add therapy',
                          ),
                        ]),

                    Expanded(
                        child:
                            TabBarView(controller: _tabController, children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Image.asset(
                                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png')),
                              title: const Text('Dr. Amrita Rao'),
                              subtitle: const Text('Speech & Language Therapy'),
                              trailing: const Icon(Icons.cancel),
                            ),
                          );
                        },
                        itemCount: 5,
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Image.asset(
                                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png')),
                              title: const Text('Dr. Amrita Rao'),
                              subtitle: const Text('Speech & Language Therapy'),
                              trailing: const Icon(Icons.cancel),
                            ),
                          );
                        },
                        itemCount: 5,
                      ),
                    ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
