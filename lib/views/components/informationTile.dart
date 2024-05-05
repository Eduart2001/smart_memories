import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  /* 
    A custom widget for displaying information in a ListTile.
  */  
  final String category;
  final Map<String, String> details;

  const InformationTile({super.key, required this.category, required this.details});

  @override
  Widget build(BuildContext context) {
    /* 
      Builds the InformationTile widget.
    */
    return ListTile(
      title: Text(category),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.entries.map((entry) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(entry.value),
            ],
          );
        }).toList(),
      ),
    );
  }
}