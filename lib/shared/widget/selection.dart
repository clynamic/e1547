import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SelectionLayoutData<T> extends InheritedWidget {
  /// Provides selection actions for a [SelectionLayout] to its subtree.
  const SelectionLayoutData({
    super.key,
    required super.child,
    required this.selections,
    required this.onChanged,
    required this.items,
  });

  /// All selected items.
  final Set<T> selections;

  /// All items that can be selected.
  final List<T> items;

  /// Called when the selection is changed.
  final ValueChanged<Set<T>> onChanged;

  /// Ensures that an item is part of this [SelectionLayout].
  void _assertItemOwnership(T item) {
    if (!items.contains(item)) {
      throw StateError('Cannot select an item which is not part of items!');
    }
  }

  /// Clears the selection.
  void clear() => onChanged(const {});

  /// Selects all items.
  void selectAll() => onChanged(items.toSet());

  /// Returns whether an item is currently selected.
  bool isSelected(T item) {
    _assertItemOwnership(item);
    return selections.contains(item);
  }

  /// Selects an item.
  /// Does nothing if the item is already selected.
  void select(T item) {
    _assertItemOwnership(item);
    if (!isSelected(item)) {
      onChanged(Set.of(selections)..add(item));
    }
  }

  /// Deselects an item.
  /// Does nothing if the item is not selected.
  void deselect(T item) {
    _assertItemOwnership(item);
    if (isSelected(item)) {
      onChanged(Set.of(selections)..remove(item));
    }
  }

  /// Sets the selection of an item.
  /// Does nothing if already in correct state.
  void setSelection(T item, bool selected) {
    if (selected) {
      select(item);
    } else {
      deselect(item);
    }
  }

  /// Toggles the selection state of an item.
  void toggleSelection(T item) => setSelection(item, !isSelected(item));

  @override
  bool updateShouldNotify(covariant SelectionLayoutData<T> oldWidget) =>
      (oldWidget.selections != selections || oldWidget.onChanged != onChanged);
}

class SelectionLayout<T> extends StatefulWidget {
  /// Provides item selection for a subtree.
  const SelectionLayout({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
    this.keyOf,
  });

  /// The widget below this one on the tree.
  final Widget child;

  /// All items which can be selected.
  final List<T>? items;

  final Object Function(T item)? keyOf;

  /// Whether items can currently be selected.
  final bool enabled;

  /// Returns the [SelectionLayoutData] of the current context.
  /// Throws an error if there is none.
  static SelectionLayoutData<T> of<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SelectionLayoutData<T>>()!;

  /// Returns the [SelectionLayoutData] of the current context or null, if there is none.
  static SelectionLayoutData<T>? maybeOf<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SelectionLayoutData<T>>();

  @override
  State<SelectionLayout<T>> createState() => _SelectionLayoutState<T>();
}

class _SelectionLayoutState<T> extends State<SelectionLayout<T>> {
  Set<T> selections = {};

  @override
  void didUpdateWidget(covariant SelectionLayout<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      final Object Function(T item)? keyOf = widget.keyOf;
      if (keyOf != null) {
        final Set<Object> kept = selections.map(keyOf).toSet();
        onSelectionChanged(
          (widget.items ?? const [])
              .where((e) => kept.contains(keyOf(e)))
              .toSet(),
        );
        return;
      }
      Set<T> updated = Set.from(selections);
      updated.removeWhere(
        (element) => !(widget.items?.contains(element) ?? false),
      );
      onSelectionChanged(updated);
    }
  }

  void onSelectionChanged(Set<T> selections) {
    setState(() {
      this.selections = selections;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return PopScope(
      canPop: selections.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) onSelectionChanged({});
      },
      child: SelectionLayoutData<T>(
        items: widget.items ?? [],
        selections: selections,
        onChanged: onSelectionChanged,
        child: widget.child,
      ),
    );
  }
}

class SelectionAppBar<T> extends StatelessWidget with AppBarBuilderWidget {
  /// Provides an appbar for handling the selection of items.
  /// Replaces the normal appbar as soon as a selection starts.
  const SelectionAppBar({
    super.key,
    required this.child,
    required this.actionBuilder,
    this.titleBuilder,
  });

