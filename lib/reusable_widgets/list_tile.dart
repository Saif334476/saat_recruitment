import 'package:flutter/material.dart';

Widget buildListTile(context,
    String label, String value, IconData? icon, Function()? onEdit) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            style: BorderStyle.solid,
            color: const Color(0xff1C4374),
            width: 1.5),
        boxShadow: const [
          BoxShadow(
              blurRadius: 5,
              blurStyle: BlurStyle.outer,
              color: Color(0xff1C4374))
        ],
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1C4374))),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xff1C4374),overflow: TextOverflow.ellipsis,),softWrap: true,),
            ),
            if (onEdit != null)
              IconButton(
                  onPressed: onEdit, icon: Icon(icon, color: Colors.black))
          ],
        ),
        onTap: () {},
      ),
    ),
  );
}
