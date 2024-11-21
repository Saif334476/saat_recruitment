import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     "My Applications",
      //     style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      //   ),
      //   backgroundColor: const Color(0xff1C4374),
      // ),
      body: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              elevatedButtons(
                  onPressed: () {},
                  widget: const Text(
                    'Successful',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.white),
                  )),
              elevatedButtons(
                  onPressed: () {},
                  widget: const Text("UnSuccessful",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white))),
              elevatedButtons(
                  onPressed: () {},
                  widget: const Text("All",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xff1C4374),
                              blurRadius: 6,
                              blurStyle: BlurStyle.outer),
                        ],
                        border: Border.all(color: const Color(0xff1C4374)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const ListTile(
                        leading: Icon(Icons.computer_outlined),
                        title: Text(
                          "Flutter Developer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          //      mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'SAAT Softs',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '40,000-50000 PKR',
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(children: [
                              Icon(Icons.location_on_outlined),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Jhang,Satellite Town',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ]),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Successful",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ))
                          ],
                        ),
                      )));
            },
          ),
        )
      ]),
    );
  }
}
