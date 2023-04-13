class BulletManager {
  ArrayList<Bullet> bullets;
  
  BulletManager() {
    this.bullets = new ArrayList<Bullet>();
  }
  
  Bullet createBullet(int type) {
    Bullet b = null;
    
    if (type == 0) b = new Bullet(); // 味方の弾
    else if (type == 1) b = new EnemyBullet(); // 敵の弾

    if (b != null) this.bullets.add(b);
    
    return b;
  }
  
  void update(ArrayList<Enemy> enemies) {
    Iterator<Bullet> it = this.bullets.iterator();
    while (it.hasNext()) {
      Bullet b = it.next();
      
      if (b.y > height) {
        it.remove();
        continue;
      }

      // 味方の弾だったら
      if (!b.isEnemyBullet) {
        for (int j = 0; j < enemies.size(); j++) {
          // 敵に当たっていたら
          if (b.hitTestICircleOtherRect(enemies.get(j))) {
            it.remove();
            enemies.get(j).damage();
            break;
          }
        }
      } else { // 敵の弾だったら
        if (b.hitTestICircleOtherCircle(player)) {
          it.remove();
          hp.currentValue--;
        }
      }
    }
    
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).update();
    }
  }
  
  void display() {
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).display();
    }    
  }
  
}

class Bullet extends Collision {
  int speed;
  boolean isEnemyBullet;
  Painter bulletColor;
  
  Bullet() {
    this.bulletColor = new Painter(255, 255, 255);
  }
  
  void update() {
    this.y -= this.speed;
    this.speed--;
  }
  
  void display() {
    this.bulletColor.paint();
    circle(this.x, this.y, this.size);
  }
}

class EnemyBullet extends Bullet {
  EnemyBullet() {
    this.isEnemyBullet = true;
    this.bulletColor = new Painter(255, 255, 0);
  }
  
  void update() {
    this.y += this.speed;
    this.speed++;
  }
  
  void display() {
    this.bulletColor.paint();
    circle(this.x, this.y, this.size);
  }
}
