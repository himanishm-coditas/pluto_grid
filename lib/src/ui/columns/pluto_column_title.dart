import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../ui.dart';

class PlutoColumnTitle extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  final PlutoColumn column;

  late final double height;

  PlutoColumnTitle({
    required this.stateManager,
    required this.column,
    final double? height,
  })  : height = height ?? stateManager.columnHeight,
        super(key: ValueKey('column_title_${column.key}'));

  @override
  PlutoColumnTitleState createState() => PlutoColumnTitleState();
}

class PlutoColumnTitleState extends PlutoStateWithChange<PlutoColumnTitle> {
  late Offset _columnRightPosition;

  bool _isPointMoving = false;

  PlutoColumnSort _sort = PlutoColumnSort.none;

  bool get showContextIcon =>
      widget.column.enableContextMenu ||
      widget.column.enableDropToResize ||
      !_sort.isNone;

  bool get enableGesture =>
      widget.column.enableContextMenu || widget.column.enableDropToResize;

  MouseCursor get contextMenuCursor {
    if (enableGesture) {
      return widget.column.enableDropToResize
          ? SystemMouseCursors.resizeLeftRight
          : SystemMouseCursors.click;
    }

    return SystemMouseCursors.basic;
  }

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(final PlutoNotifierEvent event) {
    _sort = update<PlutoColumnSort>(
      _sort,
      widget.column.sort,
    );
  }

  void _showContextMenu(
      final BuildContext context, final Offset position) async {
    final selected = await showColumnMenu(
      context: context,
      position: position,
      backgroundColor: stateManager.style.menuBackgroundColor,
      items: stateManager.columnMenuDelegate.buildMenuItems(
        stateManager: stateManager,
        column: widget.column,
      ),
    );

    if (context.mounted) {
      stateManager.columnMenuDelegate.onSelected(
        context: context,
        stateManager: stateManager,
        column: widget.column,
        mounted: mounted,
        selected: selected,
      );
    }
  }

  void _handleOnPointDown(final PointerDownEvent event) {
    _isPointMoving = false;

    _columnRightPosition = event.position;
  }

  void _handleOnPointMove(final PointerMoveEvent event) {
    // if at least one movement event has distanceSquared > 0.5 _isPointMoving will be true
    _isPointMoving |=
        (_columnRightPosition - event.position).distanceSquared > 0.5;

    if (!_isPointMoving) return;

    final moveOffset = event.position.dx - _columnRightPosition.dx;

    final bool isLTR = stateManager.isLTR;

    stateManager.resizeColumn(widget.column, isLTR ? moveOffset : -moveOffset);

    _columnRightPosition = event.position;
  }

  void _handleOnPointUp(final PointerUpEvent event) {
    if (_isPointMoving) {
      stateManager.updateCorrectScrollOffset();
    } else if (mounted && widget.column.enableContextMenu) {
      _showContextMenu(context, event.position);
    }

    _isPointMoving = false;
  }

  @override
  Widget build(final BuildContext context) {
    final style = stateManager.configuration.style;

    final columnWidget = _SortableWidget(
      stateManager: stateManager,
      column: widget.column,
      child: _ColumnWidget(
        stateManager: stateManager,
        column: widget.column,
        height: widget.height,
      ),
    );

    final contextMenuIcon = SizedBox(
      height: widget.height,
      child: Align(
        child: IconButton(
          icon: PlutoGridColumnIcon(
            sort: _sort,
            color: style.iconColor,
            icon: widget.column.enableContextMenu
                ? style.columnContextIcon
                : style.columnResizeIcon,
            ascendingIcon: style.columnAscendingIcon,
            descendingIcon: style.columnDescendingIcon,
          ),
          iconSize: style.iconSize,
          mouseCursor: contextMenuCursor,
          onPressed: null,
        ),
      ),
    );

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: widget.column.enableColumnDrag
              ? _DraggableWidget(
                  stateManager: stateManager,
                  column: widget.column,
                  child: columnWidget,
                )
              : columnWidget,
        ),
        if (showContextIcon)
          Positioned.directional(
            textDirection: stateManager.textDirection,
            end: -3,
            child: enableGesture
                ? Listener(
                    onPointerDown: _handleOnPointDown,
                    onPointerMove: _handleOnPointMove,
                    onPointerUp: _handleOnPointUp,
                    child: contextMenuIcon,
                  )
                : contextMenuIcon,
          ),
      ],
    );
  }
}

class PlutoGridColumnIcon extends StatelessWidget {
  final PlutoColumnSort? sort;

  final Color color;

  final IconData icon;

