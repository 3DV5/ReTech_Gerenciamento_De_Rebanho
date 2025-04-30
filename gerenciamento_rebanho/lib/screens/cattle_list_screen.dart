import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cattle_provider.dart';
import 'cattle_form_screen.dart';
import 'cattle_detail_screen.dart';

class CattleListScreen extends StatelessWidget {
  final String farmId;
  final String farmName;

  const CattleListScreen({super.key, required this.farmId, required this.farmName});

  @override
  Widget build(BuildContext context) {
    final cattleData = Provider.of<CattleProvider>(context);
    final cattleList = cattleData.cattleByFarm(farmId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gado - $farmName'),
      ),
      body: cattleList.isEmpty
          ? const Center(
              child: Text(
                'Nenhum animal cadastrado nesta fazenda.\nClique no botão + para adicionar.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: cattleList.length,
              itemBuilder: (ctx, i) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      cattleList[i].identifier.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(cattleList[i].identifier),
                  subtitle: Text(
                      '${cattleList[i].breed} - ${cattleList[i].gender} - Nascimento: ${_formatDate(cattleList[i].birthDate)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => CattleFormScreen(
                                farmId: farmId,
                                cattleId: cattleList[i].id,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Excluir Animal'),
                              content: const Text(
                                  'Tem certeza que deseja excluir este animal?'),
                              actions: [
                                TextButton(
                                  child: const Text('Não'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Sim'),
                                  onPressed: () {
                                    cattleData.deleteCattle(cattleList[i].id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CattleDetailScreen(
                          cattleId: cattleList[i].id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CattleFormScreen(farmId: farmId),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}