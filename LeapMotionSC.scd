///// Project Leap Motion & SuperCollider – Lisa Andersson López /////

// 1. Set up Leap Motion, and download LM software & SDK
// 2. Download Processing and Processing libraries Leap Motion & oscP5
// 3. Run Leap Motion Processing sketch (LeapMotion_Fingertips_15Inputs) in background
// 4. Run this SuperCollider code, receiving from port 6448

s.boot;
s.meter;

thisProcess.openPorts;
OSCFunc.trace(true);
OSCFunc.trace(false);
OSCFunc({|msg| msg.postln}, '/wek/inputs', recvPort:6448).oneShot;
OSCFunc({|msg| msg[1].postln}, '/wek/inputs', recvPort:6448).oneShot;

///// SOUND /////
// This is the code that interacts with Leap Motion
(
SynthDef(\sin, {
	arg freq=100, amp=0.5, width=0.5, out=0, pos=0;
	var sig;
	// env = EnvGen.ar(Env([0,1,0.7,0], [1,3,2], loopNode:1));
	freq = freq * LFPulse.kr(8, add:1); //
	sig = Saw.ar(freq);
	sig = Pulse.ar(freq, width, amp); //
	sig = FreeVerb.ar(sig, 0.7, 0.8, 0.25); //
	sig = sig * amp;
	sig = Pan2.ar(sig, pos, 1); //
	Out.ar(out, sig);
}).send(s);
)

Synth(\sin);

(
~hello = Synth(\sin);
~osc = OSCFunc({|msg|
	(msg[1]/2).postln; // [1]: left to right
	(msg[2]/300).postln; // [2]: up to down
	(msg[3]/100).postln; //
	~hello.set(\freq, msg[1]/2);
	~hello.set(\amp, msg[2]/400);
	~hello.set(\pos, msg[3]/100); //
},
'/wek/inputs',
recvPort:6448);
)

