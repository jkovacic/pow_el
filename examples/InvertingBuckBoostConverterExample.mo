model InvertingBuckBoostConverterExample
  "
  A nonideal inverting buck - boost converter, built of nonideal 
  (lossy) elements. A constant DC input voltage and resistive load
  are connected to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6;
  // Mostly use provided buck boost converter skeleton's default values:
  SMPS.BasicConverter.InvertingBuckBoostConverter bbconv;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 750);
  EL.Sources.ConstantVoltage Vg(V = 10);

equation
  connect(gnd.p, bbconv.inN);
  connect(Vg.n, bbconv.inN);
  connect(Vg.p, bbconv.inP);
  connect(bbconv.outP, load.p);
  connect(bbconv.outN, load.n);
  bbconv.d = D;

end InvertingBuckBoostConverterExample;
