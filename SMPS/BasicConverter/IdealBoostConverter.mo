within SMPS.BasicConverter;

model IdealBoostConverter
  "
  A boost converter, built of ideal (lossless) elements.
  
  The duty cycle is set directly (as a dimensionless real number
  between 0 and 100) and is constant during the simulation run.
  "
extends ISmps;

  parameter SI.Inductance L = 100.e-3
    "Inductor's inductance [H]";
  parameter SI.Capacitance C = 1.e-5
    "Capacitor's capacitance [F]";
  parameter SMPS.PWM.DutyCycleRatio D = 0.5
    "Duty cycle";

protected
  // threshold voltage to operate the switch
  constant SI.Voltage Vth = 0.5;
  EL.Basic.Inductor ind (L=L);
  EL.Basic.Capacitor cap (C=C);
  EL.Ideal.IdealCommutingSwitch sw;
  SMPS.PWM.DutyCycleD dgen(Vm=2, Von=2, fs=100.e+3);
  EL.Basic.Resistor Rinf(R=1.e+15);
  
equation
  dgen.d = D;
  connect(inP, ind.p);
  connect(ind.n, sw.p);
  connect(sw.n2, inN);
  connect(sw.n1, cap.p);
  connect(cap.p, outP);
  connect(cap.n, outN);
  connect(cap.n, sw.n2);
  
  /*
    To prevent possible singularities and to ensure proper
    operation of the switch, the PWM is connected to a very large
    resistance and the switch depends on voltage on the resistor. 
   */
  connect(dgen.p, Rinf.p);
  connect(dgen.n, Rinf.n);
  sw.control = Rinf.v>Vth;
  connect(dgen.n, cap.n);

  /*
    For more details about a boost converter and its typical circuits, see
    https://en.wikipedia.org/wiki/Boost_converter
   */

end IdealBoostConverter; 
