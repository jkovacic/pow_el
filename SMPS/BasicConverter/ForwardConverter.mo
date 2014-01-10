within SMPS.BasicConverter;

model ForwardConverter
  "
  A forward converter, built of nonideal (lossy) elements.
  Losses of a transistor, diode, winding resistance, core losses and
  magnetizing current are modeled. Optionally any lossy element can be
  set to 0. All diodes are identical.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 1) and may vary during the simulation run.
  "
extends ISmpsDport;

  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real ni = 1
    "\"Intermediate\" winding's relative winding turns";
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
  parameter SI.Inductance L = Defaults.L
    "Inductor's inductance [H]";
  parameter SI.Resistance Rl = Defaults.Rl
    "Inductor's copper resistance [Ohm]";
  parameter SI.Inductance Lm = Defaults.L
    "Magnetizing inductance w.r.t. primary side [H]";
  parameter SI.Resistance Rlp = Defaults.Rl
    "Resistance of the primary winding [Ohm]";
  parameter SI.Resistance Rlsi = Defaults.Rl
    "Resistance od the \"intermediate\" winding [Ohm]";
  parameter SI.Resistance Rls = Defaults.Rl
    "Resistance od the secondary winding [Ohm]";
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
  EL.Basic.Inductor ind (L=L);
  EL.Basic.Resistor rl (R=Rl);
  SMPS.Switch.SingleQuadrantSwitch tr (Ron=Rton);
  SMPS.Switch.Diode d1 (Vd=Vdknee, Rd=Rd);
  SMPS.Switch.Diode d2 (Vd=Vdknee, Rd=Rd);
  SMPS.Switch.Diode d3 (Vd=Vdknee, Rd=Rd);
  SMPS.PWM.DutyCycleD dgen (Vm=Vm, Von=Von, fs=fs);
  SMPS.Transformer.TwoSecWindingTransformer tf (np=np, ns1=ni, ns2=ns, Lm=Lm, Rlp=Rlp, 
                                                Rls1=Rlsi, Rls2=Rls,  Rcore=Rcore);

  // Internal nodes for more robust modeling
  EL.Interfaces.PositivePin node1;
  EL.Interfaces.PositivePin node2;
  EL.Interfaces.NegativePin noden;

equation
  assert(d<1/(1+ni/np), "Duty cycle too large");

  // Primary side:
  connect(inP, tf.inP);
  connect(tf.inP, tf.out1N);
  connect(tf.inN, tr.p);
  connect(tr.n, inN);
  connect(tf.out1P, d1.n);
  connect(d1.p, tr.n);

  // Secondary side:
  connect(outN, noden);

  connect(tf.out2N, noden);
  connect(tf.out2P, d2.p);
  connect(d2.n, node1);
  connect(node1, d3.n);
  connect(d3.p, noden);
  connect(node1, ind.p);
  connect(ind.n, rl.p);
  connect(rl.n, node2);
  connect(cap.p, node2);
  connect(cap.n, noden);
  connect(node2, outP);

  // The PWM controller is "grounded" w.r.t. primary side 
  connect(dgen.n, tr.n);
  connect(dgen.p, tr.ctrl);
  connect(tr.gnd, dgen.n);
  connect(d, dgen.d);

  /*
    For more details about a forward converter and its typical circuits, see
    http://ecee.colorado.edu/copec/book/slides/Ch6slide.pdf
    (page 43)
   */

end ForwardConverter;
