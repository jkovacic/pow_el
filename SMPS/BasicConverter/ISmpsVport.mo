within SMPS.BasicConverter;

partial model ISmpsVport
  "
  An extension of SMPS.BasicConverter.ISmps with aditional input pins 
  that allow setting of the duty cycle ratio (D) via a voltage, e.g.
  output of a PID compensator.
  "
extends ISmps;

  EL.Interfaces.PositivePin vdp
    "Reference voltage - positive pin";
    
  EL.InterfacesNegativePin vdn
    "Reference voltage - negative pin";

end ISmpsVport; 
