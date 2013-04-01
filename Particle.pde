/*
  Particle

  Many classes deriving from 'Particle'. The interface is just
  the functions 'draw' and 'move' and so it can be used to mix 
  and match different particles.
*/

class Particle
{
   public PVector pos;
   public PVector speed;
   public float size_x;
   public float size_y;
   
   PVector accel;
   float shade;
   boolean first;
   long create_time;

   Particle(float x, float y)
   {
     pos = new PVector(x, y);
     speed = new PVector(0, 1);
     accel = new PVector(0.00, 0.1);
     size_x = 5;
     size_y = 5;
     shade = 255;
     first = true;
     create_time = frameCount;
   }

   Particle(float x, float y, float size, color c)
   {
      //(x, y);
      size_x = size;
      size_y = size;
//      shade =  
   }

   long createdTime()
   {
      return frameCount - create_time;
   }

   float getX()
   {
     return pos.x;
   }
   
   float getY()
   {
     return pos.y;
   }

   float getShade()
   {
     return shade;
   }

   void collide()
   {
   }

   void move()
   {
     // Update position
     pos.add(speed);
   }
   
   void accel()
   {
     speed.add(accel);
   }

   void setShade(float c)
   {
     shade = c;
   }

   void setAccel(float x, float y)
   {
     accel.x = x;
     accel.y = y;
   }

   void setSpeed(float x, float y)
   {
     speed.set(x,y, 0);
   }

   void addSpeed(float x, float y)
   {
     speed.add(x, y, 0);
   }
   
   void addAccel(float x, float y)
   {
     accel.add(x, y, 0);
   }
   
   boolean outOfBounds()
   {
     return pos.x >= width || pos.x < 0
         || pos.y >= height || pos.y < 0;
   }
   
   boolean done()
   {
      return outOfBounds();
   }
   
   void draw()
   {
     if (!done())
     {
       color c = color(shade, 255, map(pos.y, 0, height, 20, 255));
       fill(c);

       ellipse(pos.x, pos.y, size_x * 4 * (map(pos.y, 0, height, 0, 1)), 
                             size_y * 4 * (map(pos.y, 0, height, 0, 1)));

     }
   }
   
   void setSize(float w, float h)
   {
     size_x = w;
     size_y = h;
   }
}

class BouncyParticle extends Particle
{
   long hits;
   int done_time;

   private static final long MAX_HITS = 2;
   private static final long EXPLODE_TIME = 30;
 
   BouncyParticle(float x, float y)
   {
     super(x, y);
     hits = 0;
   }
  
   void collide()
   {
     hits++;
   }

   void move()
   {
     // Update position
     pos.add(speed);

     // Ricochet to the center
     if (outOfBounds())
     {
       float mag = speed.mag();
       PVector center = new PVector((width/2 + random(-width/5, width/5)) - pos.x, 
                                    (height/2 + random(-height/5, height/5)) - pos.y); 
       center.normalize();

       setSpeed(center.x * mag/1.5, center.y * mag/1.5);
     
       collide();

       if (hits > MAX_HITS)
         done_time = frameCount;
     }
   }
   
   boolean done()
   {
     return hits > MAX_HITS;
   }

   boolean exploded()
   {
     return explodeTime() > EXPLODE_TIME;
   }
   
   int explodeTime()
   {
     return frameCount - done_time;
   }
   
   void draw()
   {
     // If the particle's life is ending, explode
     if (outOfBounds() || done() && exploded())
     {
       //nothing
     }
     else if (done())
     {
       color c = color(shade, 255, map(pos.y, 0, height, 20, 255));
       fill(c);

       float sx = size_x/2.0, sy = size_y/2.0;
       float e = explodeTime();

       rect(pos.x-sx*e, pos.y-sy*e, sx, sy);
       rect(pos.x+sx*e, pos.y-sy*e, sx, sy);
       rect(pos.x-sx*e, pos.y+sy*e, sx, sy);
       rect(pos.x+sx*e, pos.y+sy*e, sx, sy);       
     }
     else
     {
       color c = color(shade, 255, map(pos.y, 0, height, 20, 255));
       fill(c);

       ellipse(pos.x, pos.y, size_x * 4 * (map(pos.y, 0, height, 0, 1)), 
                             size_y * 4 * (map(pos.y, 0, height, 0, 1)));
     }
   }
}

class FloatingParticle extends Particle
{
  FloatingParticle(float x, float y)
  {
    super(x, y);
  }

  boolean done()
  {
    return size_x < 1;
  }
  
  void move()
  {
    // no movement, just floating
    size_x -= 0.6;
    size_y -= 0.6;
    pos.add(random(-2, 2), random(-2, 2), 0);
  }
}


class SpriteParticle extends CenterParticle
{  

  PImage sprite;
  
  SpriteParticle(float x, float y, PImage img)
  {
    super(x, y);
    setAccel( (width/2 - x)/(width*10), 0.01);
    img = sprite;
  }

  void move()
  {
    super.move();    

    if ( pos.x < width * 0.10)
      addSpeed(0.8, 0);
    if ( pos.y < height * 0.10)
      addSpeed(0, 0.8); 

    if ( pos.x > width * 0.9 )
      addSpeed( -0.8, 0);

    if ( pos.y > height * 0.9 )
      addSpeed( 0, -0.8);

  }

  void draw()
  {
     if (!done())
     {
         pushMatrix();
         translate(pos.x + sprite.width/2, pos.y + sprite.height/2);         
         float d = dist(pos.x, pos.y, width/2, height/2);
         image(sprite, 0, 0, d*8 / sprite.height, d*8 / sprite.width);     
         popMatrix();
     }
  }
}

class ExpandingParticle extends Particle
{
  ExpandingParticle(float x, float y)
  {
    super(x, y);
  }

  void move()
  {
  }

  boolean done()
  {
    return createdTime() > 60;
  }
  
  void draw()
  {
    ellipse(pos.x, pos.y, size_x * 4 * (map(createdTime(), 0, 60, 0, 1)), 
                          size_y * 4 * (map(createdTime(), 0, 60, 0, 1)));   
  }
}

class CenterParticle extends Particle
{
  boolean go_away;
  CenterParticle(float x, float y)
  {
    super(x, y);
    setAccel( (x - width/2)/(width*4), 0.01);
    go_away = false;
  }
 
 
  boolean done()
  {
    return outOfBounds() || dist(pos.x, pos.y, width/2, height/2) < 10;
  }

  void move()
  {

    if (!go_away)
    {
      setSpeed( (width/2 + random(-50, 50))- pos.x, (height/2 + random(-50,50)) - pos.y);
      speed.normalize();
      speed.mult(4);
    }
    
    // Update position
    pos.add(speed);

  }

  void dontComeBack()
  {
    go_away = true;
  }

  void draw()
  {
     if (!done())
     {
       color c = color(shade, 255, map(pos.y, 0, height, 20, 255));
       fill(c);

       ellipse(pos.x, pos.y, size_x * 10 * dist(pos.x, pos.y, width/2, height/2)/width, 
                             size_y * 10 * dist(pos.x, pos.y, width/2, height/2)/width);

     }
  }
}

class GravityParticle extends Particle
{
  GravityParticle(float x, float y)
  {
    super(x, y);
  }
  
  void move()
  {
    speed.set(0, 4, 0);
    pos.add(speed);
  }
}
