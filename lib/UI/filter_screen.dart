import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  // Recibe los filtros seleccionados como conjuntos desde el widget padre
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
  // Variables locales para almacenar los valores seleccionados
  Set<String> _selectedSex = {};
  Set<String> _selectedSize = {};
  Set<String> _selectedAge = {};
  Set<String> _selectedEnergyLevel = {};

  // Traducciones Español -> Inglés
  // Lo utilizamos porque en la base de datos los valores estan en ingles, y en la aplicacion se mostraran en español
  // por eso, auqnue mostremos los valores en español, los guardaremos en el filtro en ingles (para que busque bien en la base de datos)
  final Map<String, String> _translations = {
    'Macho': 'male',
    'Hembra': 'female',
    'Pequeño': 'small',
    'Mediano': 'medium',
    'Grande': 'large',
    'Cachorro': 'puppy',
    'Adulto': 'adult',
    'Senior': 'senior',
    'Baja': 'low',
    'Media': 'medium',
    'Alta': 'high',
  };

  // Traducciones Inglés -> Español (inverso del anterior)
  // Cuando volvamos a entrar al filtro, como los valores se guardaron en estado en ingles para poder pasarlos al widget padre
  // tendremos que volver a traducirlos al español, para mostrar los filtros que ya estaban activos en la pantalla anteriormente
  final Map<String, String> _translationsInverse = {
    'male': 'Macho',
    'female': 'Hembra',
    'small': 'Pequeño',
    'medium': 'Mediano',
    'large': 'Grande',
    'puppy': 'Cachorro',
    'adult': 'Adulto',
    'senior': 'Senior',
    'low': 'Baja',
    'medium': 'Media',
    'high': 'Alta',
  };

  @override
  void initState() {
    super.initState();
    // Inicializa las selecciones locales con las recibidas del widget padre
    _selectedSex = widget.selectedSex;
    _selectedSize = widget.selectedSize;
    _selectedAge = widget.selectedAge;
    _selectedEnergyLevel = widget.selectedEnergyLevel;
  }

  // Limpia todos los filtros seleccionados
  void _clearFilters() {
    setState(() {
      _selectedSex.clear();
      _selectedSize.clear();
      _selectedAge.clear();
      _selectedEnergyLevel.clear();
    });
  }

  // Traduce un conjunto de valores al inglés antes de devolverlos
  Set<String> _translateValues(Set<String> values) {
    return values.map((value) => _translations[value] ?? value).toSet();
  }

  // Aplica los filtros traducidos al inglés y los devuelve al widget padre
  void _applyFilters() {
    Navigator.pop(context, {
      'sex': _translateValues(_selectedSex),
      'size': _translateValues(_selectedSize),
      'age': _translateValues(_selectedAge),
      //'energyLevel': _translateValues(_selectedEnergyLevel),
    });
  }

  // Construye el cuerpo principal de la pantalla con los filtros
  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila de filtros para "Sexo"
            _buildFilterRow("Sexo", ['Macho', 'Hembra'], _selectedSex),
            const SizedBox(height: 13.0),
            // Fila de filtros para "Tamaño"
            _buildFilterRow(
                "Tamaño", ['Pequeño', 'Mediano', 'Grande'], _selectedSize),
            const SizedBox(height: 13.0),
            // Fila de filtros para "Edad"
            _buildFilterRow(
                "Edad", ['Cachorro', 'Adulto', 'Senior'], _selectedAge),
            const Spacer(),
            // Fila de filtros para "Nivel de energía"
            //_buildFilterRow("Nivel energía", ['Baja', 'Media', 'Alta'], _selectedEnergyLevel),
            //const Spacer(),
            // Botones para aplicar o borrar filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    //minWidth: 140.0,
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                    onPressed: _clearFilters, // Aplica los filtros
                    child: const Text('Borrar Filtros'),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: _applyFilters, // Borra los filtros
                    child: const Text('Aplicar Filtros'),
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
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Filtros'),
      ),
      body: _buildBody(),
    );
  }

  // Construye una fila de filtros con checkboxes
  Widget _buildFilterRow(
      String title, List<String> values, Set<String> selectedValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la fila (e.g., "Sexo", "Tamaño")
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10.0,
          children: values.map((value) {
            // Traduce el valor al idioma interno si es necesario
            final translatedValue = _translations[value] ?? value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkbox para el valor
                Checkbox(
                  value: selectedValues.contains(translatedValue),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        selectedValues
                            .add(translatedValue); // Agrega el valor traducido
                      } else {
                        selectedValues.remove(
                            translatedValue); // Elimina el valor traducido
                      }
                    });
                  },
                ),
                Text(value), // Muestra el valor en español
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
