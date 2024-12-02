

#ifndef PLAYER_H
#define PLAYER_H

#include <string>
#include "Globals.h"
#include "Screen.h"

class Player {
 public:
  Player();
  Player(double x, double y, int height);
  double getX();
  double getY();
  int getHeight();
  int getWidth();
  void update(char c);
  void draw(Screen& screen_to_draw_to);
  void decreaseHeight(int delta_to_decrease_by);

 private:
  double x, y;
  int height, width;
};

#endif  // PLAYER_H
