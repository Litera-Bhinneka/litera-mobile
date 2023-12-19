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
              color: const Color.fromARGB(255, 255, 207, 63), // You can set the color based on your design
              size: 20.0, // Adjust the size of the star icon
            );
          } else if (index == integerPart && decimalPart > 0) {
            // Partial star for decimal part (only if decimal part is greater than 0)
            return FaIcon(
              FontAwesomeIcons.solidStar,
              color: Color.fromARGB(255, 255, 207, 63).withOpacity(0.5), // Adjust the opacity for partial stars
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

class StarRatingInput extends StatefulWidget {
  final int rating; // Rating out of 5
  final ValueChanged<int>? onRatingChanged;
  final FormFieldValidator<int>? validator;

  StarRatingInput({super.key, required this.rating, this.onRatingChanged, this.validator});

  @override
  _StarRatingInputState createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  final double starSize = 28.0; // Set the size of each star

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) => GestureDetector(
            onTap: () {
              int newRating = index + 1;
              if (widget.rating == newRating) {
                newRating = 0;
              }

              String? error = widget.validator?.call(newRating);
              if (error == null) {
                widget.onRatingChanged?.call(newRating);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0), // Set the gap between stars
              child: Icon(
                index < widget.rating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                color: Color.fromARGB(255, 255, 207, 63),
                size: starSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}