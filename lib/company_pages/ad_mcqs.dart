import 'package:flutter/material.dart';


class CompanyMCQCreationScreen extends StatefulWidget {
  const CompanyMCQCreationScreen({super.key});

  @override
  CompanyMCQCreationScreenState createState() =>
      CompanyMCQCreationScreenState();
}

class CompanyMCQCreationScreenState
    extends State<CompanyMCQCreationScreen> {
  List<MCQ> mcqs = List.generate(10, (index) => MCQ());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
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
              onAdd: (){
                setState(() {
                  if (mcqs.length<=9){
                    mcqs.add(MCQ());
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class MCQ {
  String question='';
  String option1='lol';
  String option2='';
  String option3='';
  String option4='';
  String correctAnswer='';
}

class MCQCard extends StatelessWidget {
  final MCQ mcq;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const MCQCard({super.key, required this.mcq, required this.onDelete,required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
              onChanged: (text) {
                mcq.question = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 1',
              ),
              onChanged: (text) {
                mcq.option1 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 2',
              ),
              onChanged: (text) {
                mcq.option2 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 3',
              ),
              onChanged: (text) {
                mcq.option3 = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 4',
              ),
              onChanged: (text) {
                mcq.option4 = text;
              },
            ),
            DropdownButton(
              value: mcq.correctAnswer.isEmpty ? 'Option 1':mcq.correctAnswer,
              onChanged: (value) {
                mcq.correctAnswer = value!;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlinedButton(
                  onPressed: onAdd,
                  child: const Text('ADD'),
                ), OutlinedButton(
                  onPressed: onDelete,
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