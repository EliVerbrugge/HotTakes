import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hot_takes/pages/sign_in_page.dart';
import 'package:hot_takes/components/takes_state.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class ProfilePage extends StatelessWidget {
  final myUserId = Supabase.instance.client.auth.currentUser!.id;
  User? _user = Supabase.instance.client.auth.currentUser!;
  String profileUrl = "";
  String profileName = "";

  ProfilePage()
  {
    profileUrl = _user?.identities?.elementAt(0).identityData!["picture"];
    profileName = _user?.identities?.elementAt(0).identityData!["full_name"];
  }

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the Provider.
    //
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
          leading: Icon(MdiIcons.fire),
          title: Text("Hot Takes"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(profileName),
          CircleAvatar(
             radius: 60,
             backgroundImage: NetworkImage(profileUrl),
          ),
        ])),
    );
  }
}