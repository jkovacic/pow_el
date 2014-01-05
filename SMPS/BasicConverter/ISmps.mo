within SMPS.BasicConverter;

partial model ISmps
  "
  An interface that defines four pins of typical power converters.
  
  The models, derived from this interface, do not include a voltage source
  (should be connected to inP and inN) and a load (should be connected
  to outP and outN).
  "
  
  EL.Interfaces.PositivePin inP   "Positive input pin";
  EL.Interfaces.NegativePin inN   "Negative input pin";
  EL.Interfaces.PositivePin outP  "Positive output pin";
  EL.Interfaces.NegativePin outN  "Negative output pin";
    
end ISmps;
