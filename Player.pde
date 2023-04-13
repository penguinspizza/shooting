class Player extends Collision {
  boolean isBulletIntervalTime;
  int bulletIntervalTime;
  int currentBulletIntervalTime;
  
  // --------------------------------------------
  // コンストラクタ
  // --------------------------------------------
  Player() {
    this.x = width/2;
    this.y = height/2;
    this.size = 50;
    
    this.isBulletIntervalTime = false;
    this.bulletIntervalTime = 5;
    this.currentBulletIntervalTime = 0;
  }

  // --------------------------------------------
  // 移動用
  // --------------------------------------------
  void update() {
    if (mouseX != 0 && mouseY != 0) {
      this.x = mouseX;
      this.y = mouseY;
    }
    
    if (this.isBulletIntervalTime) {
      this.currentBulletIntervalTime++;
      
      if (this.currentBulletIntervalTime > this.bulletIntervalTime) {
        this.isBulletIntervalTime = false;
        this.currentBulletIntervalTime = 0;
      }
    }
  }
  
  // --------------------------------------------
  // 表示用
  // --------------------------------------------
  void display() {
    if (this.isBulletIntervalTime) fill(125);
    else fill(255);
    
    circle(this.x, this.y, this.size);
  }
  
  // --------------------------------------------
  // 弾を打つ
  // --------------------------------------------
  void shot() {
    if (!this.isBulletIntervalTime) {
      Bullet bullet = bulletManager.createBullet(0);
      bullet.x = this.x;
      bullet.y = this.y;
      bullet.size = 10;
      bullet.speed = 20;

      this.isBulletIntervalTime = true;
    }
  }
}
