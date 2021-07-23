import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screen/EditMembers.dart';

List<dynamic> selectedUsernames = <dynamic>[];
late String groupName;
String groupId = '';

class Members extends StatelessWidget {

  Members({
    required String grpName,
    required String grpId,
    required List<dynamic> sltUsernames
    }) {
    selectedUsernames = sltUsernames;
    groupName = grpName;
    groupId = grpId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EditMembers()
    );
  }
}
