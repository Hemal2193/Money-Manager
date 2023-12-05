import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/Databese/db.dart';
import 'package:money_manager/addtransaction.dart';
import 'page_transition.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  int totalBalance = 0;
  int totalincome = 0;
  int totalexpence = 0;

  getTotalBalance(Map entireData){
    totalincome = 0;
    totalexpence = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      if(value['type'] == 'Income'){
        totalBalance += (value['amount'] as int);
        totalincome += (value['amount'] as int);
      }else{
        totalBalance -= (value['amount'] as int);
        totalexpence += (value['amount'] as int);
      }
    }
    );
  }


  database db = database();

  TextEditingController name = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            PageTransition(
              enterPage: const addtrans(),
            ),
          ).then((value) {
            setState(() {
              _scrollToTop();
            });
          });
        },
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add,color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<Map>(
        future: db.fetch(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(child: Text('Unexpected Error !'),);
          }
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return const Center(child: Text('No Data !'),);
            }
            getTotalBalance(snapshot.data!);
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 5,color: Colors.grey,spreadRadius: 2)
                        ],
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.amber,
                                Colors.amber.shade700,
                                Colors.amber
                              ]
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            const Text('Total Balance'),
                            const SizedBox(height: 10,),
                            Text('₹$totalBalance',style: const TextStyle(fontSize: 35),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  //income
                                  incomeCard(totalincome),


                                  //Expence
                                  expenceCard(totalexpence),
                                  
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                    'Recent Transactions',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      reverse: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        final displayIndex = snapshot.data!.length - 1 - index;
                        Map dataAtIndex = snapshot.data![displayIndex];
                        if(dataAtIndex['type'] == 'Income'){
                          return incomeTile(dataAtIndex['amount'],dataAtIndex['note']);
                        }
                        if(dataAtIndex['type'] == 'Expence'){
                          return expenceTile(dataAtIndex['amount'],dataAtIndex['note']);
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            );
          }else{
            return const Center(child: Text('Unexpected Error !'),);
          }
        },
      )
    );
  }

  void _scrollToTop() {
    _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
}



Widget incomeCard(int inc){
  return Container(
    width: 130,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(blurRadius: 5,spreadRadius: 2,color: Colors.amber.shade700)
      ],
      color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.only(right: 7),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.arrow_downward),
        ),
        const SizedBox(width: 10,),
        Text('₹$inc',style: TextStyle(color: Colors.black,fontSize: inc>99999?15:20),)
      ],
    ),
  );
}

Widget expenceCard(int exp){
  return Container(
    width: 130,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(blurRadius: 5,color: Colors.amber.shade700,spreadRadius: 2)
      ],
      color: Colors.amber,
        // color: const Color.fromRGBO(255,137,141,1),
        borderRadius: BorderRadius.circular(10)
    ),
    padding: const EdgeInsets.only(right: 7),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.arrow_upward),
        ),
        const SizedBox(width: 10,),
        Text('₹$exp',style: TextStyle(color: Colors.black,fontSize: exp>9999?15:20),)
      ],
    ),
  );
}

Widget incomeTile(int value,String note){
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.green.shade300,
      borderRadius: BorderRadius.circular(10)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_circle_down,size: 30,),
            const SizedBox(width: 5,),
            Text(note,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
          ],
        ),
        Text('+ $value',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
      ],
    ),
  );
}

Widget expenceTile(int value,String note){
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(10)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_circle_up,size: 30,),
            const SizedBox(width: 5,),
            Text(note,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
          ],
        ),
        Text('- $value',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
      ],
    ),
  );
}
}