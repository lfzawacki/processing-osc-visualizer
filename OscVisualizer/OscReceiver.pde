/*
  OscReceiver
  Used to receive OSC events and call callback functions
  
  Extend this class and implement 'noteOn' or 'pitchBend' 
*/
class OscReceiver
{
  OscReceiver()
  {
  }
  
  void oscEvent(OscMessage m)
  {
      if(m.checkAddrPattern("/noteOn") && m.checkTypetag("iii")) {
        noteOn(m.get(2).intValue(), m.get(0).intValue(), m.get(1).intValue());
      } else if(m.checkAddrPattern("/pitchBend") && m.checkTypetag("iii")) {
        pitchBend(m.get(2).intValue(), m.get(0).intValue(), m.get(1).intValue());
      } else
      {
        println("Unprocessed message " + m);
      }
  }

  void noteOn(int channel, int note, int velocity)
  {
    // Do something with it
  }
  
  void pitchBend(int channel, int value1, int value2)
  {
    // Do something with it
  }

  void draw()
  {
    // Tipically draw something based on the messages being passed
  }

}
