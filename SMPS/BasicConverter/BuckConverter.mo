within SMPS.BasicConverter;

model BuckConverter
  "
  A buck converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode and inductor copper are modeled.
  Optionally any lossy element can be set to 0. By default
  both inductors and capacitors are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter SI.Resistance Rton = 1.6e-3
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = 1.2
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = 0
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Inductance L = 100.e-3
    "Inductor's inductance [H]";
  parameter SI.Resistance RLloss = 4e-3
    "Inductor's copper resistance [Ohm]";
  parameter SI.Capacitance C = 100.e-6
    "Capacitor's capacitance [F]";
  parameter SI.Voltage Vm = 2.0
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = 2.0
    "PWM's high level voltage [V]";
  parameter SI.Frequency fs = 75.e+3
    "Switching frequency [Hz]";

protected
  EL.Basic.Inductor ind(L=L);
  EL.Basic.Capacitor cap(C=C);
  EL.Basic.Resistor rl(R=RLloss);
  SMPS.Switch.SingleQuadrantSwitch t(Ron=Rton);
  SMPS.Switch.Diode diode(Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen(Vm=Vm, Von=Von, fs=fs);

equation
  connect(inP, t.p);
  connect(t.n, diode.n);
  connect(inN, diode.p);
  connect(diode.n, ind.p);
  connect(ind.n, rl.p);
  connect(rl.n, cap.p);
  connect(cap.n, diode.p);
  connect(outP, cap.p);
  connect(outN, cap.n);
  
  connect(dgen.n, diode.p);
  connect(dgen.p, t.ctrl);
  connect(t.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a buck converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Buck_converter
   */

end BuckConverter;
