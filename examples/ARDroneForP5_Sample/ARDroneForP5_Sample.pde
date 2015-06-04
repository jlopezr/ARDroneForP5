import com.shigeodayo.ardrone.processing.*;
import com.shigeodayo.ardrone.manager.*;
import com.shigeodayo.ardrone.navdata.*;
import com.shigeodayo.ardrone.utils.*;
import com.shigeodayo.ardrone.processing.*;
import com.shigeodayo.ardrone.command.*;
import com.shigeodayo.ardrone.*;

ARDroneForP5 ardrone;

void setup() {
  
  //Tamany del display de la camara al PC
  //Size.620,360
  size(1000,360);
  //IP de la Wi-Fi del drone
  ardrone=new ARDroneForP5("192.168.1.1");
  // conectem amb drone
  ardrone.connect();
  // agafem informació dels sensors
  ardrone.connectNav();
  // agafem informació de la camara
  ardrone.connectVideo();
  // comencem el control del drone i 
  //agafem info dels sensors i video

  ardrone.start();
}

void draw() {
  background(204);  

  // getting image from AR.Drone
  // true: resizeing image automatically
  // false: not resizing
  PImage img = ardrone.getVideoImage(false);
  if (img == null)
    return;
  image(img, 0, 0);

  // print out AR.Drone information
  ardrone.printARDroneInfo();

  // getting sensor information of AR.Drone
  float pitch = ardrone.getPitch();
  float roll = ardrone.getRoll();
  float yaw = ardrone.getYaw();
  float altitude = ardrone.getAltitude();
  float[] velocity = ardrone.getVelocity();
  int battery = ardrone.getBatteryPercentage();
  
  double lat = ardrone.getLatitude();
  double lon = ardrone.getLongitude();
  double elev = ardrone.getElevation();

  String attitude = "pitch:" + pitch + "\nroll:" + roll + "\nyaw:" + yaw + "\naltitude:" + altitude;
  PFont f;
  f=createFont("Arial",16,true);
  textFont(f);
  String GPS = "Latitude:" + lat + "\nLongitude:" + lon + "\nElevation" + elev;
  text(GPS, 120, 85);
  text(attitude, 20, 85);
  String vel = "vx:" + velocity[0] + "\nvy:" + velocity[1];
  text(vel, 20, 250);
  String bat = "battery:" + battery + " %";
  text(bat, 20, 200);

  //AI--> Image: (620,360) centre (260,180)
  //pitch: (negatiu morro avall) 220pi == 90 º  100pi == -90º
  //roll: postiu (a la dreta down)

//AI
arc(810.0,180.0,180.0,180.0,0.0,TWO_PI);
arc(810.0,180.0,10.0,10.0,0.0,TWO_PI);
line(790,90,790,270);
line(830,90,830,270);

float i=90;
while(i<=270)
{
  line(790,i,830,i);
  i=i+10;
}

  double xi=750;
  double yi=180;
  double xf=870;
  double yf=180;

  double xChange = 60*Math.cos(Math.toRadians(roll));

  double yChange = 60*Math.sin(Math.toRadians(roll));
  
  float Xi = (float) xChange;
  float Yi = (float) yChange;
  

  line(810-Math.abs(Xi),180+Yi,810+Math.abs(Xi),180-Yi);
  
  //y coord: 100-->-90 260-->90 180--0
  float newY=(100/90)*pitch;
  line(750,180+newY,870,180+newY);
}

//PCのキーに応じてAR.Droneを操作できる．
// controlling AR.Drone through key input
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      ardrone.forward(); // go forward
    } 
    else if (keyCode == DOWN) {
      ardrone.backward(); // go backward
    } 
    else if (keyCode == LEFT) {
      ardrone.goLeft(); // go left
    } 
    else if (keyCode == RIGHT) {
      ardrone.goRight(); // go right
    } 
    else if (keyCode == SHIFT) {
      println("takeoff");
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
    } 
    else if (keyCode == CONTROL) {
      ardrone.landing();
      // landing
    }
  } 
  else {
    if (key == 's') {
      ardrone.stop(); // hovering
    } 
    else if (key == 'r') {
      ardrone.spinRight(); // spin right
    } 
    else if (key == 'l') {
      ardrone.spinLeft(); // spin left
    } 
    else if (key == 'u') {
      ardrone.up(); // go up
    }
    else if (key == 'd') {
      ardrone.down(); // go down
    }
    else if (key == '1') {
      ardrone.setHorizontalCamera(); // set front camera
    }
    else if (key == '2') {
      ardrone.setHorizontalCameraWithVertical(); // set front camera with second camera (upper left)
    }
    else if (key == '3') {
      ardrone.setVerticalCamera(); // set second camera
    }
    else if (key == '4') {
      ardrone.setVerticalCameraWithHorizontal(); //set second camera with front camera (upper left)
    }
    else if (key == '5') {
      ardrone.toggleCamera(); // set next camera setting
    }
  }
}

