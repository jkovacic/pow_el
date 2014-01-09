within SMPS.BasicConverter;

model FlybackConverter
  "
  A single output flyback converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode, winding resistance and core losses are modeled.
  Optionally any lossy element can be set to 0. 
  
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
  EL.Ideal.IdealTransformer tf (n=np/ns, considerMagnetization=false);
  EL.Basic.Inductor indm (L=Lm);      // magnetizing inductor
  EL.Basic.Resistor rp (R=Rlp);       // resistance of primary winding
  EL.Basic.Resistor rs (R=Rls);       // resistance of secondary winding
  EL.Basic.Resistor rc (R=Rcore);     // core losses
  
  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.NegativePin noden;

equation

  /*
    The provided model of an ideal transformer does not
    consider all desired losses. Hence an ideal transformer will
    be applied, magnetizing inductor and loss resistors will
    be connected to it as necessary
   */

  connect(indm.p, tf.p1);
  connect(indm.n, tf.n1);
  connect(tf.p1, rc.p);
  connect(tf.n1, rc.n);

  connect(rp.n, tf.p1);
  connect(rs.p, tf.p2);

  // Primary side:
  connect(inP, rp.p);
  connect(tf.n1, tr.p);
  connect(tr.n, inN);

  // Secondary side:
  connect(outN, noden);

  connect(rs.n, noden);
  connect(tf.n2, diode.p);
  connect(diode.n, node1);
  connect(node1, cap.p);
  connect(cap.n, noden);
  connect(outP, node1);

  // The PWM controller is "grounded" w.r.t. secondary side 
  connect(dgen.n, noden);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a buck converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Flyback_converter
   */

end FlybackConverter;
