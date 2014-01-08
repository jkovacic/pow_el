model ZetaConverterExample
  "
  A nonideal zeta converter, built of nonideal (lossy) elements. 
  A constant DC input voltage and resistive load are connected
  to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6;
  // Mostly use provided zeta converter skeleton's default values:
  SMPS.BasicConverter.SepicConverter zeta;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 750);
  EL.Sources.ConstantVoltage Vg(V = 10);

equation
  connect(gnd.p, zeta.inN);
  connect(Vg.n, zeta.inN);
  connect(Vg.p, zeta.inP);
  connect(zeta.outP, load.p);
  connect(zeta.outN, load.n);
  zeta.d = D;

end ZetaConverterExample;
