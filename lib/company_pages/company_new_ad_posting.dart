import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saat_recruitment/reusable_widgets/reusable_widget.dart';
import '../job_seeker_pages/job_seeker_profile.dart';

class CompanyNewAdPosting extends StatefulWidget {
  const CompanyNewAdPosting({super.key});

  @override
  CompanyNewAdPostingState createState() => CompanyNewAdPostingState();
}

class CompanyNewAdPostingState extends State<CompanyNewAdPosting> {
  String _selectedOption = '';
  String? _selectedCategory;
  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  String? _location;
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
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          "JOB POSTING",
                          style: TextStyle(
                              fontSize: 38, fontWeight: FontWeight.w900),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: textFormField(
                          onChanged: () {
                            setState(() {});
                          },
                          "Enter Job Title",
                          Icons.title_outlined,
                          false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Job title";
                            }
                            return null;
                          },
                          controller: _jobTitle,
                          keyboard: TextInputType.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: dropDown(
                        items: [
                          'IT & Technology',
                          'Healthcare',
                          'Sales & Marketing',
                          'Finance & Accounting',
                          'Customer Service',
                          'Administration & HR',
                          'Engineering & Manufacturing',
                          'Creative & Design',
                          'Hospitality & Tourism',
                          'Education & Training'
                        ].map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Job Category';
                          }
                          return null;
                        },
                        text: 'Job Category',
                        icon: Icons.category_outlined,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: dropDown(
                        items: [
                          'Remote',
                          'Full-time',
                          'Part-time',
                          'Contract',
                          'Freelance',
                          'Internship',
                        ].map((jobType) {
                          return DropdownMenuItem(
                            value: jobType,
                            child: Text(jobType),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Job Type';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        text: 'Job Type',
                        icon: Icons.type_specimen_rounded,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: dropDown(
                        items: [
                          'No',
                          'One Year',
                          'Two Years',
                          'Three Years',
                          'Five Years',
                        ].map((jobExperience) {
                          return DropdownMenuItem(
                            value: jobExperience,
                            child: Text(jobExperience),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Job Experience';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        text: 'Required Experience',
                        icon: Icons.type_specimen_rounded,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: dropDown(
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
                        ].map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select Job Location';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _location = value;
                          });
                        },
                        text: 'Job Location',
                        icon: Icons.my_location_outlined,
                      ),
                    ),
                       Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textFormField(
                          onChanged: () {
                            setState(() {});
                          },
                          "Salary",
                          Icons.currency_pound_outlined,
                          false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Salary";
                            }
                            return null;
                          },
                          controller: _salary,
                          keyboard: TextInputType.text),
                    ),
                    Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Do you want to add MCQs for this Ad?',
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // CupertinoButton(
                            //   color:const Color(0xff1C4374),
                            //   onPressed: () {},
                            //   child: const Text('Preview AD',style: TextStyle(color: Colors.white),),
                            // ),
                      // SizedBox(height: 10,),
                            CupertinoButton(
                              color:const Color(0xff1C4374),
                              onPressed: () {},
                              child: const Text('Post Job',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 18),),
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
