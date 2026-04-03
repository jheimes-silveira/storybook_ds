import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Indicate whether [child] uses an inherited [MediaQuery].
///
/// Note that its will try its best to evaluate this by seeing if child is a [WidgetsApp] and will eventually
/// look at children if child is a [ProxyWidget], [MultiChildRenderObjectWidget] or [SingleChildRenderObjectWidget].
bool isWidgetsAppUsingInheritedMediaQuery(
  Widget child, [
  bool fallback = true,
]) {
  // Flutter 3.7+: [MaterialApp]/[CupertinoApp] no longer override [MediaQuery];
  // [useInheritedMediaQuery] exists only for compatibility and is ignored.
  // DevicePreview already wraps the app in an explicit [MediaQuery].
  if (child is MaterialApp || child is CupertinoApp || child is WidgetsApp) {
    return true;
  }

  if (child is ProxyWidget) {
    return isWidgetsAppUsingInheritedMediaQuery(child.child);
  }
  if (child is SingleChildRenderObjectWidget) {
    return child.child == null ||
        isWidgetsAppUsingInheritedMediaQuery(child.child!);
  }

  if (child is MultiChildRenderObjectWidget) {
    return child.children.every(isWidgetsAppUsingInheritedMediaQuery);
  }

  return fallback;
}
