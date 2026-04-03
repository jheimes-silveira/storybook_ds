# Storybook Design System

Flutter package to build a **storybook** for your Design System: attribute panel, live preview, and generated code snippet.

**Live demo:** [showroom-ds.web.app](https://showroom-ds.web.app/#/)

**Reference implementation:** [`example/lib/`](example/lib/) — especially [`custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) and [`main.dart`](example/lib/main.dart).

---

## Install

```bash
flutter pub add storybook_ds
```

```yaml
dependencies:
  flutter:
    sdk: flutter
  storybook_ds: ^1.2.5
```

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

---

## Step-by-step: add a story screen

This follows the same structure as the `CustomCard` example.

### 1. Host the story in your app

Wrap the story with `MaterialApp`. If the story can change the global theme, keep `ThemeData` in state (see `main.dart`):

```dart
home: MyWidgetStorybook(
  onThemeChanged: (ThemeData next) {
    setState(() => _appTheme = next);
  },
),
```

### 2. Create the story `StatefulWidget`

```dart
class MyWidgetStorybook extends StatefulWidget {
  const MyWidgetStorybook({super.key, required this.onThemeChanged});

  final ValueChanged<ThemeData> onThemeChanged;

  @override
  Storybook<MyWidgetStorybook> createState() => _MyWidgetStorybookState();
}
```

### 3. `State` extends `Storybook<...>`

Implement:

| Member | Purpose |
|--------|---------|
| `String get title` | Panel title |
| `String get description` | Short description |
| `String get nameObjectInDisplay` | Class name in the code snippet (e.g. `CustomCard`) |
| `List<AttributeDto> attributes` | Panel controls |
| `Widget buildComponentWidget(BuildContext)` | Widget shown in the preview |

Minimal getters:

```dart
@override
String get title => 'My widget';

@override
String get description => 'Short description for DS consumers.';

@override
String get nameObjectInDisplay => 'MyWidget';
```

### 4. Define `attributes`

Each `AttributeDto` is one control. **`name`** is the key for **`getWhereAttribut('name')`**.

Use factories where useful: `AttributeDto.enumType`, `AttributeDto.rangeDoubleInterval`, `AttributeDto.objectInObject`, `StorybookAttributeFactories.factoryAttributeDtoString`, etc.

### 5. The `builders` field

A **list of strings** saying which constructors/factories include that attribute:

| Value | Meaning |
|--------|---------|
| `''` | **Default** (unnamed) constructor |
| `'inline'`, `'outline'`, … | Same labels you compare against **`selectedConstructor`** |

Use **`''`**, not `null`, for the default.  
If you omit `builders`, many factories default to `['']` (default constructor only).

**Tip:** file-level constants avoid typos, as in the example:

```dart
const _all = ['', 'inline', 'outline'];
const _defaultOnly = [''];
```

Attributes that exist **only** on the default constructor use `builders: _defaultOnly`.

### 6. Implement `buildComponentWidget`

1. Read values with **`getWhereAttribut('attributeName')`** (cast when needed).
2. Branch on **`selectedConstructor`**:
   - **`selectedConstructor.isEmpty`** → default constructor (same as `''` in `builders`).
   - **`selectedConstructor == 'inline'`** → named factory `inline`, etc.

Same pattern as the example:

```dart
@override
Widget buildComponentWidget(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (selectedConstructor.isEmpty) _buildDefault(),
          if (selectedConstructor == 'inline') _buildInline(),
          if (selectedConstructor == 'outline') _buildOutline(),
        ],
      ),
    ),
  );
}
```

Optional helper: `T? _knob<T>(String name) => getWhereAttribut(name) as T?;`

### 7. Optional themes (`MultipleThemeSettings`)

Assign **`multipleThemeSettings` in `initState`** (field is provided by base `Storybook`):

```dart
@override
void initState() {
  super.initState();
  multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'Light / dark',
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
      ),
    ],
  );
}
```

Forward the chosen theme in **`onUpdateTheme`**:

```dart
@override
void onUpdateTheme(MultipleThemeSettings settings) {
  widget.onThemeChanged(settings.selectedThemes.currentTheme());
}
```

---

## Nested objects in the panel

For `AttributeDto.objectInObject`, pass **`merge`**: `(instance, fieldName, newValue)` returning the updated object. Implement by hand or generate with **`@StorybookModel()`** and **`storybook_ds_builder`** (see [`example/build.yaml`](example/build.yaml) and [`builder/`](builder/)).

---

## No `reflectable`

This package **does not** use `reflectable`. Build your `AttributeDto` list manually (or generate only the `merge` helper). See [`CHANGELOG.md`](CHANGELOG.md).

---

## Reflection-free code generation (optional)

Flutter has no `dart:mirrors` on mobile/web. For **`merge`** helpers:

1. Add **`storybook_ds_builder`** + **`build_runner`** as `dev_dependencies`.
2. Restrict `build.yaml` `generate_for` to files with `@StorybookModel` (see [`example/build.yaml`](example/build.yaml)).
3. Annotate plain data classes, add `part '*.storybook.g.dart'`, run `dart run build_runner build --delete-conflicting-outputs`.
4. Wire `mergeMyModel` into `AttributeDto.objectInObject`.

If `pub get` fails between `build_runner` and the builder, pin **`build_runner: 2.4.13`** like [`example/pubspec.yaml`](example/pubspec.yaml).

---

## Cheat sheet

1. `StatefulWidget` → `State extends Storybook<T>`.
2. Implement `title`, `description`, `nameObjectInDisplay`, `attributes`, `buildComponentWidget`.
3. `builders`: `''` = default; other strings = same tokens as `selectedConstructor`.
4. `getWhereAttribut` + `selectedConstructor.isEmpty` / `== 'name'`.
5. Themes: `initState` + `onUpdateTheme` when needed.
