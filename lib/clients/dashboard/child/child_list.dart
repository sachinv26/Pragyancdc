import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';

class ChildList extends StatelessWidget {
  const ChildList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'My Children'),
      body: FutureBuilder<List<ChildModel>?>(
          future: getChildListfromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No Children Found'));
            } else {
              final List<ChildModel> childList = snapshot.data!;

              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    kheight30,
                    Expanded(
                      child: ListView.separated(
                        itemCount: childList.length,
                        itemBuilder: (context, index) {
                          final ChildModel childData = childList[index];
                          return ListTile(
                            selectedTileColor: Colors.green,
                            leading: childData.childImage == ""
                                ? const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                        'assets/images/empty-user.jpeg'),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(childData.childImage),
                                  ),

                            // leading: CircleAvatar(
                            //   radius: 20,

                            //   backgroundImage:
                            //       AssetImage('assets/images/cute_little_girl.png'),
                            // ),
                            title: Text(
                              childData.childName,
                              style: kTextStyle1,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<List<ChildModel>?> getChildListfromApi() async {
    // Use FlutterSecureStorage to get userId and token
    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');
    debugPrint('got userId and token');
    debugPrint(userId);
    debugPrint(token);

    if (userId != null && token != null) {
      // Use UserApi to fetch the user profile
      return ApiServices().getChildList(userId, token);
    } else {
      return null;
    }
  }
}
