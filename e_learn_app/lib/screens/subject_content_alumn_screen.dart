import 'package:e_learn_app/data/GlobalData.dart';
import 'package:e_learn_app/models/asignaturas.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectContentAlumnScreen extends StatefulWidget {

  Asignatura subject_info;
   
  SubjectContentAlumnScreen({Key? key, required this.subject_info}) : super(key: key);

  @override
  State<SubjectContentAlumnScreen> createState() => _SubjectContentAlumnScreenState();
}

class _SubjectContentAlumnScreenState extends State<SubjectContentAlumnScreen> {

  AlumnContentService _alumnContentService = AlumnContentService();
  Map<String, dynamic> listContent = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    Map<String, dynamic> data = await _alumnContentService.loadContentSubject(widget.subject_info.id);

    setState(() {
      listContent = data;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(widget.subject_info.nombre, style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
        ),
        actions: [
          
          Padding(  
            padding: EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/E-Learn_logotipo-removebg-preview.png', 
              fit: BoxFit.cover, 
              height: 80.0, 
              width: 80.0,
            ),
          ),

        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [

                SizedBox(height: 30,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Container(
                      child: Text(widget.subject_info.nombre, style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 40.0, fontWeight: FontWeight.bold))
                    ),
                  ),
                ),

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
                  ],
                ),
            
                SizedBox(height: 20,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: Text(
                        widget.subject_info.descripcion,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 20,),
            
                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

              ],
            )
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext contex, int index) {
                final contentEntry = listContent.entries.elementAt(index);
                final sectionName = contentEntry.key;
                Map<String, dynamic> sectionContent = {};
                
                if(contentEntry.value != ""){
                  sectionContent = contentEntry.value;
                }

                return Card(
                  child: Column(
                    children: [

                      SizedBox(height: 30,),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Container(
                            child: Text(
                              sectionName,
                              style: TextStyle(
                                color: Color.fromRGBO(90, 70, 178, 1),
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: sectionContent.entries.map((entry) {
                              return Container(
                                height: 65,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(90, 70, 178, 1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0,3))
                                  ]
                                ),
                                child: GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0, top: 16.0, ),
                                    child: Text(entry.key, style: TextStyle(fontSize: 25, color: Colors.white),),
                                  ),
                                  onTap: () {
                                    print(entry.value);
                                    _alumnContentService.loadFileContent(entry.key, entry.value);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )

                    ],
                  ),
                  
                );
              },
            childCount: listContent.length
            ),
          ),
        ],
      )
    );
  }
}