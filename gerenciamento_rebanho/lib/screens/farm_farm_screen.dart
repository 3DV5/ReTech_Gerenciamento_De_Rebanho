import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/farm.dart';
import '../providers/farm_provider.dart';

class FarmFormScreen extends StatefulWidget {
  final String? farmId;

  const FarmFormScreen({super.key, this.farmId});

  @override
  _FarmFormScreenState createState() => _FarmFormScreenState();
}

class _FarmFormScreenState extends State<FarmFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _editedFarm = Farm.create(
    name: '',
    location: '',
    area: 0,
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.farmId != null) {
        _editedFarm = Provider.of<FarmProvider>(context, listen: false)
            .findById(widget.farmId!);
      }
      _isInit = false;
    }
    super.didChangeDependencies();
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
      if (widget.farmId != null) {
        await Provider.of<FarmProvider>(context, listen: false)
            .updateFarm(_editedFarm);
      } else {
        await Provider.of<FarmProvider>(context, listen: false)
            .addFarm(_editedFarm);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar a fazenda.'),
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
        title: Text(widget.farmId == null ? 'Nova Fazenda' : 'Editar Fazenda'),
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
                      initialValue: _editedFarm.name,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe um nome';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedFarm = Farm(
                          id: _editedFarm.id,
                          name: value!,
                          location: _editedFarm.location,
                          area: _editedFarm.area,
                          createdAt: _editedFarm.createdAt,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedFarm.location,
                      decoration: const InputDecoration(labelText: 'Localização'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a localização';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedFarm = Farm(
                          id: _editedFarm.id,
                          name: _editedFarm.name,
                          location: value!,
                          area: _editedFarm.area,
                          createdAt: _editedFarm.createdAt,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedFarm.area.toString(),
                      decoration: const InputDecoration(labelText: 'Área (hectares)'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a área';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, informe um número válido';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Por favor, informe um valor maior que zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedFarm = Farm(
                          id: _editedFarm.id,
                          name: _editedFarm.name,
                          location: _editedFarm.location,
                          area: int.parse(value!),
                          createdAt: _editedFarm.createdAt,
                        );
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
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