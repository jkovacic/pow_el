within SMPS.BasicConverter;

model BoostConverter
  "
  A boost converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode and inductor copper are modeled.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 100) and is constant during the simulation run.
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
  EL.Basic.Inductor ind (L=L);
  EL.Basic.Capacitor cap (C=C);
  EL.Basic.Resistor rl (R=RLloss);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (Vm=Vm, Von=Von, fs=fs);

  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.PositivePin node2;
  EL.Interfaces.NegativePin noden;

equation

  connect(inN, noden);
  connect(outN, noden);

  connect(inP, ind.p);
  connect(ind.n, rl.p);
  connect(rl.n, node1);
  connect(node1, tr.p);
  connect(tr.n, noden);
  
  connect(node1, diode.p);
  connect(diode.n, node2);
  connect(node2, cap.p);
  connect(cap.n, noden);
  connect(outP, node2);

  connect(dgen.n, noden);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(dgen.d, d);

  /*
    For more details about a boost converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Boost_converter
   */

end BoostConverter;
