import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class FadeShimmerLoading extends StatelessWidget {
  const FadeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, i) {
          final delay = (i * 300);
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                FadeShimmer.round(
                  size: 40,
                  fadeTheme: FadeTheme.light,
                  millisecondsDelay: delay,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      height: 8,
                      width: 150,
                      radius: 4,
                      millisecondsDelay: delay,
                      fadeTheme: FadeTheme.light,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    FadeShimmer(
                      height: 8,
                      millisecondsDelay: delay,
                      width: 170,
                      radius: 4,
                      fadeTheme: FadeTheme.light,
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: 20,
        separatorBuilder: (_, __) => const SizedBox(
          height: 16,
        ),
      ),
    );
  }
}
