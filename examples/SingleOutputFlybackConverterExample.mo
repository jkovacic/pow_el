model SingleOutputFlybackConverterExample
  "
  A nonideal single output flyback converter, built of nonideal 
  (lossy) elements. A constant DC input voltage and resistive load
  are connected to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.75;
  // Mostly use provided flyback converter skeleton's default values:
  SMPS.BasicConverter.FlybackConverter fb(np=3, ns=10);
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 2500);
  EL.Sources.ConstantVoltage Vg(V = 20);

equation
  connect(gnd.p, fb.inN);
  connect(gnd.p, fb.outN);
  connect(Vg.n, fb.inN);
  connect(Vg.p, fb.inP);
  connect(fb.outP, load.p);
  connect(fb.outN, load.n);
  fb.d = D;

end SingleOutputFlybackConverterExample;
