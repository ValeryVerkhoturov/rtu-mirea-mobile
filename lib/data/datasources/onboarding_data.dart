import 'package:flutter/material.dart';

class OnBoardingData {
  static List<Color> backgroundColors = [
    Color.fromRGBO(30, 144, 255, 0.5),
    Color.fromRGBO(255, 155, 112, 0.5),
    Color.fromRGBO(255, 165, 2, 0.5),
    Color.fromRGBO(55, 66, 250, 0.5),
    Color.fromRGBO(255, 127, 80, 1.0),
  ];

  static List<Image> containersImages = [
    Image(
      image: AssetImage('assets/images/Saly-1.png'),
      height: 375.0,
      width: 375.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-2.png'),
      height: 324.0,
      width: 328.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-3.png'),
      height: 315.0,
      width: 315.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-4.png'),
      height: 375.0,
      width: 315.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-5.png'),
      height: 315.0,
      width: 315.0,
    ),
  ];

  static List textWidgets = [
    Text(
      'Добро пожаловать!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
    Text(
      'Смотри расписание!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color(0xFFF28080),
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
    Text(
      'Будь вкурсе не надевая штаны!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color(0xFFE26B96),
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
    Text(
      'Ставь цели!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFB059),
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
    Text(
      'Коммуницируй!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color(0xFF4356FF),
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
  ];

  static List contentTexts = [
    'Это приложение было создано студентами для студентов',
    'Как же легко оказывается можно смотреть расписание, а главное быстро',
    'Иногда так лень заходить на сайт и искать нужную тебе информацию, мы это исправили',
    'Как же много дедлайнов!? Создавать дедлайны теперь как никогда просто и удобно',
    'Слово сложное, но все легко. Общайся и делись материалами с другими группами мгновенно',
  ];

  static double getImageTopPadding(int page) {
    switch (page) {
      case 0:
        return 18.0;
      case 1:
        return 70.0;
      case 2:
        return 73.0;
      case 3:
        return 30.0;
      case 4:
        return 91.0;
      default:
        return 0.0;
    }
  }
}
