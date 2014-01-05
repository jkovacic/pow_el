within SMPS.PWM;

model SchmittTrigger
  "
  As the model of an ideal limited operational amplifier 
  is not suitable to build a Schmitt trigger, a specialized
  model is provided. Its pin layout is eaxactly the same as at the
  Modelica.Electrical.Analog.Ideal.IdealOpAmpLimited.
  "
  
  EL.Interfaces.PositivePin in_p   "Positive pin of the input port";
  EL.Interfaces.NegativePin in_n   "Negative pin of the input port";
  EL.Interfaces.PositivePin VMax   "Positive output voltage limitation";
  EL.Interfaces.NegativePin VMin   "Negative output voltage limitation";
  EL.Interfaces.PositivePin out    "Output pin";

  parameter SI.Voltage Vth = 0
    "
    Internal comparison threshold, recommended to be a bit more than zero 
    when inputs are digital signals [V]
    ";

equation
  // All input impedances are very high, hence input currents equal 0
  
  in_p.i = 0;
  in_n.i = 0;
  
  VMax.i = 0;
  VMin.i = 0;

  // Output is realized as a simple voltage comparison function:
  out.v = (if (in_p.v-in_n.v)>Vth then VMax.v else VMin.v);
  
end SchmittTrigger;
