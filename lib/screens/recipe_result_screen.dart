import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/widgets/confetti_screen.dart';

import '../services/servicee_recipe.dart';

class RecipeResultScreen extends StatefulWidget {
  final String recipeName;
  final List<String> ingredients;
  final List<String> steps;
  final String tips;
  final int wtfLevel;

  const RecipeResultScreen({
    super.key,
    required this.recipeName,
    required this.ingredients,
    required this.steps,
    required this.tips,
    required this.wtfLevel,
  });

  @override
  State<RecipeResultScreen> createState() => _RecipeResultScreenState();
}

class _RecipeResultScreenState extends State<RecipeResultScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _checkedIngredients = {};
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    for (var ingredient in widget.ingredients) {
      _checkedIngredients[ingredient] = false;
    }
    _checkIfFavorite();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkIfFavorite() async {
    final box = Hive.box<Map>('favoriteRecipes');
    final isFavorite = box.containsKey(widget.recipeName);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      _checkedIngredients[ingredient] =
          !(_checkedIngredients[ingredient] ?? false);
    });
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final recipe = {
      'nama_resep': widget.recipeName,
      'bahan': widget.ingredients,
      'langkah': widget.steps,
      'tips': widget.tips,
      'wtfLevel': widget.wtfLevel,
    };

    if (_isFavorite) {
      await HiveService.saveFavoriteRecipe(recipe);
    } else {
      await HiveService.removeFavoriteRecipe(widget.recipeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.recipeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.orange[300]!,
                            Colors.orange[800]!,
                          ],
                        ),
                      ),
                    ),
                    // WTF Level Indicator
                    if (widget.wtfLevel > 3)
                      Positioned(
                        top: 60,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.whatshot, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'WTF Level ${widget.wtfLevel}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFavorite, // Toggle favorit
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.orange[800],
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.orange[800],
                  tabs: const [
                    Tab(text: 'Bahan'),
                    Tab(text: 'Langkah'),
                    Tab(text: 'Tips'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Ingredients Tab
            _buildIngredientsTab(),

            // Steps Tab
            _buildStepsTab(),

            // Tips Tab
            _buildTipsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.orange[800],
        icon: const Icon(Icons.refresh),
        label: const Text('Buat Resep Baru'),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.ingredients[index];
        return Card(
          elevation: 0,
          color: Colors.grey[50],
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            title: Text(
              ingredient,
              style: TextStyle(
                decoration: _checkedIngredients[ingredient] == true
                    ? TextDecoration.lineThrough
                    : null,
                color: _checkedIngredients[ingredient] == true
                    ? Colors.grey
                    : Colors.black87,
              ),
            ),
            value: _checkedIngredients[ingredient],
            onChanged: (_) => _toggleIngredient(ingredient),
            activeColor: Colors.orange[800],
          ),
        );
      },
    );
  }

  Widget _buildStepsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.grey[50],
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.orange[800],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.steps[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      Text(
                        'Tips Penyajian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.tips,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Lottie.asset(
              'assets/animations/cooking_pot.json',
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
