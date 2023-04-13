// スコアとHP表示用
class Information {
  int x;
  int y;

  int w;
  int h;

  int maxValue;
  int currentValue;

  Painter maxValueColor;
  Painter currentValueColor;
  Painter textColor;

  String label;

  Information(
    int x,
    int y,

    int w,
    int h,

    int maxValue,
    int currentValue,

    Painter maxValueColor,
    Painter currentValueColor,
    Painter textColor,

    String label
  ) { 
    this.x = x;
    this.y = y;

    this.w = w;
    this.h = h;

    this.maxValue = maxValue;
    this.currentValue = currentValue;

    this.maxValueColor = maxValueColor;
    this.currentValueColor = currentValueColor;
    this.textColor = textColor;

    this.label = label;
  }

  void display() {
    this.maxValueColor.paint();
    rect(this.x, this.y, this.w, this.h);

    this.currentValueColor.paint();
    rect(
      this.x,
      this.y,
      this.currentValue * this.w / maxValue,
      this.h
    );

    textAlign(LEFT);
    textSize(this.h);
    this.textColor.paint();
    text(this.label + this.currentValue, this.x, this.y + this.h * 0.85);
  }
}
