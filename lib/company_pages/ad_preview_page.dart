import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/mcq_model.dart';


class PreviewPage extends StatefulWidget {
  final List<MCQ> mcq;
  const PreviewPage({super.key, required this.mcq});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C4374),
        title: const Text(
          "Preview Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
        child: ListView.builder(
          itemCount: widget.mcq.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(
                  'Question ${index + 1}: ${widget.mcq[index].question}',
                ),
                const SizedBox(height: 10),
                Text('Option 1: ${widget.mcq[index].option1}'),
                Text('Option 2: ${widget.mcq[index].option2}'),
                Text('Option 3: ${widget.mcq[index].option3}'),
                Text('Option 4: ${widget.mcq[index].option4}'),
                const SizedBox(height: 15),
                Text(
                  'Correct Answer: ${widget.mcq[index].correctAnswer}',
                ),
                const SizedBox(height: 25),
                const Divider(
                  thickness: 2,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CupertinoButton(
            color: Colors.blueGrey,
            child: const Text(
              "Back",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            color: Colors.blueGrey,
            child: const Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              // final jobService = JobService();
              // await jobService.createMCQ(DateTime.now().toString(), widget.mcq);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}