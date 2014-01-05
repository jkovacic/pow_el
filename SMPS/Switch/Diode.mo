within SMPS.Switch;

model Diode
  "
  A model of a typical diode with the knee voltage and
  conducting mode differential resistance.
  
  The diode can be used as a passive single quadrant switch,
  conducting positive on-state currents and blocking
  negative off-state voltages.
  
  Note: the model does not include reverse recovery losses yet,
  this will be implemented in the future.
  "
extends EL.Interfaces.TwoPin;

  parameter SI.Voltage Vd = 0.7
    "Knee voltage [V]";
  parameter SI.Resistance Rd = 100.e-3
    "Conduction  mode differential resistance [Ohm]";
  
  // Recovery losses parameters, not supported yet:
  parameter SI.ElectricCharge Qr = 0
    "Reverse recovery charge, currently ignored [As]";
  parameter SI.Time tr = 0
    "Reverse recovery time, currently ignored [s]";

protected
  EL.Ideal.IdealDiode d(Vknee=Vd, Ron=Rd);
  
equation
  /*
    Until the model is further developed to include reverse recovery losses,
    an "ideal" diode (Modelica.Electrical.analog.Ideal.IdealDiode)
    will be connected to pins 'p' and 'n'.
   */
   
  connect(p, d.p);
  connect(d.n, n);

  // TODO also model reverse recovery losses, usingQr, tr
end Diode;
