within SMPS.BasicConverter;

model SepicConverter
  "
  A SEPIC (single-ended primary-inductor converter), built of nonideal (lossy)
  elements. Losses of a transistor, diode and inductor copper are 
  modeled. Optionally any lossy element can be set to 0. By default
  both inductors and capacitors are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter SI.Inductance Li = Defaults.L
    "Input inductor's (L1) inductance [H]";
  parameter SI.Inductance L2 = Defaults.L
    "Second inductor's (L2) inductance [H]";
  parameter SI.Capacitance C1 = Defaults.C
    "First capacitor's capacitance [F]";
  parameter SI.Capacitance Co = Defaults.C
    "Output capacitor's capacitance [F]";
  parameter SI.Resistance RLlossi = Defaults.Rl
    "Input inductor's copper resistance [Ohm]";
  parameter SI.Resistance RLloss2 = RLlossi
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
  EL.Basic.Inductor indi (L=Li);
  EL.Basic.Inductor ind2 (L=L2);
  EL.Basic.Capacitor cap1 (C=C1);
  EL.Basic.Capacitor capo (C=Co);
  EL.Basic.Resistor RLi (R=RLlossi);
  EL.Basic.Resistor RL2 (R=RLloss2);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (fs=fs, Vm=Vm, Von=Von);
  
equation

  connect(inP, indi.p);
  connect(indi.n, RLi.p);
  connect(RLi.n, tr.p);
  connect(tr.n, inN);
  connect(tr.p, cap1.p);
  connect(cap1.n, ind2.p);
  connect(ind2.n, RL2.p);
  connect(RL2.n, tr.n);
  connect(ind2.p, diode.p);
  connect(diode.n, capo.p);
  connect(capo.n, RL2.n);
  connect(capo.p, outP);
  connect(capo.n, outN);
  
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);
  
  /*
    For more details about a SEPIC converter and 
    its typical circuits, see
    https://en.wikipedia.org/wiki/Single-ended_primary-inductor_converter
   */

end SepicConverter;
