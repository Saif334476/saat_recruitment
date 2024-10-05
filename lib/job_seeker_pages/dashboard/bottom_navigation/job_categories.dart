import 'package:flutter/material.dart';
import 'package:saat_recruitment/job_seeker_pages/dashboard/bottom_navigation/home.dart';

class JobCategories extends StatefulWidget {
  final List<JobCategory> jobCategories;
  final Function(String) onCategorySelected;
  const JobCategories(
      {super.key,
      required this.jobCategories,
      required this.onCategorySelected});

  @override
  State<JobCategories> createState() => _JobCategoriesState();
}

class _JobCategoriesState extends State<JobCategories> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 0, right: 10, left: 10),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff1C4374)),
              color: const Color(0xff1C4374),
              // gradient: const LinearGradient(
              //     colors: [Color(0xff57a9f3), Colors.white],
              //     begin: Alignment(0, 5),
              //     end: Alignment(4, 2.8)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0xff1C4374),
                    blurRadius: 5,
                    blurStyle: BlurStyle.outer),
              ],
              borderRadius: BorderRadius.circular(10)),
          height: 95.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.jobCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      widget
                          .onCategorySelected(widget.jobCategories[index].name);
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: SizedBox(
                      height: 100,
                      width: 110,
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 6, right: 6),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff1C4374)),
                              color: _selectedIndex == index
                                  ? const Color(0xff97C5FF)
                                  : Colors.white,
                              // gradient:  _selectedIndex == index
                              //     ? const LinearGradient(
                              //     colors: [Color(0xff57a9f3), Colors.blue],
                              //     begin: Alignment(0, 5.2),
                              //     end: Alignment(4, 2.8))
                              //     : const LinearGradient(
                              //     colors: [Colors.white, Colors.white],
                              //     begin: Alignment(0, 5.2),
                              //     end: Alignment(4, 2.8)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 3,
                                    blurStyle: BlurStyle.outer),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 80,
                                  child: ListTile(
                                      leading: SizedBox(
                                    width: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                          widget.jobCategories[index].icon),
                                    ),
                                  ))),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Text(
                                    widget.jobCategories[index].name,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ));
              }),
        ));
  }
}

class JobCategory {
  final IconData icon;
  final String name;

  JobCategory({required this.icon, required this.name});
}
