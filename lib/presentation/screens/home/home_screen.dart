import 'package:flutter/material.dart';
import 'package:game_library/presentation/screens/gameDetails/gameDetails_screen.dart';
import 'package:game_library/provider/games_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<GamesProvider>().fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _GameListCard(),
    );
  }
}

class _GameListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final games = context.watch<GamesProvider>().games;

    return SafeArea(
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _AnimatedGameCard(game: game);
        },
      ),
    );
  }
}

class _AnimatedGameCard extends StatefulWidget {
  final dynamic game;

  const _AnimatedGameCard({required this.game});

  @override
  State<_AnimatedGameCard> createState() => _AnimatedGameCardState();
}

class _AnimatedGameCardState extends State<_AnimatedGameCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 120), () {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => GameDetailsScreen(id: widget.game.id),
      ),
    );
  });
        
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Card(
          margin: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                widget.game.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.game.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}