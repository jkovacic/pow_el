model ForwardConverterExample
  "
  A nonideal forward converter, built of nonideal 
  (lossy) elements. A constant DC input voltage and resistive load
  are connected to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.25;
  // Mostly use provided forward converter skeleton's default values:
  SMPS.BasicConverter.ForwardConverter fwd(np=1, ni=2, ns=5);
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 2500);
  EL.Sources.ConstantVoltage Vg(V = 20);

equation
  connect(gnd.p, fwd.inN);
  connect(gnd.p, fwd.outN);
  connect(Vg.n, fwd.inN);
  connect(Vg.p, fwd.inP);
  connect(fwd.outP, load.p);
  connect(fwd.outN, load.n);
  fwd.d = D;

end ForwardConverterExample;
