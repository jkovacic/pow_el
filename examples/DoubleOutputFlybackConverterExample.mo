model DoubleOutputFlybackConverterExample

import SMPS.*;

  parameter SMPS.PWM.DutyCycleRatio D = 0.75;
  
  SMPS.BasicConverter.DoubleOutputFlybackConverter fb(np=10, ns1=3, ns2=7);
  EL.Basic.Ground gnd;
  EL.Basic.Resistor load1(R = 2500);
  EL.Basic.Resistor load2(R = 2500);
  EL.Sources.ConstantVoltage Vg(V = 10);

equation

  connect(fb.inP, Vg.p);
  connect(fb.inN, Vg.n);
  
  connect(fb.out1P, load1.p);
  connect(fb.out1N, load1.n);
  
  connect(fb.out2P, load2.p);
  connect(fb.out2N, load2.n);
  
  connect(gnd.p, fb.inN);
  connect(gnd.p, fb.out1N);
  connect(gnd.p, fb.out2N);
  
  fb.d = D;

end DoubleOutputFlybackConverterExample;
