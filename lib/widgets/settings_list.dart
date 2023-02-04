import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  Widget buildListTile(
    BuildContext context,
    String title,
    IconData iconData,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: () {
          if (title == 'Topics') {
            Navigator.pushNamed(
              context,
              topicsRoute,
            );
          } else if (title == 'Statistics') {
            Navigator.pushNamed(
              context,
              statisticsRoute,
            );
          }
        },
        tileColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Icon(
              iconData,
              color: Theme.of(context).primaryColorLight,
            ),
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return index == 0
            ? buildListTile(
                context,
                'Topics',
                Icons.topic_outlined,
              )
            : buildListTile(
                context,
                'Statistics',
                Icons.analytics_outlined,
              );
      },
    );
  }
}
