# Storybook Design System

Flutter package to build a **storybook** for your Design System: an attribute panel, a live preview of your component, and an auto-generated code snippet.

**Live demo:** [showroom-ds.web.app](https://showroom-ds.web.app/#/)

**Reference implementation:** see [`example/lib/`](example/lib/) — in particular:

- [`example/lib/main.dart`](example/lib/main.dart) — boots the app.
- [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) — the `CustomCard` story.
- [`example/lib/custom_card.dart`](example/lib/custom_card.dart) — the widget itself (with `@StorybookModel` for the nested config object).
- [`example/lib/sample_themes.dart`](example/lib/sample_themes.dart) — sample Material 3 themes.
- [`example/lib/storybook_example_attributes.dart`](example/lib/storybook_example_attributes.dart) — a reusable `colorPicker` factory.

> Since version **1.2.5** the package **no longer uses `reflectable`** (reflection does not run on Flutter AOT). Since **1.3.0**, all internal references to `AttributeDto` have been renamed to `AttributeModel`. `AttributeDto` remains as a deprecated type alias for backwards compatibility. You build the `AttributeModel` list **by hand** (this guide shows how) or use the optional `storybook_ds_builder` (with `build_runner`) only to generate `merge*` helpers for nested objects.

---

## 1. Install

In an existing Flutter app:

```bash
flutter pub add storybook_ds
```

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  storybook_ds: ^1.3.0
```

Single import you'll use everywhere:

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

To use the `merge*` generator (nested objects), add to `dev_dependencies`:

```yaml
dev_dependencies:
  build_runner: 2.4.13
  storybook_ds_builder: ^1.0.0
```

> If `pub get` complains about a conflict between `build_runner` and the builder, **pin `build_runner` to `2.4.13`** as in [`example/pubspec.yaml`](example/pubspec.yaml).

---

## 2. What the package gives you

The abstract base is the `Storybook<T>` class. You extend it in a `State` and the package draws, around your widget:

1. A **preview** (with `DevicePreview` and theme switching).
2. A **left-side attribute panel** with the knobs you declared.
3. A **code snippet** that shows how to instantiate the widget with the current values.

To make that work, your `State` has to implement:

| Member | Required? | Purpose |
|--------|-----------|---------|
| `String get title` | yes | Story title |
| `String get description` | yes | Short description |
| `String get nameObjectInDisplay` | yes | Class name in the snippet (e.g. `CustomCard`) |
| `List<AttributeModel> get attributes` | yes | The panel controls |
| `Widget buildComponentWidget(BuildContext)` | yes | Your widget being rendered |
| `MultipleThemeSettings? multipleThemeSettings` | optional | Switch themes in the preview |
| `OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom` | optional | Extra UI in the panel |
| `StorybookTheme? get storybookTheme` | optional | Colors of the storybook chrome |

There's no magic: you describe **a list of knobs** and the panel renders the editors automatically (`String`, `bool`, `int`, `double` range, `enum`, `Color`, `Function?`, nested object).

---

## 3. Step-by-step: build a story screen from scratch

I'll use the `CustomCard` from the example as a reference. By the end of these steps you'll have a story like [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) and your widget (`CustomCard` here) as a regular `StatefulWidget`.

### Step 1 — Host the story inside a `MaterialApp`

The story must live **inside a `MaterialApp`**. If you want the global theme to change when the user picks a theme in the panel, keep `ThemeData` in state:

```dart
// example/lib/main.dart
import 'package:flutter/material.dart';

import 'custom_card_storybook.dart';

void main() {
  runApp(const StorybookDemoApp());
}

class StorybookDemoApp extends StatefulWidget {
  const StorybookDemoApp({super.key});

  @override
  State<StorybookDemoApp> createState() => _StorybookDemoAppState();
}

class _StorybookDemoAppState extends State<StorybookDemoApp> {
  ThemeData _appTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storybook DS — example',
      theme: _appTheme,
      debugShowCheckedModeBanner: false,
      home: CustomCardStorybook(
        onThemeChanged: (ThemeData next) {
          setState(() => _appTheme = next);
        },
      ),
    );
  }
}
```

> **Important detail:** the `CustomCardStorybook` receives a `ValueChanged<ThemeData>` in its constructor. That callback is invoked by the `Storybook` base every time the user picks another theme in the panel.

### Step 2 — The story `StatefulWidget`

```dart
class CustomCardStorybook extends StatefulWidget {
  const CustomCardStorybook({
    super.key,
    required this.onThemeChanged,
  });

