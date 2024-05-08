class tagChild {
  final String tagName;
  String tagType;

  tagChild({this.tagName = "", this.tagType = ""});

  factory tagChild.fromJson(Map<String, dynamic> json) {
    return tagChild(
      tagName: json['tagName'],
      tagType: json['tagType'],
    );
  }
}

class tagParent {
  final int superTagCount;
  final List<tagChild> superTags;
  final int adjTagCount;
  final List<tagChild> adjTags;

  tagParent({
    required this.superTagCount,
    required this.superTags,
    required this.adjTagCount,
    required this.adjTags,
  });

  factory tagParent.fromJson(Map<String, dynamic> json) {
    var listSuper = json['superTags'] as List;
    var listAdj = json['adjTags'] as List;
    List<tagChild> superTagsList =
        listSuper.map((i) => tagChild.fromJson(i)).toList();
    List<tagChild> adjTagsList =
        listAdj.map((i) => tagChild.fromJson(i)).toList();

    return tagParent(
      superTagCount: json['superTagCount'],
      superTags: superTagsList,
      adjTagCount: json['adjTagCount'],
      adjTags: adjTagsList,
    );
  }
}
