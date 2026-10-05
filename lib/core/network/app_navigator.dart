import 'package:flutter/material.dart';

/// Global navigator key used to navigate from outside the widget tree
/// (e.g. Dio interceptors) when the auth token expires (HTTP 401).
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();