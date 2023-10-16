int sWidth =1800;
int sHeight = 900;
void setup(){
size(1800,900);
background(224,216,177);
frameRate(100);
noLoop();
}
class Human
{
  int Mx;
  int My;
  float theta;
  int speed;
  float rotsped;
  Human(int a, int b, float c,int s,float p)  //x ,y ,rotation , rotation speed
  {
    Mx =a;
    My=b;
    theta = c;
    speed = s;
    rotsped = p;
  }
 
 void show(){
 //bouncing off walla  a
   if (Mx<0 || Mx>sWidth){
   theta =  (PI-theta); 
 }
   if(My>sHeight||My<0){
   theta =  (2*PI-theta);
   
   }
 
 
   fill(250,229,174);
 ellipse(Mx,My,50,50);
 ellipse(Mx +25*cos(theta+PI/8),My + 25*sin(theta+PI/8),15,15);
 ellipse(Mx +25*cos(theta-PI/8),My + 25*sin(theta-PI/8),15,15);
 }
}


class Zombie
{
  int Mx;
  int My;
  float theta;
  float speed;
  boolean moved;
  boolean special;
  Zombie(int a, int b, float c,float s, boolean t)
  {
    Mx =a;
    My=b;
    theta = c;
    speed = s;
    special = t;
  }
 void show(){
 if(Mx<0)
   Mx = 0;
 if(Mx>sWidth)
   Mx = 950;
 if(My<0)
   My = 0;
 if(My>sWidth)
   My = 950;
 if (special)
   fill(150*cos(0.1*dumCount)+150,150*sin(0.1*dumCount)+150,150*tan(0.1*dumCount)+150);
 else
   fill(90,222,137);
 ellipse(Mx,My,50,50);
 ellipse(Mx +25*cos(theta),My + 25*sin(theta),15,15);
 }
}

Human bob = new Human(sWidth/2,750,PI/2.5,6,1.0);
float zombsped = 2.5;
int counter = 0;
Zombie[] swarm= {new Zombie(sWidth/4,250,PI/2,zombsped,false),new Zombie(sWidth/2,250,PI/2,zombsped,false),new Zombie(3*sWidth/4,250,PI/2,zombsped,false)};
int spawnFreq = 10; //seconds b/w sparn *10
float handy; // for storing random numbers
boolean lost;
boolean gameStart = true;
int score = 0;
int dumCount = 0;

void draw(){
dumCount++;
if(lost){
  background(150,150,150);
  fill(244,245,106);
  rect(sWidth/2-300,sHeight/2-50,600,220,40);
  textSize(45);
  fill(150*cos(0.1*dumCount)+150,150*sin(0.1*dumCount)+150,150*tan(0.1*dumCount)+150);
  textAlign(CENTER);
  text("GAME OVER!" , sWidth/2,sHeight/2+12);
  text("Your score was " + score, sWidth/2,sHeight/2+12+57);
  textSize(55);
  text("Click to play again", sWidth/2,sHeight/2+12+125);
  gameStart = true;
  fill(200,200,200);
  text("GAME OVER!" , dumCount-handy + 100, sHeight/2 + 400*sin(0.05*dumCount));
}    
else{
background(224,216,177);
counter++;
   bob.My+=bob.speed*sin(bob.theta);
   bob.Mx+=bob.speed*cos(bob.theta);
//human movement, controlled by player
if (keyPressed) {
 if (key == 'a')
   bob.theta-=0.01*PI;
 if (key == 'd')
   bob.theta+=0.01*PI;
  }
  
  bob.show(); //render human

  //per zombie loop
  for (int i = 0; i<swarm.length;i++){
    if((counter+i)%10==0){
    //zombie rotation to face human
    if(swarm[i].Mx-bob.Mx==0){ //if human and zombie have same x coordinate
      if(swarm[i].My-bob.My<0)
        swarm[i].theta=PI/2;
      else
        swarm[i].theta=-PI/2;;
    }
    
      else{
      if(swarm[i].Mx-bob.Mx<0)
        swarm[i].theta = atan((swarm[i].My-bob.My)/(swarm[i].Mx-bob.Mx));
       else
        swarm[i].theta = PI + atan((swarm[i].My-bob.My)/(swarm[i].Mx-bob.Mx));
      }
    }
    
    //check for loss
    if(abs((swarm[i].Mx)-bob.Mx)<25 && abs((swarm[i].My)-bob.My)<25){
     lost = true;
     handy = dumCount;
     if (swarm[i].special){
     ;}
     redraw();
     }
    
    //zombie movement towards human
    swarm[i].My+=swarm[i].speed*sin(swarm[i].theta);
    swarm[i].Mx+=swarm[i].speed*cos(swarm[i].theta);
    swarm[i].show();
    
    //zombies avoid other zombies
    for (int j = 0; j<i;j++){
      if(abs((swarm[i].Mx)-swarm[j].Mx)<25 && abs((swarm[i].My)-swarm[j].My)<25){
        handy = random(2*PI);
        swarm[i].My+= 27*sin(handy);
        swarm[i].Mx+= 27*cos(handy);
        swarm[i].moved = true;
      }
    }
    
    //second half of for loop, to not include the zombie 'i' itself
    for (int j = i+1; j<swarm.length;j++){
      if(abs((swarm[i].Mx)-swarm[j].Mx)<25 && abs((swarm[i].My)-swarm[j].My)<25){
        handy = random(2*PI);
        swarm[i].My+= 27*sin(handy);
        swarm[i].Mx+= 27*cos(handy);
        swarm[i].moved = true;
      }
    }
  //}
  }
  //end per zombie loop
  
  
//adding zombie every spawnFreq seconds -- make array one item longer  
if (counter%(10*spawnFreq)==0){
  Zombie[] temp = new Zombie[swarm.length + 1];   
   for (int i = 0; i < swarm.length; i++){
      temp[i] = swarm[i];
   }
   temp[swarm.length] = new Zombie(sWidth/2,100,PI/2,zombsped,false);
   swarm = temp;
   score ++;
   if ((score-3)%10==0){ //creating a "special" zombie every ten spawns with rgb coloring
     swarm[swarm.length-1].special = true;
     swarm[swarm.length-1].speed = zombsped*1.15;   // "special" zombies are 15% faster
   }
}

//reenables forced correction every .15 seconds: not tied to corrections, but clock time
  if (counter%15==0){
    for(int i = 0; i<swarm.length; i++)
    swarm[i].moved = false;
    }
  }
}


void mousePressed(){
if(gameStart){
  loop();
  //resetting global game variables
  lost = false;
  gameStart = false;
  counter = 3;
  //resetting positions and rotation of all figures
  bob.My = 750;
  bob.Mx = sWidth/2;
  bob.theta = PI/2;
  Zombie[] temp2= {new Zombie(sWidth/4,250,PI/2,zombsped,false),new Zombie(sWidth/2,250,PI/2,zombsped,false),new Zombie(3*sWidth/4,250,PI/2,zombsped,false)};
  swarm = temp2;
  score = 0;
}
if (lost){
  redraw();
  }
}
