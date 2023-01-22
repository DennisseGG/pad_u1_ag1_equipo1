import 'package:flutter/material.dart';
import 'principal.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú de navegación"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          const UserAccountsDrawerHeader(
              accountName: Text("Equipo 1"),
              accountEmail: Text("equipo1@unideh.edu.mx")),
          Card(
            child: ListTile(
              title: const Text("Inicio"),
              trailing: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("CRUD Estudiantes"),
              trailing: const Icon(Icons.accessibility_new_rounded),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => principal()));
              },
            ),
          ),
        ]),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                "Programación Avanzada de Dispositivos Móviles\n"
                    "PAD_U1_AG1_Equipo1",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            Text("Ingeniería de software\n"
                "Décimo cuatrimestre",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            Text("Tutor: \nJorge Alberto Hernández Tapia\n"
                "\nAlumnos:\n"
                "José Rafael García Ceme\n"
                "Héctor Miguel Cruz García\n"
                "Oscar Manuel Elizalde Razo\n"
                "Daniela Dennisse Gallegos García\n"
                "Rafael García Cobos\n",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
