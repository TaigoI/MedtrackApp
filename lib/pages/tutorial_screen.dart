import 'package:flutter/material.dart';
import 'package:medtrack/pages/home_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
        title: 'Bem-vindo(a) ao MedTrack!',
        body: 'O MedTrack é o seu novo gerenciador de alarmes para seus remédios. Com ele, organizar sua rotina de medicações ficou ainda mais fácil!',
        image: Center(
          child: Image.asset('assets/images/healthcare.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )
        )
    ),
    PageViewModel(
        title: 'Sua receita a alguns cliques de distância.',
        body: 'Para criar os alarmes, basta inserir uma receita médica via QRCode clicando no botão + da tela inicial.',
        image: Center(
          child: Image.asset('assets/images/report.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )
        )
    ),
    PageViewModel(
        title: 'Receita importada = alarmes configurados!',
        body: 'Após inserir uma nova receita médica, seus alarmes aparecerão na tela inicial e você poderá iniciar sua rotina.',
        image: Center(
          child: Image.asset('assets/images/medicine.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(15,15),
            color: Color(0xFF044c73),
            activeSize: Size.square(20),
            activeColor: Color(0xFFbadcf5),
          ),
          showDoneButton: true,
          done: Text('Começar', style: TextStyle(fontSize: 20)),
          showSkipButton: true,
          skip: const Text('Próximo', style: TextStyle(fontSize: 20)),
          showNextButton: true,
          next: const Icon(Icons.arrow_forward, size: 25),
          onDone: () => onDone(context),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  void onDone(context) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setBool('ONBOARDING', false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()));
  }
}
