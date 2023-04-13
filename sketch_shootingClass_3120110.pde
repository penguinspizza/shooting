import java.util.*;

final int MAX_HP = 20; // 保有HP数
final int MAX_SCORE = 10; // ラスボスステージ移動スコア

boolean noBoss = true; // ボス出現フラグ
boolean isBossDead = false; // ボス死亡フラグ
int scene = 0; // シーン遷移用変数

BulletManager bulletManager;
EnemyManager enemyManager;
Player player;
Information hp; // HPゲージ
Information score; // SCOREゲージ
StandbyScreen startScreen; // スタート画面
StandbyScreen youWinScreen; // 勝画面
StandbyScreen gameOverScreen; // 敗画面

class Collision {
  int x;
  int y;
  int size;

  // thisが丸、otherが丸の当たり判定
  boolean hitTestICircleOtherCircle(Collision other) {
    double dist = Math.sqrt(
      Math.pow(other.x - this.x, 2)
      + Math.pow(other.y - this.y, 2)
    );
    if (dist < other.size / 2 + this.size / 2) return true;
    return false;
  }

  // thisが四角形、otherが丸の当たり判定
  boolean hitTestIRectOtherCircle(Collision other) {
    int rectX2 = this.x + this.size;
    int rectY2 = this.y + this.size;
    double circleR = other.size / 2;
    double squareRectX1MinusCircleX = Math.pow(this.x - other.x, 2);
    double squareRectX2MinusCircleX = Math.pow(rectX2 - other.x, 2);
    double squareRectY1MinusCircleY = Math.pow(this.y - other.y, 2);
    double squareRectY2MinusCircleY = Math.pow(rectY2 - other.y, 2);
    double squareCircleR = Math.pow(circleR, 2);
    if (
      (
        this.x < other.x
        && rectX2 > other.x
        && this.y - circleR < other.y
        && rectY2 + circleR > other.y
      ) || (
        this.x - circleR < other.x
        && rectX2 + circleR > other.x
        && this.y < other.y
        && rectY2 > other.y
      ) || (
        squareRectX1MinusCircleX
        + squareRectY1MinusCircleY
        < squareCircleR
      ) || (
        squareRectX2MinusCircleX
        + squareRectY1MinusCircleY
        < squareCircleR
      ) || (
        squareRectX2MinusCircleX
        + squareRectY2MinusCircleY
        < squareCircleR
      ) || (
        squareRectX1MinusCircleX
        + squareRectY2MinusCircleY
        < squareCircleR
      )
    ) return true;
    return false;
  }

  // thisが丸、otherが四角形の当たり判定
  boolean hitTestICircleOtherRect(Collision other) {
    int rectX2 = other.x + other.size;
    int rectY2 = other.y + other.size;
    double circleR = this.size / 2;
    double squareRectX1MinusCircleX = Math.pow(other.x - this.x, 2);
    double squareRectX2MinusCircleX = Math.pow(rectX2 - this.x, 2);
    double squareRectY1MinusCircleY = Math.pow(other.y - this.y, 2);
    double squareRectY2MinusCircleY = Math.pow(rectY2 - this.y, 2);
    double squareCircleR = Math.pow(circleR, 2);
    if (
      (
        this.x > other.x
        && this.x < rectX2
        && this.y > other.y - circleR
        && this.y < rectY2 + circleR
      ) || (
        this.x > other.x - circleR
        && this.x < rectX2 + circleR
        && this.y > other.y
        && this.y < rectY2
      ) || (
        squareRectX1MinusCircleX
        + squareRectY1MinusCircleY
        < squareCircleR
      ) || (
        squareRectX2MinusCircleX
        + squareRectY1MinusCircleY
        < squareCircleR
      ) || (
        squareRectX2MinusCircleX
        + squareRectY2MinusCircleY
        < squareCircleR
      ) || (
        squareRectX1MinusCircleX
        + squareRectY2MinusCircleY
        < squareCircleR
      )
    ) return true;
    return false;
  }
}

// 色塗り担当クラス
class Painter {
  int r;
  int g;
  int b;

  Painter(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void paint() {
    fill(r, g, b);
  }
}

// 透明度も表現出来る色塗り担当クラス
class AlphaPainter extends Painter {
  int a;

  AlphaPainter(int r, int g, int b, int a) {
    super(r, g, b);
    this.a = a;
  }

  void paint() {
    fill(r, g, b, a);
  }
}

void setup() {
  size(640, 480);
  
  noStroke();

  bulletManager = new BulletManager();
  enemyManager = new EnemyManager();
  
  player = new Player();

  hp = new Information(
    0, 0,
    width, 20,
    MAX_HP, MAX_HP,
    new Painter(255, 0, 0),
    new Painter(0, 255, 0),
    new Painter(0, 0, 0),
    "HP: "
  );

  score = new Information(
    0, 20,
    width, 20,
    MAX_SCORE, 0,
    new Painter(0, 0, 255),
    new Painter(255, 255, 0),
    new Painter(0, 0, 0),
    "SCORE: "
  );

  startScreen = new StandbyScreen(
    "Welcome!",
    "Start to Pless Any Key\nWin: Kill Boss; Lose: HP<=0;",
    new Painter(0, 127, 255),
    new Painter(0, 0, 0),
    new Painter(220, 220, 220)
  );

  youWinScreen = new StandbyScreen(
    "You Win!",
    "Restart to Pless Any Key",
    new Painter(255, 255, 255),
    new Painter(127, 127, 127),
    new Painter(0, 127, 0)
  );

  gameOverScreen = new StandbyScreen(
    "You Lose...",
    "Restart to Pless Any Key",
    new Painter(255, 255, 255),
    new Painter(127, 127, 127),
    new Painter(127, 0, 0)
  );
}

void draw() { 
  if (scene == 0) startScreen.display();
  else if (scene == 1) game();
  else if (scene == 2) youWinScreen.display();
  else if (scene == 3) gameOverScreen.display();
}

void game() {
  background(0);
  
  ArrayList<Enemy> enemies = enemyManager.getEnemies();
  
  bulletManager.update(enemies);
  bulletManager.display();
  
  if (mousePressed) player.shot();
  
  // 敵の生成
  if (score.currentValue >= MAX_SCORE) {
    if (noBoss) {
      enemyManager.enemies.clear();
      enemyManager.createEnemy(5);
      noBoss = false;
    }
  } else {
    if ((int)random(0, 100 / (score.currentValue + 1)) == 0) {
      int type = (int)random(0, 5);
      println("Enemy type: " + type);
    
      enemyManager.createEnemy(type);
    }
  }
  
  enemyManager.update();
  enemyManager.display();
  
  player.update();
  player.display();

  score.display();
  hp.display();

  if (hp.currentValue <= 0) {
    scene = 3;
    resetGame();
  }

  if (isBossDead) {
    scene = 2;
    resetGame();
  }
}

void resetGame() {
  score.currentValue = 0;
  hp.currentValue = 20;
  enemyManager.enemies.clear();
  bulletManager.bullets.clear();
  noBoss = true;
  isBossDead = false;
}

void keyPressed() {
  scene = 1;
}
