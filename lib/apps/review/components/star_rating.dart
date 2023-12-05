import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StarRating extends StatelessWidget {
  final double rating; // Rating out of 5

  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    // Ensure that rating is between 0 and 5
    double clampedRating = rating.clamp(0.0, 5.0);

    // Calculate the integer part of the rating
    int integerPart = clampedRating.floor();

    // Calculate the decimal part of the rating and convert it to a percentage
    double decimalPart = clampedRating - integerPart;
    double percentage = decimalPart * 100;

    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < integerPart) {
            // Full star for integer part
            return FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.amber, // You can set the color based on your design
              size: 20.0, // Adjust the size of the star icon
            );
          } else if (index == integerPart && decimalPart > 0) {
            // Partial star for decimal part (only if decimal part is greater than 0)
            return FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.amber.withOpacity(0.5), // Adjust the opacity for partial stars
              size: 20.0,
            );
          } else {
            // Empty star for the remaining
            return FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.grey, // You can set the color based on your design
              size: 20.0, // Adjust the size of the star icon
            );
          }
        },
      ),
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}