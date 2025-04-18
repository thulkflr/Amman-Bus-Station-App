import 'package:ammanbus/Resources/styels_manager.dart';
import 'package:ammanbus/Resources/values_manager.dart';
import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'fonts_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(
      //main colors
      primaryColor: ColorManager.primary,
      primaryColorDark: ColorManager.darkPrimary,
      primaryColorLight: ColorManager.lightPrimary,
      disabledColor: ColorManager.grey1,
      splashColor: ColorManager.lightPrimary,
      //card theme
      cardTheme: CardTheme(
          color: ColorManager.white,
          shadowColor: ColorManager.grey,
          elevation: AppSize.size4),
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primary,
          elevation: AppSize.size4,
          shadowColor: ColorManager.lightPrimary,
          titleTextStyle: getRegularStyle(
              fontSize: FontSize.s16, color: ColorManager.white)),
      //button theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.primary,
          splashColor: ColorManager.lightPrimary)

      //elevated Button
      ,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(
                  color: ColorManager.white, fontSize: FontSize.s17),
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.size12))))

      //text theme
      ,
      textTheme: TextTheme(
        displayLarge:
            getLightStyle(color: ColorManager.darkGrey, fontSize: FontSize.s16),
        headlineLarge: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        headlineMedium:
            getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
        titleMedium:
            getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s14),
        titleSmall:
            getRegularStyle(color: ColorManager.white, fontSize: FontSize.s16),
        bodyLarge: getRegularStyle(color: ColorManager.grey1),
        bodySmall: getRegularStyle(color: ColorManager.grey),
        bodyMedium: getRegularStyle(color: ColorManager.grey2,fontSize: FontSize.s12),
        labelSmall:
            getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s12),
      ),
      //input decoration theme(forms)
      inputDecorationTheme: InputDecorationTheme(
          //content padding
          contentPadding: const EdgeInsets.all(AppPadding.padding8),

          //hint style
          hintStyle:
              getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14)

          //label style
          ,
          labelStyle:
              getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),

          //error style
          errorStyle: getRegularStyle(
              color: ColorManager.error, fontSize: FontSize.s12),

          //enabled border style
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.grey, width: AppSize.size1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.size8))),

//focused border style
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ColorManager.primary, width: AppSize.size1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.size8)))

          //error border style
          ,
          errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.error, width: AppSize.size1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.size8)))

          //focused error border style
          ,
          focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.error, width: AppSize.size1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.size8)))));
}
