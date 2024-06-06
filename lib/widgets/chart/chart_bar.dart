import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill; // Fill percentage for the chart bar

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark; // Check if the current theme is dark mode

    return Expanded( // Expanded widget to fill available space horizontally
      child: Padding( // Add padding around the chart bar
        padding: const EdgeInsets.symmetric(horizontal: 4), // Set horizontal padding
        child: FractionallySizedBox( // A widget that sizes its child to a fraction of its own size
          heightFactor: fill, // Set the height factor based on the fill percentage
          child: DecoratedBox( // A widget that applies a decoration to its child
            decoration: BoxDecoration( // Decoration for the chart bar
              shape: BoxShape.rectangle, // Set the shape to rectangle
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(8)), // Set border radius for the top corners
              color: isDarkMode // Set color based on dark or light mode
                  ? Theme.of(context).colorScheme.secondary // Use secondary color scheme for dark mode
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65), // Use primary color with opacity for light mode
            ),
          ),
        ),
      ),
    );
  }
}
