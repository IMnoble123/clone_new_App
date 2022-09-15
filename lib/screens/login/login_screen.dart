import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/controllers/countries_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/request/social_user_data.dart';
import 'package:podcast_app/models/response/countries_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/network/network_config.dart';
import 'package:podcast_app/screens/login/countries_list.dart';
import 'package:podcast_app/screens/login/email_signin_screen.dart';
import 'package:podcast_app/screens/login/otp_screen.dart';
import 'package:podcast_app/screens/login/register_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/tc/terms_conditions.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';
import 'package:podcast_app/widgets/circle_btn.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileInputController = TextEditingController();

  final authController = Get.find<AuthController>();

  bool isProgress = false;

  Timer? _timer;

  String countryCode = "+91";

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    mobileInputController.text = '';

    authController.fetchCountries();
  }

  @override
  void dispose() {
    super.dispose();
    mobileInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const LinearGradientBg(),
              Column(
                children: [
                  GestureDetector(
                      onPanCancel: () => _timer?.cancel(),
                      onPanDown: (_) => {
                            _timer = Timer(const Duration(seconds: 5), () {
                              _timer?.cancel();
                              showPopup();
                            })
                          },
                      onPanUpdate: (d) => _timer?.cancel(),
                      onTapUp: (d) => _timer?.cancel(),
                      child: const TomTomTitle(
                        title: 'LOG IN',
                        height: 125,
                        width: 125,
                        hideTitle: true,
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /*const Text('New user?',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: MaterialButton(
                                minWidth: 120,
                                onPressed: () {
                                  Get.to(const RegisterScreen());
                                },
                                shape: const StadiumBorder(),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                color: const Color.fromARGB(255, 186, 16, 19),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.5),
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Existing user? Sign in with OTP',
                                // 'Please enter the Registered number\n to get the OTP',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),*/
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                child: Row(
                                  children: [
                                    /*const Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 2.0),
                                      child: Icon(Icons.phone_android),
                                    ),*/
                                    /*SizedBox(
                                      width: 50,
                                      child: CountryCodePicker(onChanged: (cc){
                                        print(cc.dialCode);
                                      },

                                        //dialogSize:  Size(double.infinity, MediaQuery.of(context).size.height),
                                        initialSelection: 'IN',
                                        favorite: ['+91','IN'],
                                        padding: EdgeInsets.zero,
                                        showFlagDialog: true,
                                        barrierColor: Colors.transparent,
                                        showFlag: false,
                                      ),
                                    ),*/
                                    /*Obx(() =>
                                        authController.isCountriesLoading.value
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    )),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Material(
                                                  child: InkWell(
                                                    onTap: () {

                                                      */ /*showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Countries List',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .firstColor),
                                                              ),
                                                              content:
                                                                  setupAlertDialoadContainer(
                                                                      context),
                                                              actions: [
                                                                TextButton(onPressed: (){
                                                                  Navigator.of(context).pop();
                                                                }, child: const Text('Cancel',style: TextStyle(color: AppColors.firstColor),))
                                                              ],
                                                            );
                                                          }).then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            countryCode = value;
                                                          });
                                                        }
                                                      });*/ /*

                                                      Get.put(CountriesController());

                                                      Get.find<CountriesController>().clearSearch();
                                                      Get.find<CountriesController>().fetchCountries();

                                                      Get.to(const CountriesList())!.then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            countryCode = value;
                                                          });
                                                        };
                                                      });

                                                    },
                                                    child: Text(
                                                      countryCode,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .phoneTextColor,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              )),*/

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Get.put(CountriesController());

                                            Get.find<CountriesController>()
                                                .clearSearch();
                                            Get.find<CountriesController>()
                                                .fetchCountries();

                                            Get.to(const CountriesList())!
                                                .then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  countryCode = value;
                                                });
                                              }
                                              ;
                                            });
                                          },
                                          child: Text(
                                            countryCode,
                                            style: const TextStyle(
                                                color: AppColors.phoneTextColor,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0, vertical: 10.0),
                                      child: VerticalDivider(
                                        color: AppColors.phoneTextColor,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        controller: mobileInputController,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: AppColors.phoneTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                            hintText: 'Mobile Number',
                                            counterText: "",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            fillColor: Colors.white,
                                            filled: true),
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                          /*SystemChrome.setEnabledSystemUIMode(
                                              SystemUiMode.immersiveSticky);*/
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            /*TextField(
                              controller: mobileInputController,
                              style:  TextStyle(
                                  color: Color.fromARGB(255, 51, 76, 116),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  prefixIcon: Icon(Icons.phone_android),
                                  prefix: Text(''),
                                  border: OutlineInputBorder(),
                                  hintText: 'Mobile Number',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  filled: true),
                              keyboardType: TextInputType.number,
                              maxLength: 13,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.immersiveSticky);
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),*/

                            Visibility(
                              visible: false,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  text:
                                      'Did not registered with this number.\nPlease',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Register ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.firstColor,
                                        )),
                                    TextSpan(
                                      text: 'or continue as',
                                    ),
                                    TextSpan(
                                        text: ' Guest  ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.firstColor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            /*const Text(
                              'Did not registered with this number. Please Register or continue as Guest',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),*/
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: MaterialButton(
                                minWidth: 120,
                                onPressed: () async {
                                  /*setState(() {
                                    isProgress = true;
                                  });*/
                                  //await Get.offAll(const MainScreen());

                                  sendOtp(context);

                                  //Get.to(OtpScreen(mobileNumber: mobileInputController.text));
                                },
                                shape: const StadiumBorder(),
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                color: const Color.fromARGB(255, 186, 16, 19),
                              ),
                            ),
                            /*Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.4),
                                  )),
                            ),*/
                            /* const Text(
                              'Or Login with',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 199, 178, 178),
                                  fontSize: 14),
                            ),*/
                            const SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.4),
                                  )),
                            ),

                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 50,
                                    // width: 75,
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.5),
                                    )),
                                //const Text(' Or ',style: TextStyle(color: Colors.white),),
                                SizedBox(
                                    width: 50,
                                    // width: 75,
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.5),
                                    )),
                              ],
                            ),*/
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /*CircleButton(
                                  child: Image.asset(
                                    'images/email_new.png',
                                    scale: 3,
                                  ),
                                  tapCallback: () {
                                    Get.to(const EmailSignInScreen());
                                  },
                                ),*/
                                CircleButton(
                                  child: Image.asset(
                                    'images/gmail_new.png',
                                    scale: 3,
                                  ),
                                  tapCallback: () {
                                    googleSignIn();
                                  },
                                ),
                                CircleButton(
                                  child: Image.asset(
                                    'images/fb_new.png',
                                    scale: 3,
                                  ),
                                  tapCallback: () {
                                    fbLogin();
                                  },
                                ),
                                Opacity(
                                  opacity: Platform.isIOS ? 1.0 : 0.5,
                                  child: CircleButton(
                                    child: Image.asset(
                                      'images/apple_new.png',
                                      scale: 3,
                                    ),
                                    tapCallback: () {
                                      // Get.offAll(() => const MainScreen());

                                      if (Platform.isIOS) {
                                        appleSingIn(context);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.4),
                                  )),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            RichText(
                              text: TextSpan(
                                  text:
                                      'By Continuing, I certify I’m over 13 years of age \nand accept the',
                                  style: const TextStyle(
                                      height: 1.5, fontSize: 11
                                  ),
                                  children: [
                                    TextSpan(
                                        text: ' Terms & Conditions',
                                        style: const TextStyle(
                                            color: AppColors.firstColor,fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()..onTap = () => openTC(),)
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'By Continuing, I certify I’m over 13 years of age \nand accepting the ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                WrapTextButton(
                                  title: 'Terms & Conditions',
                                  textColor: AppColors.firstColor,
                                  boldText: true,
                                  callback: () {
                                    Get.to(() => const TermsAndConditionsScreen(
                                          title: 'Terms & Conditions',
                                          url:
                                              'https://www.tomtompodcast.com/mterms.html',
                                        ));
                                    *//*AppSharedPreference()
                                        .saveStringData(AppConstants.USER_ID,
                                            '-1') // '-1' means Guest user
                                        .then((value) =>
                                            Get.offAll(() => const MainPage()));*//*

                                    //Get.offAll(() => const MainPage());
                                    // Get.offAll(() => const MainScreen());
                                  },
                                )
                              ],
                            ),*/
                            const SizedBox(
                              height: 10,
                            ),
                            /* Image.asset(
                              'images/ls_mic.png',
                              width: 80,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'For new user register here',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),*/

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                  width: 150,
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.4),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Or Continue as a ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                WrapTextButton(
                                  title: 'GUEST',
                                  textColor: AppColors.firstColor,
                                  boldText: true,
                                  callback: () {
                                    CommonNetworkApi().mobileUserId = "-1";
                                    Get.offAll(() => const MainPage());
                                    /*AppSharedPreference()
                                        .saveStringData(AppConstants.USER_ID,
                                            '-1') // '-1' means Guest user
                                        .then((value) =>
                                            Get.offAll(() => const MainPage()));*/

                                    //Get.offAll(() => const MainPage());
                                    // Get.offAll(() => const MainScreen());
                                  },
                                )
                              ],
                            ),
                            /* RichText(
                              text: TextSpan(
                                text: 'Or Continue as a ',
                                style: const TextStyle(color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'GUEST',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print('Guest');
                                          Get.offAll(() => const MainScreen());
                                        },
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 186, 16, 19))),
                                ],
                              ),
                            ),*/
                            const SizedBox(
                              height: 100,
                            )
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
                ),
              /*isProgress
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink()*/
            ],
          ),
        ),
      ),
    );
  }

  bool showProgress = false;

  void sendOtp(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (mobileInputController.text.isEmpty ||
        mobileInputController.text.length < 8) {
      AppDialogs.simpleOkDialog(
          context, 'Alert!', "Please enter valid mobile number");
      return;
    }

    setState(() {
      showProgress = true;
    });

    String mobileNumber = countryCode + mobileInputController.text;

    Map<String, dynamic> q = {"mobile": mobileNumber};
    // Map<String, dynamic> q = {"mobile": mobileInputController.text};

    // final res = await ApiService().sendOtp(q);
    final res = await ApiService().sendNewOtp(q);

    try {
      ResponseData responseData = ResponseData.fromJson(res);

      setState(() {
        showProgress = false;
      });

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        Get.to(OtpScreen(mobileNumber: mobileNumber));
      } else {
        AppDialogs.simpleOkDialog(context, 'Failed',
            responseData.response ?? "unable to process request");
      }
    } catch (e) {
      print(e);
      setState(() {
        showProgress = false;
      });
    }
  }

  void googleSignIn() async {
    /*GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await _googleSignIn.signIn();

    print(_googleSignIn.currentUser?.email);
    print(_googleSignIn.currentUser ?? 'null');

    postGoogleSignInData(_googleSignIn.currentUser!);*/




    signInWithGoogle().then((userCredential) {
      User user = userCredential.user!;
      postGoogleSignInData(user);
    }).catchError((e, s) {
      print(e);
    });

    /*_googleSignIn.currentUser?.authentication
        .then((auth){
          postGoogleSignInData(auth);
    });*/
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth == null) {
      throw Exception('canceled');
    }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void fbLogin() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    try {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      setState(() {
        showProgress =true;
      });

      final result = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      print(result.user!.displayName);

      User? user = result.user!;

      final socialUser = SocialUserData(
          email: user.email,
          name: user.displayName,
          source: 'facebook',
          gmailId: "",
          gender: "Male",
          //userData['gender'] ?? 'Male',
          appleId: "",
          dob: "",
          facebookId: user.uid,
          mobile: user.phoneNumber ?? AppConstants.getRandomNumber(),
          password: "",
          profileImage: user.photoURL ?? "");

      print(user.photoURL);

      final response =
          await ApiService().registerSocialUser(socialUser.toJson());

      AppConstants.navigateToDashBoard(context, response);
    } catch (e) {
      print(e);
      //AppDialogs.simpleOkDialog(context, 'Warning!', e.toString());
    }

    if(mounted){

      setState(() {
        showProgress =false;
      });

    }


  }

  void fbLoginOld() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_friends',
        //'user_gender',
        'user_link'
      ],
    ); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      print(accessToken);

      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,friends,gender,link",
      );

      print(userData['picture']);
      print(userData['picture']['data']['url']);
      //FbPictureData fbPictureData = FbPictureData.fromJson(userData['picture']);

      final socialUser = SocialUserData(
          email: userData['email'],
          name: userData['name'],
          source: 'facebook',
          gmailId: "",
          gender: getGender(userData['gender']),
          //userData['gender'] ?? 'Male',
          appleId: "",
          dob: "",
          facebookId: userData['id'],
          mobile: AppConstants.getRandomNumber(),
          password: "",
          profileImage: userData['picture']['data']['url'] ?? '');

      print(userData['picture']);

      final response =
          await ApiService().registerSocialUser(socialUser.toJson());

      AppConstants.navigateToDashBoard(context, response);
    } else {
      print(result.status);
      print(result.message);
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void appleSingIn(BuildContext context) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    if (appleCredential == null) {
      return;
    }

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    String name = appleCredential.givenName ?? 'Anonymous';

    setState(() {
      showProgress =true;
    });


    final result =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    User? user = result.user!;

    final socialUser = SocialUserData(
        email: user.email ?? '${user.uid}@apple.com',
        name: name,
        source: 'apple',
        gmailId: "",
        gender: "Male",
        appleId: user.uid,
        dob: "",
        facebookId: "",
        mobile: user.phoneNumber ?? AppConstants.getRandomNumber(),
        password: "",
        profileImage: user.photoURL ?? '');

    final response = await ApiService().registerSocialUser(socialUser.toJson());

    AppConstants.navigateToDashBoard(context, response);

    if(mounted){

      setState(() {
        showProgress =false;
      });
      
    }
  }

  void appleSingInOld(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        // clientId: 'de.lunaone.flutter.signinwithappleexample.service',
        clientId: 'com.tomtompodcast.app',

        redirectUri:
            // For web your redirect URI needs to be the host of the "current page",
            // while for Android you will be using the API server that redirects back into your app via a deep link
            kIsWeb
                ? Uri.parse('https://tomtompodcast.com')
                : Uri.parse(
                    'https://tomtompodcast.com/callbacks/sign_in_with_apple',
                  ),
      ),
    );

    print(credential);

    final socialUser = SocialUserData(
        email: getAppleEmail(credential),
        name: credential.givenName,
        source: 'apple',
        gmailId: "",
        gender: "Male",
        appleId: credential.userIdentifier,
        dob: "",
        facebookId: "",
        mobile: AppConstants.getRandomNumber(),
        password: "",
        profileImage: "");

    final response = await ApiService().registerSocialUser(socialUser.toJson());

    AppConstants.navigateToDashBoard(context, response);
  }

  void postGoogleSignInData(User? user) async {

    setState(() {
      showProgress = true;
    });

    final socialUser = SocialUserData(
        email: user?.email,
        name: user?.displayName,
        source: 'google',
        gmailId: user?.uid,
        gender: "Male",
        appleId: "",
        dob: "",
        facebookId: "",
        mobile: AppConstants.getRandomNumber(),
        password: "",
        profileImage: user?.photoURL ?? AppConstants.dummyProfilePic);

    final response = await ApiService().registerSocialUser(socialUser.toJson());

    AppConstants.navigateToDashBoard(context, response);

    if(mounted){
      setState(() {
        showProgress = false;
      });
    }

  }

  /*void postGoogleSignInData(GoogleSignInAccount? user) async {
    final socialUser = SocialUserData(
        email: user?.email,
        name: user?.displayName,
        source: 'google',
        gmailId: user?.id,
        gender: "Male",
        appleId: "",
        dob: "",
        facebookId: "",
        mobile: AppConstants.getRandomNumber(),
        password: "",
        profileImage: user?.photoUrl);

    final response = await ApiService().registerSocialUser(socialUser.toJson());

    AppConstants.navigateToDashBoard(context, response);
  }*/

  getAppleEmail(AuthorizationCredentialAppleID credential) {
    if (credential.email == null || credential.email!.isEmpty) {
      return "${credential.userIdentifier}@apple.com";
    } else {
      return credential.email;
    }
  }

  getGender(String userData) {
    if (userData == null) return 'Male';

    if (userData.contains('male')) {
      return 'Male';
    } else if (userData.contains('female')) {
      return 'Female';
    }

    return 'Other';
  }

  void showPopup() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),

      //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
            child: const Text(
              'Enable Production',
            ),
            value: '1',
            onTap: () {
              ApiService().initDio(NetworkConfig.prod_baseUrl);
              //ApiService().generateToken();
            }),
        PopupMenuItem<String>(
            child: const Text(
              'Enable QA',
            ),
            value: '2',
            onTap: () {
              ApiService().initDio(NetworkConfig.qa_baseUrl);
              //ApiService().generateToken();
            }),
      ],

      elevation: 8.0,
    );
  }

  Widget setupAlertDialoadContainer(BuildContext context) {
    List<Country> countries = authController.countriesList.value;
    return Container(
      height: MediaQuery.of(context).size.width /
          2, // Change as per your requirement
      width: MediaQuery.of(context).size.height /
          2, // Change as per your requirement
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title:
                Text('${countries[index].dialcode}  ${countries[index].name}'),
            onTap: () {
              Navigator.of(context).pop(countries[index].dialcode);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            color: Colors.black45.withOpacity(0.5),
          );
        },
      ),
    );
  }

  openTC() {

    Get.to(() => const TermsAndConditionsScreen(
      title: 'Terms & Conditions',
      url:
      'https://www.tomtompodcast.com/mterms.html',
    ));

  }

// List<Country> countries = List.empty(growable: true);

/*void fetchCountries() async{

    final res = await ApiService().getServerItems(ApiKeys.COUNTRIES_SUFFIX);

    try{

      CountriesData countriesData = CountriesData.fromJson(res);

      if(countriesData.status=="Success"){
          countries.addAll(countriesData.countries!);
      }

    }catch(e){
      print(e);
    }



  }*/

}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
