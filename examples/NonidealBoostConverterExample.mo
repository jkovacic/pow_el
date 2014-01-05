model NonidealBoostConverterExample
  "
  An ideal boost converter, built of ideal (lossless) elements.
  A constant DC input voltage and resistive load are connected
  to the converter.
  "
import SMPS.*;

  // Mostly use provided boost converter skeleton's default values:
  SMPS.BasicConverter.NonIdealBoostConverter boost(D = 0.6);
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 1000);
  EL.Sources.ConstantVoltage Vg(V = 5);

equation
  connect(gnd.p, boost.inN);
  connect(Vg.n, boost.inN);
  connect(Vg.p, boost.inP);
  connect(boost.outP, load.p);
  connect(boost.outN, load.n);

end NonidealBoostConverterExample;
