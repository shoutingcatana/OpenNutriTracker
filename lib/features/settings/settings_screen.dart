import 'package:flutter/material.dart';
import 'package:opennutritracker/core/utils/app_const.dart';
import 'package:opennutritracker/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingsLabel),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16.0),
          ListTile(
            leading: const Icon(Icons.ac_unit_outlined),
            title: Text(S.of(context).settingsUnitsLabel),
            onTap: () => _showUnitsDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(S.of(context).settingsDisclaimerLabel),
            onTap: () => _showDisclaimerDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: Text(S.of(context).settingsReportErrorLabel),
            onTap: () => _showReportErrorDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.error_outline_outlined),
            title: Text(S.of(context).settingAboutLabel),
            onTap: () => _showAboutDialog(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 32.0),
            child: FutureBuilder(
              // Version name needs future
              future: _getVersionNumber(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            child:
                                Image.asset('assets/icon/ont_logo_square.png'),
                          ),
                          Text(S.of(context).appTitle,
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      Text(S.of(context).appVersionName(snapshot.requireData))
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _showUnitsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Wrap(children: [
                Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabled: false,
                        filled: false,
                        labelText: S.of(context).settingsMassLabel,
                      ),
                      onChanged: null,
                      items: const [
                        DropdownMenuItem(child: Text('kg, g, mg'))
                      ], // TODO add units
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabled: false,
                        filled: false,
                        labelText: S.of(context).settingsDistanceLabel,
                      ),
                      onChanged: null,
                      items: const [DropdownMenuItem(child: Text('cm, m, km'))],
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabled: false,
                        filled: false,
                        labelText: S.of(context).settingsVolumeLabel,
                      ),
                      onChanged: null,
                      items: const [DropdownMenuItem(child: Text('ml, l'))],
                    ),
                  ],
                ),
              ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).dialogOKLabel))
              ]);
        });
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).settingsDisclaimerLabel),
            content: Text(S.of(context).disclaimerText),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).dialogOKLabel))
            ],
          );
        });
  }

  void _showReportErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).settingsReportErrorLabel),
            content: Text(S.of(context).reportErrorDialogText),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).dialogCancelLabel)),
              TextButton(
                  onPressed: () async {
                    _reportError(context);
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).dialogOKLabel))
            ],
          );
        });
  }

  Future<void> _reportError(BuildContext context) async {
    final reportUri =
        Uri.parse("mailto:${AppConst.reportErrorEmail}?subject=Report_Error");

    if (await canLaunchUrl(reportUri)) {
      launchUrl(reportUri);
    } else {
      // Cannot open email app, show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorOpeningEmail)));
    }
  }

  void _showAboutDialog(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
        context: context,
        applicationName: S.of(context).appTitle,
        applicationIcon: SizedBox(
            width: 40, child: Image.asset('assets/icon/ont_logo_square.png')),
        applicationVersion: packageInfo.version,
        applicationLegalese: S.of(context).appLicenseLabel,
        children: [
          TextButton(
              onPressed: () {
                _launchSourceCodeUrl(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.code_outlined),
                  const SizedBox(width: 8.0),
                  Text(S.of(context).settingsSourceCodeLabel),
                ],
              ))
        ]);
  }

  void _launchSourceCodeUrl(BuildContext context) async {
    final sourceCodeUri = Uri.parse(AppConst.sourceCodeUrl);
    if (await canLaunchUrl(sourceCodeUri)) {
      launchUrl(sourceCodeUri, mode: LaunchMode.externalApplication);
    } else {
      // Cannot open browser app, show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorOpeningBrowser)));
    }
  }

  Future<String> _getVersionNumber(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}