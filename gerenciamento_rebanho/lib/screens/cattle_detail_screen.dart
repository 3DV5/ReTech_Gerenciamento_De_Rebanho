import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/cattle.dart';
import '../providers/cattle_provider.dart';
import 'vaccination_form_screen.dart';
import 'insemination_form_screen.dart';
import 'weight_form_screen.dart';

class CattleDetailScreen extends StatelessWidget {
  final String cattleId;

  const CattleDetailScreen({super.key, required this.cattleId});

  @override
  Widget build(BuildContext context) {
    final cattleData = Provider.of<CattleProvider>(context);
    final cattle = cattleData.findById(cattleId);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes - ${cattle.identifier}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Vacinação', icon: Icon(Icons.medical_services)),
              Tab(text: 'Inseminação', icon: Icon(Icons.science)),
              Tab(text: 'Peso', icon: Icon(Icons.monitor_weight)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVaccinationTab(context, cattle),
            _buildInseminationTab(context, cattle),
            _buildWeightTab(context, cattle),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationTab(BuildContext context, Cattle cattle) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Registro de Vacinações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: cattle.vaccinations.isEmpty
              ? const Center(
                  child: Text('Nenhuma vacinação registrada.'),
                )
              : ListView.builder(
                  itemCount: cattle.vaccinations.length,
                  itemBuilder: (ctx, i) {
                    final vaccination = cattle.vaccinations[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.medical_services, color: Colors.white),
                        ),
                        title: Text(vaccination.name),
                        subtitle: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(vaccination.date)}\nObservações: ${vaccination.notes}'),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nova Vacinação'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => VaccinationFormScreen(cattleId: cattle.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInseminationTab(BuildContext context, Cattle cattle) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Registro de Inseminações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: cattle.inseminations.isEmpty
              ? const Center(
                  child: Text('Nenhuma inseminação registrada.'),
                )
              : ListView.builder(
                  itemCount: cattle.inseminations.length,
                  itemBuilder: (ctx, i) {
                    final insemination = cattle.inseminations[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.science, color: Colors.white),
                        ),
                        title: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(insemination.date)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Status: ${insemination.confirmed ? 'Confirmada' : 'Pendente'}'),
                            Text('Observações: ${insemination.notes}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nova Inseminação'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => InseminationFormScreen(cattleId: cattle.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeightTab(BuildContext context, Cattle cattle) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Registro de Pesagens',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (cattle.weightRecords.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Último peso: ${cattle.weightRecords.last.weight.toStringAsFixed(2)} kg (${DateFormat('dd/MM/yyyy').format(cattle.weightRecords.last.date)})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        Expanded(
          child: cattle.weightRecords.isEmpty
              ? const Center(
                  child: Text('Nenhuma pesagem registrada.'),
                )
              : ListView.builder(
                  itemCount: cattle.weightRecords.length,
                  itemBuilder: (ctx, i) {
                    final weightRecord = cattle.weightRecords[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child:
                              const Icon(Icons.monitor_weight, color: Colors.white),
                        ),
                        title: Text(
                            '${weightRecord.weight.toStringAsFixed(2)} kg'),
                        subtitle: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(weightRecord.date)}\nObservações: ${weightRecord.notes}'),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nova Pesagem'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => WeightFormScreen(cattleId: cattle.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}