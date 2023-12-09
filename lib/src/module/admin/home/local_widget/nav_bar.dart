import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:npi_project/src/module/admin/login/view/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  final String userName, roll;
  const NavBar({
    required this.userName,
    required this.roll,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
           DrawerHeader(
              child: Center(
            child: Column(
              children: [
                const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 42,
                    backgroundImage: AssetImage('assets/images/npi_logo.png')),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    userName,
                    style: TextStyle(
                        fontSize: 18.sp,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500
                    )),
                const SizedBox(
                  height: 5,
                ),
                Text(roll)
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: () async {
                  var sharedPref = await SharedPreferences.getInstance();
                  sharedPref.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLogInScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: Offset(5, 5))
                      ]),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Image.asset('assets/images/exit.png'),
                      const SizedBox(width: 30),
                      Text(
                        'Log out',
                        style: TextStyle(fontSize: 16.sp, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ));
  }
}