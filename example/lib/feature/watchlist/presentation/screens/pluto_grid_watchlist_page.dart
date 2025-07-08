import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/constants/app_strings.dart';
import 'package:example/core/di/app_injector.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<WatchlistBloc>(
    create: (final BuildContext context) =>
    AppInjector.getIt<WatchlistBloc>()..add(const LoadWatchlistEvent()),
    child: Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.watchlistTitle),
        actions: <Widget>[
          Builder(
            builder: (final BuildContext context) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context
                  .read<WatchlistBloc>()
                  .add(const LoadWatchlistEvent()),
              tooltip: AppStrings.refreshTooltip,
            ),
          ),
        ],
      ),
      body: const _WatchlistBody(),
    ),
  );
}

class _WatchlistBody extends StatelessWidget {
  const _WatchlistBody();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (final BuildContext context, final WatchlistState state) =>
        switch (state) {
          WatchlistInitial() =>
          const Center(child: CircularProgressIndicator()),
          WatchlistError(message: final String message) => Center(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () => context
                      .read<WatchlistBloc>()
                      .add(const LoadWatchlistEvent()),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          ),
          WatchlistLoaded(items: final List<WatchlistItemEntity> items)
          when items.isEmpty =>
              Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppStrings.noWatchlistItems,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton(
                    onPressed: () => context
                        .read<WatchlistBloc>()
                        .add(const LoadWatchlistEvent()),
                    child: const Text(AppStrings.refresh),
                  ),
                ],
              ),
          WatchlistLoaded(items: final List<WatchlistItemEntity> items) =>
              _WatchlistGrid(items: items),
        },
      );
}

class _WatchlistGrid extends StatelessWidget {
  const _WatchlistGrid({required this.items});

  final List<WatchlistItemEntity> items;

  @override
  Widget build(final BuildContext context) => PlutoGrid(
    columns: _buildColumns(),
    rows: _buildRows(),
    configuration: _buildGridConfig(),
  );

  List<PlutoColumn> _buildColumns() => <PlutoColumn>[
    PlutoColumn(
      title: AppStrings.symbol,
      field: 'symbol',
      enableRowDrag: true,
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.company,
      field: 'company',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.bidQty,
      field: 'bid_qty',
      type: PlutoColumnType.number(),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.bidRate,
      field: 'bid_rate',
      type: PlutoColumnType.currency(symbol: r'$', decimalDigits: 2),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.askQty,
      field: 'ask_qty',
      type: PlutoColumnType.number(),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.askRate,
      field: 'ask_rate',
      type: PlutoColumnType.currency(symbol: r'$', decimalDigits: 2),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.volume,
      field: 'volume',
      type: PlutoColumnType.number(),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.high52w,
      field: 'high_52w',
      type: PlutoColumnType.currency(symbol: r'$', decimalDigits: 2),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.low52w,
      field: 'low_52w',
      type: PlutoColumnType.currency(symbol: r'$', decimalDigits: 2),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.ltp,
      field: 'ltp',
      type: PlutoColumnType.currency(symbol: r'$', decimalDigits: 2),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: AppStrings.change,
      field: 'change',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
      readOnly: true,
      enableContextMenu: false,
      enableDropToResize: false,
      renderer: (final PlutoColumnRendererContext rendererContext) {
        final String value = rendererContext.cell.value.toString();
        final bool isPositive = value.startsWith('+');
        return Text(
          value,
          style: TextStyle(
            color: isPositive
                ? AppColors.positiveChange
                : AppColors.negativeChange,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  ];

  List<PlutoRow> _buildRows() => items
      .map(
        (final WatchlistItemEntity item) => PlutoRow(
      cells: <String, PlutoCell>{
        'symbol': PlutoCell(
          value: item.symbol,
        ),
        'company': PlutoCell(value: item.company),
        'bid_qty': PlutoCell(value: item.bidQty),
        'bid_rate': PlutoCell(value: item.bidRate),
        'ask_qty': PlutoCell(value: item.askQty),
        'ask_rate': PlutoCell(value: item.askRate),
        'volume': PlutoCell(value: item.volume),
        'high_52w': PlutoCell(value: item.high52w),
        'low_52w': PlutoCell(value: item.low52w),
        'ltp': PlutoCell(value: item.ltp),
        'change': PlutoCell(value: item.change),
      },
    ),
  )
      .toList();

  PlutoGridConfiguration _buildGridConfig() => const PlutoGridConfiguration(
    style: PlutoGridStyleConfig.dark(
      gridBorderColor: AppColors.gridBorderColor,
      rowHoverColor: AppColors.rowHoverColor,
    ),
    enableMoveHorizontalInEditing: true,
  );
}
