import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuvpn/model/themeCollection.dart';
import 'package:uuvpn/models/app_model.dart';
import 'package:uuvpn/models/server_model.dart';
import 'package:uuvpn/utils/l10n.dart';
import 'package:uuvpn/widgets/bottom_block.dart';
import 'package:uuvpn/widgets/connection_stats.dart';
import 'package:uuvpn/widgets/logo_bar.dart';
import 'package:uuvpn/widgets/power_btn.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  late AppModel _appModel;
  late ServerModel _serverModel;

  customListTile(BuildContext context, String title, String icon,
          {Widget? trailing, String? subtitle, VoidCallback? onTap}) =>
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
          leading: SvgPicture.asset(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            width: 24,
            alignment: Alignment.centerRight,
          ),
          trailing: trailing);

  @override
  bool get wantKeepAlive => true;

  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appModel = Provider.of<AppModel>(context);
    _serverModel = Provider.of<ServerModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;

    return SingleChildScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // // Logo bar
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(75),
                right: ScreenUtil().setWidth(75)),
            child: LogoBar(
              isOn: _appModel.isOn,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // SvgPicture.asset(
          //   'assets/map.svg',
          //   height: 230,
          //   width: ScreenUtil().screenWidth,
          //   color: _appModel.isOn
          //       ? AppColors.greenColor
          //       : isDarkTheme
          //           ? AppColors.darkSurfaceColor
          //           : Color.fromARGB(255, 133, 132, 132),
          // ),
          const PowerButton(),
          const SizedBox(
            height: 40,
          ),
          _appModel.isOn
              ? (_serverModel.selectServerEntity?.name != null
                  ? Center(
                      child: Text(context.l10n.yilianjie,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            fontSize: 25,
                          )))
                  : Center(
                      child: Text(context.l10n.yilianjie,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            fontSize: 25,
                          ))))
              : Center(
                  child: Text(context.l10n.yiduankai2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        fontSize: 25,
                      ))),
          const SizedBox(
            height: 20,
          ),
          _appModel.isOn
              ? const ConnectionStats()
              : const SizedBox(
                  height: 1,
                ),

          const BottomBlock(),
        ],
      ),
    );
  }
}