  final ValueChanged<ThemeData> onThemeChanged;

  @override
  Storybook<CustomCardStorybook> createState() => _CustomCardStorybookState();
}
```

Notes:

- The class is a regular `StatefulWidget`.
- `createState` returns a `State<...>` that **extends `Storybook<...>`** (the package's base).
- `onThemeChanged` is what wires the panel's selected theme to the `MaterialApp`.

### Step 3 — The `State` extends `Storybook<T>`

```dart
class _CustomCardStorybookState extends Storybook<CustomCardStorybook> {
  @override
  String get description =>
      'Magna et nonumy dolor duo sanctus sed est stet voluptua...';

  @override
  String get nameObjectInDisplay => 'CustomCard';

  @override
  String get title => 'Custom Card';

  @override
  Widget buildComponentWidget(BuildContext context) {
    return const Center(child: Text('work in progress'));
  }
}
```

Four required getters for now. In step 6 we'll fill `buildComponentWidget` properly and in step 4 we'll declare attributes.

### Step 4 — Declare `attributes`

Each `AttributeModel` is **one knob** in the panel. `name` is the key you use later in `getWhereAttribut('name')`.

The most common types (all are *factories* of `AttributeModel`):

| Factory | Control rendered in the panel |
|---------|------------------------------|
| `AttributeModel(name:..., type:'String', ...)` | Free-form text |
| `StorybookAttributeFactories.factoryAttributeDtoString(...)` | Long text with presets at 5, 10, 20, 40, 80, 120 words (great for `description`) |
| `AttributeModel(name:..., type:'bool', ...)` | On/off switch |
| `AttributeModel.enumType(values: ...)` | Enum dropdown |
| `AttributeModel.rangeIntInterval(begin, end, ...)` | Integer slider |
| `AttributeModel.rangeDoubleInterval(begin, end, ...)` | Double slider |
| `AttributeModel.color(...)` | Color picker |
| `AttributeModel.function(...)` | Callback (button) |
| `AttributeModel.objectInObject(...)` | Sub-panel for a nested object (needs `merge`) |

Real example (snippet from [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart)):

```dart
late final List<AttributeModel> attributes = [
  // Required string with long-text presets
  StorybookAttributeFactories.factoryAttributeDtoString(
    name: 'title',
    selectedValue: 'Lorem justo clita tempor labore',
    required: true,
    builders: _cardBuildersAll, // ['', 'inline', 'outline']
  ),

  // Boolean
  AttributeModel(
    name: 'hidden',
    type: 'bool',
    selectedValue: VariableOption(value: false),
    builders: _cardBuildersAll,
  ),

  // Enum
  AttributeModel.enumType(
    name: 'imageDisplay',
    selectedValue: CardImageDisplay.image,
    values: CardImageDisplay.values,
    builders: _cardImageBuildersAll,
  ),

  // Double range
  AttributeModel.rangeDoubleInterval(
    name: 'width',
    begin: 220,
    end: 400,
    canBeNull: true,
    selectedValue: null,
    builders: _cardBuildersAll,
  ),

  // Callback (action button)
  AttributeModel(
    name: 'onPositive',
    type: 'Function()?',
    selectedValue: VariableOption(value: '(){}'),
    builders: _cardBuildersAll,
  ),
];
```

Two valuable tips:

1. **`builders: const ['']`** (empty string) is the **default** (unnamed) constructor. Use `''` for default, never `null`.
2. To reuse combinations, declare file-level constants:

```dart
const _cardBuildersAll = <String>['', 'inline', 'outline'];
const _cardBuilderDefaultOnly = <String>[''];
```

### Step 5 — The `builders` field in detail

`builders` is a `List<String>` saying **which constructors / factories** that attribute appears under in the panel. You compare the value with **`selectedConstructor`** in `buildComponentWidget`.

| Value in `builders` | Meaning |
|---------------------|---------|
| `''` (empty string) | **Default** (unnamed) constructor |
| `'inline'`, `'outline'`, ... | Named factory — use the same label you test in `selectedConstructor == 'inline'` |

Mental example for `CustomCard`:

- The widget has the default constructor `CustomCard(...)` and two factories: `CustomCard.inline(...)` and `CustomCard.outline(...)`.
- The `variant` parameter **only exists in the default constructor** (the factories fix the variant internally). So: `builders: _cardBuilderDefaultOnly` (i.e. `['']`).
- The `imageDisplay` parameter exists in **all** constructors. So: `builders: _cardImageBuildersAll` (i.e. `['', 'inline', 'outline']`).
- Everything else (`title`, `description`, `width`, `height`, `hidden`, `enabled`, `borderEnabled`, `settings`, `onPositive`, `onNegative`, `textPositive`, `textNegative`) also exists in all → `builders: _cardBuildersAll`.

### Step 6 — Implement `buildComponentWidget`

Here you **read the knobs** with `getWhereAttribut('name')` and decide which constructor to use with `selectedConstructor`.

Recommended pattern (a helper for readability):

```dart
T? _knob<T>(String name) => getWhereAttribut(name) as T?;
```

Three builders (one per constructor), each assembling the widget:

```dart
CustomCard _cardDefaultConstructor() {
  return CustomCard(
    title: _knob<String>('title') ?? '',
    variant: _knob<CustomCardVariant>('variant') ?? CustomCardVariant.inline,
    description: _knob<String>('description'),
    settings: _knob<CustomCardSettings>('settings'),
    onNegative: _knob<dynamic>('onNegative') != null ? () {} : null,
    textNegative: _knob<String>('textNegative'),
    onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
    textPositive: _knob<String>('textPositive'),
    height: _knob<double>('height'),
    width: _knob<double>('width'),
    hidden: _knob<bool>('hidden') ?? false,
    enabled: _knob<bool>('enabled') ?? true,
    imageDisplay: _knob<CardImageDisplay>('imageDisplay') ?? CardImageDisplay.image,
    imageUrl: _kDefaultImageUrl,
    borderEnabled: _knob<bool>('borderEnabled') ?? false,
  );
}

