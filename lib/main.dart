import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/auth/auth_home.dart';
import 'auth/auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'SourceSansPro',
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? _user = Auth().currentUser;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    //Done components go here
    const Text(
      'Index 0: Feed',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    const Text(
      'Index 1: Friends',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    const Text(
      'Index 2: Profile',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //TODO: implement the title change
  Widget _title() {
    return const Text(
      'Networking App',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return AuthHome();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: _title(),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.primaries[0],
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
