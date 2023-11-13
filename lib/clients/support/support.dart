import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/support/chat_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
          ),
        ),
        title: const Text(
          'Support',
          style: kTextStyle1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (Column(
          children: [
            const CustomTextFormField(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search here',
            ),
            kheight10,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatScreen()));
                },
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(
                            'A',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        title: Text('Arun'),
                        subtitle: Text('Today sessions was good  '),
                        trailing: Text('Today > '),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                            child: Image.asset(
                                'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png')),
                        title: const Text('Support'),
                        subtitle: const Text('Thank you for your response '),
                        trailing: const Text('Today > '),
                      );
                    },
                    itemCount: 4),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
