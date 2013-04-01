class MidiPlayer
{
    MidiIn min;
    MidiMsg msg;
    OscSend send;

    fun void initialize()
    {
        // OSC stuff to communicate with the Zombie GUI
        send.setHost("localhost", 12000);

        send.startMsg( "/status", "i" );
        1 => send.addInt;

        init_midi();

        spork ~wait_midi();
    }

    fun void init_midi()
    {
        0 => int device;

        if( !min.open( device ) ) me.exit();
        <<< "MIDI device:", min.num(), " -> ", min.name() >>>;
    }

    // Call this to wait for midi events
    fun void wait_midi()
    {
        while( true )
        {
            min => now;

            while( min.recv(msg) )
            {
                msg.data3 == 0 => int fake_noteoff;
                msg.data1 - 144 => int fake_channel;

                // bend
                if ( (msg.data1 - 224) >= 0 && (msg.data1 - 224) < 16)
                {
                    noteBend(msg.data1 - 224, msg.data2, msg.data3);
                }

                // noteon
                if ((msg.data1 - 144) >= 0 && (msg.data1 - 144) < 16 && !fake_noteoff) //note on
                {
                    noteTrigger(1, msg.data1 - 144, msg.data2,msg.data3);
                }
                // 0 velocity noteon mean a noteoff
                else if (fake_noteoff)
                    noteTrigger(0, fake_channel, msg.data2,msg.data3);

                // noteoff
                else if ((msg.data1 - 128) >= 0 && (msg.data1 - 128) < 16)
                {
                    noteTrigger(0, msg.data1 - 128, msg.data2,msg.data3);
                }
                else
                {
                    <<<msg.data1, msg.data2, msg.data3>>>;
                }

            }
        }
    }

    fun void panic()
    {
    }

    fun void noteTrigger(int state, int c, int n, int v)
    {
        if (state == 1)
        {
            send.startMsg( "/noteOn", "i,i,i" );
            n => send.addInt;
            v => send.addInt;
            c => send.addInt;
          //  <<< n, c, v >>>;
        }
    }

    fun void noteBend(int c, int l, int m)
    {
        send.startMsg( "/pitchBend", "i,i,i" );
        m => send.addInt;
        l => send.addInt;
        c => send.addInt;
        <<< m, l, c >>>;
    }

}

MidiPlayer m;

m.initialize();

2::week => now;