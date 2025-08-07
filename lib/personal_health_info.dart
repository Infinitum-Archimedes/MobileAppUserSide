import 'package:flutter/material.dart';

class PersonalHealthInfo extends StatefulWidget {
  const PersonalHealthInfo({super.key});

  @override
  State<PersonalHealthInfo> createState() => _PersonalHealthInfoState();
}

class _PersonalHealthInfoState extends State<PersonalHealthInfo> {
  // Controllers for each input field
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController healthConditionsController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    allergiesController.dispose();
    medicationsController.dispose();
    healthConditionsController.dispose();
    otherController.dispose();
    super.dispose();
  }

  void _saveData() {
    // This is where you'd save or send the data
    print("Allergies: ${allergiesController.text}");
    print("Medications: ${medicationsController.text}");
    print("Health Conditions: ${healthConditionsController.text}");
    print("Other: ${otherController.text}");
              controller: otherController,
              decoration: const InputDecoration(
                labelText: "Other",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveData,
              child: const Text("Save"),
            ),
  },
        ),
      ),
    );
  }
}