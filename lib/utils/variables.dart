// 폰트, 색상 등을 저장하기 위한 파일입니다.
import 'dart:ui';

class AppColor {
  // 노란색 계열 메인 컬러
  Color primaryColor() {
    return const Color(0xFFF4C54F);
  }

  Color primaryColorDark() {
    return const Color(0xFFC39F44);
  }

  Color primaryColorLight() {
    return const Color(0xFFF6DC92);
  }

  Color primaryColorBackground() {
    return const Color(0xFFF8F4D7);
  }

  // 초록색 계열 서브 커러
  Color secondaryColor() {
    return const Color(0xFF14B690);
  }

  // 폰트 컬러
  Color fontPrimaryColor() {
    return const Color(0xFF855026);
  }

  Color fontSecondaryColor() {
    return const Color(0xFF136750);
  }
}
