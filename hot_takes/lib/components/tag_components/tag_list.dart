import 'package:flutter/material.dart';

import 'package:hot_takes/components/tag_components/tag_json_object.dart';

/*
TODO LIST:

>I see this probably needing to be broken up into bite size pieces for 
    reusability. Like we should probably just do one row at a time and then
    call this twice once for superTags and once for adjTags. I see this being
    used at least in our createTake page as well if we do it better

*/

class TagList extends StatelessWidget {
  final tagParent tags;
  final int superTagCount;
  final int adjTagCount;
  final List<String> superTagNames;
  final List<String> superTagTypes;
  final List<String> adjTagNames;
  final List<String> adjTagTypes;
  /* 
  Json Format: 
  { 
    "superTagCount":"2",
    "superTags": 
    [
      {"tag":"Da Bois", "tagType":"private"},
      {"tag":"Hot Take", "tagType":"category"},
    ],
    "adjTagCount":"1",
    "adjTags":
    [
      {"tag":"No Tags", "tagType":""},
    ]
  }
  */

  TagList({required this.tags})
      : superTagCount = tags.superTagCount,
        superTagNames = tags.superTags.map((tag) => tag.tagName).toList(),
        superTagTypes = tags.superTags.map((tag) => tag.tagType).toList(),
        adjTagCount = tags.adjTagCount,
        adjTagNames = tags.adjTags.map((tag) => tag.tagName).toList(),
        adjTagTypes = tags.adjTags.map((tag) => tag.tagType).toList();

  Widget buildSuperTagButton(BuildContext context, int index) {
    TextStyle buttonStyle;
    Icon tagIcon;

    if (superTagTypes[index] == "private") {
      tagIcon = new Icon(
        Icons.lock,
        color: Color.fromRGBO(175, 0, 123, 1),
      );
    } else {
      tagIcon = new Icon(
        Icons.tag,
        color: Color.fromRGBO(175, 0, 123, 1),
      );
    }

    buttonStyle =
        new TextStyle(fontSize: 15, color: Color.fromRGBO(175, 0, 123, 1));

    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            tagIcon,
            Text(
              superTagNames[index],
              style: buttonStyle,
            )
          ],
        ));
  }

  buildAdjTagButton(context, index) {
    Icon tagIcon = new Icon(Icons.tag, color: Colors.white);
    TextStyle buttonStyle;
    buttonStyle = new TextStyle(fontSize: 15, color: Colors.white);

    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            tagIcon,
            Text(
              adjTagNames[index],
              style: buttonStyle,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: new List.generate(
              superTagCount, (index) => buildSuperTagButton(context, index)),
        ),
        Row(
          children: new List.generate(
              adjTagCount, (index) => buildAdjTagButton(context, index)),
        )
      ],
    );
  }
}
