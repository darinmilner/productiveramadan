import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:productive_ramadan_app/utils/circular_icon.dart';
import 'package:productive_ramadan_app/utils/constants.dart';

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisplayingAnswer;
  final VoidCallback onTap;

  const AnswerCard({
    Key key,
    @required this.answer,
    @required this.isSelected,
    @required this.isCorrect,
    @required this.isDisplayingAnswer,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> boxShadow = [
      BoxShadow(
        color: kDarkGreen,
        offset: Offset(0, 2),
        blurRadius: 4.0,
      ),
    ];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow,
          border: Border.all(
            color: isDisplayingAnswer
                ? isCorrect
                    ? kDarkGreen
                    : isSelected
                        ? kDarkOrangeRed
                        : Colors.white
                : Colors.white,
            width: 5.0,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                HtmlCharacterEntities.decode(answer),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: isDisplayingAnswer && isCorrect
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
            ),
            if (isDisplayingAnswer)
              isCorrect
                  ? CircularIcon(
                      icon: Icons.check,
                      color: kDarkGreen,
                    )
                  : isSelected
                      ? CircularIcon(
                          icon: Icons.close,
                          color: kDarkOrangeRed,
                        )
                      : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