CustomCard _cardInlineFactory() { /* CustomCard.inline(...) */ }
CustomCard _cardOutlineFactory() { /* CustomCard.outline(...) */ }
```

And `buildComponentWidget` branching on `selectedConstructor`:

```dart
@override
Widget buildComponentWidget(BuildContext context) {
  final canvasColor = Theme.of(context).scaffoldBackgroundColor;

  return Scaffold(
    backgroundColor: canvasColor,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedConstructor.isEmpty) _cardDefaultConstructor(),
            if (selectedConstructor == 'inline') _cardInlineFactory(),
            if (selectedConstructor == 'outline') _cardOutlineFactory(),
          ],
        ),
      ),
    ),
  );
}
```

Key points:

- **`selectedConstructor.isEmpty`** = default constructor (same as `''` in `builders`).
- **`selectedConstructor == 'inline'`** = the `CustomCard.inline(...)` factory.
- For `Function?` attributes (`onPositive`, `onNegative`), the panel only sends a value when the user enables the knob. Check `_knob<dynamic>('onPositive') != null` before passing a real `() {}`, avoiding accidental null callbacks.

### Step 7 — Optional themes (`MultipleThemeSettings`)

If you want to **switch themes inside the preview**, assign the **`multipleThemeSettings`** field in `initState` (the `Storybook` base already declares that field):

```dart
@override
void initState() {
  super.initState();
  multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'System (default Material)',
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
      ),
      ThemeSettings(
        title: 'M3 — Sage (light / dark)',
        light: buildSampleM3Theme(seedColor: sampleSeedSage, brightness: Brightness.light),
        dark: buildSampleM3Theme(seedColor: sampleSeedSage, brightness: Brightness.dark),
      ),
      // ...other themes
    ],
  );
}
```

And forward the chosen theme to the `MaterialApp` in `onUpdateTheme`:

```dart
@override
void onUpdateTheme(MultipleThemeSettings settings) {
  widget.onThemeChanged(settings.selectedThemes.currentTheme());
}
```

`currentTheme()` returns the right `ThemeData` (light or dark) of the theme the user picked in the panel.

---

## 4. Nested objects in the panel (`AttributeModel.objectInObject`)

When your widget takes a **config object** (e.g. `CustomCardSettings`), you want the panel to let users edit each field of that object separately. To make that work:

1. Annotate the config class with `@StorybookModel()`.
2. Add `part 'my_class.storybook.g.dart';` in that file.
3. Run the generator (it produces a `mergeClassName` function).
4. Use `AttributeModel.objectInObject(...)` with `merge: mergeClassName`.

### 4.1. Annotate the model

```dart
// example/lib/custom_card.dart
import 'package:flutter/material.dart';
import 'package:storybook_ds/annotations.dart';

