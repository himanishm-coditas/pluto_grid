import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/constants/app_textstyles.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AppTheme {
  const AppTheme._();

  static PlutoGridStyleConfig lightPlutoStyle = const PlutoGridStyleConfig(
    rowHoverColor: AppColors.rowHoverColor,
    columnTextStyle: AppTextStyles.columnTitleTextStyle,
    cellTextStyle: AppTextStyles.cellTextStyle,
    enableCellBorderVertical:false ,
    columnHeight: 32,
    rowHeight: 40,
    gridBorderColor: AppColors.gridBorderColor,
    borderColor: AppColors.gridBorderColor,

  );

  static PlutoGridStyleConfig darkPlutoStyle = PlutoGridStyleConfig(
      rowHoverColor: AppColors.rowHoverColorDark,
      gridBorderColor: AppColors.gridBorderColorDark,
      columnTextStyle: AppTextStyles.columnTitleTextStyle
          .copyWith(color: AppColors.columnTitleTextColorDark),
      cellTextStyle: AppTextStyles.cellTextStyle
          .copyWith(color: AppColors.cellTextColorDark),
      columnHeight: 32,
    enableCellBorderVertical:false ,
    borderColor: AppColors.gridBorderColorDark,
    rowHeight: 40,
  gridBackgroundColor: AppColors.gridBackgroundColor,);
}
