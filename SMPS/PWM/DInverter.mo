within SMPS.PWM;

model DInverter
  "
  Inverts the PWM's output from high level to low and vice versa.
  This block is useful when designing inverter circuits.
  "
  
  parameter SI.Voltage Von = 2
    "High level voltage [V]";
  parameter SI.Voltage Vth = 0.5*Von
    "Threshold of the internal comparator, typically should not be modified [V]";
  
  EL.Interfaces.PositivePin in_p  "Positive input pin";
  EL.Interfaces.NegativePin n     "Negative input pin";
  EL.Interfaces.PositivePin out   "Output pin, its voltage is relative to 'n'";
  
protected
  EL.Voltage vin;
  
equation
  vin = in_p.v - n.v; 
  out.v = ( if vin>Vth then n.v else n.v+Von);
  
  /*
    Instead of using a Schmitt trigger, a simple equation is used.
    When the input level is high, the output's level is equal to the pin n,
    when the input level is low, the output's voltage level is high.
  */
  
end DInverter;
