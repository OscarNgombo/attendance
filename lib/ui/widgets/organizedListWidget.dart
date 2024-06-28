import 'package:flutter/material.dart';

Widget createOrganizedListWidget(Map<String, List<Map<String, dynamic>>> organizedData){
  List<Widget> dateCheckInWidgets = [];

  // Iterate over the organized data to create list items.
  for (var key in organizedData.keys) {
    List<Map<String, dynamic>> listItems = organizedData[key]!;

    // Create a widget to display the list items for each date and check-in time.
    // This can be a ListView, Column, or any other widget based on your UI design.
    Widget dateCheckInWidget = Column(
      children: [
        Text('Date and Check-In Time: $key'),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            // Customize how each list item is displayed.
            return ListTile(
              title: Text('Item ${index + 1}'),
              subtitle: Text(listItems[index]['additionalData'] ?? ''),
              // Add more widgets as needed for data display.
            );
          },
        ),
      ],
    );

    dateCheckInWidgets.add(dateCheckInWidget);
  }

  // Return a widget that contains all the organized data widgets.
  return Column(children: dateCheckInWidgets);
}
