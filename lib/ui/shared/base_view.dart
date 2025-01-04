import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseView extends StatelessWidget {
  final Widget Function(BuildContext context, Size size) builder;
  final Color? backgroundColor;
  final AppBar? appBar;
  final Widget? drawer;
  final bool resizeToAvoidBottomInset;
  final Function(bool)? onWillPop;
  final Function? onTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool canPop;
  final bool hasPadding;
  const BaseView({
    super.key,
    required this.builder,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.onWillPop,
    this.onTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.scaffoldKey,
    this.hasPadding = true,
    this.canPop = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        Size constraints = Size(constraint.maxWidth, constraint.maxHeight);
        return PopScope(
          canPop: canPop,
          onPopInvoked: onWillPop,
          child: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: backgroundColor ?? const Color(0xffFFFFFF),
              bottomNavigationBar: bottomNavigationBar,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              floatingActionButton: floatingActionButton,
              appBar: appBar,
              drawer: drawer,
              body: SafeArea(
                child: Padding(
                  padding: hasPadding ? EdgeInsets.symmetric(horizontal: 15.w) : EdgeInsets.zero,
                  child: Builder(
                    builder: (context) => builder(context, constraints),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
