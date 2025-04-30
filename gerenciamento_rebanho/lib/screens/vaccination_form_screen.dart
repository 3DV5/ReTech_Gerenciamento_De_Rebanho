import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/cattle.dart';
import '../providers/cattle_provider.dart';

class VaccinationFormScreen extends StatefulWidget {
  final String cattleId;

  const VaccinationFormScreen({super.key, required this.cattleId});

  @override
  _VaccinationFormScreenState createState() => _VaccinationFormScreenState();
}

class _VaccinationFormScreenState extends State<VaccinationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _vaccinationData = {
    'name': '',
    'date': DateTime.now(),
    'notes': '',
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _vaccinationData['date'] as DateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _vaccinationData['date']) {
      setState(() {
        _vaccinationData['date'] = picked;
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final vaccination = Vaccination.create(
        name: _vaccinationData['name'] as String,
        date: _vaccinationData['date'] as DateTime,
        notes: _vaccinationData['notes'] as String,
      );

      await Provider.of<CattleProvider>(context, listen: false)
          .addVaccination(widget.cattleId, vaccination);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar a vacinação.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Vacinação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome da Vacina'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o nome da vacina';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _vaccinationData['name'] = value!;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          const Text('Data da Vacinação: '),
                          TextButton(
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(_vaccinationData['date'] as DateTime),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Observações'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _vaccinationData['notes'] = value ?? '';
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('SALVAR'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}