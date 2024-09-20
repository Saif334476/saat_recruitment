import 'package:flutter/material.dart';
import '../job_seeker_pages/job_seeker_profile.dart';

class CompanyNewAdPosting extends StatefulWidget {
  const CompanyNewAdPosting({super.key});

  @override
  CompanyNewAdPostingState createState() => CompanyNewAdPostingState();
}

class CompanyNewAdPostingState extends State<CompanyNewAdPosting> {
  String _selectedOption = '';
  List<MCQ> mcqs = List.generate(10, (index) => MCQ());
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        // color: Colors.white,
        child: ListView(children: [
          Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                          "JOB POSTING",
                          style: TextStyle(
                              fontSize: 38, fontWeight: FontWeight.w900),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Category',
                            prefixIcon: const Icon(Icons.category_outlined)),
                        dropdownColor: const Color(0xFF97C5FF),
                        items: [
                          'Software Engineer',
                          'Call Center',
                          'Graphic Designer',
                          'Office Boy',
                          'Manager',
                        ].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Job Location';
                          }
                          return null;
                        },
                        onChanged: (String? value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: "Enter Job Description",
                          hintText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                width: 20.0, color: Colors.lightBlueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            // borderSide: const BorderSide(
                            //     color: Colors.lightBlueAccent,
                            //     width: 2)
                          ),
                          // boxShadow:const [BoxShadow(color: Colors.lightBlueAccent)],
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.description_outlined),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //         const JobSeekerProfile()));
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Location',
                            prefixIcon: const Icon(Icons.location_on_outlined)),
                        dropdownColor: const Color(0xFF97C5FF),
                        items: [
                          'Karachi',
                          'Lahore',
                          'Faisalabad',
                          'Rawalpindi',
                          'Multan',
                          'Gujranwala',
                          'Hyderabad',
                          'Peshawar',
                          'Islamabad',
                          'Quetta',
                          'Sargodha',
                          'Sialkot',
                          'Bahawalpur',
                          'Sukkur',
                          'Gujrat',
                          'Sahiwal',
                          'Okara',
                          'Jhang',
                          'D.G Khan',
                          'Chiniot',
                          'Jehlum',
                          'Khanewal',
                          'Kohat',
                          'Bawalnagar',
                          'Chakwal',
                          'Mianwali',
                        ].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Job Location';
                          }
                          return null;
                        },
                        onChanged: (String? value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Salary',
                            prefixIcon: const Icon(Icons.currency_pound)),
                        dropdownColor: const Color(0xFF97C5FF),
                        items: [
                          '10000-50000',
                          '50000-100000',
                          '100000-150000',
                          '150000-200000',
                          '200000-500000',
                        ].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Your Salary';
                          }
                          return null;
                        },
                        onChanged: (String? value) {},
                      ),
                    ),
                    Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Do you want to add MCQs for this Ad? Get ready to '
                          'put Candidates to the test with 10 tricky MCQs '
                          'designed  to separate the experts from the rest',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile(
                        value: 'Yes',
                        title: const Text('Yes'),
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        value: 'No',
                        title: const Text('No'),
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                    ]),
                    _selectedOption == 'Yes'
                        ? SizedBox(
                            height: 500,
                            child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.white],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ListView.builder(
                                    itemCount: mcqs.length,
                                    itemBuilder: (context, index) {
                                      return MCQCard(
                                        mcq: mcqs[index],
                                        onDelete: () {
                                          setState(() {
                                            mcqs.removeAt(index);
                                          });
                                        },
                                        onAdd: () {
                                          setState(() {
                                            if (mcqs.length <= 9) {
                                              mcqs.add(MCQ());
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                )))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              child: const Text('Preview AD'),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Text('Post AD'),
                            ),
                          ]),
                    )
                  ]))
        ]));
  }
}

class MCQ {
  String question = '';
  String option1 = 'lol';
  String option2 = '';
  String option3 = '';
  String option4 = '';
  String correctAnswer = '';
}

class MCQCard extends StatefulWidget {
  final MCQ mcq;
  final VoidCallback onDelete;
  final VoidCallback onAdd;
  const MCQCard(
      {super.key,
      required this.mcq,
      required this.onDelete,
      required this.onAdd});

  @override
  State<MCQCard> createState() => _MCQCardState();
}

class _MCQCardState extends State<MCQCard> {
  void showAddMCQModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  labelText: 'Question',
                ),
                onChanged: (text) {
                  widget.mcq.question = text;
                },
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Option 1',
              ),
              onChanged: (text) {
                widget.mcq.option1 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Option 2',
              ),
              onChanged: (text) {
                widget.mcq.option2 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Option 3',
              ),
              onChanged: (text) {
                widget.mcq.option3 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                labelText: 'Option 4',
              ),
              onChanged: (text) {
                widget.mcq.option4 = text;
              },
            ),
            DropdownButton(
              value: widget.mcq.correctAnswer.isEmpty
                  ? 'Option 1'
                  : widget.mcq.correctAnswer,
              onChanged: (value) {
                widget.mcq.correctAnswer = value!;
              },
              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                  .map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OutlinedButton(
                  onPressed: widget.onAdd,
                  child: const Text('ADD'),
                ),
                OutlinedButton(
                  onPressed: widget.onDelete,
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
