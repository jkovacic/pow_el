within SMPS.BasicConverter;

model ZetaConverter
  "
  A SEPIC (single-ended primary-inductor converter), built of nonideal (lossy)
  elements. Losses of a transistor, diode and inductor copper are 
  modeled. Optionally any lossy element can be set to 0. By default
  both inductors and capacitors are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter SI.Inductance L1 = Defaults.L
    "Input inductor's (L1) inductance [H]";
  parameter SI.Inductance Lo = Defaults.L
    "Output inductor's (Lo) inductance [H]";
  parameter SI.Capacitance C1 = Defaults.C
    "First capacitor's capacitance [F]";
  parameter SI.Capacitance Co = Defaults.C
    "Output capacitor's capacitance [F]";
  parameter SI.Resistance RLloss1 = Defaults.Rl
    "Input inductor's copper resistance [Ohm]";
  parameter SI.Resistance RLlosso = Defaults.Rl
    "Second inductor's copper resistance [Ohm]";
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
  EL.Basic.Inductor ind1 (L=L1);
  EL.Basic.Inductor indo (L=Lo);
  EL.Basic.Capacitor cap1 (C=C1);
  EL.Basic.Capacitor capo (C=Co);
  EL.Basic.Resistor RL1 (R=RLloss1);
  EL.Basic.Resistor RLo (R=RLlosso);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (fs=fs, Vm=Vm, Von=Von);
  
  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin n1;
  EL.Interfaces.PositivePin n2;
  EL.Interfaces.PositivePin n3;
  EL.Interfaces.NegativePin nn;
  
equation

  connect(inN, nn);
  connect(outN, nn);

  connect(inP, tr.p);
  connect(tr.n, n1);
  connect(ind1.p, n1);
  connect(ind1.n, Rl1.p);
  connect(Rl1.n, nn);
  connect(n1, cap1.p);
  connect(cap1.n, n2);
  connect(n2, diode.n);
  connect(diode.p, nn);
  connect(n2, indo.p);
  connect(indo.n, Rlo.p);
  connect(Rlo.n, n3);
  connect(n3, capo.p);
  connect(capo.n, nn);
  connect(outP, n3);

  connect(dgen.n, nn);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a zeta converter and 
    its typical circuits, see
    http://www.ti.com/lit/an/slyt372/slyt372.pdf
    and (in German language):
    https://de.wikipedia.org/wiki/Zeta-Wandler
   */

end ZetaConverter;
