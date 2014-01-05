within SMPS.Switch;

partial model ActiveSwitchAb
  "
  An abstract model that defines pins, common to all
  active switches, derived from this model.
  
  Typically 'ctrl', relative to 'gnd', will determine
  whether the connection between 'p' and 'n' is opened 
  or closed. Current from/to 'ctrl' will typically be 
  negligible. 
  "
  
  EL.Interfaces.PositivePin p       "Positive pin";
  EL.Interfaces.NegativePin n       "Negative pin";
  EL.Interfaces.PositivePin ctrl    "Switch control pin";
  EL.Interfaces.NegativePin gnd     
    "
    Reference voltage for switching, necessary for proper operation of
    gate driving circuits. Typically it should be connected to PWM's 'n' pin.
    ";
  
  SI.Voltage v
    "Voltage between 'p' and 'v' [V]";
  SI.Current i
    "Current from 'p' to 'n' [A]";
  
equation
  // Typical OnePort's equation for 'p' and 'n':
  v = p.v - n.v;
  i = p.i;
  
  /* 
    V and I equations for 'ctrl' will be defined by each
    derived model.
   */

end ActiveSwitchAb;
