/*
  OscParticles
  
  Receives 'noteOn' and 'pitcheBend' messages and creates some particles
  in response to them. 
*/

class OscParticles extends OscReceiver {

  boolean shake;
  boolean bigShake;
  boolean grow;

  ArrayList particles;
  Particle[] bendParticles;
  boolean[] bendUsed;

  OscParticles()
  {
    particles = new ArrayList();
    bendParticles = new Particle[16];
    bendUsed = new boolean[16];

    for (int i=0; i < 16; i++)
      bendUsed[i] = false;
  }

  void noteOn(int channel, int value, int velocity)
  {
      float seqX = width*0.05 + ((frameCount/30.0)*width/8.0 % width*0.85);
      Particle p = null;

      if (channel == 0 || channel == 1)
      {
        float seqY = map(value, 30, 90, height*0.75, 0);
  
        p = new FloatingParticle(seqX, seqY);
        p.setShade(channel * 10);
        p.setSize(value, value);
      }
      else
      if (channel == 11 || channel == 12)
      {
        float seqY = map(value, 30, 90, height*0.75, 0);
        p = new BouncyParticle(seqX, seqY);
        p.setShade(channel * 10);
        p.setSize(value/3, value/3);
      }
      else if (channel == 4 || channel == 5)
      {
        float seqY = map(value, 30, 90, height*0.75, 0);
        p = new CenterParticle(seqX, seqY);
        p.setShade(channel * 10);
        p.setSize(value/2, value/2);
      }
      else if (channel == 6 || channel == 7)
      {
        float seqY = map(value, 30, 90, height*0.95, 0);
        p = new FloatingParticle(seqX, seqY);
        p.setShade(channel * 10);
        p.setSize(value/2, value/2);
      }
      else if (channel == 9)
      {
        if (value == 44 || value == 42 || value == 53 || value == 51 || value == 81 || value == 85)
          shake = true;

        if (value == 52 || value == 49)
          bigShake = true;

        if (value == 36 || value == 35 || value == 43 || value == 45 || value == 41 || value == 47)
        {
            grow = true;
        }
      }
      else if (channel == 8 || channel == 10)
      {
        float seqY = map(value, 30, 90, height*0.75, 0);
  
        p = new GravityParticle(seqX, seqY);
        p.setShade(channel * 10);
        p.setSize(value/2, value/2);
      }
      else
      {
        float seqY = map(value, 30, 90, height*0.75, 0);
  
        p = new Particle(seqX, seqY);
  
        p.setShade(channel * 10);
      }

      if (p != null)
      {
        bendParticles[channel] = p;
        particles.add(p);
      }
  }

  void pitchBend(int channel, int value, int value2)
  {
      if (!bendUsed[channel] && value == 64)
      {
          bendUsed[channel] = true;
          Particle p = bendParticles[channel];

          if (p == null) return;
      }
      else
      {
        if (value == 64)
        {
          bendUsed[channel] = false;
        }
        else
        {
          Particle p = bendParticles[channel];
          float v = map( log(value), log(40), log(70), -0.01, -.3);
          float xspeed = v*random(-.1,.1);
          p.addSpeed(0, v);
        }
      }
  }

  void draw()
  {
      for (int i = particles.size()-1; i >= 0; i--)
      { 
        Particle p = (Particle) particles.get(i);
    
        p.move();
        p.accel();
    
        if (grow)
        {
          p.size_x *= 3;
          p.size_y *= 3;
        }
    
        p.draw();
        
        if (grow)
        {
          p.size_x /= 3;
          p.size_y /= 3;
        }
    
        if (shake)
        {
          p.addSpeed(random(-1,1), -2);
        }

        if (bigShake)
        {
          p.addSpeed(random(-4,4), random(-4,4));
        }
    
        if (p.done()) {
          particles.remove(i);
        }
    
      } 
    
      if (shake)
        shake = false;
    
      if (bigShake)
        bigShake = false;
    
      if (grow)
        grow = false;
  }
}

