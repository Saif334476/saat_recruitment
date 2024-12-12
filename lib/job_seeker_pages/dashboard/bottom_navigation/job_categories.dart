import 'package:flutter/material.dart';

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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _selectFirstCategory() {
    setState(() {
      _selectedIndex = 0;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    widget.onCategorySelected(widget.jobCategories[_selectedIndex].name);
  }

  void _selectLastCategory() {
    setState(() {
      _selectedIndex = widget.jobCategories.length - 1;
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to the last item
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    widget.onCategorySelected(widget.jobCategories[_selectedIndex].name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xff1C4374)),
          height: MediaQuery.of(context).size.height * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    _selectFirstCategory();
                  },
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    size: 20,
                    color: Colors.white,
                  )),
              Container(
                decoration: const BoxDecoration(color: Color(0xff1C4374)),
                child: const Text(
                  "Job Categories",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: Colors.white),
                ),
              ),
              IconButton(
                  onPressed: () {
                  _selectLastCategory();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 105,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              controller: _scrollController,
            shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.jobCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget
                          .onCategorySelected(widget.jobCategories[index].name);
                    },
                    child: SizedBox(
                      height: 50,
                      width: 115,
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 6, right: 6),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff1C4374)),
                              color: const Color(0xff1C4374),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 3,
                                    blurStyle: BlurStyle.outer),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        widget.jobCategories[index].icon,
                                        color: _selectedIndex == index
                                            ? const Color(0xff97C5FF)
                                            : Colors.white,
                                      ),
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
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: _selectedIndex == index
                                            ? const Color(0xff97C5FF)
                                            : Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ));
              }),
        ),
      ],
    );
  }
}

class JobCategory {
  final IconData icon;
  final String name;

  JobCategory({required this.icon, required this.name});
}
