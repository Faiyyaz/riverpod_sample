import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants.dart';
import '../../theme/theme.dart';

class ReUsableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const ReUsableAppBar({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(
          Pallete.blueColor,
          BlendMode.srcIn,
        ),
        height: 30.0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + MediaQuery.paddingOf(context).top,
      );
}
