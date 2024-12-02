
#ifndef BALL_H
#define BALL_H

#include "Globals.h"
#include "Player.h"
#include "Screen.h"

class Ball {
 public:
  Ball();
  Ball(double x, double y, double velocity_x, double velocity_y, int id);
  void update();
  void draw(Screen& screen_to_draw_to);
  void bounce(Ball arr[], int ballCount, Player player);
  int getID();
  double getX();
  int overlap(Ball& b);
  int overlap(Player& p);

 private:
  double velocity_x, velocity_y;
  double x, y;
  double width, height;
  int id;
};

#endif  // BALL_H
