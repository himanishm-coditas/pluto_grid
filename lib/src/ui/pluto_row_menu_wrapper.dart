import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoRowMenuWrapper extends StatefulWidget {
  final PlutoRow row;
  final PlutoGridStateManager stateManager;
  final Widget dragTarget;
  final Offset menuOffset;
  final List<Widget>? menuChildren;
  final double? menuChildrenSpacing;
  final MenuStyle? menuChildrenStyle;
  final MenuStyle? menuOptionsStyle;
  final ButtonStyle? menuOptionsButtonStyle;
  final List<Widget>? menuOptions;
  final Icon? menuOptionsIcon;

  const PlutoRowMenuWrapper(
      {super.key,
      required this.row,
      required this.stateManager,
      required this.dragTarget,
      required this.menuOffset,
      this.menuChildren,
      this.menuChildrenSpacing,
      this.menuChildrenStyle,
      this.menuOptions,
      this.menuOptionsStyle,
      this.menuOptionsButtonStyle,
      this.menuOptionsIcon});

  @override
  State<PlutoRowMenuWrapper> createState() => _PlutoRowMenuWrapperState();
}

class _PlutoRowMenuWrapperState extends State<PlutoRowMenuWrapper> {
  final _menuController = MenuController();
  final _optionsMenuController = MenuController();

  bool _isInteractingWithMenu = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    widget.stateManager.addListener(_handleRowHoverChange);
  }

  @override
  void dispose() {
    _isDisposed = true;
    widget.stateManager.removeListener(_handleRowHoverChange);
    super.dispose();
  }

  void _handleRowHoverChange() {
    if (_isDisposed || !mounted || widget.stateManager.isDraggingRow) return;

    final isHovered = widget.stateManager.isRowHovered(widget.row);

    if (!isHovered) {
      if (_menuController.isOpen) _menuController.close();
      if (_optionsMenuController.isOpen) _optionsMenuController.close();
    } else if (isHovered && !_menuController.isOpen) {
      _menuController.open();
    }
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
        style: widget.menuChildrenStyle,
        controller: _menuController,
        alignmentOffset: widget.menuOffset,
        onOpen: () => _isInteractingWithMenu = true,
        onClose: () {
          _isInteractingWithMenu = false;
          if (!widget.stateManager.isRowHovered(widget.row)) {
            widget.stateManager.clearHoveredRow();
          }
        },
        menuChildren: [
          MouseRegion(
            onEnter: (final _) {
              widget.stateManager.clearHoveredRow();
              widget.stateManager.setHoveredRow(widget.row);
            },
            onExit: (final _) {
              if (!_isInteractingWithMenu) {
                widget.stateManager.clearHoveredRow();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: widget.menuChildrenSpacing ?? 0.0,
              children: [
                if (widget.menuChildren?.isNotEmpty ?? false)
                  ...widget.menuChildren!.map(
                    (final menuItem) => menuItem,
                  ),
                if (widget.menuOptions?.isNotEmpty ?? false)
                  MenuAnchor(
                    style: widget.menuOptionsStyle,
                    controller: _optionsMenuController,
                    crossAxisUnconstrained: false,
                    onOpen: () {
                      _isInteractingWithMenu = true;
                      if (!_menuController.isOpen) {
                        _menuController.open();
                      }
                    },
                    onClose: () {
                      _isInteractingWithMenu = false;
                      if (!widget.stateManager.isRowHovered(widget.row)) {
                        widget.stateManager.clearHoveredRow();
                      }
                    },
                    menuChildren: widget.menuOptions!,
                    child: IconButton(
                      onPressed: () {
                        if (_optionsMenuController.isOpen) {
                          _optionsMenuController.close();
                        } else {
                          _optionsMenuController.open();
                        }
                      },
                      style: widget.menuOptionsButtonStyle ??
                          IconButton.styleFrom(padding: EdgeInsets.zero),
                      icon:
                          widget.menuOptionsIcon ?? const Icon(Icons.more_vert),
                    ),
                  ),
              ],
            ),
          ),
        ],
        child: widget.dragTarget, // This will remain transparent
      );
}
