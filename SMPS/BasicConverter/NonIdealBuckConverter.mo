within SMPS.BasicConverter;

model NonIdealBuckConverter
  "
  A buck converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode and inductor copper are modeled.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 100) and is constant during the simulation run.
  "
extends ISmps;

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
    "Capacitor's capacitance";
  parameter SMPS.PWM.DutyCycleRatio D = 0.6
    "Duty cycle";
  parameter SI.Voltage Von = 2.0
    "PWM's high level voltage";

protected
  EL.Basic.Inductor ind(L=L);
  EL.Basic.Capacitor cap(C=C);
  EL.Basic.Resistor rl(R=RLloss);
  SMPS.Switch.SingleQuadrantSwitch t(Ron=Rton);
  SMPS.Switch.Diode d(Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen(Vm=2, Von=Von, fs=100.e+3);

equation
  connect(inP, t.p);
  connect(t.n, d.n);
  connect(inN, d.p);
  connect(d.n, ind.p);
  connect(ind.n, rl.p);
  connect(rl.n, cap.p);
  connect(cap.n, d.p);
  connect(outP, cap.p);
  connect(outN, cap.n);
  
  connect(dgen.n, d.p);
  connect(dgen.p, t.ctrl);
  connect(t.gnd, dgen.n);

  dgen.d = D;

  /*
    For more details about a buck converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Buck_converter
   */

end NonIdealBuckConverter;
