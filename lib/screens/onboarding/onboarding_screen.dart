import 'package:intro_slider/intro_slider.dart';
import 'package:koompi_hotspot/all_export.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = <Slide>[];

  Function? goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: 'Connect people\naround the world',
        styleTitle: kTitleStyle,
        description: 'KOOMPI Fi-Fi is accessable and affordable',
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/onboarding0.svg",
      ),
    );
    slides.add(
      Slide(
        title: 'Live your life smarter with us!',
        styleTitle: kTitleStyle,
        description: 'For everyone and KOOMPI\'s school partner',
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/onboarding1.svg",
      ),
    );
    slides.add(
      Slide(
        title: 'Get a new experience of imagination',
        styleTitle: kTitleStyle,
        description:
            'We all are connected by the internet, like neurons in a giant brain',
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/onboarding2.svg",
      ),
    );
  }

  void onDonePress() {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const LoginPhone(),
      ),
      ModalRoute.withName('/loginPhone'),
    );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: primaryColor,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: primaryColor,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: primaryColor,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = <Widget>[];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child: SvgPicture.asset(
                  currentSlide.pathImage!,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Text(
                  currentSlide.title!,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    currentSlide.description!,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // List slides
      // slides: this.slides,

      // Skip button
      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: HexColor("0F4471"),
      sizeDot: 13.0,
      typeDotAnimation: DotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: renderListCustomTabs(),
      backgroundColorAllSlides: Color(primaryColor.value),
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: const BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: false,

      // On tab change completed
      onTabChangeCompleted: onTabChangeCompleted,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      overlayColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
}
