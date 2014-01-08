within SMPS.BasicConverter;

model CukConverter
  "
  An non-isoltaed  Cuk converter, built of nonideal (lossy)
  elements. Losses of a transistor, diode and inductor copper are 
  modeled. Optionally any lossy element can be set to 0. By default
  both inductors and capacitors are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter SI.Inductance Li = Defaults.L
    "Input inductor's (Li) inductance [H]";
  parameter SI.Inductance Lo = Defaults.L
    "Output inductor's (Lo) inductance [H]";
  parameter SI.Capacitance C1 = Defaults.C
    "First capacitor's capacitance [F]";
  parameter SI.Capacitance Co = Defaults.C
    "Output capacitor's capacitance [F]";
  parameter SI.Resistance RLlossi = Defaults.Rl
    "Input inductor's copper resistance [Ohm]";
  parameter SI.Resistance RLlosso = Defaults.Rl
    "Output inductor's copper resistance [Ohm]";
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
    "PWM's high level voltage [V]";
    
protected
  EL.Basic.Inductor indi (L=Li);
  EL.Basic.Inductor indo (L=Lo);
  EL.Basic.Capacitor cap1 (C=C1);
  EL.Basic.Capacitor capo (C=Co);
  EL.Basic.Resistor RLi (R=RLlossi);
  EL.Basic.Resistor RLo (R=RLlosso);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (fs=fs, Vm=Vm, Von=Von);

  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.PositivePin node2;
  EL.Interfaces.PositivePin node3;
  EL.Interfaces.NegativePin noden;

equation

  connect(inN, noden);
  connect(outN, noden);
  
  connect(inP, indi.p);
  connect(indi.n, RLi.p);
  connect(RLi.n, node1);
  connect(node1, tr.p);
  connect(tr.n, noden);
  connect(node1, cap1.p);
  connect(cap1.n, node2);
  connect(node2, diode.p);
  connect(diode.n, noden);
  connect(node2, indo.p);
  connect(indo.n, RLo.p);
  connect(RLo.n, node3);
  connect(node3, capo.p);
  connect(capo.n, noden);
  connect(node3, outP);
  
  connect(dgen.n, noden);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);
  
  /*
    For more details about a Cuk converter and 
    its typical circuits, see
    https://en.wikipedia.org/wiki/%C4%86uk_converter
   */

end CukConverter;
