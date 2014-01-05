within SMPS.PWM;

model DutyCycle
  "
  A PWM modulator that converts the input reference voltage
  into the duty cycle.
  
  The duty cycle D is equal to:
    D = ctrl / Vm
  "
extends DutyCycleAb;
  
  EL.Interfaces.PositivePin ctrl  
    "Reference voltage, relative to the pin n [V]";

equation
  connect(ctrl, opamp.in_p);
  
  /*
    To complete the parent model's circuit, 'ctrl' must
    be connected dirtectly to the voltage comparator's
    p pin and that's it.
   */

end DutyCycle;
