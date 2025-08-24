import 'package:flutter/material.dart';
import '../models/lottery_type.dart';
import '../models/lottery_result.dart';
import '../services/lottery_service.dart';
import '../widgets/lottery_selector.dart';
import '../widgets/number_ball.dart';
import '../widgets/result_card.dart';
import '../widgets/developer_footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LotteryType _selectedType = LotteryType.mega;
  List<int> _generatedNumbers = [];
  List<LotteryResult> _latestResults = [];
  bool _isGenerating = false;
  bool _isLoadingResults = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildLotterySelector(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 32),
                _buildGeneratedNumbers(),
                const SizedBox(height: 32),
                _buildLatestResults(),
                const DeveloperFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.casino,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'LotoAnjo',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.casino,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Palpites inteligentes para suas apostas',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
  Widget _buildLotterySelector() {
    return LotterySelector(
      selectedType: _selectedType,
      onChanged: (type) {
        setState(() {
          _selectedType = type;
          _generatedNumbers.clear();
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isGenerating ? null : _generateNumbers,
            icon: _isGenerating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : const Icon(Icons.auto_awesome, size: 24),
            label: Text(
              _isGenerating ? 'Gerando...' : 'Gerar Palpite Inteligente',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoadingResults ? null : _loadLatestResults,
            icon: _isLoadingResults
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : const Icon(Icons.calendar_today, size: 24),
            label: Text(
              _isLoadingResults ? 'Carregando...' : 'Mostrar Últimos Resultados',
              style: const TextStyle(fontSize: 18),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedNumbers() {
    if (_generatedNumbers.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        Text(
          'Seus Números da Sorte',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _generatedNumbers
              .asMap()
              .entries
              .map((entry) => NumberBall(
                    number: entry.value,
                    index: entry.key,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLatestResults() {
    if (_latestResults.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimos Resultados',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        ..._latestResults.map((result) => ResultCard(result: result)),
      ],
    );
  }

  Future<void> _generateNumbers() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final numbers = await LotteryService.generateSmartNumbers(_selectedType);
      setState(() {
        _generatedNumbers = numbers;
      });
    } catch (e) {
      _showErrorSnackBar('Erro ao gerar números. Tente novamente.');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _loadLatestResults() async {
    setState(() {
      _isLoadingResults = true;
    });

    try {
      final results = await LotteryService.getAllLatestResults();
      setState(() {
        _latestResults = results;
      });
    } catch (e) {
      _showErrorSnackBar('Erro ao carregar resultados. Tente novamente.');
    } finally {
      setState(() {
        _isLoadingResults = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
