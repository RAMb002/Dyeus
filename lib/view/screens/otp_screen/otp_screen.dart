import 'package:dyeus/view/css/css.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/auth_button.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/page_loader.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/toast.dart';
import 'package:dyeus/view_model/provider/authenticiation_message.dart';
import 'package:dyeus/view_model/provider/loading.dart';
import 'package:dyeus/view_model/provider/phone_authentication.dart';
import 'package:dyeus/view_model/provider/resend_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  // final int index;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _smsController = TextEditingController();
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    // TODO: implement dispose
    _smsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _verificationId = "";
  int? _resendToken;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    const defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 34, color: Colors.black, fontWeight: FontWeight.w500),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.red,
      borderRadius: BorderRadius.circular(20),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: const Border(
        bottom: BorderSide(width: 1.0, color: Colors.black),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: const TextStyle(fontSize: 34, color: Colors.black, fontWeight: FontWeight.w500),
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(17.0, 80, 17, 17),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter OTP",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<PhoneAuthenticationProvider>(
                builder: (context, data, child) => Text(
                  'An six digit code has been sent to + ${data.countryNumberCode} ${data.phoneNumber}',
                  style: const TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Visibility(
                visible: index == 1,
                child: Row(
                  children: [
                    const Text(
                      "Incorrect number?",
                      style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CupertinoButton(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text(
                          "Change",
                          style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              Pinput(
                  closeKeyboardWhenCompleted: false,
                  // useNativeKeyboard: false,
                  controller: _smsController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onSubmitted: (pin) async {
                    onSubmitted(pin);
                  }),
              const SizedBox(
                height: 60,
              ),
              Consumer<ResendOtpProvider>(
                builder: (context, data, child) => Column(
                  children: [
                    AuthButton(
                      color: data.status && index == 1 ? const Color(0xFFEDFFD0) : kPrimaryColor,
                      text: index == 0 ? "Done" : "Resend OTP",
                      fontSize: 17,
                      iconVisibility: false,
                      secondaryText: "",
                      onTap: () {
                        if (index == 1 && !data.status) {
                          data.changeStatus();
                          verifyPhone();
                        } else if (index == 0) {
                          onSubmitted(_smsController.text);
                        }
                      },
                    ),
                    Visibility(
                      visible: index == 1 && data.status,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0, top: 12),
                        child: Text(
                          "Resend OTP in ${data.count}s",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: index == 0,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0, top: 12),
                    child: Text(
                      "Didn't you receive any code?",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: index == 0,
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      "Re-send Code",
                      style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    }),
              )
            ],
          ),
          Positioned(
              top: 0,
              child: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )),
          const PageLoader(),
          MyToast(animationController: _animationController, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }

  onSubmitted(String pin) async {
    FocusScope.of(context).unfocus();
    final pMessage = Provider.of<AuthenticationMessageProvider>(context, listen: false);
    if (_smsController.text.length != 6) {
      if (_animationController.status == AnimationStatus.dismissed) {
        pMessage.changeMessage("Enter a 6 digit pin");
        _animationController.forward();
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _animationController.reverse();
        }
      }
    } else {
      if (_verificationId.isNotEmpty) {
        await phoneOtpVerificationProcess(context, pin, pMessage);
      } else {
        if (_animationController.status == AnimationStatus.dismissed) {
          pMessage.changeMessage("Request timed out");
          _animationController.forward();
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _animationController.reverse();
          }
        }
      }
    }
  }

  phoneOtpVerificationProcess(
      BuildContext context, String pin, AuthenticationMessageProvider pMessage) async {
    final pLoader = Provider.of<LoadingProvider>(context, listen: false);
    try {
      pLoader.changeLoadingStatus(true);
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: pin))
          .then((value) async => {
                if (value.user != null)
                  {
                    pLoader.changeLoadingStatus(false),
                    Navigator.pop(context),
                    if (_animationController.status == AnimationStatus.dismissed)
                      {
                        pMessage.changeMessage("Signed in Successfully"),
                        _animationController.forward(),
                        await Future.delayed(const Duration(seconds: 2)),
                        if (mounted)
                          {
                            _animationController.reverse(),
                          }
                      },
                    pLoader.changeLoadingStatus(false),
                  }
              });
    } on FirebaseAuthException catch (e) {
      // print(e.message);
      FocusScope.of(context).unfocus();
      pLoader.changeLoadingStatus(false);
      if (_animationController.status == AnimationStatus.dismissed) {
        pMessage.changeMessage(e.message.toString());
        _animationController.forward();
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _animationController.reverse();
        }
      }
    }
  }

  verifyPhone() async {
    final pPhone = Provider.of<PhoneAuthenticationProvider>(context, listen: false);
    final pMessage = Provider.of<AuthenticationMessageProvider>(context, listen: false);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+${pPhone.countryNumberCode}${pPhone.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await phoneOtpVerificationProcess(context, credential.smsCode.toString(), pMessage);
      },
      verificationFailed: (FirebaseAuthException e) async {
        pMessage.changeMessage(e.message.toString());
        if (_animationController.status == AnimationStatus.dismissed) {
          _animationController.forward();
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) {
            _animationController.reverse();
          }
        }
        // print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        Provider.of<ResendOtpProvider>(context, listen: false).changeStatus();
        setState(() {
          _resendToken = resendToken;
          this._verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this._verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 30),
      forceResendingToken: _resendToken,
      // forceResendingToken:
    );
  }
}
