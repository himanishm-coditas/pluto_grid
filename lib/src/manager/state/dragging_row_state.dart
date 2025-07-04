import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

abstract class IDraggingRowState {
  bool get isDraggingRow;

  List<PlutoRow> get dragRows;

  int? get dragTargetRowIdx;

  bool get canRowDrag;

  bool get isTopHalf;


  void setIsDraggingRow(
      bool flag, {
        bool notify = true,
      });

  void setDragRows(
      List<PlutoRow> rows, {
        bool notify = true,
      });

  void setDragTargetRowIdx(
      int rowIdx, {
        bool notify = true,
      });

  bool isRowIdxDragTarget(int rowIdx);

  bool isRowIdxTopDragTarget(int rowIdx);

  bool isRowIdxBottomDragTarget(int rowIdx);

  bool isRowBeingDragged(Key rowKey);

  void clearDraggingState({bool notify = true});

}

class _DraggingRowState {
  bool _isDraggingRow = false;
  List<PlutoRow> _dragRows = [];
  int? _dragTargetRowIdx;
  bool _isTopHalf = false;
}
mixin DraggingRowState implements IPlutoGridState {
  final _DraggingRowState _state = _DraggingRowState();

  @override
  bool get isDraggingRow => _state._isDraggingRow;

  @override
  List<PlutoRow> get dragRows => _state._dragRows;

  @override
  int? get dragTargetRowIdx => _state._dragTargetRowIdx;

  @override
  bool get isTopHalf => _state._isTopHalf;

  @override
  bool get canRowDrag => !hasFilter && !hasSortedColumn && !enabledRowGroups;

  @override
  void setIsDraggingRow(bool flag, {bool notify = true}) {
    if (_state._isDraggingRow == flag) return;

    _state._isDraggingRow = flag;

    if (!flag) {
      clearDraggingState(notify: notify);
    }

    notifyListeners(notify, setIsDraggingRow.hashCode);
  }

  @override
  void setDragRows(List<PlutoRow> rows, {bool notify = true}) {
    if (const ListEquality().equals(_state._dragRows, rows)) return;

    _state._dragRows = rows;
    notifyListeners(notify, setDragRows.hashCode);
  }

  @override
  void setDragTargetRowIdx(int? rowIdx, {
    bool isTopHalf = false,
    bool notify = true,
  }) {
    if (_state._dragTargetRowIdx == rowIdx && _state._isTopHalf == isTopHalf) {
      return;
    }

    _state._dragTargetRowIdx = rowIdx;
    _state._isTopHalf = isTopHalf;

    notifyListeners(notify, setDragTargetRowIdx.hashCode);
  }

  @override
  bool isRowIdxDragTarget(int? rowIdx) {
    return rowIdx != null &&
        _state._dragTargetRowIdx != null &&
        _state._dragTargetRowIdx == rowIdx;
  }

  @override
  bool isRowIdxTopDragTarget(int? rowIdx) {
    return isRowIdxDragTarget(rowIdx) && _state._isTopHalf;
  }

  @override
  bool isRowIdxBottomDragTarget(int? rowIdx) {
    return isRowIdxDragTarget(rowIdx) && !_state._isTopHalf;
  }

  @override
  bool isRowBeingDragged(Key? rowKey) {
    return rowKey != null &&
        isDraggingRow &&
        _state._dragRows.any((row) => row.key == rowKey);
  }

  @override
  void clearDraggingState({bool notify = true}) {
    if (_state._dragRows.isEmpty && _state._dragTargetRowIdx == null) return;

    _state._dragRows = [];
    _state._dragTargetRowIdx = null;
    _state._isTopHalf = false;

    notifyListeners(notify, clearDraggingState.hashCode);
  }
}
