import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  Widget _appBar() {
    return Row(
      children: const <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        SizedBox(width: 15),
        // TitleText(text: "Hello,"),
        Text(' Luna Boob,', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70)),
        Expanded(
          child: SizedBox(),
        ),
        // Icon(
        //   Icons.settings,
        //   color: Colors.green,
        // )
      ],
    );
  }

  Widget balanceCard(context) {
    return Container(
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .27,
            color: Colors.black12,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total Balance,',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '6,354',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: Colors.white70),
                        ),
                        Text(
                          ' Copper',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500, color: Colors.yellow.withAlpha(200)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 85,
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(color: Colors.white, width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text("Top up", style: TextStyle(color: Colors.white)),
                          ],
                        ))
                  ],
                ),
                Positioned(
                  left: -170,
                  top: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.blue.shade600,
                  ),
                ),
                const Positioned(
                  left: -160,
                  top: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Positioned(
                  right: -170,
                  bottom: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.blue.shade600,
                  ),
                ),
                Positioned(
                  right: -160,
                  bottom: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.blue.shade600,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _operationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _icon(Icons.add, "Bank"),
        _icon(Icons.phone, "something"),
        _icon(Icons.payment, "something"),
        _icon(Icons.code, "something"),
      ],
    );
  }

  Widget _icon(IconData icon, String text) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Color(0xffEEF2F5),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[BoxShadow(color: Color(0xfff3f3f3), offset: Offset(2, 2), blurRadius: 1)]),
            child: Icon(icon),
          ),
        ),
        Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff76797e))),
      ],
    );
  }

  Widget _transectionList() {
    return Column(
      children: <Widget>[
        _transection("Flight Ticket", "23 Feb 2020"),
        _transection("Electricity Bill", "25 Feb 2020"),
        _transection("Flight Ticket", "03 Mar 2020"),
      ],
    );
  }

  Widget _transection(String text, String time) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Icon(Icons.hd, color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(),
      title: Text('totle', style: TextStyle(color: Colors.white)),
      subtitle: Text(time, style: TextStyle(color: Colors.white)),
      trailing: Container(
          height: 30,
          width: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.green,
            // color: LightColor.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Text('-20 MLR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 35),
              _appBar(),
              const SizedBox(
                height: 20,
              ),
              // TitleText(text: "My wallet"),
              const SizedBox(
                height: 20,
              ),
              balanceCard(context),
              SizedBox(
                height: 50,
              ),
              // TitleText(
              //   text: "Operations",
              // ),
              SizedBox(
                height: 10,
              ),
              _operationsWidget(),
              SizedBox(
                height: 40,
              ),
              // TitleText(
              //   text: "Transactions",
              // ),
              _transectionList(),
            ],
          )),
    ));
  }
}
