within SMPS.Transformer;

model NonidealTransformer
  "
  A nonideal single secondary winding transformer, modeling
  magnetizing current, winding resistive losses and core losses.
  "

  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real ns = 1
    "Secondary side relative winding turns";
  parameter SI.Inductance Lm = SMPS.BasicConverter.Defaults.L
    "Magnetizing inductance w.r.t. primary side [H]";
  parameter SI.Resistance Rlp = SMPS.BasicConverter.Defaults.Rl
    "Resistance of the primary winding [Ohm]";
  parameter SI.Resistance Rls = SMPS.BasicConverter.Defaults.Rl
    "Resistance od the secondary winding";
  parameter SI.Resistance Rcore = 1.e+15
    "Resistance modeling core losses [Ohm]";

  // Pin names of Modelica.Electrical.Analog.Ideal.IdealTransformer
  // are preserved:
  EL.Interfaces.PositivePin p1;
  EL.Interfaces.NegativePin n1;
  EL.Interfaces.PositivePin p2;
  EL.Interfaces.NegativePin n2;

protected
  EL.Ideal.IdealTransformer tf (n=np/ns, considerMagnetization=false);
  EL.Basic.Inductor indm (L=Lm);      // magnetizing inductor
  EL.Basic.Resistor rp (R=Rlp);       // resistance of primary winding
  EL.Basic.Resistor rs (R=Rls);       // resistance of secondary winding
  EL.Basic.Resistor rc (R=Rcore);     // core losses

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

  connect(p1, rp.p);
  connect(n1, tf.n1);
  connect(p2, rs.n);
  connect(n2, tf.n2);

end NonidealTransformer;
