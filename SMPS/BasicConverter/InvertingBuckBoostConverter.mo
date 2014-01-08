within SMPS.BasicConverter;

model InvertingBuckBoostConverter
  "
  An inverting buck - boost converter, built of nonideal (lossy)
  elements. Losses of a transistor, diode and inductor copper are 
  modeled. Optionally any lossy element can be set to 0.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter SI.Inductance L = Defaults.L
    "Inductor's inductance [H]";
  parameter SI.Capacitance C = Defaults.C
    "Capacitor's capacitance [F]";
  parameter SI.Resistance RLloss = Defaults.Rl
    "Inductor's copper resistance [Ohm]";
  parameter SI.Resistance Rton = Defaults.Rton
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = Defaults.Vknee
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = Defaults.Rd
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Frequency fs = Defaults.fs
    "Switching frequency [Hz]";
  parameter SI.Voltage Vm = Defaults.Vm
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = Defaults.Von
    "PWM's high level voltage";


protected
  EL.Basic.Inductor ind (L=L);
  EL.Basic.Capacitor cap (C=C);
  EL.Basic.Resistor Rl (R=RLloss);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.PWM.DutyCycleD dgen(fs=fs, Vm=Vm, Von=Von);

  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.PositivePin node2;
  EL.Interfaces.NegativePin noden;

equation

  connect(inN, noden);
  connect(outN, noden);
  
  connect(inP, tr.p);
  connect(tr.n, node1);
  connect(node1, ind.p);
  connect(ind.n, Rl.p);
  connect(Rl.n, noden);
  connect(node1, diode.n);
  connect(diode.p, node2);
  connect(node2, cap.p);
  connect(cap.n, noden);
  connect(node2, outP);
  
  connect(dgen.n, noden);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about an inverting buck - boost converter and 
    its typical circuits, see
    https://en.wikipedia.org/wiki/Buck%E2%80%93boost_converter
   */
end InvertingBuckBoostConverter;
