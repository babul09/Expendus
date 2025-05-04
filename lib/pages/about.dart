import 'package:expen/core/theme.dart';
import 'package:expen/provider/version_provider.dart';
import 'package:expen/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  //Function to redirect for contacting developer
  Future<void> redirectUrl(query) async {
    Uri url = Uri.parse(query);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  //This function will show a license and credits page(everything used in the app)
  void showLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );
    Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) => themes.wrap(
              LicensePage(
                applicationName: applicationName,
                applicationVersion: applicationVersion,
                applicationIcon: applicationIcon,
                applicationLegalese: applicationLegalese,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: -1,
      title: "About",
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Contact Section
            Text(
              "Contact",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
           
            ListTile(
              onTap: () {
                redirectUrl(
                  "mailto:babulbishwas09@gmail.com?subject={From Expen App}",
                );
              },
              title: const Text("Email"),
              splashColor: AppColors.transparent,
              leading: const Icon(Icons.email_outlined),
              subtitle: const Text("babulbishwas09@gmail.com"),
            ),

            //About App
            Text(
              "App",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              onTap: () {
                showLicensePage(context: context);
              },
              title: const Text("Credits & Licenses"),
              leading: const Icon(Icons.badge_outlined),
              splashColor: AppColors.transparent,
              subtitle: const Text("Open Source Licesnses"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("App Version"),
              subtitle: Text(context.watch<VersionProvider>().version),
              splashColor: AppColors.transparent,
              leading: const Icon(Icons.android),
            ),

            //Developers Section
            Text(
              "Developers Section",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              onTap: () {
                redirectUrl("https://github.com/babul09");
              },
              title: const Text("GitHub"),
              splashColor: AppColors.transparent,
              leading: const Icon(Icons.code),
              subtitle: const Text("Babul_Bishwas"),
            ),
          ],
        ),
      ),
    );
  }
}
