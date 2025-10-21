import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/cattle.dart';
import '../providers/cattle_provider.dart';

class CattleFormScreen extends StatefulWidget {
  final String farmId;
  final String? cattleId;

  const CattleFormScreen({super.key, required this.farmId, this.cattleId});

  @override
  _CattleFormScreenState createState() => _CattleFormScreenState();
}

class _CattleFormScreenState extends State<CattleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _editedCattle = Cattle.create(
    identifier: '',
    farmId: '',
    breed: '',
    birthDate: DateTime.now(),
    gender: 'Macho',
  );
  final List<String> _genderOptions = ['Macho', 'Fêmea'];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _editedCattle = Cattle.create(
        identifier: '',
        farmId: widget.farmId,
        breed: '',
        birthDate: DateTime.now(),
        gender: 'Macho',
      );

      if (widget.cattleId != null) {
        _editedCattle = Provider.of<CattleProvider>(context, listen: false)
            .findById(widget.cattleId!);
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _editedCattle.birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _editedCattle.birthDate) {
      setState(() {
        _editedCattle = Cattle(
          id: _editedCattle.id,
          identifier: _editedCattle.identifier,
          farmId: _editedCattle.farmId,
          breed: _editedCattle.breed,
          birthDate: picked,
          gender: _editedCattle.gender,
          vaccinations: _editedCattle.vaccinations,
          inseminations: _editedCattle.inseminations,
          weightRecords: _editedCattle.weightRecords,
          createdAt: _editedCattle.createdAt,
        );
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
      if (widget.cattleId != null) {
        await Provider.of<CattleProvider>(context, listen: false)
            .updateCattle(widget.cattleId!, _editedCattle);
      } else {
        await Provider.of<CattleProvider>(context, listen: false)
            .addCattle(_editedCattle);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar o animal.'),
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
          'Deseja realmente salvar este animal?',
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
        title: Text(widget.cattleId == null ? 'Novo Animal' : 'Editar Animal'),
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
                      initialValue: _editedCattle.identifier,
                      decoration: const InputDecoration(labelText: 'Identificador/Número'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe um identificador';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCattle = Cattle(
                          id: _editedCattle.id,
                          identifier: value!,
                          farmId: _editedCattle.farmId,
                          breed: _editedCattle.breed,
                          birthDate: _editedCattle.birthDate,
                          gender: _editedCattle.gender,
                          vaccinations: _editedCattle.vaccinations,
                          inseminations: _editedCattle.inseminations,
                          weightRecords: _editedCattle.weightRecords,
                          createdAt: _editedCattle.createdAt,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedCattle.breed,
                      decoration: const InputDecoration(labelText: 'Raça'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a raça';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCattle = Cattle(
                          id: _editedCattle.id,
                          identifier: _editedCattle.identifier,
                          farmId: _editedCattle.farmId,
                          breed: value!,
                          birthDate: _editedCattle.birthDate,
                          gender: _editedCattle.gender,
                          vaccinations: _editedCattle.vaccinations,
                          inseminations: _editedCattle.inseminations,
                          weightRecords: _editedCattle.weightRecords,
                          createdAt: _editedCattle.createdAt,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          const Text('Data de Nascimento: '),
                          TextButton(
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_editedCattle.birthDate),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                    DropdownButtonFormField(
                      value: _editedCattle.gender,
                      decoration: const InputDecoration(labelText: 'Gênero'),
                      items: _genderOptions.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _editedCattle = Cattle(
                            id: _editedCattle.id,
                            identifier: _editedCattle.identifier,
                            farmId: _editedCattle.farmId,
                            breed: _editedCattle.breed,
                            birthDate: _editedCattle.birthDate,
                            gender: value.toString(),
                            vaccinations: _editedCattle.vaccinations,
                            inseminations: _editedCattle.inseminations,
                            weightRecords: _editedCattle.weightRecords,
                            createdAt: _editedCattle.createdAt,
                          );
                        });
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
