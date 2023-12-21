import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
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

              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    kheight30,
                    Expanded(
                      child: ListView.separated(
                        itemCount: childList.length,
                        itemBuilder: (context, index) {
                          final ChildModel childData = childList[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 192, 228, 193),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                childData.childImage == ""
                                    ? const CircleAvatar(
                                        radius: 28,
                                        backgroundImage: AssetImage(
                                            'assets/images/empty-user.jpeg'),
                                      )
                                    : CircleAvatar(
                                        radius: 28,
                                        backgroundImage:
                                            NetworkImage(childData.childImage),
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    kheight10,
                                    Text(
                                      childData.childName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                    kheight10,
                                    Text(
                                      'Gender : ${childData.childGender}',
                                      style: khintTextStyle,
                                    ),
                                    kheight10,
                                    Text(
                                      'DOB : ${childData.childDob}',
                                      style: khintTextStyle,
                                    ),
                                    kheight10,
                                    Text(
                                      'Relation: ${childData.relationship}',
                                      style: khintTextStyle,
                                    )
                                  ],
                                ),
                                kwidth30,
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete))
                                  ],
                                )
                              ],
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
