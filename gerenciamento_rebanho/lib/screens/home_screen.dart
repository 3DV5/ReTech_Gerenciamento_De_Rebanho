import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import '../providers/cattle_provider.dart';
import 'farm_list_screen.dart';
import 'farm_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  String? _error;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Provider.of<FarmProvider>(context, listen: false).loadFarms();
      await Provider.of<CattleProvider>(context, listen: false).loadCattle();
    } catch (error) {
      setState(() {
        _error = 'Erro ao carregar os dados. Por favor, reinicie o aplicativo.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Gado'),
        actions: [
          if (_error != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white, // Define a cor aqui em vez de no Icon
              onPressed: _loadData,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : const FarmListScreen(),
      floatingActionButton: _error == null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const FarmFormScreen(),
                  ),
                );
              },
            )
          : null,
    );
  }
}
