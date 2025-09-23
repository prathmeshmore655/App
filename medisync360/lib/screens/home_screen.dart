import 'package:flutter/material.dart';
import 'package:medisync360/screens/ml_analyzers.dart';
import 'package:medisync360/screens/my_profile.dart';
import 'package:medisync360/screens/my_vault.dart';
import 'package:medisync360/screens/sos_screen.dart';
import 'package:medisync360/widgets/mapwidget.dart';
import 'chatbot_screen.dart';
import '../widgets/custom_appbar.dart';


class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediSync 360'),
        actions: [
          InkWell(
            onTap :() {
            
              Navigator.push(context, MaterialPageRoute(builder:(context) => const MyProfile()));
            },

                 child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  "username",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
              ],
            ),
            
          )
        ],
      ),

      

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, size: 80, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'MediSync 360 +',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chatbot'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('ML Analyzers'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MlAnalyzers()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Book Appointment'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MlAnalyzers()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('My Vault'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyVault()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: MapWidget(),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.warning ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SOS_Screen()));
        },
      ),
    );
  }
}

