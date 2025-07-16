import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoRowMenuWrapper extends StatefulWidget {
  final PlutoRow row;
  final PlutoGridStateManager stateManager;
  final Widget dragTarget;
  final Offset menuOffset;
  final List<Widget>? menuChildren;
  final List<Widget>? menuOptions;

  const PlutoRowMenuWrapper({super.key,
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
    _safeCloseMenu(_menuController);
    _safeCloseMenu(_optionsMenuController);
    super.dispose();
  }

  void _handleRowHoverChange() {
    if (_isDisposed || !mounted) return;

    final isHovered = widget.stateManager.isRowHovered(widget.row);

    if (!isHovered) {
      _safeCloseMenu(_optionsMenuController);
      _safeCloseMenu(_menuController);
    } else if (isHovered) {
      _safeOpenMenu(_menuController);
    }
  }

  void _safeCloseMenu(final MenuController controller) {
    if (!_isDisposed && mounted && controller.isOpen) {
      controller.close();
    }
  }

  void _safeOpenMenu(final MenuController controller) {
    if (!_isDisposed && mounted && !controller.isOpen) {
      controller.open();
    }
  }

  @override
  Widget build(final BuildContext context) => MenuAnchor(
    controller: _menuController,
    alignmentOffset: widget.menuOffset,
    onOpen: () => _isInteractingWithMenu = true,
    onClose: () {
      _isInteractingWithMenu = false;
      if (!widget.stateManager.isRowHovered(widget.row)) {
        _safeCloseMenu(_menuController);
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
          children: [
            if (widget.menuChildren?.isNotEmpty ?? false)
              ...widget.menuChildren!
                  .map(
                    (final menuItem) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: menuItem,
                ),
              )
            ,
            if (widget.menuOptions?.isNotEmpty ?? false)
              MenuAnchor(
                controller: _optionsMenuController,
                crossAxisUnconstrained: false,
                onOpen: () {
                  _isInteractingWithMenu = true;
                  _safeOpenMenu(_menuController);
                },
                onClose: () {
                  _isInteractingWithMenu = false;
                  if (!widget.stateManager.isRowHovered(widget.row)) {
                    _safeCloseMenu(_menuController);
                  }
                },
                menuChildren: widget.menuOptions!,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (_optionsMenuController.isOpen) {
                        _safeCloseMenu(_optionsMenuController);
                      } else {
                        _safeOpenMenu(_optionsMenuController);
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