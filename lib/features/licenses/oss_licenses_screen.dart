import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/configs/app_colors.dart';
import '../../oss_licenses.dart';

class OssLicensesScreen extends StatelessWidget {
  const OssLicensesScreen({super.key});

  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenses = allDependencies.toList();
    for (var key in lm.keys) {
      licenses.add(
        Package(
          name: key,
          description: '',
          authors: [],
          version: '',
          license: lm[key]!.join('\n\n'),
          isMarkdown: false,
          isSdk: false,
          dependencies: [],
          devDependencies: const [],
        ),
      );
    }
    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Source Licenses')),
      body: FutureBuilder<List<Package>>(
        future: _licenses,
        initialData: const [],
        builder: (context, snapshot) {
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final package = snapshot.data![index];
                return ListTile(
                  title: Text('${package.name} ${package.version}'),
                  subtitle: package.description.isNotEmpty
                      ? Text(package.description)
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push('/oss-license', extra: {'package': package}),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          );
        },
      ),
    );
  }
}

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;

  const MiscOssLicenseSingle({super.key, required this.package});

  String _bodyText() {
    return package.license!
        .split('\n')
        .map((line) {
          if (line.startsWith('//')) line = line.substring(2);
          line = line.trim();
          return line;
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${package.name} ${package.version}')),
      body: SafeArea(
        child: Container(
          color: AppColors.background(context),
          child: ListView(
            children: <Widget>[
              if (package.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  child: Text(
                    package.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMain(context),
                    ),
                  ),
                ),
              if (package.homepage != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  child: InkWell(
                    child: Text(
                      package.homepage!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary(context),
                      ),
                    ),
                    onTap: () => launchUrlString(package.homepage!),
                  ),
                ),
              if (package.description.isNotEmpty || package.homepage != null)
                const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: Text(
                  _bodyText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMain(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
