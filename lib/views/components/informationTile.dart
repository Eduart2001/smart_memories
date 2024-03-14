import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  final String category;
  final Map<String, String> details;

  const InformationTile({super.key, required this.category, required this.details});

  @override
  Widget build(BuildContext context) {
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

/*
todo : a utiliser comme ceci dans /views/pages/imageDetails.dart pour lister les data décryptées
InfoTile(
  category: 'Appareil',
  details: {
    'Modèle': 'Nikon D5200',
    'Ouverture': 'f1.8',
    // Ajoutez plus de détails ici
  },
)
 */