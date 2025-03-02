import 'package:flutter/material.dart';

class IngredientInput extends StatefulWidget {
  final List<String> ingredients;
  final Function(String) onAdd;
  final Function(int) onRemove;

  const IngredientInput({
    super.key,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _addIngredient(String ingredient) {
    if (ingredient.trim().isNotEmpty) {
      widget.onAdd(ingredient.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar Style Input
        Container(
          decoration: BoxDecoration(
            color: _isFocused ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? Colors.orange[300]! : Colors.transparent,
              width: 2,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: Colors.orange[100]!.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Tambahkan bahan makanan...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _isFocused ? Colors.orange[300] : Colors.grey[400],
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: _isFocused ? Colors.orange[300] : Colors.grey[400],
                    ),
                    onPressed: () {
                      // Implementasi input suara
                    },
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.orange[300],
                      ),
                      onPressed: () => _addIngredient(_controller.text),
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: _addIngredient,
            onChanged: (value) {
              // Trigger rebuild untuk menampilkan/sembunyikan tombol add
              setState(() {});
            },
          ),
        ),

        if (widget.ingredients.isNotEmpty) ...[
          const SizedBox(height: 16),

          // Label untuk ingredients
          Text(
            'Bahan yang ditambahkan:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Animated Wrap untuk ingredients chips
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final ingredient = entry.value;
                return AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: 1.0,
                  child: Chip(
                    label: Text(
                      ingredient,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.orange[300],
                    deleteIconColor: Colors.white,
                    onDeleted: () => widget.onRemove(index),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
