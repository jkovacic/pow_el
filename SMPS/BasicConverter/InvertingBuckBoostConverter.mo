within SMPS.BasicConverter;

model InvertingBuckBoostConverter
  "
  An inverting buck - boost converter, built of nonideal (lossy)
  elements. Losses of a transistor, diode and inductor copper are 
  modeled. Optionally any lossy element can be set to 0.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 100) and is constant during the simulation run.
  "
extends ISmps;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6
    "Duty cycle";
  parameter SI.Inductance L = 100.e-3
    "Inductor's inductance [H]";
  parameter SI.Capacitance C = 100.e-6
    "Capacitor's capacitance";
  parameter SI.Resistance RLloss = 4.e-3
    "Inductor's copper resistance [Ohm]";
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
    "PWM's high level voltage";

protected
  EL.Basic.Inductor ind (L=L);
  EL.Basic.Capacitor cap (C=C);
  SMPS.Switch.Diode d (Vd=Vdknee, Rd=Rd);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.PWM.DutyCycleD dgen(fs=fs, Vm=Vm, Von=Von);
  
equation

  connect(inP, tr.p);
  connect(tr.n, ind.p);
  connect(ind.n, inN);
  connect(ind.p, d.n);
  connect(d.p, cap.p);
  connect(cap.n, ind.n);
  connect(cap.p, outP);
  connect(cap.n, outN);
  
  connect(dgen.n, ind.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  dgen.d = D;

  /*
    For more details about an inverting buck - boost converter and 
    its typical circuits, see
    https://en.wikipedia.org/wiki/Buck%E2%80%93boost_converter
   */
end InvertingBuckBoostConverter;
