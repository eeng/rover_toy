import 'package:flutter/material.dart';
import '../domain/settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  static Settings settings = Settings.getInstance();

  constrainTypeSelector() {
    return ListTile(
      title: Text('Constrain type'),
      subtitle: Text('Define the form of the joystick limits'),
      trailing: DropdownButton(
        items: [
          DropdownMenuItem(value: ConstrainType.box, child: Text('Box')),
          DropdownMenuItem(value: ConstrainType.circle, child: Text('Circle')),
        ],
        value: settings.constrainType,
        onChanged: (value) => setState(() => settings.constrainType = value),
      ),
    );
  }

  originSensibilitySlider() {
    return ListTile(
      subtitle: Text('Prevent triggering events of small movements'),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Origin sensibility'),
          Slider(
            min: 0.0,
            max: 30.0,
            value: settings.originSensibility.toDouble(),
            onChanged: (value) =>
                setState(() => settings.originSensibility = value.round()),
            activeColor: Colors.white70,
            inactiveColor: Colors.white24,
          ),
        ],
      ),
      trailing: SizedBox(
        width: 20.0,
        child: Text(settings.originSensibility.toString()),
      ),
    );
  }

  dangerousDistanceSlider() {
    return ListTile(
      subtitle: Text('Alert when distance is smaller than this (in cm)'),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Danger zone'),
          Slider(
            min: 0.0,
            max: 50.0,
            value: settings.dangerZone.toDouble(),
            onChanged: (value) =>
                setState(() => settings.dangerZone = value.round()),
            activeColor: Colors.white70,
            inactiveColor: Colors.white24,
          ),
        ],
      ),
      trailing: SizedBox(
        width: 20.0,
        child: Text(settings.dangerZone.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: <Widget>[
          constrainTypeSelector(),
          Divider(),
          originSensibilitySlider(),
          Divider(),
          dangerousDistanceSlider(),
        ],
      ),
    );
  }
}
