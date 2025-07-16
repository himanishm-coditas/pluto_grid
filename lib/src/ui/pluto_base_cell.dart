import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid/src/ui/pluto_row_menu_wrapper.dart';

import 'ui.dart';

class PlutoBaseCell extends StatelessWidget
    implements PlutoVisibilityLayoutChild {
  final PlutoCell cell;

  final PlutoColumn column;

  final int rowIdx;

  final PlutoRow row;

  final PlutoGridStateManager stateManager;
  final bool showMenu;

  const PlutoBaseCell({
    super.key,
    required this.cell,
    required this.column,
    required this.rowIdx,
    required this.row,
    required this.stateManager,
    this.showMenu = false,
  });

  @override
  double get width => column.width;

  @override
  double get startPosition => column.startPosition;

  @override
  bool get keepAlive => stateManager.currentCell == cell;

  void _addGestureEvent(
      final PlutoGridGestureType gestureType, final Offset offset) {
    stateManager.eventManager!.addEvent(
      PlutoGridCellGestureEvent(
        gestureType: gestureType,
        offset: offset,
        cell: cell,
        column: column,
        rowIdx: rowIdx,
      ),
    );
  }

  void _handleOnTapUp(final TapUpDetails details) {
    _addGestureEvent(PlutoGridGestureType.onTapUp, details.globalPosition);
  }

  void _handleOnLongPressStart(final LongPressStartDetails details) {
    if (stateManager.selectingMode.isNone) {
      return;
    }

    _addGestureEvent(
      PlutoGridGestureType.onLongPressStart,
      details.globalPosition,
    );
  }

  void _handleOnLongPressMoveUpdate(final LongPressMoveUpdateDetails details) {
    if (stateManager.selectingMode.isNone) {
      return;
    }

    _addGestureEvent(
      PlutoGridGestureType.onLongPressMoveUpdate,
      details.globalPosition,
    );
  }

  void _handleOnLongPressEnd(final LongPressEndDetails details) {
    if (stateManager.selectingMode.isNone) {
      return;
    }

    _addGestureEvent(
      PlutoGridGestureType.onLongPressEnd,
      details.globalPosition,
    );
  }

  void _handleOnDoubleTap() {
    _addGestureEvent(PlutoGridGestureType.onDoubleTap, Offset.zero);
  }

  void _handleOnSecondaryTap(final TapDownDetails details) {
    _addGestureEvent(
      PlutoGridGestureType.onSecondaryTap,
      details.globalPosition,
    );
  }

  void Function()? _onDoubleTapOrNull() =>
      stateManager.onRowDoubleTap == null ? null : _handleOnDoubleTap;

  void Function(TapDownDetails details)? _onSecondaryTapOrNull() =>
      stateManager.onRowSecondaryTap == null ? null : _handleOnSecondaryTap;

  @override
  Widget build(final BuildContext context) {
    final cellContent = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: _handleOnTapUp,
      onLongPressStart: _handleOnLongPressStart,
      onLongPressMoveUpdate: _handleOnLongPressMoveUpdate,
      onLongPressEnd: _handleOnLongPressEnd,
      onDoubleTap: _onDoubleTapOrNull(),
      onSecondaryTapDown: _onSecondaryTapOrNull(),
      child: _CellContainer(
        cell: cell,
        rowIdx: rowIdx,
        row: row,
        column: column,
        cellPadding: column.cellPadding ??
            stateManager.configuration.style.defaultCellPadding,
        stateManager: stateManager,
        child: _Cell(
          stateManager: stateManager,
          rowIdx: rowIdx,
          column: column,
          row: row,
          cell: cell,
          showMenu: showMenu,
        ),
      ),
    );

    if (showMenu && row.hasMenu) {
      return PlutoRowMenuWrapper(
        row: row,
        stateManager: stateManager,
        dragTarget: cellContent,
        menuOffset: Offset(
          column.width * 0.8,
          -stateManager.rowHeight,
        ),
        menuChildren: row.menuChildren,
        menuOptions: row.menuOptions,
      );
    }

    return cellContent;
  }
}