part 'custom_card.storybook.g.dart';

@StorybookModel()
class CustomCardSettings {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomCardSettings({
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });
}
```

**Requirements** for the class to be valid:

- An **unnamed constructor** with all fields as **named** parameters.
- All fields **public** (no leading `_`).

### 4.2. Configure `build_runner`

In `build.yaml` (at the root of your app / example), limit the generator to annotated files so it doesn't scan the whole project:

```yaml
# example/build.yaml
targets:
  $default:
    builders:
      storybook_ds_builder|storybookModelBuilder:
        generate_for:
          - lib/custom_card.dart
```

In `pubspec.yaml`, ensure the `dev_dependency`:

```yaml
dev_dependencies:
  build_runner: 2.4.13
  storybook_ds_builder: ^1.0.0
```

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This produces `custom_card.storybook.g.dart` with the function `mergeCustomCardSettings(current, fieldName, newValue)`.

### 4.3. Use it in the panel

```dart
AttributeModel.objectInObject(
  name: 'settings',
  type: 'CustomCardSettings?',
  merge: (instance, fieldName, newValue) => mergeCustomCardSettings(
    instance as CustomCardSettings,
    fieldName,
    newValue,
  ),
  children: [
    StorybookExampleAttributes.colorPicker(
      name: 'backgroundColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
    StorybookExampleAttributes.colorPicker(
      name: 'textColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
    StorybookExampleAttributes.colorPicker(
      name: 'borderColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
  ],
  builders: _cardBuildersAll,
  selectedValue: VariableOption(
    value: const CustomCardSettings(
      backgroundColor: null,
      textColor: null,
      borderColor: null,
    ),
  ),
),
```

In `buildComponentWidget`, just forward the object as `settings: _knob<CustomCardSettings>('settings')`. The generator ensures that **on every sub-field edit**, the object is rebuilt with a manual `copyWith`.

### 4.4. Without the generator (optional, manual)

If you don't want to use `build_runner`, write `merge` by hand:

```dart
CustomCardSettings mergeCustomCardSettings(
  CustomCardSettings current,
  String fieldName,
  Object? newValue,
) {
  switch (fieldName) {
    case 'backgroundColor':
      return CustomCardSettings(
        backgroundColor: newValue as Color?,
        textColor: current.textColor,
        borderColor: current.borderColor,
      );
    case 'textColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: newValue as Color?,
        borderColor: current.borderColor,
      );
    case 'borderColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: current.textColor,
        borderColor: newValue as Color?,
      );
    default:
      return current;
  }
}
```

And use it the exact same way in `AttributeModel.objectInObject(merge: ...)`.

---

## 5. Quick recipes

### 5.1. `String` attribute with handy presets (e.g. description)

```dart
StorybookAttributeFactories.factoryAttributeDtoString(
  name: 'description',
  selectedValue: 'Lorem ipsum dolor sit amet...',
  canBeNull: true,
  builders: _cardBuildersAll,
)
```

### 5.2. `enum` attribute

```dart
AttributeModel.enumType(
  name: 'variant',
  selectedValue: CustomCardVariant.outline,
  values: CustomCardVariant.values,
  builders: const [''], // default constructor only
)
```

### 5.3. `bool` attribute

```dart
AttributeModel(
  name: 'borderEnabled',
  type: 'bool',
  selectedValue: VariableOption(value: false),
  builders: _cardBuildersAll,
)
```

### 5.4. `double` slider (with `null` allowed)

```dart
AttributeModel.rangeDoubleInterval(
  name: 'height',
  begin: 160,
  end: 600,
  canBeNull: true,
  selectedValue: null,
  builders: _cardBuildersAll,
)
```

### 5.5. Reusable `Color` attribute (your own factory)

Instead of repeating the same `AttributeModel` with a color list, create a helper:

```dart
// example/lib/storybook_example_attributes.dart
class StorybookExampleAttributes {
  StorybookExampleAttributes._();

  static AttributeModel colorPicker({
    required String name,
    bool canBeNull = false,
    VariableOption? selectedValue,
    List<String> builders = const [''],
  }) {
    return AttributeModel(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      builders: builders,
      selectedValue: selectedValue ?? VariableOption(value: null),
      variableOptions: [
        VariableOption(value: Colors.lime, textInDisplay: 'Colors.lime', textInSelectedOptions: 'lime'),
        VariableOption(value: Colors.black, textInDisplay: 'Colors.black', textInSelectedOptions: 'black'),
        VariableOption(value: Colors.red, textInDisplay: 'Colors.red', textInSelectedOptions: 'red'),
        VariableOption(value: Colors.white, textInDisplay: 'Colors.white', textInSelectedOptions: 'white'),
      ],
    );
  }
}
```

Usage:

```dart
StorybookExampleAttributes.colorPicker(
  name: 'textColor',
  canBeNull: true,
  builders: _cardBuildersAll,
)
```

### 5.6. `Function?` attribute (callback / button)

```dart
AttributeModel(
  name: 'onPositive',
  type: 'Function()?',
  selectedValue: VariableOption(value: '(){}'),
  builders: _cardBuildersAll,
)
```

In the builder:

```dart
onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
```

---

## 6. Cheat sheet

1. `StatefulWidget` → `State extends Storybook<T>`.
2. Implement: `title`, `description`, `nameObjectInDisplay`, `attributes`, `buildComponentWidget`.
3. `builders`: `''` = default constructor; other strings = labels compared in `selectedConstructor`.
4. `getWhereAttribut('name')` to read a knob's value.
5. `selectedConstructor.isEmpty` → default; `selectedConstructor == 'inline'` → `inline` factory.
6. Nested objects: `@StorybookModel()` + `part '*.storybook.g.dart';` + `dart run build_runner build`.
7. Themes: `initState` (assign `multipleThemeSettings`) + `onUpdateTheme` (forward to the app).
8. **No `reflectable`**: the `AttributeModel` list is explicit (you write it), no runtime magic.

---

## 7. Troubleshooting

- **The attribute doesn't show up in the panel?** Check `builders`. If you created a knob with `builders: const ['']`, it only appears for the default constructor.
- **The nested object doesn't update?** You forgot the `merge` in `AttributeModel.objectInObject`. Without it, a `StateError` is thrown when editing a sub-field.
- **`pub get` complaining about `build_runner`?** Pin to `2.4.13` as in [`example/pubspec.yaml`](example/pubspec.yaml).
- **The code snippet shows parameters that don't exist on the current constructor?** Verify the attribute `builders` lists match the active `selectedConstructor`.
