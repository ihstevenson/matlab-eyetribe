
This is a light-weight matlab class for connecting to the EyeTribe tracker (http://theeyetribe.com/). Allows realtime access to gaze data and simultaneous recording using the JSON API and Matlab's native tcp/ip object

* Author:  Ian Stevenson
* This work is licensed under a Creative Commons Attribution 4.0 International License (https://creativecommons.org/licenses/by/4.0/).

# Install:
    1. Install JSONlab (https://github.com/fangq/jsonlab)
    2. Use the EyeTribe UI (http://dev.theeyetribe.com/general/) to connect and calibrate the tracker
    2. Run demo.m

# Issues:
Code is not threaded so there are some problems...
    1. keeping connection alive when matlab is doing other things (2Hz heartbeats are needed)
    2. using loadJSON to convert a long recording tends to throw errors if the eyetribe is still running
    3. continuous stimuli (e.g. movies in psychtoolbox) do not run smoothly

# Notes:
In Windows C:\Users\<current_user>\AppData\Local\EyeTribe\EyeTribe.cfg
contains json formatted user-adjustable paramters. Framerate can be 30, 40, or 60Hz.

If it does not exist you may need to add it, e.g....
    {
        "config" : {
        "device" : 0,
        "framerate" : 60,
        "port" : 6555 
        }
    }

The port is hard-coded in eyetribe.m.

    Specs:
    Accuracy            0.5° – 1°
    Spatial Resolution	0.1° (RMS)
    Latency             <20ms at 60Hz
    Calibration         9, 12 or 16 points
    Operating range		45cm – 75cm
    Tracking area		40cm x 30cm at 65cm distance (30Hz)
