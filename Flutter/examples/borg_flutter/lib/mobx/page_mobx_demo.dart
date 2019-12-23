import 'package:borg_flutter/mobx/multi_counter/multi_counter_store.dart';
import 'package:borg_flutter/mobx/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'examples.dart';
import 'settings/preferences_service.dart';
import 'connectivity/connectivity_store.dart';

class MobxDemo extends StatelessWidget {
  static const String routeName = '/page/mobx';
  static const String name = "MobxDemo";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MultiCounterStore>(
          builder: (_) => MultiCounterStore(),
        ),
        Provider<PreferencesService>(
          builder: (_) => PreferencesService(),
        ),
        ProxyProvider<PreferencesService, SettingsStore>(
            builder: (_, preferencesService, __) =>
                SettingsStore(preferencesService)),
        Provider<ConnectivityStore>(
          builder: (_) => ConnectivityStore(),
        )
      ],
      child: Consumer<SettingsStore>(
        builder: (_, store, __) => Observer(
          builder: (_) => MaterialApp(
            initialRoute: '/',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness:
              store.useDarkMode ? Brightness.dark : Brightness.light,
            ),
            routes: {
              '/': (_) => ExampleList(),
            }..addEntries(
                examples.map((ex) => MapEntry(ex.path, ex.widgetBuilder))),
          ),
        ),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MobX Examples'),
      ),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (_, int index) {
          final ex = examples[index];

          return ListTile(
            title: Text(ex.title),
            subtitle: Text(ex.description),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, ex.path),
          );
        },
      ));
}
