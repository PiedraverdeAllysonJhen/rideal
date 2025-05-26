import 'package:flutter/material.dart';

class PromoSliderWidget extends StatelessWidget {
  const PromoSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: NetworkImage('https://picsum.photos/800/300?random=$index'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}