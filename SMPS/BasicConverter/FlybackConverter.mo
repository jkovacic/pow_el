within SMPS.BasicConverter;

model FlybackConverter
  "
  A single output flyback converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode, winding resistance,core losses and
  magnetizing current are modeled. Optionally any lossy element can be
  set to 0. 
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real ns = 1
    "Secondary side relative winding turns";
  parameter SI.Resistance Rton = Defaults.Rton
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = Defaults.Vknee
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = Defaults.Rd
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Capacitance C = Defaults.C
    "Capacitor's capacitance [F]";
  parameter SI.Inductance Lm = Defaults.L
    "Magnetizing inductance w.r.t. primary side [H]";
  parameter SI.Resistance Rlp = Defaults.Rl
    "Resistance of the primary winding [Ohm]";
  parameter SI.Resistance Rls = Defaults.Rl
    "Resistance od the secondary winding";
  parameter SI.Resistance Rcore = 1.e+15
    "Resistance modeling core losses [Ohm]";
  parameter SI.Voltage Vm = Defaults.Vm
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = Defaults.Von
    "PWM's high level voltage [V]";
  parameter SI.Frequency fs = Defaults.fs
    "Switching frequency [Hz]";

protected
  EL.Basic.Capacitor cap (C=C);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (Vm=Vm, Von=Von, fs=fs);
  SMPS.Transformer.NonidealTransformer tf (np=np, ns=ns, Lm=Lm, Rlp=Rlp, Rls=Rls, Rcore=Rcore);
    
  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.NegativePin noden;

equation

  // Primary side:
  connect(inP, tf.p1);
  connect(tf.n1, tr.p);
  connect(tr.n, inN);

  // Secondary side:
  connect(outN, noden);

  connect(tf.p2, noden);
  connect(tf.n2, diode.p);
  connect(diode.n, node1);
  connect(node1, cap.p);
  connect(cap.n, noden);
  connect(outP, node1);

  // The PWM controller is "grounded" w.r.t. primary side 
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a flyback converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Flyback_converter
   */

end FlybackConverter;
