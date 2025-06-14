import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LaundryAnimations {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<Offset> bottomSheetSlideAnimation;
  final Animation<double> bottomSheetFadeAnimation;
  final ScrollController scrollAnimationController;
  final AnimationController bottomSheetAnimationController;

  const LaundryAnimations({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.bottomSheetSlideAnimation,
    required this.bottomSheetFadeAnimation,
    required this.scrollAnimationController,
    required this.bottomSheetAnimationController,
  });
}

LaundryAnimations useLaundryAnimations(String? selectedServiceId) {
  // Animation Controllers
  final fadeAnimationController = useAnimationController(duration: const Duration(milliseconds: 1000));
  final slideAnimationController = useAnimationController(duration: const Duration(milliseconds: 1000));
  final bottomSheetAnimationController = useAnimationController(duration: const Duration(milliseconds: 1000));
  final scrollAnimationController = useScrollController();

  // Create animations
  final fadeAnimation = useMemoized(
    () => Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeAnimationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut))),
    [fadeAnimationController],
  );

  final slideAnimation = useMemoized(
    () => Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideAnimationController, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic))),
    [slideAnimationController],
  );

  final bottomSheetSlideAnimation = useMemoized(
    () => Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: bottomSheetAnimationController, curve: Curves.easeOutCubic)),
    [bottomSheetAnimationController],
  );

  final bottomSheetFadeAnimation = useMemoized(
    () => Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: bottomSheetAnimationController, curve: const Interval(0.0, 0.8, curve: Curves.easeOut))),
    [bottomSheetAnimationController],
  );

  // Start initial animations when widget is first built
  useEffect(() {
    fadeAnimationController.forward();
    slideAnimationController.forward();
    return null;
  }, []); // Empty dependency list to run only once

  // Handle bottom sheet animation based on selection
  useEffect(() {
    if (selectedServiceId != null) {
      bottomSheetAnimationController.forward();
    } else {
      bottomSheetAnimationController.reverse();
    }
    return null;
  }, [selectedServiceId]); // Dependency on selectedServiceId

  return LaundryAnimations(
    fadeAnimation: fadeAnimation,
    slideAnimation: slideAnimation,
    bottomSheetSlideAnimation: bottomSheetSlideAnimation,
    bottomSheetFadeAnimation: bottomSheetFadeAnimation,
    scrollAnimationController: scrollAnimationController,
    bottomSheetAnimationController: bottomSheetAnimationController,
  );
}
