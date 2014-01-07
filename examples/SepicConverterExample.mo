model SepicConverterExample
  "
  A nonideal SEPIC (single-ended primary-inductor converter), 
  built of nonideal (lossy) elements. A constant DC input voltage
  and resistive load are connected to the converter.
  "
import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.6;
  // Mostly use provided SEPIC skeleton's default values:
  SMPS.BasicConverter.SepicConverter sepic;
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load(R = 750);
  EL.Sources.ConstantVoltage Vg(V = 10);

equation
  connect(gnd.p, sepic.inN);
  connect(Vg.n, sepic.inN);
  connect(Vg.p, sepic.inP);
  connect(sepic.outP, load.p);
  connect(sepic.outN, load.n);
  sepic.d = D;

end SepicConverterExample;
