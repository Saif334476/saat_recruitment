import 'package:flutter/material.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors:[Colors.blue,Colors.white],begin: Alignment.topCenter,end: Alignment.bottomCenter),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Successful')),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("UnSuccessful")),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text("All"))
                  ],
                ),
              ),
              Expanded(
                child:Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors:[Colors.blue,Colors.white],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                  ),
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, right: 10, left: 10),
                        child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 6,
                                    blurStyle: BlurStyle.outer),
                              ],
                              border: Border.all(color: Colors.lightBlueAccent),
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
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text(
                                          'SAAT Softs',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
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
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        '40,000-50000 PKR',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )));
                  },
                ),
              )
              )])));
  }
}
