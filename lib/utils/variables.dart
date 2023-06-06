// 폰트, 색상 등을 저장하기 위한 파일입니다.
import 'dart:ui';

class AppColors {
  // 노란색 계열 메인 컬러
  static Color primaryColor() {
    return const Color(0xFFF4C54F);
  }

  static Color primaryColorDark() {
    return const Color(0xFFC39F44);
  }

  static Color primaryColorLight() {
    return const Color(0xFFF6DC92);
  }

  static Color primaryColorBackground() {
    return const Color(0xFFF8F4D7);
  }

  // 초록색 계열 서브 커러
  static Color secondaryColor() {
    return const Color(0xFF14B690);
  }

  // 폰트 컬러
  static Color fontPrimaryColor() {
    return const Color(0xFF855026);
  }

  static Color fontSecondaryColor() {
    return const Color(0xFF126750);
  }

  static Color fontGreyColor() {
    return const Color(0xFFAAAAAA);
  }
}