import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Để tạo một Grid không chiếm toàn bộ khoảng trống => Sử dụng shrinkWrap = true
    // Làm cho Grid không cuộn được => set physics = NeverScrollableScrollPhysics();

    // Cách 1: Đơn giản
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 225,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: List.generate(
        12,
        (index) => Shimmer.fromColors(
          baseColor: Colors.white.withAlpha(100),
          highlightColor: Colors.grey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColoredBox(
              color: Colors.white.withAlpha(100),
            ),
          ),
        ),
      ),
    );

    // or
    // Cách 2:
    // return CustomScrollView(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(), // Disable scrolling
    //   slivers: [
    //     SliverGrid(
    //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 3, // Number of columns
    //         mainAxisSpacing: 10,
    //         crossAxisSpacing: 10,
    //         childAspectRatio: 2 / 3,
    //       ),
    //       delegate: SliverChildBuilderDelegate(
    //         (ctx, index) {
    //           // Replace this with your colored boxes or widgets
    //           return Shimmer.fromColors(
    //             baseColor: Colors.white.withAlpha(100),
    //             highlightColor: Colors.grey,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(4),
    //               child: ColoredBox(
    //                 color: Colors.white.withAlpha(100),
    //               ),
    //             ),
    //           );
    //         },
    //         childCount: 12, // Number of boxes in the grid
    //       ),
    //     ),
    //   ],
    // );
  }
}
