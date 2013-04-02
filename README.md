Processing Osc Visualizer
==========================

Write code with the Processing language to visualize musical data

## How to

To make it work you just:

* Download the code into your Processing sketchbook (generally it's a folder called 'sketchbook' inside your user files)
* Install the [oscP5](http://www.sojamo.de/libraries/oscP5/) library
* Open Processing and select the `OscVisualizer` sketch
* Send OSC data and visualize it

## Message format

Currently there are two messages that can be visualized:

    /noteOn iii

        Denotes a musical note being played.

        Arguments:
            Pitch (integer)
            Velocity (integer)
            Channel (integer)

    /pitchBend iii

        Denotes the pitch shifting of previous note

        Arguments:
            Initial value (integer)
            Final value (integer)
            Channel (integer)

### Using midi data

The events are fed into the visualizer via OSC, but we all love some MIDI messages. To use them instead, you can in some way translate the MIDI messages you'll be sending with a sequencer to the OSC message format.

I've included a [Chuck](http://chuck.cs.princeton.edu) script called `midi_osc.ck` that makes this conversion for you. You can run it with:

    chuck midi_osc.ck

It'll convert 'noteOn' and 'pitchBend' messages to the correct OSC format and output on port 12000.

### Customizing the visualization

The class `OscReceiver` is where things happen. You can extend it and implement the methods 'noteOn' and 'pitchBend' and then draw something inside them or just collect data and later draw it with the 'draw' method.

The class 'OscParticle' demonstrates that, by creating different particles with the method 'noteOn'. Their color and behavior is determined by the channel and pitch data of the notes.

## Demos

* [The Fuzziest Pickles](http://www.youtube.com/watch?v=TQ8erSK_ZfI&feature=youtu.be)
* [Ownlife](#) (soon)