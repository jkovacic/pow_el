model CukConverterExample
  "
  A nonideal Cuk converter, built of nonideal 
  (lossy) elements. A constant DC input voltage and resistive load
  are connected to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6;
  // Mostly use provided Cuk converter skeleton's default values:
  SMPS.BasicConverter.CukConverter cuk;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 750);
  EL.Sources.ConstantVoltage Vg(V = 10);

equation
  connect(gnd.p, cuk.inN);
  connect(Vg.n, cuk.inN);
  connect(Vg.p, cuk.inP);
  connect(cuk.outP, load.p);
  connect(cuk.outN, load.n);
  cuk.d = D;

end CukConverterExample;
