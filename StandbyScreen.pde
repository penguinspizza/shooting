// 待機画面
class StandbyScreen {
  String title;
  String subTitle;
  Painter titleColor;
  Painter subTitleColor;
  Painter backgroundColor;

  StandbyScreen(
    String title,
    String subTitle,
    Painter titleColor,
    Painter subTitleColor,
    Painter backgroundColor
  ) {
    this.title = title;
    this.subTitle = subTitle;
    this.titleColor = titleColor;
    this.subTitleColor = subTitleColor;
    this.backgroundColor = backgroundColor;
  }

  void display() {
    background(
      this.backgroundColor.r,
      this.backgroundColor.g,
      this.backgroundColor.b
    );
    textAlign(CENTER);
    textSize(100);
    this.titleColor.paint();
    text(this.title, width / 2, height / 2);

    textSize(50);
    this.subTitleColor.paint();
    text(this.subTitle, width / 2, height * 3 / 4);
  }
}
