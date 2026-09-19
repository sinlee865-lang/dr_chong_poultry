import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PoultryMedApp());
}

class MedicineConfig {
  final String name;
  final double factor; // Grams required per gram of average body weight (for 10,000 birds)
  final Color themeColor;

  const MedicineConfig({
    required this.name,
    required this.factor,
    required this.themeColor,
  });
}

class PoultryMedApp extends StatelessWidget {
  const PoultryMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr.Chong 014-6220912',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const DosageCalculatorScreen(),
    );
  }
}

class DosageCalculatorScreen extends StatefulWidget {
  const DosageCalculatorScreen({super.key});

  @override
  State<DosageCalculatorScreen> createState() => _DosageCalculatorScreenState();
}

class _DosageCalculatorScreenState extends State<DosageCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _flockController = TextEditingController(text: '10000');

  // Complete list of 16 medications
  final List<MedicineConfig> _medications = const [
    MedicineConfig(name: 'Amoxicillin 50', factor: 0.27, themeColor: Colors.teal),
    MedicineConfig(name: 'Amprol 20', factor: 1.00, themeColor: Colors.pink),
    MedicineConfig(name: 'Apramycin Pure', factor: 0.60, themeColor: Colors.lime),
    MedicineConfig(name: 'Bromhexine 2', factor: 0.25, themeColor: Colors.green),
    MedicineConfig(name: 'Doxy 50', factor: 0.40, themeColor: Colors.indigo),
    MedicineConfig(name: 'Enro 10', factor: 1.00, themeColor: Colors.blue),
    MedicineConfig(name: 'Erthryo 30', factor: 0.78, themeColor: Colors.purple),
    MedicineConfig(name: 'Florf 10', factor: 2.00, themeColor: Colors.brown),
    MedicineConfig(name: 'Flumequin 25', factor: 0.50, themeColor: Colors.cyan),
    MedicineConfig(name: 'Linco Spec 66', factor: 0.75, themeColor: Colors.deepPurple),
    MedicineConfig(name: 'Paracetamol 30', factor: 1.00, themeColor: Colors.red),
    MedicineConfig(name: 'Sulfa 480', factor: 0.68, themeColor: Colors.deepOrange),
    MedicineConfig(name: 'Tilmiseen 25', factor: 0.80, themeColor: Colors.orange),
    MedicineConfig(name: 'Toltrazuril 2.5', factor: 2.80, themeColor: Colors.amber),
    MedicineConfig(name: 'Tylosin Pure', factor: 1.00, themeColor: Colors.blueGrey), 
    MedicineConfig(name: 'Tylvalosin 62.5', factor: 0.40, themeColor: Colors.lightGreen),
  ];

  // Body Weight in grams by age (Days 0 to 45)
  final Map<int, double> _bodyWeightData = const {
    0: 44.0, 1: 62.0, 2: 81.0, 3: 102.0, 4: 125.0, 5: 151.0, 6: 181.0, 7: 213.0,
    8: 249.0, 9: 288.0, 10: 330.0, 11: 376.0, 12: 425.0, 13: 477.0, 14: 533.0,
    15: 592.0, 16: 655.0, 17: 720.0, 18: 789.0, 19: 860.0, 20: 935.0, 21: 1012.0,
    22: 1092.0, 23: 1174.0, 24: 1258.0, 25: 1345.0, 26: 1434.0, 27: 1524.0,
    28: 1616.0, 29: 1710.0, 30: 1805.0, 31: 1901.0, 32: 1999.0, 33: 2097.0,
    34: 2196.0, 35: 2296.0, 36: 2396.0, 37: 2496.0, 38: 2597.0, 39: 2697.0,
    40: 2798.0, 41: 2898.0, 42: 2998.0, 43: 3097.0, 44: 3197.0, 45: 3295.0,
  };

  // Updated 8-Hour Water Intake in Liters for 10,000 birds (Days 0 to 45)
  final Map<int, double> _waterIntakeData = const {
    0: 0.0, 1: 68.0, 2: 91.0, 3: 113.0, 4: 136.0, 5: 153.0, 6: 176.0, 7: 198.0,
    8: 221.0, 9: 249.0, 10: 272.0, 11: 295.0, 12: 323.0, 13: 351.0, 14: 380.0,
    15: 408.0, 16: 436.0, 17: 470.0, 18: 499.0, 19: 533.0, 20: 567.0, 21: 595.0,
    22: 629.0, 23: 663.0, 24: 691.0, 25: 725.0, 26: 759.0, 27: 788.0, 28: 822.0,
    29: 850.0, 30: 884.0, 31: 912.0, 32: 941.0, 33: 969.0, 34: 997.0, 35: 1020.0,
    36: 1048.0, 37: 1071.0, 38: 1094.0, 39: 1116.0, 40: 1139.0, 41: 1156.0, 42: 1173.0,
    43: 1447.0, 44: 1467.0, 45: 1487.0,
  };

  // Daily Intake in kg for 10,000 birds (Days 0 to 45)
  final Map<int, double> _dailyIntakeData = const {
    0: 0.0, 1: 120.0, 2: 160.0, 3: 200.0, 4: 240.0, 5: 270.0, 6: 310.0, 7: 350.0,
    8: 390.0, 9: 440.0, 10: 480.0, 11: 520.0, 12: 570.0, 13: 620.0, 14: 670.0,
    15: 720.0, 16: 770.0, 17: 830.0, 18: 880.0, 19: 940.0, 20: 1000.0, 21: 1050.0,
    22: 1110.0, 23: 1170.0, 24: 1220.0, 25: 1280.0, 26: 1340.0, 27: 1390.0, 28: 1450.0,
    29: 1500.0, 30: 1560.0, 31: 1610.0, 32: 1660.0, 33: 1710.0, 34: 1760.0, 35: 1800.0,
    36: 1850.0, 37: 1890.0, 38: 1930.0, 39: 1970.0, 40: 2010.0, 41: 2040.0, 42: 2070.0,
    43: 2110.0, 44: 2130.0, 45: 2160.0,
  };

  // Currently selected medication (null = All Medications)
  MedicineConfig? _selectedMedication;

  int? _calculatedAge;
  int? _calculatedFlock;
  double? _avgWeightG;
  double? _totalWeightKg;
  double? _waterIntakeL;
  double? _dailyIntakeKg;
  List<Map<String, dynamic>> _medResults = [];

  @override
  void dispose() {
    _ageController.dispose();
    _flockController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final int age = int.parse(_ageController.text);
      final int flock = int.parse(_flockController.text);

      final double avgBw = _bodyWeightData[age]!;
      final double totalFlockKg = (avgBw * flock) / 1000.0;
      final double flockMultiplier = flock / 10000.0;

      // Calculate scaled 8-hour water intake and total daily intake
      final double scaledWaterL = _waterIntakeData[age]! * flockMultiplier;
      final double scaledDailyIntakeKg = _dailyIntakeData[age]! * flockMultiplier;

      // Filter list: calculate for single selected medication, or all if null
      final targetList = _selectedMedication != null
          ? [_selectedMedication!]
          : _medications;

      final results = targetList.map((med) {
        final double gramsRequired = avgBw * med.factor * flockMultiplier;
        return {
          'name': med.name,
          'dose': '${gramsRequired.toStringAsFixed(2)} g',
          'color': med.themeColor,
        };
      }).toList();

      setState(() {
        _calculatedAge = age;
        _calculatedFlock = flock;
        _avgWeightG = avgBw;
        _totalWeightKg = totalFlockKg;
        _waterIntakeL = scaledWaterL;
        _dailyIntakeKg = scaledDailyIntakeKg;
        _medResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dr.Chong Poultry Medicine Dosage'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Inputs Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Chicken Age (Days 0 - 45)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the chicken age';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 0 || age > 45) {
                            return 'Enter a valid age between 0 and 45';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _flockController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Flock Size (Number of Birds)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.groups),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
return 'Please enter the flock size';
                          }
                          final flock = int.tryParse(value);
                          if (flock == null || flock <= 0) {
                            return 'Enter a valid bird count';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Searchable Dropdown Menu
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<MedicineConfig?>(
                            width: constraints.maxWidth,
                            initialSelection: null,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            leadingIcon: const Icon(Icons.medication),
                            label: const Text('Select Medication'),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(),
                            ),
                            dropdownMenuEntries: [
                              const DropdownMenuEntry<MedicineConfig?>(
                                value: null,
                                label: 'All Medications (All 16)',
                              ),
                              ..._medications.map((med) {
                                return DropdownMenuEntry<MedicineConfig?>(
                                  value: med,
                                  label: med.name,
                                );
                              }),
                            ],
                            onSelected: (MedicineConfig? value) {
                              setState(() {
                                _selectedMedication = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Calculate Dosage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Results Card
              if (_medResults.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Results for $_calculatedFlock birds (Day $_calculatedAge)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                        const Divider(),
                        _buildResultRow('Average Weight / Bird', '$_avgWeightG g'),
                        _buildResultRow('Total Flock Weight', '${_totalWeightKg!.toStringAsFixed(1)} kg'),
                        _buildResultRow('8-Hour Water Intake', '${_waterIntakeL!.toStringAsFixed(1)} L'),
                        _buildResultRow('Total Daily Intake', '${_dailyIntakeKg!.toStringAsFixed(1)} kg'),
                        const SizedBox(height: 16),
                        Text(
                          'Required Medication Amounts:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 10),
                        ..._medResults.map((med) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildMedBox(med['name'], med['dose'], med['color']),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMedBox(String name, String dose, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(dose, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}