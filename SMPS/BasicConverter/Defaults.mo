within SMPS.BasicConverter;

package Defaults
  "
  Sensible default values of some most often used quantities.
  "

  // Inductor:
  constant SI.Inductance L = 100.e-3
    "Default inductance of inductors: 100 mH";

  constant SI.Resistance Rl = 4.e-3
    "Default inductor's copper resistance: 4 mOhm";

  // Capacitor:
  constant SI.Capacitance C = 100.e-6
    "Default capacitance of capacitors:  100 uF";

  // MOSFET transistor:
  constant SI.Resistance Rton = 1.6e-3
    "Default transistor's on-state resistance: 1.6 mOhm";

  // Semiconductor diode:
  constant SI.Voltage Vknee = 0.7
    "Default diode's knee voltage: 0.7 V";

  constant SI.Resistance Rd = 1e-5
    "Default diode's conduction mode resistance: 1.e-5 Ohm";

  // TODO: default Qr and tr


  // PWM controller:
  constant SI.Voltage Vm = 2.0
    "Default PWM's sawtooth voltage amplitude: 2 V";

  constant SI.Voltage Von = 2.0
    "Default PWM's high level voltage: 2 V";

  constant SI.Frequency fs = 100.e+3
    "Default switching frequency: 100 kHz";

end Defaults;
