import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/auth/rank.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/rankController.dart';
import '../../mixins/statistics_mixin.dart';
import '../../utils/game_colors.dart';
import '../../utils/game_consts.dart';
import '../../utils/game_sizes.dart';

class StatsTable extends StatelessWidget with StatisticsMixin {
  final GameMode gameMode;
  const StatsTable({Key? key, required this.gameMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rank = RankController();

    Future<RankModel?> getEmailAndItem() async {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? "";
      print('email: $email');

      RankModel? item = await rank.getItem(email);
      return item;
    }

    return FutureBuilder<RankModel?>(
      future: getEmailAndItem(),
      builder: (context, AsyncSnapshot<RankModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("statisticsError".tr()));
        }

        RankModel? item = snapshot.data!;

        return Padding(
          padding: GameSizes.getPadding(0.04),
          child: Column(
            children: [
              StatWidget(
                iconData: Icons.grid_on_rounded,
                statName: "gamesStarted".tr(),
                statValue: item.games,
              ),
              StatWidget(
                iconData: Icons.workspace_premium_outlined,
                statName: "gamesWon".tr(),
                statValue: item.won,
              ),
              StatWidget(
                iconData: Icons.flag_outlined,
                statName: "winRate".tr(),
                statValue: item.rate,
              ),
              StatWidget(
                iconData: Icons.timer_outlined,
                statName: "bestTime".tr(),
                statValue: item.best,
              ),
              StatWidget(
                iconData: Icons.access_time_sharp,
                statName: "averageTime".tr(),
                statValue: item.ave,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatWidget extends StatelessWidget {
  const StatWidget({
    Key? key,
    required this.iconData,
    required this.statName,
    required this.statValue,
  }) : super(key: key);

  final IconData iconData;
  final String statName;
  final dynamic statValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: GameSizes.getPadding(0.04),
      margin: EdgeInsets.only(bottom: GameSizes.getHeight(0.015)),
      decoration: BoxDecoration(
        color: GameColors.darkBlue.withOpacity(0.2),
        borderRadius: GameSizes.getRadius(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                iconData,
                size: GameSizes.getWidth(0.08),
                color: Colors.black,
              ),
              SizedBox(height: GameSizes.getHeight(0.015)),
              Text(
                statName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: GameSizes.getWidth(0.042),
                ),
              ),
            ],
          ),
          Text(
            statValue == null || statValue == 0 ? "-" : statValue.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: GameSizes.getWidth(0.048),
            ),
          ),
        ],
      ),
    );
  }
}
