//
//  Ball.cpp
//  Lab 2 Pong Game
//
//  Created by Author Name, Date

#include <iostream>
using namespace std;
#include "Player.h"
#include "Globals.h"
#include "Screen.h"
#include "Ball.h"
#define width 1
#define height 1

Ball::Ball(){}

Ball::Ball(double x, double y, double velocity_x, double velocity_y, int id){
    this->x = x;
    this->y = y;
    this->velocity_x = velocity_x;
    this->velocity_y = velocity_y;
    this->id = id;
}

double Ball::getX(){
    return x;
}

int Ball::getID(){
    return id;
}


void Ball::update(){
    x = x + velocity_x * timeStep;
    y = y + velocity_y * timeStep;
    velocity_y = velocity_y - 0.02 * timeStep;
}

int Ball::overlap(Ball& b){

    double  yOverlap = abs(y - b.y);
    double xOverlap = abs(x - b.x);

    if((yOverlap > 1) || (xOverlap > 1)){
        return NO_OVERLAP;
    }

    if(yOverlap >= xOverlap){
        return VERTICAL_OVERLAP;
    } 
    else {
        return HORIZONTAL_OVERLAP;
    }
    }

int Ball::overlap(Player& p){
    
    double xOverlap = (x - p.getX());
    if(xOverlap > 1){
        return NO_OVERLAP;
    }
    if (y>p.getY() && y<p.getY()+p.getHeight() && x<1){
        return HORIZONTAL_OVERLAP;
    };

    return NO_OVERLAP;
}

void Ball::bounce(Ball arr[], int ballCount, Player player){
    
    //player overlap
    if(overlap(player) == HORIZONTAL_OVERLAP){
        velocity_x = velocity_x * (-1.0);
    }
    //Border collission
    if(x >= WIDTH-1){
        velocity_x = velocity_x * (-1.0);
    }
    if(y >= HEIGHT-1 || y <= 0){
        velocity_y = velocity_y * (-1.0);
    }

    //ball collission
    for(int i=0; i<ballCount ; i++){
        if(id==i) continue;
        if(overlap(arr[i]) == HORIZONTAL_OVERLAP){
            velocity_x = velocity_x * (-1.0); 
        } 
        if(overlap(arr[i]) == VERTICAL_OVERLAP){
            velocity_y = velocity_y * (-1.0);
        }
    }
}

void Ball::draw(Screen& screen_to_draw_to){
    screen_to_draw_to.addPixel(x, y, 'o');
}
