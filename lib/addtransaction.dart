import 'package:flutter/material.dart';
import 'package:money_manager/Databese/db.dart';

// ignore: camel_case_types
class addtrans extends StatefulWidget {
  const addtrans({Key? key}) : super(key: key);

  @override
  State<addtrans> createState() => _addtransState();
}

// ignore: camel_case_types
class _addtransState extends State<addtrans> {

  final TextEditingController _date = TextEditingController();

  int? amount;
  String note = '';
  // ignore: non_constant_identifier_names
  DateTime selected_date = DateTime.now();
  String type = 'Income';
  String mode = 'Cash';

  // ignore: non_constant_identifier_names
  Future<void> _selected_date(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100)
    );
    if(picked != null && picked != selected_date){
      setState(() {
        selected_date = picked;
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        toolbarHeight: 0,
      ),
      floatingActionButton: GestureDetector(
        onTap: ()async{
          if(amount != null && note.isNotEmpty){
            await database().addData(amount!, selected_date, type, mode, note);
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 140,vertical: 15),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(8)
          ),
          child: const Text('ADD',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          Container(
            height: 210,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.only(top: 0,left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),

                  //Date
                  TextField(
                    showCursor: false,
                    keyboardType: TextInputType.none,
                    controller: _date,
                    onTap: (){
                      _selected_date(context);
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today),
                      prefixIconColor: Colors.black,
                      hintText: '${selected_date.day}/${selected_date.month}/${selected_date.year}',
                      hintStyle: const TextStyle(color: Colors.black),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),


                  const SizedBox(height: 20,),

                  //Amout
                  TextField(
                    onChanged: (val){amount = int.parse(val);},
                    style: const TextStyle(fontSize: 20,),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      prefixIcon: Icon(Icons.currency_rupee),
                      prefixIconColor: Colors.black,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(fontSize: 20)
                    ),
                    textCapitalization: TextCapitalization.words,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),

          //type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        ChoiceChip(
                          padding: const EdgeInsets.all(10),
                          pressElevation: 0,
                          elevation: 0,
                          selectedColor: Colors.amber,
                          label: const Text('Income',style: TextStyle(color: Colors.black),),
                          selected: type == 'Income' ? true : false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5))),
                          onSelected: (val){
                            setState(() {
                              type = 'Income';
                            });
                          },
                        ),
                        ChoiceChip(
                          padding: const EdgeInsets.all(10),
                          pressElevation: 0,
                          elevation: 0,
                          selectedColor: Colors.amber,
                          label: const Text('Expence',style: TextStyle(color: Colors.black),),
                          selected: type == 'Expence' ? true : false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5))),
                          onSelected: (val){
                            setState(() {
                              type = 'Expence';
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),

                //mode
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Row(
                      children: [
                        ChoiceChip(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.all(10),
                          pressElevation: 0,
                          elevation: 0,
                          selectedColor: Colors.amber,
                          label: const Text('Cash',style: TextStyle(color: Colors.black),),
                          selected: mode == 'Cash' ? true : false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5))),
                          onSelected: (val){
                            setState(() {
                              mode = 'Cash';
                            });
                          },
                        ),
                        ChoiceChip(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.all(10),
                          pressElevation: 0,
                          elevation: 0,
                          selectedColor: Colors.amber,
                          label: const Text('Online',style: TextStyle(color: Colors.black),),
                          selected: mode == 'Online' ? true : false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5))),
                          onSelected: (val){
                            setState(() {
                              mode = 'Online';
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30,),


                //note
                TextField(
                  onChanged: (val){note = val;},
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 2)
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.image,color: Colors.black,),
                      onPressed: (){},
                    ),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      labelText: 'Note',
                    labelStyle: const TextStyle(color: Colors.black)
                  ),
                  textCapitalization: TextCapitalization.words,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}