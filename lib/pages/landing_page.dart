import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsden/home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10,),
        child: Column(
          children: [
            Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 3.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset('images/first.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.7,
                fit: BoxFit.cover,),
              ),
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Text('News from the world',style: TextStyle(
                  color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold
                ),),
                 Text('for you',style: TextStyle(
                  color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 10,),
                 Text('Best time to read a little more',style: TextStyle(
              color: Colors.black45,fontSize: 20,fontWeight: FontWeight.w500
            ),),
             Text('of this world',style: TextStyle(
              color: Colors.black45,fontSize: 20,fontWeight: FontWeight.w500
            ),),
              ],
            ),
              
            SizedBox(height: 40,),

            
               Container(
                  width: MediaQuery.of(context).size.width/1.2,
                child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                        Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (builder) => Home()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Get Started',style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                        ),),
                      ),
                    ),
                  ),
                ),
              ),
          
          ],
        ),
      ),
    );
  }
}