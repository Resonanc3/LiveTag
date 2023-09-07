import 'package:capstone/components/show_info.dart';
import 'package:capstone/models/user_data.dart';
import 'package:flutter/material.dart';

import '../../models/tags.dart';

class UserCard extends StatefulWidget {
  final UserData user;
  final List<Tags> tags;
  final Function(Tags tag) onTagClick;
  final VoidCallback togleUser;
  const UserCard(
      {Key? key,
      required this.user,
      required this.tags,
      required this.onTagClick,
      required this.togleUser})
      : super(key: key);

  @override
  UserCardState createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  bool expanded = false;

  bool checkOnline(DateTime timestamp) {
    return timestamp
        .isAfter(DateTime.now().subtract(const Duration(seconds: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: expanded ? 450 : 185,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'My Profile',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                widget.togleUser();
              },
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.blue)),
                      child: Image.asset(
                        'assets/icons/farmer.png',
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.user.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      child: Icon(
                        expanded
                            ? Icons.expand_more_rounded
                            : Icons.expand_less_rounded,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.user.address,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(children: [
                const Expanded(
                    child: Text(
                  'Available Tags:',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                )),
                if (!expanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: widget.tags.isEmpty
                        ? const Text('No tags')
                        : ListView.builder(
                            itemCount: widget.tags.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5, color: Colors.orange),
                                    shape: BoxShape.circle),
                                child: Image.asset('assets/icons/cow.png'),
                              );
                            })),
                  )
              ]),
            ),
            if (expanded)
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.tags.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if (!checkOnline(widget.tags[index].timestamps)) {
                        await ShowInfo.showUpDialog(context,
                            title: 'Note',
                            message:
                                'This tag is currently offline, we are just directing you to the last known location of this tag.',
                            action1: 'Okay', btn1: () {
                          Navigator.of(context).pop();
                        });
                      }

                      widget.onTagClick(widget.tags[index]);
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: Row(children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.5, color: Colors.orange),
                                shape: BoxShape.circle),
                            child: Image.asset('assets/icons/cow.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.tags[index].tagName,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.circle_rounded,
                              color: checkOnline(widget.tags[index].timestamps)
                                  ? Colors.green
                                  : Colors.grey,
                              size: 10,
                            ),
                          ),
                          Text(
                            checkOnline(widget.tags[index].timestamps)
                                ? 'Online'
                                : 'Offline',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ])),
                  );
                }),
              )
          ]),
        ),
      ),
    );
  }
}
