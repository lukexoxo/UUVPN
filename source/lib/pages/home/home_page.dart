import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuvpn/constant/app_dimens.dart';
import 'package:uuvpn/model/themeCollection.dart';
import 'package:uuvpn/models/app_model.dart';
import 'package:uuvpn/models/plan_model.dart';
import 'package:uuvpn/models/server_model.dart';
import 'package:uuvpn/models/user_model.dart';
import 'package:uuvpn/models/user_subscribe_model.dart';
import 'package:uuvpn/routes/OnceNotice.dart';
import 'package:uuvpn/utils/l10n.dart';
import 'package:uuvpn/utils/message_util.dart';
import 'package:uuvpn/utils/navigator_util.dart';
import 'package:uuvpn/widgets/home_widget.dart';
import 'package:uuvpn/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late AppModel _appModel;
  late ServerModel _serverModel;
  late UserModel _userModel;
  late UserSubscribeModel _userSubscribeModel;
  late PlanModel _planModel;
  bool _isLoadingData = false;
  bool _initialStatus = false;
  // bool _isfinishedLoad = false;
  late Timer _timer;
  bool _isFirst = false;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    createTimer();

    // /判断是不是第一次启动
    getFristBool();

    Future.delayed(const Duration(seconds: 1), () {
      //1秒后跳转到privacy路由
      if (_isFirst) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const OnceNotice()));
      }
    });
  }

  void getFristBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = "FristLaunchs";
    if (preferences.containsKey(key)) {
      setState(() => _isFirst = preferences.getBool(key)!);

      preferences.setBool(key, false);
    } else {
      setState(() => _isFirst = true);
      preferences.setBool(key, false);
    }
  }

  @override
  void dispose() {
    cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void createTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _appModel.getStatus();
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _planModel.fetchPlanList();
      _appModel.getStatus();
      print("_appModel.isOn: ${_appModel.isOn}");
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _appModel = Provider.of<AppModel>(context);
    _userModel = Provider.of<UserModel>(context);
    _userSubscribeModel = Provider.of<UserSubscribeModel>(context);
    _serverModel = Provider.of<ServerModel>(context);
    _planModel = Provider.of<PlanModel>(context);

    if (_userModel.isLogin && !_isLoadingData) {
      _isLoadingData = true;
      await _userSubscribeModel.getUserSubscribe();
      await _serverModel.getServerList(forceRefresh: true);
      await _serverModel.getSelectServer();
      _appModel.setConfigProxies(_userModel, _serverModel);
    }

    if (!_initialStatus) {
      _initialStatus = true;
      _planModel.fetchPlanList();
    }

    // if (_userModel.userEntity?.uuid != null) {
    //   setState(() {
    //     _isfinishedLoad = true;
    //   });
    // }
  }

  sendEmail(recipient, subject, body) async {
    final String url = 'mailto:$recipient?subject=$subject&body=$body';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(AppDimens.maxWidth, AppDimens.maxHeight));

    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;

    return Scaffold(
        backgroundColor: isDarkTheme ? Color(0xff0B0415) : Colors.white,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: SvgPicture.asset(
            'assets/text2.svg',
            height: 28,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              color: isDarkTheme ? Colors.white : Colors.black,
              icon: const Icon(Icons.support_agent),
              tooltip: 'support_agent',
              onPressed: () {
                sendEmail("admin@uuvpn.co", "UUVPN Question Help", "");
              },
            ),
            IconButton(
              icon: const Icon(Icons.public),
              color: isDarkTheme ? Colors.white : Colors.black,
              tooltip: 'public',
              onPressed: () {
                if (_serverModel.serverEntityList.isEmpty) {
                  MessageUtil.toast(context.l10n.nodefornullcheckissubscripts);
                } else {
                  NavigatorUtil.goServerList(context);
                }
              },
            ),
            IconButton(
              color: isDarkTheme ? Colors.white : Colors.black,
              icon: const Icon(Icons.menu),
              tooltip: 'menu',
              onPressed: () {
                NavigatorUtil.goSettings(context);
              },
            ),
          ],
        ),
        body: const HomeWidget());
  }
}
