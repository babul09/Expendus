import 'package:expen/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MigrationPage extends StatefulWidget {
  const MigrationPage({Key? key}) : super(key: key);

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends State<MigrationPage> {
  bool _isMigrating = false;
  String? _errorMessage;
  bool _migrationComplete = false;

  Future<void> _migrateData() async {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    
    if (!expenseProvider.firebaseAvailable) {
      setState(() {
        _errorMessage = 'Firebase is not available. Please check your internet connection and try again.';
      });
      return;
    }
    
    setState(() {
      _isMigrating = true;
      _errorMessage = null;
      _migrationComplete = false;
    });

    try {
      await expenseProvider.migrateFromHiveToFirebase();
      setState(() {
        _migrationComplete = true;
        _isMigrating = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Migration failed: $e';
        _isMigrating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final bool firebaseAvailable = expenseProvider.firebaseAvailable;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrate to Cloud Storage'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                firebaseAvailable ? Icons.cloud_upload : Icons.cloud_off,
                size: 80,
                color: firebaseAvailable ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                firebaseAvailable 
                    ? 'Migrate to Firebase Cloud Storage'
                    : 'Cloud Storage Not Available',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                firebaseAvailable
                    ? 'This will migrate all your local expenses data to Firebase Cloud Storage. '
                      'You can access your data from multiple devices after migration.'
                    : 'Firebase Cloud Storage is not available at this time. '
                      'Please check your internet connection and Firebase configuration.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isMigrating)
                Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Migrating data... Please wait.'),
                  ],
                )
              else if (_migrationComplete)
                Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Migration Complete!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Continue to App'),
                    ),
                  ],
                )
              else if (firebaseAvailable)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _migrateData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Start Migration',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Skip for Now'),
                      ),
                    ],
                  ],
                )
              else
                Column(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Return to App'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
} 