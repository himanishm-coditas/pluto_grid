import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/constants/app_strings.dart';
import 'package:example/core/constants/app_textstyles.dart';
import 'package:example/core/controller/theme_controller.dart';
import 'package:example/core/di/app_injector.dart';
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
  Widget build(final BuildContext context) => BlocProvider<WatchlistBloc>(
        create: (final BuildContext context) =>
            AppInjector.getIt<WatchlistBloc>()..add(const LoadWatchlistEvent()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              AppStrings.watchlistTitle,
              style: AppTextStyles.appTitleTextStyle,
            ),
            actions: <Widget>[
              RefreshButton(
                onPressed: () => context
                    .read<WatchlistBloc>()
                    .add(const LoadWatchlistEvent()),
              ),
              ToggleThemeButton(
                onPressed: () async {
                  final ThemeController themeController =
                      AppInjector.getIt<ThemeController>();
                  await themeController.toggleTheme();
                },
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
                      .add(const LoadWatchlistEvent()),
                ),
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
          ) =>
            _WatchlistGrid(
              items: items,
            ),
        },
      );
}

class _WatchlistGrid extends StatelessWidget {
  const _WatchlistGrid({
    required this.items,
  });

  final List<WatchlistItemEntity> items;

  @override
  Widget build(final BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDarkMode = brightness == Brightness.dark;

    return PlutoGrid(
      key: ValueKey<Brightness>(brightness),
      columns: _buildColumns(),
      rows: _buildRows(isDarkMode),
      configuration: _buildGridConfig(isDarkMode),
    );
  }

  List<PlutoColumn> _buildColumns() => <PlutoColumn>[
        PlutoColumn(
          title: AppStrings.symbol,
          field: 'symbol',
          type: PlutoColumnType.text(),
          frozen: PlutoColumnFrozen.start,
          enableColumnDrag: false,
          readOnly: true,
          minWidth: 224,
          enableContextMenu: false,
          enableDropToResize: false,
          enableRowDrag: true,
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 160,
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
          suppressedAutoSize: true,
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          type: PlutoColumnType.number(format: '#,##0.00'),
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
          type: PlutoColumnType.number(format: '#,##0.00'),
          titleTextAlign: PlutoColumnTextAlign.right,
          textAlign: PlutoColumnTextAlign.right,
          readOnly: true,
          enableContextMenu: false,
          enableDropToResize: false,
          minWidth: 88,
        ),
      ];

  List<PlutoRow> _buildRows(final bool isDarkMode) {
    final Color? cellBg = isDarkMode ? AppColors.gridBackgroundColor : null;

    return items
        .map(
          (final WatchlistItemEntity item) => PlutoRow(
            menuChildren: <Widget>[
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.add,
                  color: AppColors.errorColor,
                ),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.edit,
                  color: AppColors.errorColor,
                ),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: AppColors.errorColor,
                ),
              ),
            ],
            menuOptions: <Widget>[
              TextButton(onPressed: () {}, child: const Text(AppStrings.open)),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.refresh),
              ),
            ],
            cells: <String, PlutoCell>{
              'symbol': PlutoCell(value: item.symbol, cellColor: cellBg),
              'bid_qty': PlutoCell(value: item.bidQty, cellColor: cellBg),
              'bid_rate': PlutoCell(
                value: item.bidRate,
                cellColor: cellBg,
              ),
              'ask_qty': PlutoCell(
                value: item.askQty,
                cellColor: isDarkMode ? AppColors.successColor : null,
              ),
              'ask_rate': PlutoCell(value: item.askRate, cellColor: cellBg),
              'volume': PlutoCell(value: item.volume, cellColor: cellBg),
              'atp': PlutoCell(value: item.atp, cellColor: cellBg),
              'open': PlutoCell(value: item.open, cellColor: cellBg),
              'high_52w': PlutoCell(value: item.high52w, cellColor: cellBg),
              'low_52w': PlutoCell(value: item.low52w, cellColor: cellBg),
              'ltp': PlutoCell(
                value: item.ltp,
                cellColor: cellBg,
              ),
              'change': PlutoCell(
                cellColor: cellBg,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.change ?? "",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.netChangeTextStyle.copyWith(
                        color: (item.change ?? "").startsWith('+')
                            ? AppColors.positiveChange
                            : AppColors.negativeChange,
                      ),
                    ),
                    Icon(
                      (item.change ?? "").startsWith('+')
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 20,
                      color: (item.change ?? "").startsWith('+')
                          ? AppColors.positiveChange
                          : AppColors.negativeChange,
                    ),
                  ],
                ),
              ),
              'previous_close':
                  PlutoCell(value: item.previousClose, cellColor: cellBg),
            },
          ),
        )
        .toList();
  }

  PlutoGridConfiguration _buildGridConfig(final bool isDarkMode) =>
      PlutoGridConfiguration(
        columnSize: const PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
        style: isDarkMode ? AppTheme.darkPlutoStyle : AppTheme.lightPlutoStyle,
        enableMoveHorizontalInEditing: true,
      );
}
