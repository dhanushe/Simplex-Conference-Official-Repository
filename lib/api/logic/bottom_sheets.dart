import 'package:flutter/material.dart';

import '../objects/workshop_data.dart';
import '../../app/workshops/workshop_landing_page.dart';
import 'API.dart';

class BottomSheets {
  static void getCheckinPage(BuildContext context, WorkshopData w, int i) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        backgroundColor: const Color(0xFFFFFFFF),
        context: context,
        builder: (context) {
          return WorkshopCard(w: w, i: i);
        }).then(
      (value) {
        API.setDark();
      },
    );
  }
}
