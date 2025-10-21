import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/cattle.dart';
import '../providers/cattle_provider.dart';

class WeightFormScreen extends StatefulWidget {
  final String cattleId;

  const WeightFormScreen({super.key, required this.cattleId});

  @override
  _WeightFormScreenState createState() => _WeightFormScreenState();
}

class _WeightFormScreenState extends State<WeightFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _weightData = {
    'weight': '',
    'date': DateTime.now(),
    'notes': '',
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _weightData['date'] as DateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _weightData['date']) {
      setState(() {
        _weightData['date'] = picked;
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
      final weightRecord = WeightRecord.create(
        weight: double.parse(_weightData['weight'] as String),
        date: _weightData['date'] as DateTime,
        notes: _weightData['notes'] as String,
      );

      await Provider.of<CattleProvider>(context, listen: false)
          .addWeightRecord(widget.cattleId, weightRecord);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar o registro de peso.'),
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

  Future<void> _confirmSave() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color.fromARGB(255, 0, 0, 0), size: 30),
            SizedBox(width: 10),
            Text(
              'Confirmação',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Deseja realmente salvar este registro de peso?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _saveForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Pesagem'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _confirmSave,
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
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg)',
                        helperText: 'Digite o peso do animal em quilogramas',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o peso';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, informe um número válido';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Por favor, informe um valor maior que zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _weightData['weight'] = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Data da Pesagem: '),
                        TextButton(
                          child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(_weightData['date'] as DateTime),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                        helperText: 'Adicione notas sobre a pesagem (opcional)',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _weightData['notes'] = value ?? '';
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _confirmSave,
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
