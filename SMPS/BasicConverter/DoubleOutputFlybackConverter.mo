within SMPS.BasicConverter;

model DoubleOutputFlybackConverter
  "
  A double output flyback converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode, winding resistance,core losses and
  magnetizing current are modeled. Optionally any lossy element can be
  set to 0. All diodes are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "

  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real ns1 = 1
    "First secondary side relative winding turns";
  parameter Real ns2 = 1
    "Second secondary side relative winding turns";
  parameter SI.Resistance Rton = Defaults.Rton
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = Defaults.Vknee
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = Defaults.Rd
    "Diode's conduction mode resistance [Ohm]";
  parameter SI.Capacitance C1 = Defaults.C
    "Capacitor's capacitance [F]";
  parameter SI.Capacitance C2 = Defaults.C
    "Capacitor's capacitance [F]";
  parameter SI.Inductance Lm = Defaults.L
    "Magnetizing inductance w.r.t. primary side [H]";
  parameter SI.Resistance Rlp = Defaults.Rl
    "Resistance of the primary winding [Ohm]";
  parameter SI.Resistance Rls1 = Defaults.Rl
    "Resistance of the secondary winding";
  parameter SI.Resistance Rls2 = Defaults.Rl
    "Resistance of the secondary winding";
  parameter SI.Resistance Rcore = 1.e+15
    "Resistance modeling core losses [Ohm]";
  parameter SI.Voltage Vm = Defaults.Vm
    "PWM's sawtooth voltage amplitude [V]";
  parameter SI.Voltage Von = Defaults.Von
    "PWM's high level voltage [V]";
  parameter SI.Frequency fs = Defaults.fs
    "Switching frequency [Hz]";

  EL.Interfaces.PositivePin inP    "Positive input pin";
  EL.Interfaces.NegativePin inN    "Negative input pin";
  EL.Interfaces.PositivePin out1P  "Positive output pin";
  EL.Interfaces.NegativePin out1N  "Negative output pin";
  EL.Interfaces.PositivePin out2P  "Positive output pin";
  EL.Interfaces.NegativePin out2N  "Negative output pin";

  Modelica.Blocks.Interfaces.RealInput d
    "Duty cycle as a dimensionless real number between 0 and 1";

protected
  EL.Basic.Capacitor cap1 (C=C1);
  EL.Basic.Capacitor cap2 (C=C2);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode diode1 (Vd=Vdknee, Rd=Rd);
  SMPS.Switch.Diode diode2 (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (Vm=Vm, Von=Von, fs=fs);
  SMPS.Transformer.TwoSecWindingTransformer tf (np=np, ns1=ns1, ns2=ns2, Lm=Lm, Rlp=Rlp, 
                                                Rls1=Rls1, Rls2=Rls2, Rcore=Rcore);

  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node11;
  EL.Interfaces.NegativePin node1n;
  EL.Interfaces.PositivePin node21;
  EL.Interfaces.NegativePin node2n;

equation
  
  // Primary side:
  connect(inP, tf.inP);
  connect(tf.inN, tr.p);
  connect(tr.n, inN);

  // Secondary side:
  // - first winding:
  connect(out1N, node1n);

  connect(tf.out1P, node1n);
  connect(tf.out1N, diode1.p);
  connect(diode1.n, node11);
  connect(node11, cap1.p);
  connect(cap1.n, node1n);
  connect(out1P, node11);

  // - second winding:
  connect(out2N, node2n);

  connect(tf.out2P, node2n);
  connect(tf.out2N, diode2.p);
  connect(diode2.n, node21);
  connect(node21, cap2.p);
  connect(cap2.n, node2n);
  connect(out2P, node21);
  
  // The PWM controller is "grounded" w.r.t. primary winding 
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a flyback converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Flyback_converter
   */

end DoubleOutputFlybackConverter;
