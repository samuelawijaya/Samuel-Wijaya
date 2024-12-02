//
//  Player.cpp
//  Lab 2 Pong Game
//
//  Created by Samuel Wijaya
#include <iostream>
using namespace std;
#include "Player.h"
#include "Globals.h"
#include "Screen.h"

//Player player(); //= Player(0, 5, 10);
Player player();
Player::Player(double x, double y, int height){
    this->x = x;
    this->y = y;
    this->height = height;

}


double Player::getX(){
    return x;
};

double Player::getY(){
    return y;
};

int Player::getHeight(){
    return height;
};

int Player::getWidth(){
    return 1;
}

void Player::decreaseHeight(int delta_to_decrease_by){
    if(getHeight()>3){
        height=height-delta_to_decrease_by;
    }
}

void Player::update(char c){
    if(c =='A' && ((y+getHeight())<(HEIGHT-1))){
        y=y+2;
    }
    if(c =='B' && (y>=0)){
        y=y-2;
    }
}
void Player::draw(Screen& screen_to_draw_to){
    for(double i = 1; i<=getHeight() ; i++){
        screen_to_draw_to.addPixel(0, getY()+i, '#');
    }
}
