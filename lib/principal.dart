import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbmanager.dart';
import 'Student.dart';

class principal extends StatefulWidget {
  const principal({Key? key}) : super(key: key);

  @override
  State<principal> createState() => _principal();
}

class _principal extends State<principal> {
  Future<List<Student>>? Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerApepa = TextEditingController();
  TextEditingController controllerApema = TextEditingController();
  TextEditingController controllerTel = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  String? name = '';
  String? apepa = '';
  String? apema = '';
  String? tel = '';
  String? email = '';
  String? photo_name = '';
  int? currentUserId;
  final formKey = GlobalKey<FormState>();
  late var dbHelper;
  late bool isUpdating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = dbManager();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  refreshListSearch() {
    setState(() {
      Studentss = dbHelper.getStudentsSpecified("name",controllerName.text);
    });
  }

  clearData() {
    controllerName.text = "";
    controllerApepa.text = "";
    controllerApema.text = "";
    controllerTel.text = "";
    controllerEmail.text = "";
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        Student stu =
        Student(
            currentUserId,
            name,
            apepa,
            apema,
            tel,
            email,
            photo_name);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(
            null,
            name,
            apepa,
            apema,
            tel,
            email,
            photo_name);
        dbHelper.save(stu);
      }
      clearData();
      refreshList();
    }
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640).then((
        imgFile) async {
      Uint8List? imageBytes = await imgFile?.readAsBytes();
      setState(() {
        photo_name = Utility.base64String(imageBytes!);
      });
      //refreshImages();
    });
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'Ingrese un nombre' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controllerApepa,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Apellido Paterno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'Ingrese Apellido Paterno' : null,
              onSaved: (val) => apepa = val,
            ),
            TextFormField(
              controller: controllerApema,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Apellido Materno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'Ingrese Apellido Materno' : null,
              onSaved: (val) => apema = val,
            ),
            TextFormField(
              controller: controllerTel,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'Ingrese Teléfono' : null,
              onSaved: (val) => tel = val,
            ),
            TextFormField(
              controller: controllerEmail,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'E-mail' : null,
              onSaved: (val) => email = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: validate,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(isUpdating ? Icons.update : Icons.add_box),
                ),
                MaterialButton(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(Icons.photo_library_outlined),
                ),
                MaterialButton(
                  onPressed: () {
                    refreshListSearch();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(Icons.manage_search_outlined),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    refreshList();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(Icons.search_off_outlined),
                ),
                MaterialButton(
                  onPressed: () {
                    clearData();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(Icons.clear),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Student>? Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Imagen')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Apellido Paterno')),
            DataColumn(label: Text('Apellido Materno')),
            DataColumn(label: Text('Teléfono')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Borrar')),
          ],
          rows: Studentss!
              .map((mapStudent) =>
              DataRow(cells: [
                DataCell(Container(
                  width: 80,
                  height: 120,
                  child:
                  Utility.ImageFromBase64String(mapStudent.photo_name!),
                )),
                DataCell(Text(mapStudent.name!), onTap: () {
                  setState(() {
                    isUpdating = true;
                    currentUserId = mapStudent.controlNum;
                  });
                  controllerName.text = mapStudent.name!;
                  controllerApepa.text = mapStudent.apepa!;
                  controllerApema.text = mapStudent.apema!;
                  controllerTel.text = mapStudent.tel!;
                  controllerEmail.text = mapStudent.email!;
                }),
                DataCell(Text(mapStudent.apepa!)),
                DataCell(Text(mapStudent.apema!)),
                DataCell(Text(mapStudent.tel!)),
                DataCell(Text(mapStudent.email!)),
                DataCell(IconButton(
                  onPressed: () {
                    dbHelper.delete(mapStudent.controlNum);
                    refreshList();
                  },
                  icon: const Icon(Icons.delete),
                ))
              ]))
              .toList(),
        ),
      )
    );
  }

  Widget list() {
    return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Studentss,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return dataTable(snapshot.data);
                }
                if (snapshot.hasData == null) {
                  print("Data not Found");
                }
                return const CircularProgressIndicator();
              }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PAD_U1_AG1_Equipo1"),
        centerTitle: true,
      ),
      body:
        ListView(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              form(),
              list(),
            ]
        )

    );
  }
}