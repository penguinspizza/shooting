// --------------------------------------------
// 敵マネージャー
// --------------------------------------------
class EnemyManager {
  ArrayList<Enemy> enemies;

  EnemyManager() {
    enemies = new ArrayList<Enemy>();
  }

  ArrayList<Enemy> getEnemies() {
    return this.enemies;
  }

  void update() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).update();
      if(enemies.get(i).hitTestIRectOtherCircle(player)) {
        score.currentValue = 0;
        println("Enemy hit player!"); 
      }
    }

    Iterator<Enemy> it = this.enemies.iterator();
    while (it.hasNext()) {
      Enemy enemy = it.next();

      if (enemy.isDead) it.remove();
    }
  }

  void display() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).display();
    }
  }

  void createEnemy(int type) {
    Enemy enemy = null;

    if (type == 0) enemy = new ReturnEnemy();
    else if (type == 1) enemy = new StraightEnemy();
    else if (type == 2) enemy = new RightMoveEnemy();
    else if (type == 3) enemy = new LeftMoveEnemy();
    else if (type == 4) enemy = new OriginalEnemy();
    else if (type == 5) enemy = new Boss();

    if (enemy != null) this.enemies.add(enemy);
  }
}

// --------------------------------------------
// 敵のベースクラス
// --------------------------------------------
class Enemy extends Collision {
  int speed;
  int count;
  boolean isDead;
  int maxLife;
  int currentLife;
  AlphaPainter enemyColor;

  Enemy() {
    this.size = (int)random(50, 70);
    this.count = 0;
    this.isDead = false;
    this.enemyColor = new AlphaPainter(224, 255, 253, 255);
  }

  void update() {
    this.count++;
    this.enemyColor.a = this.currentLife * 256 / this.maxLife;
  }

  void display() {
    this.enemyColor.paint();
    rect(this.x, this.y, this.size, this.size);
  }

  void shot() {
    Bullet b = bulletManager.createBullet(1);
    b.x = this.x + this.size/2;
    b.y = this.y + this.size/2;
    b.size = 10;
    b.speed = 0;
  }

  void damage() {
    this.currentLife--;

    if (this.currentLife < 0) {
      this.isDead = true;
      score.currentValue++;
    }
  }
}

// --------------------------------------------
// 上から下に流れてきて、途中で止まって上に戻る敵
// --------------------------------------------
class ReturnEnemy extends Enemy {
  ReturnEnemy() {
    this.x = (int)random(0, width - this.size);
    this.y = -this.size;
    this.speed = (int)random(2, 6);
    this.maxLife = 3;
    this.currentLife = this.maxLife;
  }

  void update() {
    super.update();

    if (this.count < 50) this.y += this.speed;
    else if (this.count > 150) {
      this.y -= this.speed;

      if (this.y + this.size < 0) this.isDead = true;
    }

    if ((int)random(0, 100) == 0) this.shot();
  }
}

// --------------------------------------------
// そのまま下にいく敵
// --------------------------------------------
class StraightEnemy extends Enemy {
  StraightEnemy() {
    this.x = (int)random(0, width - this.size);
    this.y = -this.size;
    this.speed = (int)random(2, 4);
    this.maxLife = 5;
    this.currentLife = this.maxLife;
  }

  void update() {
    super.update();

    this.y += this.speed;

    if (this.y > height) this.isDead = true;

    if ((int)random(0, 100) == 0) this.shot();
  }
}

// --------------------------------------------
// 左から右に移動しながら消えていく敵
// --------------------------------------------
class RightMoveEnemy extends Enemy {
  RightMoveEnemy() {
    this.x = -this.size;
    this.y = (int)random(0, height/3);
    this.speed = (int)random(2, 4);
    this.maxLife = 1;
    this.currentLife = this.maxLife;
  }

  void update() {
    super.update();

    this.x += this.speed;

    if (this.x > width) this.isDead = true;

    if ((int)random(0, 100) == 0) this.shot();
  }
}

// --------------------------------------------
// 右から左に移動しながら消えていく敵
// --------------------------------------------
class LeftMoveEnemy extends Enemy {
  LeftMoveEnemy() {
    this.x = width;
    this.y = (int)random(0, height/3);
    this.speed = (int)random(2, 4);
    this.maxLife = 1;
    this.currentLife = this.maxLife;
  }

  void update() {
    super.update();

    this.x -= this.speed;

    if (this.x + this.size < 0) this.isDead = true;

    if ((int)random(0, 100) == 0) this.shot();
  }
}

// --------------------------------------------
// 追加した敵
// --------------------------------------------
class OriginalEnemy extends Enemy {
  OriginalEnemy() {
    this.x = -this.size;
    this.y = (int)random(0, height * 3 / 4);
    this.speed = (int)random(2, 8);
    this.maxLife = 7;
    this.currentLife = this.maxLife;
    this.enemyColor = new AlphaPainter(255, 0, 0, 255);
  }

  void update() {
    super.update();

    double sinValue = Math.sin(Math.toRadians(frameCount));
    if (sinValue > 0) this.x += (int)(sinValue * this.speed);
    else this.x += (int)(sinValue * this.speed / 2);

    this.y += (int)(Math.sin(Math.toRadians(this.x)) * 3);

    if (this.x > width) this.isDead = true;

    if ((int)random(0, 50) == 0) this.shot();
  }
}

// --------------------------------------------
// ラスボス
// --------------------------------------------
class Boss extends Enemy {
  boolean noResetCount;

  Boss() {
    this.size = 100;
    this.x = width / 2 - this.size / 2;
    this.y = -this.size;
    this.speed = 1;
    this.maxLife = 200;
    this.currentLife = this.maxLife;
    this.enemyColor = new AlphaPainter(255, 0, 255, 255);
    this.noResetCount = true;
  }

  void update() {
    super.update();

    if (this.y < 50) this.y += this.speed;
    else {
      if (this.noResetCount) {
        this.count = 0;
        this.noResetCount = false;
      }
      this.x += (int)(Math.cos(Math.toRadians(this.count)) * 5);
    }

    if (frameCount % 20 == 0) {
      if ((int)random(0, 10) == 0) this.shot(150, -10);
      else this.shot(10, 0);
    }
  }

  void shot(int size, int speed) {
    Bullet b = bulletManager.createBullet(1);
    b.x = this.x + this.size/2;
    b.y = this.y + this.size/2;
    b.size = size;
    b.speed = speed;
  }

  void damage() {
    super.damage();

    if(this.isDead) isBossDead = true;
  }
}
