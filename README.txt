
This is a light-weight matlab class for connecting to The Eyetribe tracker (http://theeyetribe.com/). Allows realtime access to gaze data using the JSON API and simultaneous recording to a file using matlab's native tcpip.

* Author:  Ian Stevenson
* This work is licensed under a Creative Commons Attribution 4.0 International License (https://creativecommons.org/licenses/by/4.0/).

Dependencies:
    JSONlab (https://github.com/fangq/jsonlab)

Generic Procedure:
    1. Use the EyeTribe UI to connect and calibrate the tracker
    2. Run demo.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Notes:
>> In Windows C:\Users\<current_user>\AppData\Local\EyeTribe\EyeTribe.cfg
contains json formatted user-adjustable paramters. Framerate can be 30, 40, or 60Hz.

If it does not exist you may need to add it, e.g....
{
"config" : {
"device" : 0,
"framerate" : 60,
"port" : 6555 
}
}

Specs:
Accuracy            0.5° – 1°
Spatial Resolution	0.1° (RMS)
Latency             <20ms at 60Hz
Calibration         9, 12 or 16 points
Operating range		45cm – 75cm
Tracking area		40cm x 30cm at 65cm distance (30Hz)