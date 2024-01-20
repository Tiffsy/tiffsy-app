import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class LoadingAnimation {
  static const String _animationOne =
      "assets/loading_animations/tiffsy_loading_animation1.json";
  static const String _animationTwo =
      "assets/loading_animations/tiffsy_loading_animation2.json";
  static const String _circularLoadingAnimation =
      "assets/loading_animations/circular_loading_animation.json";
  static const String _emptyPageAnimation =
      "assets/loading_animations/empty_data_animations.json";

  static Widget loadingAnimationOne(BuildContext context) {
    return Center(
      child: Lottie.asset(_animationOne,
          height: MediaQuery.sizeOf(context).height * 0.2,
          repeat: true,
          fit: BoxFit.contain),
    );
  }

  static Widget loadingAnimationTwo(BuildContext context) {
    return Center(
      child: Lottie.asset(_animationTwo,
          height: MediaQuery.sizeOf(context).height * 0.2,
          repeat: true,
          fit: BoxFit.contain),
    );
  }

  static Widget circularLoadingAnimation(BuildContext context) {
    return Center(
      child: Lottie.asset(_circularLoadingAnimation,
          height: MediaQuery.sizeOf(context).height * 0.2,
          repeat: true,
          fit: BoxFit.contain),
    );
  }

  static Widget emptyDataAnimation(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            _emptyPageAnimation,
            height: MediaQuery.sizeOf(context).height * 0.2,
            repeat: false,
            fit: BoxFit.contain,
          ),
          Text(
            message ?? "",
            style: const TextStyle(
              color: Color(0xFF121212),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              letterSpacing: 0.15,
            ),
          )
        ],
      ),
    );
  }
}
