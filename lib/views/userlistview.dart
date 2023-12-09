import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/userlistcontroller.dart';
import '../screens/splashscreen.dart';
import 'adduserscreen.dart';

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userListProv = Provider.of<HomeScreenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Are you sure want to signout..?",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const SplashScreen();
                                },
                              ), (route) => false);
                            }
                          },
                          child: const Text("Logout")),
                      ElevatedButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("later"))
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        title: const Text(
          "Student Home",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AdduserView();
              },
            ),
          );
        },
        label: const Text(
          "Add user",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Filter by age"),
                const SizedBox(
                  width: 40,
                ),
                DropdownButton<String>(
                  value: userListProv.selectedAgeRange,
                  onChanged: (String? newValue) {
                    userListProv.setSelectedAgeRange(newValue!);
                  },
                  items: <String>["All Students", '10-20', '21-30', '31-40']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Select Age Range'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: userListProv.searchController,
              onChanged: (value) {
                userListProv.setSearchValue(value);
              },
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("userdetails")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();

                        if ((userListProv.selectedAgeRange == "All Students" ||
                                (data['age'] >=
                                        int.parse(userListProv.selectedAgeRange
                                            .split('-')[0]) &&
                                    data['age'] <=
                                        int.parse(userListProv.selectedAgeRange
                                            .split('-')[1]))) &&
                            (userListProv.streamValue.isEmpty ||
                                data["sortfield"].toString().startsWith(
                                    userListProv.streamValue.toLowerCase()))) {
                          return Padding(
                            padding: const EdgeInsets.all(13),
                            child: Card(
                              surfaceTintColor: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      CachedNetworkImageProvider(data['dp']),
                                ),
                                title: Text(data['name']),
                                subtitle: Text(data['age'].toString()),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Are you sure want to delete..??",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          shape:
                                              const ContinuousRectangleBorder(),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await userListProv.deleteData(
                                                      snapshot.data!.docs[index]
                                                          .id);
                                                },
                                                child: const Text("Delete")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("not now"))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      });
                } else {
                  return const Text("No data");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
