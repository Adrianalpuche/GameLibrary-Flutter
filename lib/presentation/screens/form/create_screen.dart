import 'package:flutter/material.dart';
import 'package:game_library/config/Theme/Colors.dart';
import 'package:game_library/models/games.dart';
import 'package:game_library/provider/games_provider.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _Formulary(),
        ),
      ),
    );
  }
}

class _Formulary extends StatefulWidget {
  const _Formulary();

  @override
  State<_Formulary> createState() => _FormularyState();
}

class _FormularyState extends State<_Formulary> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Genre? genreId;
  Developer? developerId;
  DateTime _releaseDate = DateTime.now();
  bool _submitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<Genre> _uniqueGenres(List<Games> games) {
    final seen = <int>{};
    return games
        .map((g) => g.genre)
        .where((genre) => seen.add(genre.id))
        .toList();
  }

  List<Developer> _uniqueDevelopers(List<Games> games) {
    final seen = <int>{};
    return games
        .map((g) => g.developer)
        .where((dev) => seen.add(dev.id))
        .toList();
  }

  Future<void> _submitForm() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    if (genreId == null || developerId == null) return;

    try {
      await context.read<GamesProvider>().postGame(
            _titleController.text,
            _imageUrlController.text,
            _descriptionController.text,
            genreId!.id,      
            developerId!.id,  
            _releaseDate,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Juego creado exitosamente')),
      );

      _titleController.clear();
      _imageUrlController.clear();
      _descriptionController.clear();
      setState(() {
        genreId = null;
        developerId = null;
        _releaseDate = DateTime.now();
        _submitted = false;
        
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
   
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _releaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _releaseDate = pickedDate);
    }
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final games = context.watch<GamesProvider>().games;
    final genres = _uniqueGenres(games);
    final developers = _uniqueDevelopers(games);

    InputDecoration fieldDecoration({
      required String hintText,
      required Widget prefixIcon,
    }) =>
        InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: colors.surface,
          border: _border(colors.border),
          enabledBorder: _border(colors.border),
          focusedBorder: _border(colors.accent, width: 2),
          errorBorder: _border(Colors.red),
          focusedErrorBorder: _border(Colors.red, width: 2),
        );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(text: 'Título'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _titleController,
            style: TextStyle(color: colors.text),
            decoration: fieldDecoration(
              hintText: 'Ej. The Legend of Zelda',
              prefixIcon: Icon(Icons.title, color: colors.accent),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'El título es requerido';
              if (v.trim().length < 2) return 'Mínimo 2 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 24),

          _SectionHeader(icon: Icons.image_outlined, label: 'Multimedia'),
          const SizedBox(height: 14),
          _FieldLabel(text: 'URL de imagen'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _imageUrlController,
            keyboardType: TextInputType.url,
            style: TextStyle(color: colors.text),
            decoration: fieldDecoration(
              hintText: 'https://example.com/cover.jpg',
              prefixIcon: Icon(Icons.link, color: colors.accent),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'La URL de imagen es requerida';
              }
              final uri = Uri.tryParse(v.trim());
           if (uri == null || !(uri.hasScheme && uri.hasAuthority)) {
            return 'Ingresa una URL válida';
}
              return null;
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(text: 'Descripción'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            style: TextStyle(color: colors.text),
            decoration: fieldDecoration(
              hintText: 'Escribe una descripción del videojuego...',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Icon(Icons.description_outlined, color: colors.accent),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'La descripción es requerida';
              }
              if (v.trim().length < 10) return 'Mínimo 10 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 24),

          _SectionHeader(icon: Icons.category_outlined, label: 'Clasificación'),
          const SizedBox(height: 14),

          _FieldLabel(text: 'Género'),
          const SizedBox(height: 6),
          DropdownButtonFormField<Genre>(
            initialValue: genreId,
            decoration: fieldDecoration(
              hintText: 'Selecciona un género',
              prefixIcon: Icon(Icons.games_outlined, color: colors.accent),
            ),
            dropdownColor: colors.surface,
            style: TextStyle(color: colors.text),
            icon: Icon(Icons.keyboard_arrow_down, color: colors.accent),
            items: genres
                .map((g) => DropdownMenuItem<Genre>(
                      value: g,
                      child: Text(g.name),
                    ))
                .toList(),
            onChanged: (v) => setState(() => genreId = v),
            validator: (_) {
              if (_submitted && genreId == null) {
                return 'Selecciona un género';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _FieldLabel(text: 'Desarrollador'),
          const SizedBox(height: 6),
          DropdownButtonFormField<Developer>(
            initialValue: developerId,
            decoration: fieldDecoration(
              hintText: 'Selecciona un desarrollador',
              prefixIcon: Icon(Icons.business_outlined, color: colors.accent),
            ),
            dropdownColor: colors.surface,
            style: TextStyle(color: colors.text),
            icon: Icon(Icons.keyboard_arrow_down, color: colors.accent),
            items: developers
                .map((d) => DropdownMenuItem<Developer>(
                      value: d,
                      child: Text(d.name), 
                    ))
                .toList(),
            onChanged: (v) => setState(() => developerId = v),
            validator: (_) {
              if (_submitted && developerId == null) {
                return 'Selecciona un desarrollador';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          _SectionHeader(
              icon: Icons.calendar_today_outlined, label: 'Lanzamiento'),
          const SizedBox(height: 14),
          _FieldLabel(text: 'Fecha de lanzamiento'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: colors.accent, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${_releaseDate.day.toString().padLeft(2, '0')}/'
                    '${_releaseDate.month.toString().padLeft(2, '0')}/'
                    '${_releaseDate.year}',
                    style: TextStyle(color: colors.text, fontSize: 16),
                  ),
                  const Spacer(),
                  Icon(Icons.edit_calendar_outlined,
                      color: colors.label, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save_alt_rounded),
            label: const Text(
              'Guardar Juego',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Row(
      children: [
        Icon(icon, color: colors.accent, size: 18),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: colors.accent,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.accent.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Text(
      text,
      style: TextStyle(
        color: colors.label,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}