import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Set<String> selectedSex;
  final Set<String> selectedSize;
  final Set<String> selectedAge;
  final Set<String> selectedEnergyLevel;

  const FilterScreen({
    super.key,
    required this.selectedSex,
    required this.selectedSize,
    required this.selectedAge,
    required this.selectedEnergyLevel,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Set<String> _selectedSex = {};
  Set<String> _selectedSize = {};
  Set<String> _selectedAge = {};
  Set<String> _selectedEnergyLevel = {};

  @override
  void initState() {
    super.initState();
    _selectedSex = widget.selectedSex;
    _selectedSize = widget.selectedSize;
    _selectedAge = widget.selectedAge;
    _selectedEnergyLevel = widget.selectedEnergyLevel;
  }

  void _clearFilters() {
    setState(() {
      _selectedSex.clear();
      _selectedSize.clear();
      _selectedAge.clear();
      _selectedEnergyLevel.clear();
    });
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'sex': _selectedSex,
      'size': _selectedSize,
      'age': _selectedAge,
      'energyLevel': _selectedEnergyLevel,
    });
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterRow("Sexo", ['Macho', 'Hembra'], _selectedSex),
            const SizedBox(
              height: 13.0,
            ),
            _buildFilterRow(
                "Tamaño", ['Pequeño', 'Mediano', 'Grande'], _selectedSize),
            const SizedBox(
              height: 13.0,
            ),
            _buildFilterRow(
                "Edad", ['Cachorro', 'Adulto', 'Senior'], _selectedAge),
            const SizedBox(
              height: 13.0,
            ),
            _buildFilterRow("Nivel energía", ['Baja', 'Media', 'Alta'],
                _selectedEnergyLevel),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    minWidth: 140.0,
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                    onPressed: _applyFilters, // Clear Filters action
                    child: const Text('Aplicar Filtros'),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      //backgroundColor: Colors.lightGreen,
                    ),
                    onPressed: _clearFilters, // Clear Filters action
                    child: const Text('Borrar Filtros'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 87, 88, 88),
        elevation: 0.0,
        title: const Text('Filtros'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildFilterRow(
      String title, List<String> values, Set<String> selectedValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10.0,
          children: values.map((value) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selectedValues.contains(value),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        selectedValues.add(value);
                      } else {
                        selectedValues.remove(value);
                      }
                    });
                  },
                ),
                Text(value),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
