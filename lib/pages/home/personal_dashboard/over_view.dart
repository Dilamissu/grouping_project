import 'package:flutter/material.dart';
import 'package:grouping_project/VM/workspace_dashboard_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/button/overview_choice_button.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_mission_page.dart';
import 'package:provider/provider.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int overViewIndex = 0;
  late int eventNumbers = 0;
  late int missionNumbers = 0;

  DataController dataController = DataController();

  List<Widget> pages = [
    const EventPage(),
    const MissionPage(),
    ListView(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        ),
      ],
    ),
  ];

  final line = const Divider(
    height: 1,
    thickness: 2,
  );

  final buttonInfo = {
    'event': {
      'label': '事件 - 即將到來',
      'icon': 'assets/icons/calendartick.svg',
      'number': '0',
    },
    'mission': {
      'label': '任務 - 即將到來',
      'icon': 'assets/icons/task.svg',
      'number': '1',
    },
    'group': {
      'label': '群組 - 即將到來',
      'icon': 'assets/icons/messagetick.svg',
      'number': '2',
    },
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Consumer<WorkspaceDashboardViewModel>(
        builder: (context, model, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OVERVIEW',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            line,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: buttonInfo.entries
                    .map((entry) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: OverViewChoiceButton(
                              onTap: () {
                                model.updateOverViewIndex(int.parse(
                                    entry.value['number']!)); // setEnable(0);
                              },
                              labelText: entry.value['label']!,
                              iconPath: entry.value['icon']!,
                              numberText: model.eventList.length,
                              isSelected: int.parse(entry.value['number']!) ==
                                  model.overView,
                            ),
                          ),
                        ))
                    .toList()),
            Expanded(
              flex: 4,
              child: Container(child: pages[model.overViewIndex]),
            )
          ],
        ),
      ),
    );
  }
}

