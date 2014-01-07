model BoostConverterExample
  "
  A nonideal boost converter, built of ideal (lossless) elements.
  A constant DC input voltage and resistive load are connected
  to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6;
  // Mostly use provided boost converter skeleton's default values:
  SMPS.BasicConverter.BoostConverter boost;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 1000);
  EL.Sources.ConstantVoltage Vg(V = 5);

equation
  connect(gnd.p, boost.inN);
  connect(Vg.n, boost.inN);
  connect(Vg.p, boost.inP);
  connect(boost.outP, load.p);
  connect(boost.outN, load.n);
  boost.d = D;

end BoostConverterExample;
