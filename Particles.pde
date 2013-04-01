import oscP5.*;
import netP5.*;

OscP5 oscP5;
OscParticles oscParticles;

void setup()
{
  size(1000, 700);
  background(0);
  noStroke();

  oscP5 = new OscP5(this, 12000);

  oscParticles = new OscParticles();

  colorMode(HSB);
}

void oscEvent(OscMessage m)
{
  oscParticles.oscEvent(m);
}

void draw()
{
  // Good old fading background
  fill(0, 5);
  rect(0, 0, width, height);

  oscParticles.draw();
}
