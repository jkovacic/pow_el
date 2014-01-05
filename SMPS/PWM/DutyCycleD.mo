within SMPS.PWM;

model DutyCycleD
  "
  A PWM modulator that implements the given duty cycle,
  i.e., 100*d percent of the switching period, the output
  signal is high, th remaining 100*(d-1) percent of the
  switching period, the output signal is low.
  "
extends DutyCycleAb;

  Modelica.Blocks.Interfaces.RealInput d
    "Duty cycle as a dimensionless value between 0 and 1";

protected
  EL.Sources.SignalVoltage Vref;

equation
  Vref.v = d * Vm;
  connect(Vref.p, opamp.in_p);
  connect(Vref.n, n);
  
  /*
    To complete the parent model's circuit, a variable voltage 
    source is connected between the pin n and the voltage 
    comparator's pin p.
   */

end DutyCycleD;
