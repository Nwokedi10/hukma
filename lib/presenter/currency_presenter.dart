import 'dart:async';
import 'package:active_ecommerce_flutter/data_model/currency_response.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/currency_repository.dart';
import 'package:flutter/material.dart';

class CurrencyPresenter extends ChangeNotifier {
  List<CurrencyInfo> currencyList = [];

  fetchListData() async {
    currencyList.clear();
    system_currency.$ = null;
    var res = await CurrencyRepository().getListResponse();

    currencyList.addAll(res.data);

    currencyList.forEach((element) {
      print('----------- seeing individual element --------');
      print(element.isDefault);
      if (element.isDefault == true) {
        SystemConfig.defaultCurrency = element;
        print('default currency =>' + element.name);
      }
      if (system_currency.$ == null && element.isDefault == true) {
        SystemConfig.systemCurrency = element;
        system_currency.$ = element.id;
        system_currency.save();
        print('assign system currency =>' + element.name);
      }
      if (system_currency.$ != null && element.id == system_currency.$) {
        SystemConfig.systemCurrency = element;
        system_currency.$ = element.id;
        system_currency.save();
        print(
            'when system currency and current index is same =>' + element.name);
      }
    });
    notifyListeners();
  }
}
