import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/auth/components/auth_home.dart';
import 'auth/auth.dart';
import 'db/notes_demo_page.dart';
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
  User? _user = Auth().currentUser;
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    //Done components go here
    const NotesDemoPage(),
    const Text(
      'Index 1: Friends',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    const AuthHome(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _listenForAuth();
  }

  void _listenForAuth() {
    Auth().authStateChanges.listen((User? user) {
      setState(() {
        _user = user;
      });
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

  Widget _buildBody() {
    if (_user == null) {
      return const AuthHome();
    }
    return _widgetOptions.elementAt(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: _title(),
      ),
      body: Center(
        child: _buildBody(),
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
