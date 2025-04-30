import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import 'cattle_list_screen.dart';
import 'farm_form_screen.dart';

class FarmListScreen extends StatelessWidget {
  const FarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmData = Provider.of<FarmProvider>(context);
    final farms = farmData.farms;

    return farms.isEmpty
        ? const Center(
            child: Text(
              'Nenhuma fazenda cadastrada.\nClique no botão + para adicionar.',
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: farms.length,
            itemBuilder: (ctx, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    farms[i].name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(farms[i].name),
                subtitle: Text('${farms[i].location} - ${farms[i].area} hectares'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => FarmFormScreen(farmId: farms[i].id),
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
                            title: const Text('Excluir Fazenda'),
                            content: const Text('Tem certeza que deseja excluir esta fazenda?'),
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
                                  farmData.deleteFarm(farms[i].id);
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
                      builder: (ctx) => CattleListScreen(
                        farmId: farms[i].id,
                        farmName: farms[i].name,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}