  final Icon? ascendingIcon;

  final Icon? descendingIcon;

  const PlutoGridColumnIcon({
    this.sort,
    this.color = Colors.black26,
    this.icon = Icons.dehaze,
    this.ascendingIcon,
    this.descendingIcon,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    switch (sort) {
      case PlutoColumnSort.ascending:
        return ascendingIcon == null
            ? Transform.rotate(
                angle: 90 * pi / 90,
                child: const Icon(
                  Icons.sort,
                  color: Colors.green,
                ),
              )
            : ascendingIcon!;
      case PlutoColumnSort.descending:
        return descendingIcon == null
            ? const Icon(
                Icons.sort,
                color: Colors.red,
              )
            : descendingIcon!;
      default:
        return Icon(
          icon,
          color: color,
        );
    }
  }
}

class _DraggableWidget extends StatelessWidget {
  final PlutoGridStateManager stateManager;

  final PlutoColumn column;

  final Widget child;

  const _DraggableWidget({
    required this.stateManager,
    required this.column,
    required this.child,
  });

  void _handleOnPointerMove(final PointerMoveEvent event) {
    stateManager.eventManager!.addEvent(PlutoGridScrollUpdateEvent(
      offset: event.position,
      scrollDirection: PlutoGridScrollUpdateDirection.horizontal,
    ));
  }

  void _handleOnPointerUp(final PointerUpEvent event) {
    PlutoGridScrollUpdateEvent.stopScroll(
      stateManager,
      PlutoGridScrollUpdateDirection.horizontal,
    );
  }

  Widget _buildDragFeedback(final BuildContext context) {
    final column = this.column;
    final stateManager = this.stateManager;
    final columnWidth = column.width;
    final columnHeight = stateManager.columnHeight;
    final rowHeight = stateManager.rowHeight;
    final rows = stateManager.refRows;
    final style = stateManager.configuration.style;

    // Calculate visible rows
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final visibleRowCount = min(
      ((maxHeight - columnHeight) / rowHeight).floor(),
      rows.length,
    );

    // Pre-build common style elements
    final borderStyle = BorderSide(
      color: style.borderColor,
    );
    final boxShadow = BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 10,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    );

    return Container(
      width: columnWidth,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: BoxDecoration(
        color: style.gridBackgroundColor,
        border: Border.all(
          color: style.gridBorderColor,
        ),
        boxShadow: [boxShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Column header
          Container(
            height: columnHeight,
            padding: column.titlePadding ?? style.defaultColumnTitlePadding,
            decoration: BoxDecoration(
              color: column.backgroundColor,
              border: Border(bottom: borderStyle),
            ),
            alignment: column.titleTextAlign.alignmentValue,
            child: _ColumnTextWidget(
              column: column,
              stateManager: stateManager,
              height: columnHeight,
            ),
          ),

          /// Visible rows only
          ListView.builder(
            ///not used separated for drawing lines
            ///because of better performance with itemExtent property of
            /// listview builder
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: visibleRowCount,
            itemExtent: rowHeight,
            itemBuilder: (final context, final index) {
              final row = rows[index];
              return Container(
                height: rowHeight,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: style.borderColor,
                    ),
                  ),
                ),
                child: PlutoBaseCell(
                  key: ValueKey('drag_feedback_${row.key}_${column.key}'),
                  cell: row.cells[column.field]!,
                  column: column,
                  rowIdx: index,
                  row: row,
                  stateManager: stateManager,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => Listener(
        onPointerMove: _handleOnPointerMove,
        onPointerUp: _handleOnPointerUp,
        child: Draggable<PlutoColumn>(
          data: column,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: _buildDragFeedback(context),
          child: child,
        ),
      );
}

class _SortableWidget extends StatelessWidget {
  final PlutoGridStateManager stateManager;

  final PlutoColumn column;

  final Widget child;

  const _SortableWidget({
    required this.stateManager,
    required this.column,
    required this.child,
  });

  void _onTap() {
    stateManager.toggleSortColumn(column);
  }

  @override
  Widget build(final BuildContext context) => column.enableSorting
      ? MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            key: const ValueKey('ColumnTitleSortableGesture'),
            onTap: _onTap,
            child: child,
          ),
        )
      : child;
}

class _ColumnWidget extends StatelessWidget {
  final PlutoGridStateManager stateManager;
  final PlutoColumn column;
  final double height;

  const _ColumnWidget({
    required this.stateManager,
    required this.column,
    required this.height,
  });

  EdgeInsets get padding =>
      column.titlePadding ??
          stateManager.configuration.style.defaultColumnTitlePadding;

  bool get showSizedBoxForIcon =>
      column.isShowRightIcon &&
          (column.titleTextAlign.isRight || stateManager.isRTL);

  @override
  Widget build(BuildContext context) => DragTarget<PlutoColumn>(
      onWillAcceptWithDetails: (final DragTargetDetails<PlutoColumn> details) =>
      details.data.key != column.key &&
          !stateManager.limitMoveColumn(
            column: details.data,
            targetColumn: column,
          ),
      onAcceptWithDetails: (final DragTargetDetails<PlutoColumn> details) {
        if (details.data.key != column.key) {
          stateManager.moveColumn(column: details.data, targetColumn: column);
        }
      },
      builder: (final dragContext, final candidate, final rejected) {
        final bool noDragTarget = candidate.isEmpty;
        final style = stateManager.style;

        return SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: noDragTarget
                  ? column.backgroundColor
                  : style.dragTargetColumnColor,
              border: BorderDirectional(
                end: style.enableColumnBorderVertical
                    ? BorderSide(color: style.borderColor)
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  if (column.enableRowChecked)
                    CheckboxAllSelectionWidget(stateManager: stateManager),
                  Expanded(
                    child: Align(
                      alignment: column.titleTextAlign.alignmentValue,
                      child: _ColumnTextWidget(
                        column: column,
                        stateManager: stateManager,
                        height: height,
                      ),
                    ),
                  ),
                  if (showSizedBoxForIcon) SizedBox(width: style.iconSize),
                ],
              ),
            ),
          ),
        );
      },
    );
}

