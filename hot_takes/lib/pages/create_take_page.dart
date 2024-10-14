import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hot_takes/components/topics/topic.dart';
import 'package:hot_takes/components/topics/topic_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../components/takes/take_utils.dart';
import 'package:hot_takes/auth/secrets.dart';

class CreateTakePage extends StatefulWidget {
  @override
  State<CreateTakePage> createState() => _CreateTakePage();
}

class _CreateTakePage extends State<CreateTakePage> {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  Topic _selected = Topic("Movies", 2, TopicType.Category);
  late List<Topic> topics;
  late TextEditingController myController;
  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
    final apiKey = geminiApiKey;

    model = GenerativeModel(
      model: 'gemini-1.5-flash-8b',
      apiKey: apiKey,
      // safetySettings: Adjust safety settings
      // See https://ai.google.dev/gemini-api/docs/safety-settings
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
          'Reply to the prompt by categorizing the message in one of the following categories depending on its context:\nNBA, Movies, TV, Video Games, Food, Cooking, Miscellaneous, Friends, Clothing, Pop Culture, Life, Hot Takes, Travel, Cars, College, Anime, Technology, Music, Sports, Animals, Books, Investing, Geography, History\n\nOnly use the Hot Takes category when the message seems to be referring to the Hot Takes social media app where you can submit Hot Takes. Reply using a json format "category": and the suggested category'),
    );
  }

  void onSubmit(BuildContext context) {
    // Get the current selected values
    String take_name = myController.text.trim();
    Topic val = _selected!;

    if (take_name.isNotEmpty) {
      createTake(take_name, val);

      //Clear input field to make it more discernible that take was submitted
      myController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted Take!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your take must have content!')),
      );
    }
  }

  Future<void> getSuggestedTopic() async {
    String take_name = myController.text.trim();
    final response = await model.generateContent([Content.text(take_name)]);
    String cleanedJson =
        (response.text ?? "").replaceAll("`", '').replaceAll("json", '');
    final body = json.decode(cleanedJson);
    if (body['category'] != null) {
      final suggestedCategory = body['category'];
      int id = 0;
      for (var topic in topics) {
        if (topic.topic_name == suggestedCategory) {
          id = topic.topic_id;
        }
      }
      setState(() {
        _selected = Topic(suggestedCategory, id, TopicType.Category);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          //leading: Image.asset("assets/img/take_icon.png"),
          title: Text("Hot Takes"),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(175, 0, 123, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: myController,
                maxLines: 2,
                minLines: 1,
                onTapOutside: (event) {
                  getSuggestedTopic();
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your take',
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Topic:",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: FutureBuilder(
                  future: getAllTopics(myUserId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none');
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          topics = snapshot.data!.toList();
                          return DropdownButton<Topic>(
                            isExpanded: true,
                            items:
                                snapshot.data?.map((Topic dropDownStringItem) {
                              return DropdownMenuItem<Topic>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem.topic_name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selected = value!;
                              });
                            },
                            value: _selected,
                          );
                        }
                    }
                  }),
            ),
            SizedBox(height: 24),
            OutlinedButton(
                onPressed: () => onSubmit(context), child: Text("Submit"))
          ],
        )));
  }
}
