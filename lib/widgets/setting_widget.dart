import 'package:flutter/material.dart';
import 'package:sumday/utils/variables.dart';

class SettingContainerText extends StatelessWidget {
  final String title;
  final String? information;
  const SettingContainerText(
      {super.key, required this.title, this.information});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  Text(
                    information ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.fontGreyColor(),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingContainerColor extends StatelessWidget {
  final String title;
  final Color color;
  const SettingContainerColor({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: color),
                child: const SizedBox(
                  height: 40,
                  width: 100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