  /// The list of actions for the selection appbar.
  /// Automatically contains an action to select all items.
  final List<Widget> Function(
    BuildContext context,
    SelectionLayoutData<T> layoutData,
  )
  actionBuilder;

  /// Called to display the title for the selection appbar.
  /// Defaults to '<count> items'.
  final Widget Function(
    BuildContext context,
    SelectionLayoutData<T> layoutData,
  )?
  titleBuilder;

  /// The appbar that is shown when no selection is taking place.
  @override
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    SelectionLayoutData<T>? layoutData = SelectionLayout.maybeOf<T>(context);
    return CrossFade.builder(
      showChild: layoutData != null && layoutData.selections.isNotEmpty,
      builder: (context) => DefaultAppBar(
        title:
            titleBuilder?.call(context, layoutData!) ??
            Text('${layoutData!.selections.length} items'),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Abort',
          onPressed: layoutData!.clear,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            tooltip: 'Select all',
            onPressed: layoutData.selectAll,
          ),
          ...actionBuilder(context, layoutData),
        ],
      ),
      secondChild: child,
    );
  }
}

class SelectionItemOverlay<T> extends StatelessWidget {
  /// Alows long press actions to start selecting items.
  const SelectionItemOverlay({
    super.key,
    required this.child,
    required this.item,
    this.padding,
  });

  /// The widget below this one in the tree.
  final Widget child;

  /// The item that can be selected.
  final T item;

  /// Padding of this widget.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    SelectionLayoutData<T>? layoutData = SelectionLayout.maybeOf<T>(context);
    if (layoutData != null) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          Positioned.fill(
            child: MouseCursorRegion(
              behavior: HitTestBehavior.translucent,
              onTap: layoutData.selections.isNotEmpty
                  ? () => layoutData.toggleSelection(item)
                  : null,
              onLongPress: () => layoutData.toggleSelection(item),
              onSecondaryTap: () => layoutData.toggleSelection(item),
              child: ExcludeFocus(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: defaultAnimationDuration,
                    opacity: layoutData.selections.contains(item) ? 1 : 0,
                    child: Container(
                      margin: padding,
                      color: Colors.black38,
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return child;
    }
  }
}

class _SelectionTag<T> {
  const _SelectionTag(this.item);

  final T item;
}

class TileSelectionOverlay<T> extends StatefulWidget {
  const TileSelectionOverlay({
    super.key,
    required this.item,
    required this.child,
    this.marker,
  });

  final T item;
  final Widget child;
  final Widget? marker;

  @override
  State<TileSelectionOverlay<T>> createState() =>
      _TileSelectionOverlayState<T>();
}

class _TileSelectionOverlayState<T> extends State<TileSelectionOverlay<T>> {
  bool? dragSelects;

  void _dragTo(SelectionLayoutData<T> data, Offset position) {
    final bool? selects = dragSelects;
    if (selects == null) return;
    final HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      position,
      View.of(context).viewId,
    );
    for (final HitTestEntry entry in result.path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData && target.metaData is _SelectionTag<T>) {
        final T item = (target.metaData as _SelectionTag<T>).item;
        if (data.isSelected(item) != selects) data.setSelection(item, selects);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SelectionLayoutData<T>? data = SelectionLayout.maybeOf<T>(context);
    if (data == null) return widget.child;
    final ThemeData theme = Theme.of(context);
    final bool selected = data.selections.contains(widget.item);
    return MetaData(
      metaData: _SelectionTag<T>(widget.item),
      behavior: HitTestBehavior.translucent,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: data.selections.isNotEmpty
                  ? () => data.toggleSelection(widget.item)
                  : null,
              onLongPressStart: (details) {
                final bool next = !data.isSelected(widget.item);
                data.setSelection(widget.item, next);
                dragSelects = next;
              },
              onLongPressMoveUpdate: (details) =>
                  _dragTo(data, details.globalPosition),
              onLongPressEnd: (details) => dragSelects = null,
              onSecondaryTap: () => data.toggleSelection(widget.item),
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: selected ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 18,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        if (widget.marker case final marker?)
                          Positioned(right: 8, bottom: 8, child: marker),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