class _CellContainer extends PlutoStatefulWidget {
  final PlutoCell cell;
  final PlutoRow row;
  final int rowIdx;
  final PlutoColumn column;
  final EdgeInsets cellPadding;
  final PlutoGridStateManager stateManager;
  final Widget child;

  const _CellContainer({
    required this.cell,
    required this.row,
    required this.rowIdx,
    required this.column,
    required this.cellPadding,
    required this.stateManager,
    required this.child,
  });

  @override
  State<_CellContainer> createState() => _CellContainerState();
}

class _CellContainerState extends PlutoStateWithChange<_CellContainer> {
  BoxDecoration _decoration = const BoxDecoration();

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();
    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(final PlutoNotifierEvent event) {
    final style = stateManager.style;

    final isCurrentCell = stateManager.isCurrentCell(widget.cell);

    _decoration = update(
      _decoration,
      _boxDecoration(
        hasFocus: stateManager.hasFocus,
        readOnly: widget.column.checkReadOnly(widget.row, widget.cell),
        isEditing: stateManager.isEditing,
        isCurrentCell: isCurrentCell,
        isSelectedCell: stateManager.isSelectedCell(
          widget.cell,
          widget.column,
          widget.rowIdx,
        ),
        isGroupedRowCell: stateManager.enabledRowGroups &&
            stateManager.rowGroupDelegate!.isExpandableCell(widget.cell),
        enableCellVerticalBorder: style.enableCellBorderVertical,
        borderColor: style.borderColor,
        activatedBorderColor: style.activatedBorderColor,
        activatedColor: style.activatedColor,
        inactivatedBorderColor: style.inactivatedBorderColor,
        gridBackgroundColor: style.gridBackgroundColor,
        cellColorInEditState: style.cellColorInEditState,
        cellColorInReadOnlyState: style.cellColorInReadOnlyState,
        cellColorGroupedRow: style.cellColorGroupedRow,
        selectingMode: stateManager.selectingMode,
        isRowHovered: stateManager.isRowHovered(widget.row),
        rowHoverColor: style.rowHoverColor,
        enableRowHoverColor: stateManager.configuration.enableRowHoverColor,
      ),
    );
  }

  Color? _currentCellColor({
    required final bool readOnly,
    required final bool hasFocus,
    required final bool isEditing,
    required final Color activatedColor,
    required final Color gridBackgroundColor,
    required final Color cellColorInEditState,
    required final Color cellColorInReadOnlyState,
    required final PlutoGridSelectingMode selectingMode,
    required final bool isCurrentCell,
    required final bool isSelectedCell,
    required final bool isRowHovered,
    required final Color rowHoverColor,
    required final bool enableRowHoverColor,
  }) {
    Color color = Colors.transparent;

    if (widget.cell.cellColor != null && !(isCurrentCell && isEditing)) {
      color = widget.cell.cellColor!;
    } else {
      if (isCurrentCell) {
        if (!hasFocus) {
          color = gridBackgroundColor;
        } else if (!isEditing) {
          color = selectingMode.isRow ? activatedColor : Colors.transparent;
        } else {
          color = readOnly ? cellColorInReadOnlyState : cellColorInEditState;
        }
      } else if (isSelectedCell) {
        color = activatedColor;
      }
    }

    if (isRowHovered && enableRowHoverColor) {
      if (!(isCurrentCell && isEditing && hasFocus)) {
        Color hoverColor = rowHoverColor;
        if (hoverColor.a < 0.1) {
          hoverColor = hoverColor.withValues(alpha: 0.1);
        }

        if (color == Colors.transparent) {
          color = hoverColor;
        } else {
          color = Color.lerp(color, hoverColor, 0.3) ?? hoverColor;
        }
      }
    }

    return color;
  }

