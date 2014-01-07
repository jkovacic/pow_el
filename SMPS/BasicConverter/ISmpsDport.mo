within SMPS.BasicConverter;

partial model ISmpsDport
  "
  An extension of SMPS.BasicConverter.ISmps with an aditional input 
  port that allows direct setting of the duty cycle ratio (D).
  "
extends ISmps;

  Modelica.Blocks.Interfaces.RealInput d
    "Duty cycle as a dimensionless real number between 0 and 1";

end ISmpsDport;