class CheckboxAllSelectionWidget extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  const CheckboxAllSelectionWidget({required this.stateManager, super.key});

  @override
  CheckboxAllSelectionWidgetState createState() =>
      CheckboxAllSelectionWidgetState();
}

class CheckboxAllSelectionWidgetState
    extends PlutoStateWithChange<CheckboxAllSelectionWidget> {
  bool? _checked;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(final PlutoNotifierEvent event) {
    _checked = update<bool?>(
      _checked,
      stateManager.tristateCheckedRow,
    );
  }

  void _handleOnChanged(bool? changed) {
    if (changed == _checked) {
      return;
    }

    changed ??= false;

    if (_checked == null) changed = true;

    stateManager.toggleAllRowChecked(changed);

    if (stateManager.onRowChecked != null) {
      stateManager.onRowChecked!(
        PlutoGridOnRowCheckedAllEvent(isChecked: changed),
      );
    }

    setState(() {
      _checked = changed;
    });
  }

  @override
  Widget build(final BuildContext context) => PlutoScaledCheckbox(
        value: _checked,
        handleOnChanged: _handleOnChanged,
        tristate: true,
        scale: 0.86,
        unselectedColor: stateManager.configuration.style.iconColor,
        activeColor: stateManager.configuration.style.activatedBorderColor,
        checkColor: stateManager.configuration.style.activatedColor,
      );
}

class _ColumnTextWidget extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  final PlutoColumn column;

  final double height;

  const _ColumnTextWidget({
    required this.stateManager,
    required this.column,
    required this.height,
  });

  @override
  _ColumnTextWidgetState createState() => _ColumnTextWidgetState();
}

class _ColumnTextWidgetState extends PlutoStateWithChange<_ColumnTextWidget> {
  bool _isFilteredList = false;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(final PlutoNotifierEvent event) {
    _isFilteredList = update<bool>(
      _isFilteredList,
      stateManager.isFilteredColumn(widget.column),
    );
  }

  void _handleOnPressedFilter() {
    stateManager.showFilterPopup(
      context,
      calledColumn: widget.column,
    );
  }

  String? get _title =>
      widget.column.titleSpan == null ? widget.column.title : null;

  List<InlineSpan> get _children => [
        if (widget.column.titleSpan != null) widget.column.titleSpan!,
        if (_isFilteredList)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: stateManager.configuration.style.iconColor,
                size: stateManager.configuration.style.iconSize,
              ),
              onPressed: _handleOnPressedFilter,
              constraints: BoxConstraints(
                maxHeight:
                    widget.height + (PlutoGridSettings.rowBorderWidth * 2),
              ),
            ),
          ),
      ];

  @override
  Widget build(final BuildContext context) => Text.rich(
        TextSpan(
          text: _title,
          children: _children,
        ),
        style: stateManager.configuration.style.columnTextStyle,
    overflow: TextOverflow.visible, // Allow text to expand
    softWrap: false, // Prevent text from wrapping
    maxLines: 1,
    textAlign: widget.column.titleTextAlign.value,
      );
}
