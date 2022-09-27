import 'package:dyeus/view/css/css.dart';
import 'package:dyeus/view/screens/otp_screen/otp_screen.dart';
import 'package:dyeus/view/screens/signed_in_screen.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/auth_button.dart';
import 'package:dyeus/view/screens/welcome_screen/widgets/toast.dart';
import 'package:dyeus/view_model/provider/authenticiation_message.dart';
import 'package:dyeus/view_model/provider/loading.dart';
import 'package:dyeus/view_model/provider/phone_authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late PhoneController _phoneController;
  @override
  void initState() {
    final pPhone = Provider.of<PhoneAuthenticationProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _phoneController =
        PhoneController(PhoneNumber(isoCode: pPhone.country.toString(), nsn: pPhone.phoneNumber.toString()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int index = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final phoneAuthProvider = Provider.of<PhoneAuthenticationProvider>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(17, 70, 17, 50),
            children: [
              Stack(
                children: [
                  Container(
                    height: kSwitchHeight + 2,
                    width: kSwitchWidth + 2,
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(35))),
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index != 0) {
                                index = 0;
                              }
                            });
                          },
                          child: Container(
                            height: kSwitchHeight,
                            width: kSwitchWidth / 2,
                            color: Colors.transparent,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index != 1) {
                                index = 1;
                              }
                            });
                          },
                          child: Container(
                            height: kSwitchHeight,
                            width: kSwitchWidth / 2,
                            color: Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      width: kSwitchWidth + 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedAlign(
                              alignment: index == 0 ? Alignment.centerLeft : Alignment.centerRight,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                height: kSwitchHeight + 4,
                                width: (kSwitchWidth + 5) / 2,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    // border: Border.all(color: Colors.red,width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(35))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      child: IgnorePointer(
                    child: SizedBox(
                      width: kSwitchWidth,
                      child: Row(
                        children: [
                          SizedBox(
                            height: kSwitchHeight,
                            width: kSwitchWidth / 2,
                            child: const Center(
                              child: Text("Signin"),
                            ),
                          ),
                          SizedBox(
                            width: kSwitchWidth / 2,
                            height: kSwitchHeight,
                            child: const Center(
                              child: Text("Signup"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 68,
              ),
              Text(
                index == 0 ? "Welcome Back!!" : "Welcome to App",
                style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 63,
              ),
              Text(
                index == 0
                    ? "Please login with your phone number."
                    : "Please signup with your phone number to get registered",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 17,
              ),
              Form(
                key: _formKey,
                child: Consumer<PhoneAuthenticationProvider>(
                  builder: (context, data, child) => PhoneFormField(
                    cursorColor: Colors.black,
                    controller: _phoneController,
                    key: const Key('phone-field'), // can't be supplied simultaneously
                    shouldFormat: true, // default
                    defaultCountry: 'IN',
                    style: const TextStyle(color: Colors.black), // default
                    countryCodeStyle: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Color(0xFFD0244D), fontWeight: FontWeight.bold),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                          borderRadius: lBorderRadius),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                          borderRadius: lBorderRadius),
                      // errorBorder: UnderlineInputBorder(
                      //   borderSide: const BorderSide(color: Color(0xFFD0244D), width: 2.0),
                      // ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1.0),
                          borderRadius: lBorderRadius),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1.5),
                          borderRadius: lBorderRadius),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Phone Number',
                      suffixIcon: _phoneController.value?.nsn != ''
                          ? MyTextFormFieldIconButtonClose(
                              lineColorWhite: false,
                              onPressed: () {
                                if (_phoneController.value != null) {
                                  _phoneController.value =
                                      PhoneNumber(isoCode: data.country.toString(), nsn: '');
                                }
                              },
                            )
                          : Container(
                              width: 0,
                            ),
                    ),
                    onSubmitted: (value) {
                      onSubmit();
                    },

                    validator: PhoneValidator.validMobile(
                      allowEmpty: false,
                    ), // default PhoneValidator.valid()
                    countrySelectorNavigator:
                        const DialogNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
                    showFlagInInput: true, // default
                    flagSize: 16, // default
                    autofillHints: const [AutofillHints.telephoneNumber], // default to null
                    autofocus: false, // def// ault
                    autovalidateMode: AutovalidateMode.onUserInteraction, // default
                    onChanged: (number) {
                      phoneAuthProvider.changeCountry(number?.isoCode);
                      phoneAuthProvider.changePhoneNumber(number?.nsn);
                      phoneAuthProvider.changeCountryNumberCode(number?.countryCode);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              AuthButton(
                color: kPrimaryColor,
                text: "Continue",
                secondaryText: "",
                iconVisibility: false,
                fontSize: 17,
                onTap: () async {
                  onSubmit();
                },
              ),
              const SizedBox(
                height: 36,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: borderColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: borderColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 33,
              ),
              AuthButton(
                color: const Color(0xFFF5FFF3),
                text: "Connect to ",
                secondaryText: "Metamask",
                iconVisibility: true,
                icon: const FaIcon(
                  FontAwesomeIcons.meteor,
                  color: Colors.orange,
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              AuthButton(
                color: const Color(0xFFF5FFF3),
                text: "Connect to ",
                secondaryText: "Google",
                iconVisibility: true,
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              AuthButton(
                color: Colors.black,
                text: "Connect to ",
                secondaryText: "Apple",
                iconVisibility: true,
                textColor: Colors.white,
                icon: const FaIcon(
                  FontAwesomeIcons.apple,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  if (index == 0) {
                    setState(() {
                      index = 1;
                    });
                  } else {
                    setState(() {
                      index = 0;
                    });
                  }
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: index == 0 ? "Don't have an account?" : "Already have an account?",
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                      children: <TextSpan>[
                        TextSpan(
                            text: index == 0 ? " Sign up" : " Sign in",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          MyToast(animationController: _animationController, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }

  onSubmit() async {
    final phoneAuthProvider = Provider.of<PhoneAuthenticationProvider>(context, listen: false);
    final pPageLoader = Provider.of<LoadingProvider>(context, listen: false);
    if (pPageLoader.loadingStatus) {
      pPageLoader.changeLoadingStatus(false);
    }
    final form = _formKey.currentState!;
    if (phoneAuthProvider.phoneNumber!.isEmpty) {
      print('empty');
      if (_animationController.status == AnimationStatus.dismissed) {
        final pMessage = Provider.of<AuthenticationMessageProvider>(context, listen: false);
        pMessage.changeMessage("Type a phone number");
        _animationController.forward();
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _animationController.reverse();
        }
      }
    } else if (form.validate()) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) => const OtpScreen())));
    }
  }
}

class MyTextFormFieldIconButtonClose extends StatelessWidget {
  const MyTextFormFieldIconButtonClose({
    required this.onPressed,
    required this.lineColorWhite,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final bool lineColorWhite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: lineColorWhite ? const EdgeInsets.only(top: 15) : EdgeInsets.zero,
      constraints: lineColorWhite ? const BoxConstraints() : null,
      onPressed: onPressed,
      icon: Icon(
        Icons.close,
        color: lineColorWhite ? Colors.white : Colors.black,
        size: 22.0,
      ),
    );
  }
}
