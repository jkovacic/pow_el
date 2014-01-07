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
extends ISmps;

  parameter SI.Inductance L1 = 100.e-3
    "Input inductor's (L1) inductance [H]";
  parameter SI.Inductance L2 = L1
    "Output inductor's (L2) inductance [H]";
  parameter SI.Capacitance C1 = 100.e-6
    "First capacitor's capacitance [F]";
  parameter SI.Capacitance Co = C1
    "Output capacitor's capacitance [F]";
  parameter SI.Resistance RLloss1 = 4.e-3
    "Input inductor's copper resistance [Ohm]";
  parameter SI.Resistance RLloss2 = RLloss1
    "Output inductor's copper resistance [Ohm]";
  parameter SI.Resistance Rton = 1.6e-3
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = 0.7
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = 0
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Frequency fs = 75.e+3
    "Switching frequency [Hz]";
  parameter SI.Voltage Vm = 2.0
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = 2.0
    "PWM's high level voltage [V]";

  Modelica.Blocks.Interfaces.RealInput d
    "Duty cycle";
    
protected
  EL.Basic.Inductor ind1 (L=L1);
  EL.Basic.Inductor ind2 (L=L2);
  EL.Basic.Capacitor cap1 (C=C1);
  EL.Basic.Capacitor capo (C=Co);
  EL.Basic.Resistor RL1 (R=RLloss1);
  EL.Basic.Resistor RL2 (R=RLloss2);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (fs=fs, Vm=Vm, Von=Von);
  
equation

  connect(inP, ind1.p);
  connect(ind1.n, RL1.p);
  connect(RL1.n, tr.p);
  connect(tr.n, inN);
  connect(tr.p, cap1.p);
  connect(cap1.n, diode.p);
  connect(diode.n, tr.n);
  connect(diode.p, ind2.p);
  connect(ind2.n, RL2.p);
  connect(RL2.n, capo.p);
  connect(capo.n, diode.n);
  connect(capo.p, outP);
  connect(capo.n, outN);
  
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);
  
  /*
    For more details about a Cuk converter and 
    its typical circuits, see
    https://en.wikipedia.org/wiki/%C4%86uk_converter
   */

end CukConverter;
