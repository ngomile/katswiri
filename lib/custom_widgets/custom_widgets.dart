import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:katswiri/app_theme.dart';

export 'job_model_widgets.dart';
export 'job_list_retriever.dart';
export 'tabbed_sources.dart';
export 'button_widgets.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class AppThemeBuilder extends StatelessWidget {
  const AppThemeBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    ({
      ThemeData lightTheme,
      ThemeData darkTheme,
    }) appTheme,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) => builder(
        context,
        fillWith(
          light: light,
          dark: dark,
        ),
      ),
    );
  }
}
