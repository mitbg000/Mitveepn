import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/views/profiles/profiles.dart';
import 'package:mitveepn/views/proxies/proxies.dart';
import 'package:mitveepn/views/tools.dart';
import 'package:mitveepn/xboard/features/payment/pages/plans.dart';
import 'package:mitveepn/xboard/features/payment/pages/plan_purchase_page.dart';
import 'package:mitveepn/xboard/features/subscription/pages/xboard_home_page.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    return [
      const NavigationItem(
        icon: Icon(Icons.space_dashboard_rounded),
        label: PageLabel.xboard,
        view: XBoardHomePage(
          key: GlobalObjectKey(
            PageLabel.xboard,
          ),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      const NavigationItem(
        icon: Icon(Icons.view_list_rounded),
        label: PageLabel.proxies,
        view: ProxiesView(
          key: GlobalObjectKey(
            PageLabel.proxies,
          ),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      const NavigationItem(
        icon: Icon(Icons.build_rounded),
        label: PageLabel.tools,
        view: ToolsView(
          key: GlobalObjectKey(
            PageLabel.tools,
          ),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      const NavigationItem(
        icon: Icon(Icons.person_rounded),
        label: PageLabel.profiles,
        view: ProfilesView(
          key: GlobalObjectKey(
            PageLabel.profiles,
          ),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      NavigationItem(
        icon: Icon(Icons.shopping_cart),
        label: PageLabel.plans,
        view: PlansView(
          key: GlobalObjectKey(PageLabel.plans),
        ),
        modes: [NavigationItemMode.mobile, NavigationItemMode.desktop],
      ),
      NavigationItem(
        icon: Icon(Icons.shopping_cart_checkout),
        label: PageLabel.planPurchase,
        view: PlanPurchasePage(
          key: GlobalObjectKey(PageLabel.planPurchase),
        ),
        modes: [], // Hidden from navigation, only accessible via page change
      ),
    ];
  }

  Navigation._internal();

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }
}

final navigation = Navigation();
