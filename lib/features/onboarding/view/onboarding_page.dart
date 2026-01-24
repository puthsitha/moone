import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/common/common.dart' hide Icons;
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/features/onboarding/view/onboarding_content.dart';
import 'package:monee/widgets/widgets.dart';

class OnboardingContent {
  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
  final String image;
  final String title;
  final String description;
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: OnboardingPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const OnboardingView();
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: ImagePaths.onboarding1,
      title: 'Take Control of Your Money',
      description:
          'Track your income and expenses easily, see where your money goes every day.',
    ),
    OnboardingContent(
      image: ImagePaths.onboarding2,
      title: 'Save Smart, Reach Your Goals',
      description:
          'Set saving goals and stay motivated with daily reminders to reach them faster.',
    ),
  ];

  Future<void> _onNextPressed() async {
    if (_currentPage < _contents.length - 1) {
      await _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(Pages.app.name);
    }
  }

  void _onSkipPressed() {
    context.goNamed(Pages.app.name);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingContentWidget(
                    content: _contents[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onSkipPressed,
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    onPress: _onNextPressed,
                    child: Row(
                      spacing: Spacing.s,
                      children: [
                        Text(
                          _currentPage == _contents.length - 1
                              ? 'Start'
                              : 'Next',
                        ),
                        if (_currentPage == _contents.length - 1)
                          const Icon(Icons.check)
                        else
                          const Icon(Icons.arrow_right_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
