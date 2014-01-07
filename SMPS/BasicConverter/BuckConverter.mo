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

  parameter SI.Resistance Rton = Defaults.Rton
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = Defaults.Vknee
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = Defaults.Rd
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Inductance L = Defaults.L
    "Inductor's inductance [H]";
  parameter SI.Resistance RLloss = Defaults.Rl
    "Inductor's copper resistance [Ohm]";
  parameter SI.Capacitance C = Defaults.C
    "Capacitor's capacitance [F]";
  parameter SI.Voltage Vm = Defaults.Vm
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = Defaults.Von
    "PWM's high level voltage [V]";
  parameter SI.Frequency fs = Defaults.fs
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
