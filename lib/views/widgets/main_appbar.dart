import 'dart:async';
import 'package:app_movil_channel_iptv/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late String _timeString;
bool boolPagina = true;

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppbar(
      {super.key});

  @override
  State<MainAppbar> createState() => _MainAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _MainAppbarState extends State<MainAppbar> {
  late FocusNode iconButtonFocusNode;
  late FocusNode settingsButtonFocusNode;

  late bool isUpdateContent = false;

  @override
  void initState() {
    _timeString = DateFormat('hh:mm a').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTimeString());
    super.initState();
  }

  _getTimeString() {
    if (mounted) {
      setState(() {
        _timeString = DateFormat('hh:mm a').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //LOGO
          const Image(
            image: AssetImage(Const.imgLogo),
            fit: BoxFit.contain,
            height: 80,
          ),
          //ESPACIO LINEA
          const SizedBox(
              height: 50,
              child: VerticalDivider(
                  color: Const.colorWhiteTransparent, thickness: 2)),
          //FECHA
          Text(
            '${DateFormat.yMMMEd().format(DateTime.now())} - $_timeString',
            style: Const.fontHeaderTextStyle,
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
