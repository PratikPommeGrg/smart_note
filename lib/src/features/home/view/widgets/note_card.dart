part of '../home_screen.dart';

Widget noteCard(
    {required NoteModel note,
    required BuildContext context,
    required WidgetRef ref}) {
  final backgroundColor = noteCardColor(note.category);
  return Stack(
    clipBehavior: Clip.none,
    fit: StackFit.expand,
    children: [
      Card(
        elevation: 8,
        shadowColor: backgroundColor.withAlpha(160),
        color: backgroundColor,
        child: Padding(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              CustomText.ourText(
                note.title,
                fontWeight: FontWeight.w600,
                color: AppColor.kNeutral700,
              ),
              CustomText.ourText(
                note.note,
                color: AppColor.kNeutral700,
                maxLines: note.cardSize == 0.8
                    ? 3
                    : note.cardSize == 1
                        ? 5
                        : 7,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: InkWell(
          onTap: () {
            _showNoteOptions(
              context,
              ref,
              note.id ?? 0,
            );
          },
          child: Container(
            height: 20,
            width: 28,
            decoration: BoxDecoration(
              color: noteCardColor(note.category),
              border: Border.all(
                color: AppColor.secondaryColor,
                width: 1,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        right: -5,
        top: -9,
        child: InkWell(
          onTap: () {
            _showNoteOptions(
              context,
              ref,
              note.id ?? 0,
            );
          },
          child: SvgPicture.asset(
            kPinSvg,
            height: 18,
            width: 18,
            colorFilter: ColorFilter.mode(
              AppColor.kNeutral600,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    ],
  );
}

Color noteCardColor(String category) {
  return category == "Personal"
      ? AppColor.kPersonalColor
      : category == "Work"
          ? AppColor.kWorkColor
          : category == "Grocery"
              ? AppColor.kGroceryColor
              : category == "Travel"
                  ? AppColor.kTravelColor
                  : category == "Health"
                      ? AppColor.kHealthColor
                      : category == "Ideas"
                          ? AppColor.kIdeasColor
                          : AppColor.kNeutral100;
}

List<num> generateMaxAxisCellCount = [0.8, 1.0, 1.2];

num generategenerateMaxAxisCellCount() {
  final Random random = Random();
  return generateMaxAxisCellCount[
      random.nextInt(generateMaxAxisCellCount.length)];
}
