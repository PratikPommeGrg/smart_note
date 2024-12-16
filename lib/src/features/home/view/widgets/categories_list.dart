part of '../home_screen.dart';
class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.noteCategories,
    required this.ref,
  });

  final List<String> noteCategories;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder(
        valueListenable: selectedCategory,
        builder: (context, value, child) => ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => hSizedBox0andHalf,
          itemCount: noteCategories.length,
          itemBuilder: (context, index) {
            bool isSelected = value == noteCategories[index];
            return InkWell(
              onTap: () {
                selectedCategory.value = noteCategories[index];
                ref.read(notesProvider.notifier).getNotes(
                      getByCategory: noteCategories[index] != "All",
                    );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.secondaryColor
                      : AppColor.kNeutral300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText.ourText(
                  noteCategories[index],
                  color: isSelected ? AppColor.kWhite : null,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}