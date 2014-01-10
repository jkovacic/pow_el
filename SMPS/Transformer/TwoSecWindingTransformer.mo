within SMPS.Transformer;

model TwoSecWindingTransformer
  "
  A nonideal three winding transformer, one winding is referred as \"primary\",
  the other two as \"secondary\".
  
  Additionally windings' resistances and core losses are modeled.
  Optionally any lossy elements can be set to 0.
  "

  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real ns1 = 1
    "First secondary side relative winding turns";
  parameter Real ns2 = 1
    "Second secondary side relative winding turns";
  parameter SI.Inductance Lm = SMPS.BasicConverter.Defaults.L
    "Magnetizing inductance w.r.t. primary side [H]";
  parameter SI.Resistance Rcore = 1.e+15
    "Resistance modeling core losses w.r.t. primary side [Ohm]";
  parameter SI.Resistance Rlp = SMPS.BasicConverter.Defaults.Rl
    "Resistance of the primary winding [Ohm]";
  parameter SI.Resistance Rls1 = SMPS.BasicConverter.Defaults.Rl
    "Resistance od the first secondary winding";
  parameter SI.Resistance Rls2 = SMPS.BasicConverter.Defaults.Rl
    "Resistance od the second secondary winding";

  EL.Interfaces.PositivePin inP
    "Positive input pin";
  EL.Interfaces.NegativePin inN
    "Negative input pin";
  EL.Interfaces.PositivePin out1P
    "Positive first output pin";
  EL.Interfaces.NegativePin out1N
    "Negative first output pin";
  EL.Interfaces.PositivePin out2P
    "Positive second output pin";
  EL.Interfaces.NegativePin out2N
    "Negative second output pin";

protected

  IdealMultipleWindingTransformer tf (N=2, np=np, ns={ns1, ns2}, Lm1=Lm);
  EL.Basic.Resistor rc (R=Rcore);
  EL.Basic.Resistor rp (R=Rlp);
  EL.Basic.Resistor rs1 (R=Rls1);
  EL.Basic.Resistor rs2 (R=Rls2);

equation

  // A resistor modeling cre losses is parallel to the primary side:
  connect(tf.pP, rc.p);
  connect(tf.pN, rc.n);

  // Connect windings' resistances to their positive pins:
  connect(tf.pP, rp.n);
  connect(tf.sP[1], rs1.p);
  connect(tf.sP[2], rs2.p);

  // Finally connect the model's pins:
  connect(inP, rp.p);
  connect(inN, tf.pN);
  connect(out1P, rs1.n);
  connect(out1N, tf.sN[1]);
  connect(out2P, rs2.n);
  connect(out2N, tf.sN[2]);

end TwoSecWindingTransformer;
