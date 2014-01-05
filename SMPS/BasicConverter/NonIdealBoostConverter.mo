within SMPS.BasicConverter;

model NonIdealBoostConverter
  "
  A boost converter, built of nonideal (lossy) elements.
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
  SMPS.Switch.SingleQuadrantSwitch tr(Ron=Rton);
  SMPS.Switch.Diode d(Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen(Vm=2, Von=2, fs=100.e+3);

equation
  dgen.d = D;
  
  connect(inP, ind.p);
  connect(ind.n, rl.p);
  connect(rl.n, tr.p);
  connect(tr.n, inN);
  
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  
  connect(tr.p, d.p);
  connect(d.n, cap.p);
  connect(cap.p, outP);
  connect(cap.n, outN);
  connect(cap.n, tr.n);

  /*
    For more details about a boost converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Boost_converter
   */

end NonIdealBoostConverter;
