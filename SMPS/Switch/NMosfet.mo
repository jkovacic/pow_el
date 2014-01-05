within SMPS.Switch;

model NMosfet
  "
  Enhancement mode NMOSFET transistor, modeled for typical
  switching operations, i.e. when Vgs>Vgsth, the transistor
  conducts between its drain and source.
  "
  
  EL.Interfaces.PositivePin d  "Drain";
  EL.Interfaces.NegativePin s  "Source";
  EL.Interfaces.PositivePin g  "Gate";
  
  parameter SI.Resistance Ron = 1e-5
    "Resistance between drain and source when the transistor conducts [Ohm]";
  parameter SI.Voltage Vgsth = 0.5
    "Threshold voltage between gate and source [V]";

protected
  EL.Ideal.IdealClosingSwitch sw(Ron=Ron);
  
  /* 
   To avoid possible singularities, a very high resistance resistor
   is introduced, its current is negligible.
   */
  EL.Basic.Resistor Rgs(R=1e+15);
  
equation
  connect(d, sw.p);
  connect(s, sw.n);
  connect(g, Rgs.p);
  connect(Rgs.n, s);
  sw.control = ( Rgs.v > Vgsth );
  
  /*
   When the voltage between the gate and the source exceeds the threshold
   voltage Vgsth, the transistor will conduct (with the provided resistance),
   otherwise it will not conduct.
   */
  
end NMosfet;
