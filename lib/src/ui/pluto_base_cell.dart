import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

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

  void _addGestureEvent(PlutoGridGestureType gestureType, Offset offset) {
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

  void _handleOnTapUp(TapUpDetails details) {
    _addGestureEvent(PlutoGridGestureType.onTapUp, details.globalPosition);
  }

  void _handleOnLongPressStart(LongPressStartDetails details) {
    if (stateManager.selectingMode.isNone) {
      return;
    }

    _addGestureEvent(
      PlutoGridGestureType.onLongPressStart,
      details.globalPosition,
    );
  }

  void _handleOnLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (stateManager.selectingMode.isNone) {
      return;
    }

    _addGestureEvent(
      PlutoGridGestureType.onLongPressMoveUpdate,
      details.globalPosition,
    );
  }

  void _handleOnLongPressEnd(LongPressEndDetails details) {
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

  void _handleOnSecondaryTap(TapDownDetails details) {
    _addGestureEvent(
      PlutoGridGestureType.onSecondaryTap,
      details.globalPosition,
    );
  }

  void Function()? _onDoubleTapOrNull() {
    return stateManager.onRowDoubleTap == null ? null : _handleOnDoubleTap;
  }

  void Function(TapDownDetails details)? _onSecondaryTapOrNull() {
    return stateManager.onRowSecondaryTap == null
        ? null
        : _handleOnSecondaryTap;
  }

  @override
  Widget build(BuildContext context) {
    final cellContent = GestureDetector(
      behavior: HitTestBehavior.translucent,
      // Essential gestures.
      onTapUp: _handleOnTapUp,
      onLongPressStart: _handleOnLongPressStart,
      onLongPressMoveUpdate: _handleOnLongPressMoveUpdate,
      onLongPressEnd: _handleOnLongPressEnd,
      // Optional gestures.
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
      return _RowMenuWrapper(
        row: row,
        stateManager: stateManager,
        dragTarget: cellContent,
        menuOffset: Offset(
          column.width * 0.8,
          -stateManager.rowHeight * 0.94,
        ),
        menuChildren: row.menuChildren,
        menuOptions: row.menuOptions,
      );
    }

    return cellContent;
  }
}

class _RowMenuWrapper extends StatefulWidget {
  final PlutoRow row;
  final PlutoGridStateManager stateManager;
  final Widget dragTarget;
  final Offset menuOffset;
  final List<Widget>? menuChildren;
  final List<Widget>? menuOptions;

  const _RowMenuWrapper({
    required this.row,
    required this.stateManager,
    required this.dragTarget,
    required this.menuOffset,
    this.menuChildren,
    this.menuOptions,
  });

  @override
  State<_RowMenuWrapper> createState() => _RowMenuWrapperState();
}

class _RowMenuWrapperState extends State<_RowMenuWrapper> {
  final _menuController = MenuController();
  final _optionsMenuController = MenuController();
  bool _isHovered = false;
  bool _isInteractingWithMenu = false;

  @override
  void dispose() {
    _menuController.close();
    _optionsMenuController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHovered = widget.stateManager.isRowHovered(widget.row);

    if (isHovered != _isHovered) {
      _isHovered = isHovered;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isHovered) {
          // Close both menus when not hovered, regardless of interaction state
          _optionsMenuController.close();
          _menuController.close();
          _isInteractingWithMenu = false;
        } else {
          // Open main menu when hovered
          _menuController.open();
        }
      });
    }

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: widget.menuOffset,
      menuChildren: [
        MouseRegion(
          onEnter: (_) {
            widget.stateManager.setHoveredRow(widget.row);
            if (!_isInteractingWithMenu) {
              _menuController.open();
            }
          },
          onExit: (_) {
            if (!_isInteractingWithMenu) {
              widget.stateManager.clearHoveredRow();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.menuChildren?.isNotEmpty ?? false)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.menuChildren!.map(
                        (menuItem) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: menuItem,
                    ),
                  ).toList(),
                ),
              if (widget.menuOptions?.isNotEmpty ?? false)
                MenuAnchor(
                  controller: _optionsMenuController,
                  crossAxisUnconstrained: false,
                  onOpen: () {
                    _isInteractingWithMenu = true;
                    _menuController.open();
                  },
                  onClose: () {
                    _isInteractingWithMenu = false;
                    // Only close main menu if not hovered
                    if (!_isHovered) {
                      _menuController.close();
                    }
                  },
                  menuChildren: widget.menuOptions!,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (_optionsMenuController.isOpen) {
                          _optionsMenuController.close();
                        } else {
                          _optionsMenuController.open();
                        }
                      },
                      child: const Icon(Icons.more_vert),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      child: widget.dragTarget,
    );
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
  void updateState(PlutoNotifierEvent event) {
    final style = stateManager.style;

    final isCurrentCell = stateManager.isCurrentCell(widget.cell);
    final isSelectedCell = stateManager.isSelectedCell(
      widget.cell,
      widget.column,
      widget.rowIdx,
    );

    _decoration = BoxDecoration(
      color: _getCellColor(
        isCurrentCell: isCurrentCell,
        isSelectedCell: isSelectedCell,
        hasFocus: stateManager.hasFocus,
        isEditing: stateManager.isEditing,
        readOnly: widget.column.checkReadOnly(widget.row, widget.cell),
        style: style,
        selectingMode: stateManager.selectingMode,
      ),
    );
  }

  Color _getCellColor({
    required bool isCurrentCell,
    required bool isSelectedCell,
    required bool hasFocus,
    required bool isEditing,
    required bool readOnly,
    required PlutoGridStyleConfig style,
    required PlutoGridSelectingMode selectingMode,
  }) {
    // Starting  with transparent as base
    Color color = Colors.transparent;

    // Applying  cell's custom color if it exists (unless editing current cell)
    if (widget.cell.cellColor != null && !(isCurrentCell && isEditing)) {
      color = widget.cell.cellColor!;
    }
    // Otherwise applying  default grid coloring
    else {
      final activatedColor = style.activatedColor;
      final gridBgColor = style.gridBackgroundColor;

      if (isCurrentCell) {
        if (!hasFocus) {
          color = gridBgColor;
        } else if (!isEditing) {
          color = selectingMode.isRow ? activatedColor : Colors.transparent;
        } else {
          color = readOnly
              ? style.cellColorInReadOnlyState
              : style.cellColorInEditState;
        }
      } else if (isSelectedCell) {
        color = activatedColor;
      }
    }

    // Apply hover effect as an overlay if row is hovered
    if (stateManager.isRowHovered(widget.row) &&
        stateManager.configuration.enableRowHoverColor) {
      color = Color.alphaBlend(
        style.rowHoverColor.withValues(alpha: 0.3), // Adjusting opacity as needed
        color,
      );
    }

    return color;
  }
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: Padding(
        padding: widget.cellPadding,
        child: widget.child,
      ),
    );
  }
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
  bool _isHovered = false;

  @override
  PlutoGridStateManager get stateManager => widget.stateManager;

  @override
  void initState() {
    super.initState();
    updateState(PlutoNotifierEventForceUpdate.instance);
  }

  @override
  void updateState(PlutoNotifierEvent event) {
    _showTypedCell = update<bool>(
      _showTypedCell,
      stateManager.isEditing && stateManager.isCurrentCell(widget.cell),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: _showTypedCell && widget.column.enableEditingMode == true
          ? _buildTypedCell()
          : PlutoDefaultCell(
        cell: widget.cell,
        column: widget.column,
        rowIdx: widget.rowIdx,
        row: widget.row,
        stateManager: stateManager,
      ),
    );
  }

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
