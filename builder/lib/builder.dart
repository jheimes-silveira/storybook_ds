import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'storybook_model_generator.dart';

Builder storybookModelBuilder(BuilderOptions options) =>
    PartBuilder([StorybookModelGenerator()], '.storybook.g.dart');
