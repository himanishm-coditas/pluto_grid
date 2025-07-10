import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/constants/app_strings.dart';
import 'package:example/core/constants/app_textstyles.dart';
import 'package:example/core/theming/app_themes.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:example/feature/watchlist/presentation/widgets/refresh_button.dart';
import 'package:example/feature/watchlist/presentation/widgets/toggle_theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.watchlistTitle),
          actions: <Widget>[
            RefreshButton(
                onPressed: () => context
                    .read<WatchlistBloc>()
                    .add(const LoadWatchlistEvent()),),
            ToggleThemeButton(
                onPressed: () => context
                    .read<WatchlistBloc>()
                    .add(const ToggleThemeEvent()),),
          ],
        ),
        body: const _WatchlistBody(),
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
          WatchlistError(message: final String message) => Column(
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
              RefreshButton(
                  onPressed: () => context
                      .read<WatchlistBloc>()
                      .add(const LoadWatchlistEvent()),),
            ],
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
          WatchlistLoaded(
            items: final List<WatchlistItemEntity> items,
            isDarkTheme: final bool isDarkTheme
          ) =>
            _WatchlistGrid(items: items, isDarkTheme: isDarkTheme),
        },
      );
}

class _WatchlistGrid extends StatelessWidget {
  const _WatchlistGrid({required this.items, required this.isDarkTheme});

  final List<WatchlistItemEntity> items;
  final bool isDarkTheme;

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
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          readOnly: true,
          minWidth: 224,
          enableContextMenu: false,
          enableDropToResize: false,
          suppressedAutoSize: true,
        ),
        PlutoColumn(
          title: AppStrings.bidQty,
          field: 'bid_qty',
          type: PlutoColumnType.number(),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.bidRate,
          field: 'bid_rate',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.askRate,
          field: 'ask_rate',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.askQty,
          field: 'ask_qty',
          type: PlutoColumnType.number(),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.change,
          field: 'change',
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          suppressedAutoSize: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 160,
          renderer: (final PlutoColumnRendererContext rendererContext) {
            final String value = rendererContext.cell.value.toString();
            final bool isPositive = value.startsWith('+');
            return Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.netChangeTextStyle.copyWith(
                color: isPositive
                    ? AppColors.positiveChange
                    : AppColors.negativeChange,
              ),
            );
          },
        ),
        PlutoColumn(
          title: AppStrings.atp,
          field: 'atp',
          type: PlutoColumnType.number(),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.volume,
          field: 'volume',
          minWidth: 136,
          type: PlutoColumnType.number(),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
        ),
        PlutoColumn(
          title: AppStrings.ltp,
          field: 'ltp',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.open,
          field: 'open',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 74,
        ),
        PlutoColumn(
          title: AppStrings.high52w,
          field: 'high_52w',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.low52w,
          field: 'low_52w',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
        PlutoColumn(
          title: AppStrings.previousClose,
          field: 'previous_close',
          type: PlutoColumnType.number(
            format: '#,##0.00',
          ),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
      ];

  List<PlutoRow> _buildRows() => items
      .map(
        (final WatchlistItemEntity item) => PlutoRow(
          cells: <String, PlutoCell>{
            'symbol': PlutoCell(
              value: item.symbol,
            ),
            'bid_qty': PlutoCell(value: item.bidQty),
            'bid_rate': PlutoCell(value: item.bidRate),
            'ask_qty': PlutoCell(value: item.askQty),
            'ask_rate': PlutoCell(value: item.askRate),
            'volume': PlutoCell(value: item.volume),
            'atp': PlutoCell(value: item.atp),
            'open': PlutoCell(value: item.open),
            'high_52w': PlutoCell(value: item.high52w),
            'low_52w': PlutoCell(value: item.low52w),
            'ltp': PlutoCell(value: item.ltp),
            'change': PlutoCell(value: item.change),
            'previous_close': PlutoCell(value: item.previousClose),
          },
        ),
      )
      .toList();

  PlutoGridConfiguration _buildGridConfig() => PlutoGridConfiguration(
        columnSize: const PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
        style: isDarkTheme ? AppTheme.darkPlutoStyle : AppTheme.lightPlutoStyle,
        enableMoveHorizontalInEditing: true,
      );
}
