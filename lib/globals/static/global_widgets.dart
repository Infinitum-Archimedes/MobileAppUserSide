import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*

Central place for widgets which are reused are to go.

Common that text, and other things may be re-used.

Also location where to bring in outside widgets, or take things other people have made to avoid having to make a whole widget on your own.

 */

class GlobalWidgets{

  static Widget textBubble(BuildContext context,
      {String text = '',
        IconData? icon,
        Color? color,
        Color? textColor,
        Color? iconColor,
        Color? borderColor,
        EdgeInsets? spacing,
        EdgeInsets? padding,
        double? width,
        double? height,
        double? textSize,
        double curve = 20,
        void Function()? onPressed}) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget buildBubble() {
      return SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            margin: spacing,
            padding: padding,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: colorScheme.shadow, blurRadius: 1)
                ],
                borderRadius: BorderRadius.circular(curve),
                border: borderColor != null
                    ? Border.all(
                    color: borderColor,
                    width: 3.5,
                    strokeAlign: BorderSide.strokeAlignOutside)
                    : null,
                color: color ?? colorScheme.primary),
            child: Row(
              children: [
                const SizedBox(width: 1),
                if (icon != null)
                  Icon(icon, color: iconColor ?? colorScheme.onPrimary, size: textSize),
                if (text.isNotEmpty)
                  Text(' $text ',
                      style: TextStyle(
                          fontSize: textSize ?? 20,
                          color: textColor ?? colorScheme.onPrimary))
              ],
            ),
          ),
        ),
      );
    }

    if (onPressed != null) {
      return TextButton(
          onPressed: () {
            onPressed();
          },
          child: buildBubble());
    }
    return buildBubble();
  }


  /// progression between pages
  static Widget progression(
      {required BuildContext context,
        required List<Widget> children,
        ColorScheme? colorScheme,
        bool autoprogress = true,
        bool labelprogress = true,
        int startPage = 0,
        List<Color>? colors,
        double? height,
        bool progressDots = true,
        bool scroll = false,
        List<String>? nextTexts,
        void Function()? endButton,
        List<void Function()>? methods,
        List<bool Function(bool)>? conditions}) {
    final PageController controller = PageController();
    int currentPage = startPage;
    conditions ??= [];
    methods ??= [];

    colorScheme ??= Theme.of(context).colorScheme;

    void button() {
      if (currentPage + 1 < children.length) {
        controller.animateToPage(currentPage + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        if (endButton != null) {
          endButton();
        }
      }
    }

    bool canProgress(bool active) {
      if (currentPage < conditions!.length) {
        if (conditions[currentPage](active)) {
          return true;
        }
        return false;
      }
      return true;
    }

    return StatefulBuilder(builder: (context, setState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (autoprogress && currentPage < conditions!.length) {
          if (conditions[currentPage](false)) {
            button();
          }
        }
      });
      return Container(
        color: (colors ?? []).length > currentPage
            ? colors![currentPage]
            : colorScheme?.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: PageView(
                  physics: scroll ? null : const NeverScrollableScrollPhysics(),
                  controller: controller,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                      if (currentPage < methods!.length) {
                        methods[currentPage]();
                      }
                    });
                  },
                  children: List<Widget>.generate(children.length, (i) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (currentPage > 0)
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      autoprogress = false;
                                    });
                                    controller.animateToPage(currentPage - 1,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: colorScheme?.onSurface,
                                    size: 20,
                                  )),
                            SizedBox(
                              height: height,
                              width: MediaQuery.of(context).size.width * 3 / 4,
                              child: Card(
                                color: colorScheme?.surface,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: height,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: SingleChildScrollView(
                                          child: children[i],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Opacity(
                                          opacity:
                                          !labelprogress || canProgress(false)
                                              ? 1
                                              : 0.75,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (canProgress(true)) {
                                                button();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 16),
                                                backgroundColor:
                                                colorScheme?.primary),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  2,
                                              child: Text(
                                                  (nextTexts ?? []).length > i
                                                      ? nextTexts![i]
                                                      : 'Continue',
                                                  style: TextStyle(
                                                      fontFamily: 'Pridi',
                                                      fontSize: 20,
                                                      color:
                                                      colorScheme?.onPrimary)),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (currentPage > 0) const SizedBox(width: 40)
                          ],
                        ));
                  }),
                )),
            if (progressDots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(children.length, (e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.5, vertical: 10),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: e == currentPage
                          ? colorScheme?.primary
                          : colorScheme?.shadow,
                    ),
                  );
                }),
              ),
          ],
        ),
      );
    });
  }

  // used for moving between pages
  static PageRoute swipePage(Widget destination,
      {bool appBar = false, String? title}) {
    if (title != null) {
      appBar = true;
    }
    return CupertinoPageRoute(
        builder: (context) => GestureDetector(
            child: appBar
                ? Scaffold(
              appBar: AppBar(
                shadowColor: Theme.of(context).colorScheme.shadow,
                elevation: 4,
                forceMaterialTransparency: title == null,
                backgroundColor:
                Theme.of(context).colorScheme.tertiaryContainer,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 25,
                  ),
                ),
                centerTitle: true,
                title: Text(title ?? '',
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Georama',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        height: 0.85)),
              ),
              extendBodyBehindAppBar: title == null,
              body: destination,
            )
                : destination,
            onHorizontalDragEnd: (details) => {
              if (details.primaryVelocity! > 0) {Navigator.pop(context)}
            }));
  }
}