import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/playlist/playlist_db.dart';
import 'package:music_app/screens/settings_screen/privacy_and_policy.dart';
import 'package:music_app/screens/settings_screen/share_app.dart';
import 'package:music_app/screens/settings_screen/terms_and_condition.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('ABOUT US'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('About Musica'),
                      contentPadding: const EdgeInsets.all(20),
                      children: [
                        const Text(
                          'Welcome to Musica App, \n\n"when words fail, Musica speaks".\nWe are dedicated to providing you the very best quality of sound and the music varient, with an emphasis on new features. Playlist and Favorites and a rich user experience \n\nFounded in 2023 by Ijas Ahammed. Musica App is our first major project with a basis perfomance of music hub and creates a better version in future. Musica gives you the best music experience that you never had. It includes attractive mode of UI\'s and good practices.\n\nIt gives good quality and had increased the settings to power up the sysytem as well as to provide better music rythms. \n \n We hope enjoy our music as much as we enjoy offering them to you. If you have any questions or comments, please don\'t hesitate to contact us. \n\nSincierely, \n\nIjas Ahammed ,',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt_sharp),
                title: const Text('RESET APP'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Reset App',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: const Text(
                          """Are you sure do you want to reset the App?
Your saved data will be deleted.
                          """,
                          style: TextStyle(fontSize: 15),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<PlaylistDb>(context, listen: false)
                                  .resetAPP(context);
                              // PlaylistDb.resetAPP(context);
                              GetAllSongController.audioPlayer.stop();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('SHARE'),
                onTap: () {
                  shareAppFile(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outlined),
                title: const Text('PRIVACY & POLICY '),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet),
                title: const Text('TERMS AND CONDITION '),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionPage(),
                      ));
                },
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Version 1.0'),
          )
        ],
      ),
    );
  }
}
