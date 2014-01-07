model BuckConverterExample
  "
  A nonideal buck converter, built of nonideal (lossy) elements.
  A constant DC input voltage and resistive load are connected
  to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.75;
  // Mostly use provided buck converter skeleton's default values:
  SMPS.BasicConverter.BuckConverter buck;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 2500);
  EL.Sources.ConstantVoltage Vg(V = 20);

equation
  connect(gnd.p, buck.inN);
  connect(Vg.n, buck.inN);
  connect(Vg.p, buck.inP);
  connect(buck.outP, load.p);
  connect(buck.outN, load.n);
  buck.d = D;

end BuckConverterExample;
