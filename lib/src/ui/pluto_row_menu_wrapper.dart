import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoRowMenuWrapper extends StatefulWidget {
  final PlutoRow row;
  final PlutoGridStateManager stateManager;
  final Widget dragTarget;
  final Offset menuOffset;
  final List<Widget>? menuChildren;
  final List<Widget>? menuOptions;

  const PlutoRowMenuWrapper({
    super.key,
    required this.row,
    required this.stateManager,
    required this.dragTarget,
    required this.menuOffset,
    this.menuChildren,
    this.menuOptions,
  });

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
  Widget build(BuildContext context) {
    return MenuAnchor(
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
          onEnter: (_) {
            widget.stateManager.clearHoveredRow();
            widget.stateManager.setHoveredRow(widget.row);
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
                ...widget.menuChildren!.map(
                      (menuItem) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: menuItem,
                  ),
                ),
              if (widget.menuOptions?.isNotEmpty ?? false)
                MenuAnchor(
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
