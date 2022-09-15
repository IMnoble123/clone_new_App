import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadiumButtons.dart';

class EnterNameScreen extends StatefulWidget {
  final String mobileNumber;
  final String token;

  const EnterNameScreen(
      {Key? key, required this.mobileNumber, required this.token})
      : super(key: key);

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  bool showProgress = false;

  final nameController = TextEditingController();

  bool enableEnter = false;

  @override
  void initState() {
    super.initState();

    nameController.text = '';

    nameController.addListener(() {

      if(nameController.text.length>=3){

        if(!enableEnter){

          setState(() {
            enableEnter = true;
          });

        }


      }else if(enableEnter){

        setState(() {
          enableEnter = false;
        });

      }

    });


  }


  @override
  void dispose() {

    nameController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            const LinearGradientBg(),
            Column(
              children: [
                const TomTomTitle(
                    title:  ''),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Please enter your name',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              child: TextField(
                                controller: nameController,
                                decoration:  InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 15.0),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle:
                                  TextStyle(color: Colors.black87),
                                  hintStyle:
                                  TextStyle(color: Colors.black87.withOpacity(0.4)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  hintText: 'user name',
                                ),
                                style: const TextStyle(color: Colors.black),
                                onEditingComplete: () {
                                  print('done click');
                                  FocusScope.of(context).unfocus();
                                  /*SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.immersiveSticky);*/
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'This name will appear on your TomTom profile.',
                            style: TextStyle(color: Colors.white,fontSize: 12),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Opacity(
                            opacity: enableEnter?1.0:0.4,
                            child: StadiumButton(
                              title: 'Enter',
                              callback: () {

                                if(!enableEnter) return;

                                submitName();

                                //Get.offAll( const MainScreen());
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (showProgress)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  void submitName() async {


    setState(() {
      showProgress = true;
    });

    Map<String, dynamic> q = {"mobile": widget.mobileNumber, "name": nameController.text.toString(),"token":widget.token};


    final res = await ApiService().otpSignupNew(q);

    setState(() {
      nameController.text = '';
      showProgress = false;
    });

    print(res);


    //AppConstants.navigateToDashBoard(context, res);

    AppConstants.navigateToDashBoard(context, res);


  }

}
