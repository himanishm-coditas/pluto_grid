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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppInjector.getIt<WatchlistBloc>()..add(const LoadWatchlistEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.watchlistTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  context.read<WatchlistBloc>().add(const LoadWatchlistEvent()),
              tooltip: AppStrings.refreshTooltip,
            ),
          ],
        ),
        body: const _WatchlistBody(),
      ),
    );
  }
}

class _WatchlistBody extends StatelessWidget {
  const _WatchlistBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        return switch (state) {
          WatchlistInitial() =>
            const Center(child: CircularProgressIndicator()),
          WatchlistError(message: final message) => Center(
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
          WatchlistLoaded(items: final items) when items.isEmpty => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.noWatchlistItems,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<WatchlistBloc>()
                        .add(const LoadWatchlistEvent()),
                    child: const Text(AppStrings.refresh),
                  ),
                ],
              ),
            ),
          WatchlistLoaded(items: final items) => _WatchlistGrid(items: items),
        };
      },
    );
  }
}

class _WatchlistGrid extends StatelessWidget {
  final List<WatchlistItem> items;

  const _WatchlistGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: _buildColumns(),
      rows: _buildRows(),
      configuration: _buildGridConfig(),
    );
  }

  List<PlutoColumn> _buildColumns() {
    return [
      PlutoColumn(
        title: AppStrings.symbol,
        field: 'symbol',
        enableRowDrag: true,
        enableColumnDrag: true,
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.company,
        field: 'company',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
      ),
      PlutoColumn(
        title: AppStrings.bidQty,
        field: 'bid_qty',
        type: PlutoColumnType.number(),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.bidRate,
        field: 'bid_rate',
        type: PlutoColumnType.currency(symbol: '\$', decimalDigits: 2),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.askQty,
        field: 'ask_qty',
        type: PlutoColumnType.number(),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.askRate,
        field: 'ask_rate',
        type: PlutoColumnType.currency(symbol: '\$', decimalDigits: 2),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.volume,
        field: 'volume',
        type: PlutoColumnType.number(),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.high52w,
        field: 'high_52w',
        type: PlutoColumnType.currency(symbol: '\$', decimalDigits: 2),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.low52w,
        field: 'low_52w',
        type: PlutoColumnType.currency(symbol: '\$', decimalDigits: 2),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.ltp,
        field: 'ltp',
        type: PlutoColumnType.currency(symbol: '\$', decimalDigits: 2),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: AppStrings.change,
        field: 'change',
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value.toString();
          final isPositive = value.startsWith('+');
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
  }

  List<PlutoRow> _buildRows() {
    return items.map((item) {
      return PlutoRow(
        menuChildren: [
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.add,
                color: AppColors.errorColor,
              )),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.edit,
                color: AppColors.errorColor,
              )),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.delete,
                color: AppColors.errorColor,
              ))
        ],
        menuOptions: [
           TextButton(onPressed: (){}, child: Text(AppStrings.edit)),
           TextButton(onPressed: (){}, child: Text(AppStrings.delete)),
        ],
        cells: {
          'symbol':
              PlutoCell(value: item.symbol, widget: const Icon(Icons.ac_unit)),
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
      );
    }).toList();
  }

  PlutoGridConfiguration _buildGridConfig() {
    return const PlutoGridConfiguration(
      enableRowHoverColor: true,
      style: PlutoGridStyleConfig.dark(
        gridBorderColor: AppColors.gridBorderColor,
        rowHoverColor: AppColors.rowHoverColor,
      ),
      enableMoveHorizontalInEditing: true,
    );
  }
}
