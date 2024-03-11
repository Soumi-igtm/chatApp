import 'package:chat_app/service/firebasemethods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  //0 = anushka / 1 = fortmindz
  // int person = 0;
  TextEditingController chatTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // go back
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[300],
              ),
              child: Image.network(
                "https://static.vecteezy.com/system/resources/previews/010/833/500/original/3d-render-people-s-profile-icon-for-illustration-png.png",
                height: 20,
                width: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fortmindz',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16),
                ),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/icons/video.png",
                height: 25,
                width: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/icons/telephone.png",
                height: 25,
                width: 25,
              )),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chat")
                  .orderBy("chat_sent", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center(
                      child: Text("Send a message to start chatting"));
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index == snapshot.data!.docs.length - 1
                              ? 100
                              : 0),
                      child: Row(
                        mainAxisAlignment:
                            snapshot.data!.docs[index]['isanushka'] == true
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.5),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: snapshot.data!.docs[index]
                                            ['isanushka'] ==
                                        true
                                    ? const Color(0xff006bfc)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15),
                                    topRight: const Radius.circular(15),
                                    bottomRight: snapshot.data!.docs[index]
                                                ['isanushka'] ==
                                            true
                                        ? const Radius.circular(0)
                                        : const Radius.circular(15),
                                    bottomLeft: snapshot.data!.docs[index]
                                                ['isanushka'] ==
                                            false
                                        ? const Radius.circular(0)
                                        : const Radius.circular(15))),
                            child: Text(
                              snapshot.data!.docs[index]['chatmessage'],
                              style: TextStyle(
                                  color: snapshot.data!.docs[index]
                                              ['isanushka'] ==
                                          true
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(70)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/icons/paper-clip.png",
                      height: 20,
                      width: 20,
                    )),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                  controller: chatTextEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type message...",
                      hintStyle: TextStyle(color: Colors.grey[400])),
                )),
                InkWell(
                  onTap: () {
                    FirebaseMethods()
                        .sendMessage("Anushka", chatTextEditingController.text);
                    chatTextEditingController.clear();
                    HapticFeedback.heavyImpact();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xff006bfc)),
                    child: Center(
                        child: Image.asset(
                      "assets/icons/send.png",
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
