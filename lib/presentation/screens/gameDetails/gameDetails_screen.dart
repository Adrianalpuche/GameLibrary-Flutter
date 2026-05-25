import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_library/config/Theme/Colors.dart';
import 'package:game_library/models/games.dart';
import 'package:game_library/presentation/screens/form/update_screen.dart';
import 'package:game_library/provider/games_provider.dart';
import 'package:provider/provider.dart';

class GameDetailsScreen extends StatefulWidget {
  final int id;

  const GameDetailsScreen({super.key, required this.id});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GamesProvider>().fetchGameDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: _GameDetailsCard(id: widget.id)),
    );
  }
}

class _GameDetailsCard extends StatelessWidget {
  final int id;

  const _GameDetailsCard({required this.id});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GamesProvider>().gameDetails[id];

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          child: game != null
              ? Image.network(game.imageUrl, fit: BoxFit.cover)
              : const Text('Loading...'),
        ),
        Positioned(top: 20, left: 5, child: _BackButton(context)),
        _DetailsSheet(game: game),
      ],
    );
  }

  Widget _BackButton(BuildContext context) {
      final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        Navigator.pop(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child:  Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: colors.accentLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  final Games? game;
  const _DetailsSheet({this.game});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.58,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: colors.border, width: 0.5)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.label.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              if (game?.genre != null) ...[
                _GenreChip(name: game!.genre.name),
                const SizedBox(height: 12),
              ],

              Text(
                game?.title ?? 'Cargando...',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),

              _DeveloperRow(name: game?.developer.name),
              const SizedBox(height: 20),

              _StatsRow(game: game),
              const SizedBox(height: 22),

              Text(
                'SINOPSIS',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: colors.textFaint,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                game?.description ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textMuted,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 28),

              _ButtonUpdate(game: game,),
              const SizedBox(height: 10),
              _ButtonDelete(id: game?.id ?? 0),
            ],
          ),
        );
      },
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String name;
  const _GenreChip({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color: colors.accentLight,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _DeveloperRow extends StatelessWidget {
  final String? name;
  const _DeveloperRow({this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    final initials = name != null && name!.isNotEmpty
        ? name!.trim().split(' ').take(2).map((w) => w[0]).join()
        : '?';

    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.accentDark, colors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'por ',
          style: TextStyle(
            fontSize: 13,
            color: colors.label.withValues(alpha: 0.4),
          ),
        ),
        Text(
          name ?? 'Desconocido',
          style: TextStyle(
            fontSize: 13,
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Games? game;
  const _StatsRow({this.game});

  @override
  Widget build(BuildContext context) {
    final year = game != null ? game!.releaseDate.year.toString() : '—';

    return Row(
      children: [
        _StatCard(label: 'Lanzamiento', value: year),
        const SizedBox(width: 10),
        _StatCard(label: 'Género', value: game?.genre.name ?? '—'),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Estudio',
          value: _shortName(game?.developer.name),
          accent: true,
        ),
      ],
    );
  }

  String _shortName(String? name) {
    if (name == null) return '—';
    final words = name.trim().split(' ');
    return words.length > 1 ? words.first : name;
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;
  const _StatCard({
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 0.8,
                color: colors.label.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accent ? colors.accentLight : colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonDelete extends StatelessWidget {
  final int id;
  const _ButtonDelete({required this.id});
  @override
  Widget build(BuildContext context) {
    final deleteGame = context.watch<GamesProvider>().deleteGame;
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.btnDelete, colors.btnDegrade],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            deleteGame(id);
            Future.delayed(const Duration(milliseconds: 120), () {
              Navigator.pop(context);
            });
          },
          child: const Center(
            child: Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonUpdate extends StatelessWidget {
    final Games? game;
    const _ButtonUpdate({required this.game});


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.btnUpdate, colors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UpdateScreen(id: game?.id ?? 0)),
            );
          },
          child: const Center(
            child: Text(
              'Actualizar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
