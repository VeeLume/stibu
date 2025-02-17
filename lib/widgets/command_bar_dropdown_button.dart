import 'package:fluent_ui/fluent_ui.dart';

class CommandBarDropdownButton extends CommandBarItem {
  final Widget Function(BuildContext context, void Function()? buttonBuilder)?
      buttonBuilder;
  final List<MenuFlyoutItemBase> items;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final double verticalOffset;
  final bool closeAfterClick;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final FlyoutPlacementMode placement;
  final ShapeBorder? menuShape;
  final Color? menuColor;
  final void Function()? onOpen;
  final void Function()? onClose;
  final FlyoutTransitionBuilder transitionBuilder;

  const CommandBarDropdownButton({
    super.key,
    this.buttonBuilder,
    required this.items,
    this.leading,
    this.title,
    this.trailing = const ChevronDown(),
    this.verticalOffset = 6,
    this.closeAfterClick = true,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.placement = FlyoutPlacementMode.bottomCenter,
    this.menuShape,
    this.menuColor,
    this.onOpen,
    this.onClose,
    this.transitionBuilder = _defaultTransitionBuilder,
  });

  static Widget _defaultTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    FlyoutPlacementMode placement,
    Widget flyout,
  ) {
    assert(debugCheckHasFluentTheme(context), 'No FluentTheme was found');
    assert(debugCheckHasDirectionality(context), 'No Directionality was found');
    final textDirection = Directionality.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        /// On the slide animation, we make use of a [ClipRect] to ensure
        /// only the necessary parts of the widgets will be visible. Altough,
        /// [ClipRect] clips all the borders of the widget, not only the necessary
        /// parts, hiding any shadow the [flyout] may have. To avoid this issue,
        /// we show the flyout independent when the animation is complated (1.0)
        /// or dismissed (0.0)
        if (animation.isCompleted || animation.isDismissed) return child!;

        if (animation.status == AnimationStatus.reverse) {
          return FadeTransition(opacity: animation, child: child);
        }

        switch (placement) {
          case FlyoutPlacementMode.bottomCenter:
          case FlyoutPlacementMode.bottomLeft:
          case FlyoutPlacementMode.bottomRight:
            return ClipRect(
              child: SlideTransition(
                textDirection: textDirection,
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: FluentTheme.of(context).animationCurve,
                  ),
                ),
                child: child,
              ),
            );
          case FlyoutPlacementMode.topCenter:
          case FlyoutPlacementMode.topLeft:
          case FlyoutPlacementMode.topRight:
            return ClipRect(
              child: SlideTransition(
                textDirection: textDirection,
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: FluentTheme.of(context).animationCurve,
                  ),
                ),
                child: child,
              ),
            );
          default:
            return child!;
        }
      },
      child: flyout,
    );
  }

  List<Widget> _space(
    Iterable<Widget> children, {
    Widget spacer = const SizedBox(width: 8),
  }) =>
      children
          .expand((child) sync* {
            yield spacer;
            yield child;
          })
          .skip(1)
          .toList();

  @override
  Widget build(BuildContext context, CommandBarItemDisplayMode displayMode) {
    assert(debugCheckHasFluentTheme(context), 'No FluentTheme was found');
    switch (displayMode) {
      case CommandBarItemDisplayMode.inPrimary:
      case CommandBarItemDisplayMode.inPrimaryCompact:
        return DropDownButton(
          buttonBuilder: buttonBuilder ??
              (context, onPressed) {
                final theme = FluentTheme.of(context);

                return IconButton(
                  onPressed: disabled ? null : onPressed,
                  autofocus: autofocus,
                  focusNode: focusNode,
                  icon: Builder(
                    builder: (context) {
                      final state = HoverButton.of(context).states;

                      return IconTheme.merge(
                        data: const IconThemeData(size: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _space(<Widget>[
                            if (leading != null) leading!,
                            if (title != null) title!,
                            if (trailing != null)
                              IconTheme.merge(
                                data: IconThemeData(
                                  color: state.isDisabled
                                      ? theme.resources.textFillColorDisabled
                                      : state.isPressed
                                          ? theme
                                              .resources.textFillColorTertiary
                                          : state.isHovered
                                              ? theme.resources
                                                  .textFillColorSecondary
                                              : theme.resources
                                                  .textFillColorPrimary,
                                ),
                                child: AnimatedSlide(
                                  duration: theme.fastAnimationDuration,
                                  curve: Curves.easeInCirc,
                                  offset: state.isPressed
                                      ? const Offset(0, 0.1)
                                      : Offset.zero,
                                  child: trailing,
                                ),
                              ),
                          ]),
                        ),
                      );
                    },
                  ),
                );
              },
          items: items,
          leading: leading,
          title: title,
          trailing: trailing,
          verticalOffset: verticalOffset,
          closeAfterClick: closeAfterClick,
          disabled: disabled,
          focusNode: focusNode,
          autofocus: autofocus,
          placement: placement,
          menuShape: menuShape,
          menuColor: menuColor,
          onOpen: onOpen,
          onClose: onClose,
          transitionBuilder: transitionBuilder,
        );
      case CommandBarItemDisplayMode.inSecondary:
        return DropDownButton(
          buttonBuilder: buttonBuilder,
          items: items,
          leading: leading,
          title: title,
          trailing: trailing,
          verticalOffset: verticalOffset,
          closeAfterClick: closeAfterClick,
          disabled: disabled,
          focusNode: focusNode,
          autofocus: autofocus,
          placement: placement,
          menuShape: menuShape,
          menuColor: menuColor,
          onOpen: onOpen,
          onClose: onClose,
          transitionBuilder: transitionBuilder,
        );
    }
  }
}
