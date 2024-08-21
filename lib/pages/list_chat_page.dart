import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taufiqsejati_motobike_cs/sources/chat_source.dart';
import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> streamChats;

  @override
  void initState() {
    streamChats = FirebaseFirestore.instance.collection('CS').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20 + MediaQuery.of(context).padding.top),
            const Text(
              'Messages',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xff070623),
              ),
            ),
            const Gap(20),
            Expanded(
              child: buildList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildBottomNav() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 78,
        width: 200,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff070623),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            buildItemNav(
              label: 'Chats',
              icon: 'assets/ic_chats_on.png',
              iconOn: 'assets/ic_chats_on.png',
              hasDot: true,
              isActive: true,
              onTap: () {},
            ),
            buildItemNav(
              label: 'Logout',
              icon: 'assets/ic_logout.png',
              iconOn: 'assets/ic_logout.png',
              isActive: false,
              onTap: () {
                DSession.removeUser().then((removed) {
                  if (!removed) return;

                  Navigator.pushReplacementNamed(context, '/signin');
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemNav({
    required String label,
    required String icon,
    required String iconOn,
    bool isActive = false,
    required VoidCallback onTap,
    bool hasDot = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          height: 46,
          child: Column(
            children: [
              Image.asset(
                isActive ? iconOn : icon,
                height: 24,
                width: 24,
              ),
              const Gap(4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(isActive ? 0xffFFBC1C : 0xffFFFFFF),
                    ),
                  ),
                  if (hasDot)
                    Container(
                      margin: const EdgeInsets.only(left: 2),
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xffFF2056),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    return StreamBuilder(
      stream: streamChats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Chats'));
        }
        final list = snapshot.data!.docs;
        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          itemBuilder: (context, index) {
            Map room = list[index].data();
            String uid = room['roomId'];
            String userName = room['name'];
            bool newFromUser = room['newFromUser'];
            return GestureDetector(
              onTap: () {
                ChatSource.openChatRoom(uid, userName).then((value) {
                  Navigator.pushNamed(
                    context,
                    '/chatting',
                    arguments: {
                      'uid': uid,
                      'userName': userName,
                    },
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/profile.png',
                      height: 50,
                      width: 50,
                    ),
                    const Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff070623),
                            ),
                          ),
                          const Gap(2),
                          Text(
                            room['lastMessage'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: newFromUser
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 14,
                              color: newFromUser
                                  ? const Color(0xff070623)
                                  : const Color(0xff838384),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
