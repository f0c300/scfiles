/* NOTES -- QUICKSTART
- C^ enter : eval
- C^ . : stop
- left to right precedence (but can be forced with brackets)
9 + 2 * 2 = 22
- evaluate multiple lines by grouping in brackets
- C^ shift + P cleans the post window (IDE) / use ??? in vim
- s.record; {sound}; s.stopRecording; s.makeWindow;
~globalVar = "foo"
var localVar = "bar"
\degree : count from 0 = middle C ( -2 is the A below)
\note : same but with 12 chromatic notes
\midinote : 60=C 61=C# ...
\ctranspose, 12 (+1 octave)
\freq : C=261.6 A = 440
\dur in beats, default with 60bpm
.play(TempoClock(120/60)) for 120bpm
.trace.play for debug output
*/

{LFNoise1.ar(LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play
{LFNoise1.ar()}.play

{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.02)}.play;

{Saw.ar(LFNoise0.kr([2, 3]).range(100, 2000), LFPulse.kr([4, 5]) * 0.1)}.play;

/* Patterns */
a = Pbind(\degree, 1);
(
b = Pbind(
    \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1),
        \dur, 0.2
	);

	)
	(
	c = Pbind(
	// play 5 times, duration of the respective degrees, shifts each time in this case
		\degree, Pseq([[0, 3, 4], [2, 3, 6]], 5), //chords
			\strum, 0.1,
			    \dur, Pseq([0.2, 0.1, 0.1,Rest(0.3), 0.2,0.2, 0.35], inf)
			    );
			    )
			    d = Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05);
(
			    e = Pbind(
			    \note, Pseq([0, −1, 2, −3, 4, −3, 8, 11, 4, 2, 0, −3], 5),
			    \dur, Pwhite(0.3, 0.7), //equal rng
			    \amp, Prand([0.7, 0.5, 0.3, 0.2], inf),
			    \legato, 0.4
			    );
)

			    // see also Pser Pxrand Pshuf Pslide Pseries Pgeom Pn Ppar Pspawner
			    ~player = d.play;
			    ~player.stop;
			    /* */

/* OO FEATURES */

//equivalent notations :
100.0.rand.round(0.01).dup(4);
dup(round(rand(100.0),0.01), 4);

"string"
'symbol'
\symbol

//function in curly braces
rand(1000.0).dup(5);
{rand(1000.0)}.dup(5);

// if / else
if(100 > 50, { "very true".postln }, { "very false".postln });
// case
(
~num = -2;
case
{~num == 0} {"WOW".postln}
{~num == 1} {"ONE!".postln}
{~num < 0} {"negative number!".postln}
{true} {"last case scenario".postln};
)
//function
f = {arg a, ; ["a plus b", a+b, "a times b", a*b].postln}; // define function
f.value(3, 7); // now you can give any two numbers as arguments to the function

// Shortcut array notation:
30!4;//Ugen

//theremin
{SinOsc.ar(freq: MouseX.kr(80, 150), mul: MouseY.kr(0, 1))}.play

// poll :
{LFNoise0.ar(2).poll}.play;

{SinOsc.ar(freq: LFNoise0.kr(10).range(50, 150).poll, mul: 0.1)}.play;

{SinOsc.ar(freq: LFPulse.kr(1).range(110, 131))}.play

// This:
{SinOsc.kr(1).range(100, 200).poll}.play;
// ...is the same as this:
{SinOsc.kr(1, mul: 50, add: 150).poll}.play;


// A bunch of numbers
a = [1, 2, 3, 4, 5, 6, 7];
// Rescale to 0−127, linear to linear
a.linlin(1, 7, 0, 127).round(1);
// Rescale to 0−127, linear to exponential
a.linexp(1, 7, 0.01, 127).round(1); // don't use zero for an exponential range

// start stop
a = { Saw.ar(LFNoise2.kr(8).range(1000, 2000), mul: 0.2) }.play;
b = { Saw.ar(LFNoise2.kr(7).range(100, 1000), mul: 0.2) }.play;
c = { Saw.ar(LFNoise0.kr(15).range(2000, 3000), mul: 0.1) }.play;
a.free
b.free
c.free

//set
x = {arg freq = 440, amp = 0.1; SinOsc.ar(freq, 0, amp)}.play;
x.set(\freq, 778);
x.set(\amp, 0.5);
x.set(\freq, 920, \amp, 0.2);
x.free;


// start the effect
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play;

//or with reverb
{FreeVerb.ar(In.ar(55), mix: 0.5, room: 0.9)}.play;

// start the source
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;
// noise -> bus 55 -> filter

//multichannel expansion
{Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(0, 1, 10)))}.play;

a = {Out.ar(0, SinOsc.ar(freq: [110, 100], mul: LFPulse.ar([2, 3])))}.play;
a.free;



// Run this first ('turn reverb on' −− you won't hear anything at first)
r = {Out.ar(0, FreeVerb.ar(In.ar(55, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;
// Now run this second ('feed the busy tone into the reverb bus')
a = {Out.ar(55, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;
a.free; r.free;


// Create the bus
~myBus = Bus.audio(s, 2);
// Turn on the reverb: read from myBus (source sound)
r = {Out.ar(0, FreeVerb.ar(In.ar(~myBus, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;
// Feed the busy tone into ~myBus
b = {Out.ar(~myBus, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;
// Free both synths
r.free; b.free;

p = {Pan2.ar(in: PinkNoise.ar, pos: SinOsc.kr(2), level: 0.1)}.play;
p.free;




(
x = {
var lfn = LFNoise2.kr(1);
var saw = Saw.ar(
		freq: 30,
		mul: LFPulse.kr(
			freq: LFNoise1.kr(1).range(1, 10),
			width: 0.1));
var bpf = BPF.ar(in: saw, freq: lfn.range(500, 2500), rq: 0.01, mul: 5);
Pan2.ar(in: bpf, pos: lfn);
}.play;
)
x.free;


// 5 channels output (watch Meter window)
a = { SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1) }.play;
a.free;
// Mix it down to mono:
b = { Mix(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)) }.play;
b.free;
// Mix it down to stereo (spread evenly from left to right)
c = { Splay.ar(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)) }.play;
c.free
// Fun with Splay:

(
f = {arg fundamental = 110;
var harmonics = [1, 7, 13];
var snd = BPF.ar(
in: Saw.ar(32, LFPulse.ar(harmonics, width: 0.1)),
freq: harmonics * fundamental,
rq: 0.05,
mul: 20);
Splay.ar(snd);
}.play;
)

Out.ar(55, f.ar(0.5))

d.set(\fundamental, 70); // change fundamental just for fun
d.set(\fifth, 139);
d.free;