  BoxDecoration _boxDecoration({
    required final bool hasFocus,
    required final bool readOnly,
    required final bool isEditing,
    required final bool isCurrentCell,
    required final bool isSelectedCell,
    required final bool isGroupedRowCell,
    required final bool enableCellVerticalBorder,
    required final Color borderColor,
    required final Color activatedBorderColor,
    required final Color activatedColor,
    required final Color inactivatedBorderColor,
    required final Color gridBackgroundColor,
    required final Color cellColorInEditState,
    required final Color cellColorInReadOnlyState,
    required final Color? cellColorGroupedRow,
    required final PlutoGridSelectingMode selectingMode,
    required final bool isRowHovered,
    required final Color rowHoverColor,
    required final bool enableRowHoverColor,
  }) {
    if (isCurrentCell) {
      return BoxDecoration(
        color: _currentCellColor(
          hasFocus: hasFocus,
          isEditing: isEditing,
          readOnly: readOnly,
          gridBackgroundColor: gridBackgroundColor,
          activatedColor: activatedColor,
          cellColorInReadOnlyState: cellColorInReadOnlyState,
          cellColorInEditState: cellColorInEditState,
          selectingMode: selectingMode,
          isCurrentCell: isCurrentCell,
          isSelectedCell: isSelectedCell,
          isRowHovered: isRowHovered,
          rowHoverColor: rowHoverColor,
          enableRowHoverColor: enableRowHoverColor,
        ),
        border: Border.all(
          color: hasFocus ? activatedBorderColor : inactivatedBorderColor,
        ),
      );
    } else if (isSelectedCell) {
      final Color selectedColor = activatedColor;

      return BoxDecoration(
        color: selectedColor,
        border: Border.all(
          color: hasFocus ? activatedBorderColor : inactivatedBorderColor,
        ),
      );
    } else {
      Color? cellColor = widget.cell.cellColor ??
          (isGroupedRowCell ? cellColorGroupedRow : null);

      if (isRowHovered && enableRowHoverColor) {
        Color hoverColor = rowHoverColor;
        if (hoverColor.a < 0.1) {
          hoverColor = hoverColor.withValues(alpha: 0.1);
        }

        if (cellColor == null) {
          cellColor = hoverColor;
        } else {
          cellColor = Color.lerp(cellColor, hoverColor, 0.3) ?? hoverColor;
        }
      }

      return BoxDecoration(
        color: cellColor,
        border: enableCellVerticalBorder
            ? BorderDirectional(
                end: BorderSide(
                  color: borderColor,
                ),
              )
            : null,
      );
    }
  }

  @override
  Widget build(final BuildContext context) => DecoratedBox(
        decoration: _decoration,
        child: Padding(
          padding: widget.cellPadding,
          child: widget.child,
        ),
      );
}


class _Cell extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;
  final int rowIdx;
  final PlutoRow row;
  final PlutoColumn column;
  final PlutoCell cell;
  final bool showMenu;

  const _Cell({
    required this.stateManager,
    required this.rowIdx,
    required this.row,
    required this.column,
    required this.cell,
    this.showMenu = false,
  });

  @override
  State<_Cell> createState() => _CellState();
}

class _CellState extends PlutoStateWithChange<_Cell> {
  bool _showTypedCell = false;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();

    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(final PlutoNotifierEvent event) {
    _showTypedCell = update<bool>(
      _showTypedCell,
      stateManager.isEditing && stateManager.isCurrentCell(widget.cell),
    );
  }

  @override
  Widget build(final BuildContext context) =>
      _showTypedCell && widget.column.enableEditingMode == true
          ? _buildTypedCell()
          : PlutoDefaultCell(
              cell: widget.cell,
              column: widget.column,
              rowIdx: widget.rowIdx,
              row: widget.row,
              stateManager: stateManager,
            );

  Widget _buildTypedCell() {
    final columnType = widget.column.type;

    if (columnType.isSelect) {
      return PlutoSelectCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    } else if (columnType.isNumber) {
      return PlutoNumberCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    } else if (columnType.isDate) {
      return PlutoDateCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    } else if (columnType.isTime) {
      return PlutoTimeCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    } else if (columnType.isText) {
      return PlutoTextCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    } else if (columnType.isCurrency) {
      return PlutoCurrencyCell(
        stateManager: stateManager,
        cell: widget.cell,
        column: widget.column,
        row: widget.row,
      );
    }

    return PlutoDefaultCell(
      cell: widget.cell,
      column: widget.column,
      rowIdx: widget.rowIdx,
      row: widget.row,
      stateManager: stateManager,
    );
  }
}
