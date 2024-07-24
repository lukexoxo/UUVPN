//ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuvpn/constant/app_colors.dart';
import 'package:uuvpn/models/app_model.dart';
import 'package:uuvpn/models/plan_model.dart';
import 'package:uuvpn/models/user_model.dart';
import 'package:uuvpn/models/user_subscribe_model.dart';
import 'package:uuvpn/utils/l10n.dart';
import 'package:uuvpn/utils/navigator_util.dart';
import 'package:uuvpn/widgets/my_subscribe.dart';
import 'package:uuvpn/widgets/plan_list.dart';

import '/routes/proRoute.dart';
import '/routes/settingsRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/themeCollection.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<AccountPage> {
  void onLogoutTap(context, userModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(context.l10n.alertsss),
            content: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: const Alignment(0, 0),
                  child: Text(
                    context.l10n.wanttoexit,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(context.l10n.cancelss),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  context.l10n.exitout,
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  userModel.logout();
                  NavigatorUtil.goLogin(context);
                },
              ),
            ],
          );
        });
  }

  customListTile(BuildContext context, String title, String icon,
          {Widget? trailing,
          Icon? sysicon,
          String? subtitle,
          VoidCallback? onTap}) =>
      ListTile(
          onTap: onTap,
          minLeadingWidth: 35,
          dense: true,
          title: Text(title,
              style: Theme.of(context).primaryTextTheme.labelMedium),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).primaryTextTheme.labelMedium,
                )
              : null,
          leading: sysicon ??
              SvgPicture.asset(
                icon,
                // color: Theme.of(context).colorScheme.secondary,
                width: 24,
                cacheColorFilter: true,
                color: AppColors.greenColor,
                alignment: Alignment.centerRight,
              ),
          trailing: trailing);

  upgradeButton(context) => GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => const ProRoute())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(65),
            gradient: const LinearGradient(
                colors: [AppColors.greenColor, Color.fromARGB(255, 9, 54, 21)],
                transform: GradientRotation(5))),
        child: Text(
          'Upgrade',
          style: Theme.of(context)
              .primaryTextTheme
              .labelMedium!
              .copyWith(color: Colors.white),
        ),
      ));

  Divider get divider => Divider(
      indent: 16,
      endIndent: 16,
      color: Colors.grey.withAlpha(50),
      thickness: 1);

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Scaffold(
      backgroundColor: isDarkTheme ? const Color(0xff0B0415) : Colors.white,
      appBar: AppBar(
        foregroundColor: isDarkTheme ? Colors.white : const Color(0xff0B0415),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Settings',
        ),
      ),
      body: build2(context),
    );
  }

  Widget build2(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    AppModel appModel = Provider.of<AppModel>(context);
    UserModel userModel = Provider.of<UserModel>(context);
    PlanModel planModel = Provider.of<PlanModel>(context);
    UserSubscribeModel userSubscribeModel0 =
        Provider.of<UserSubscribeModel>(context);

    UserSubscribeModel userSubscribeModel =
        Provider.of<UserSubscribeModel>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(
          //       left: ScreenUtil().setWidth(75),
          //       right: ScreenUtil().setWidth(75)),
          //   child: LogoBar(
          //     isOn: appModel.isOn,
          //   ),
          // ),

          // SvgPicture.asset(
          //   isDarkTheme
          //       ? 'assets/darkNoResults.svg'
          //       : 'assets/lightNoResults.svg',
          //   width: MediaQuery.of(context).size.width * 0.75,
          //   fit: BoxFit.cover,
          // ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            child: MySubscribe(
              isLogin: userModel.isLogin,
              isOn: appModel.isOn,
              userSubscribeEntity: userSubscribeModel0.userSubscribeEntity,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            child: PlanList(
              isOn: appModel.isOn,
              userSubscribeEntity: userSubscribeModel.userSubscribeEntity,
              plans: planModel.planEntityList,
            ),
          ),
          userModel.isLogin
              ? Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Looks like You’re not signed in yet.',
                    style: Theme.of(context).primaryTextTheme.labelMedium,
                  ),
                ),

          // style: ButtonStyle(
          //       backgroundColor: const Color(0xff353351),
          //       textColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(64)),
          //     ),
          // TextButton(onPressed: () {}, child: const Text('SIGN IN')),
          userModel.isLogin
              ? customListTile(context, 'User', 'assets/id.svg',
                  subtitle: userSubscribeModel?.userSubscribeEntity?.email ??
                      context.l10n.welcome,
                  trailing: IconButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        onLogoutTap(context, userModel);
                      },
                      icon:
                          Icon(Icons.exit_to_app, size: 30, color: Colors.red)))
              : customListTile(
                  context, context.l10n.login, 'assets/profile.svg',
                  onTap: () =>
                      //Navigator.of(context).push(MaterialPageRoute(
                      // builder: (builder) => const SettingsRoute()))
                      NavigatorUtil.goLogin(context)),
          divider,
          customListTile(context, 'Base Plan', 'assets/active.svg',
              trailing: upgradeButton(context)),
          divider,
          customListTile(
            context,
            'Restore',
            'assets/history.svg',
          ),
          divider,
          customListTile(context, 'Settings', 'assets/settings.svg',
              trailing: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkTheme
                          ? const Color.fromARGB(255, 148, 145, 145)
                          : const Color.fromARGB(255, 190, 187, 187))),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const SettingsRoute()))),
          divider,
          Text("App Version: 2.0.0",
              style: Theme.of(context).primaryTextTheme.labelMedium),

          // 删除账户按钮
          // userModel.isLogin
          //     ? GestureDetector(
          //         onTap: () => {
          //           // NavigatorUtil.goWebView(context, "Delete my account",
          //           // "https://uuvpn.co/help/Help.php?userid=${userModel.userEntity?.email}")

          //           NavigatorUtil.goWebView(context, "Delete My Account",
          //               "https://go.crisp.chat/chat/embed/?website_id=3ed83170-f288-4c23-acd4-30c1e557948b&user_email=${userModel.userEntity?.email}")
          //         },
          //         child: Container(
          //           alignment: Alignment.center,
          //           height: kToolbarHeight - 10,
          //           margin: const EdgeInsets.symmetric(
          //               horizontal: 32.0, vertical: 8),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(65),
          //               color: isDarkTheme
          //                   ? Color.fromARGB(255, 220, 66, 66)
          //                   : AppColors.greenColor),
          //           child: Text(
          //             'Delete My Account',
          //             style: Theme.of(context)
          //                 .primaryTextTheme
          //                 .headline6!
          //                 .copyWith(
          //                     color: isDarkTheme
          //                         ? AppColors.whiteColor
          //                         : Color.fromARGB(255, 9, 30, 4)),
          //           ),
          //         ),
          //       )
          //     : SizedBox(),
        ],
      ),
    );
  }
}
