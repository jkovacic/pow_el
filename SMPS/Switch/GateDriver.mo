within SMPS.Switch;

model GateDriver
  "
  A gate driver ensures that a high switching signal is converted into
  the proper gate to source voltage, ensuring that the signal will
  actually switch the MOSFET transistor to ON or OFF state.
  
  The gate driver should be connected as follows:
    dp - PWM modulator's positive pin
    dn - PWM modualtor's negative pin
    gp - MOSFET's gate pin
    tn - MOSFET's source pin
  "
  
  EL.Interfaces.PositivePin dp  "Positive switching pin";
  EL.Interfaces.NegativePin dn  "Negative switching pin";
  EL.Interfaces.PositivePin gp  "Gate signal, relative to tn";
  EL.Interfaces.NegativePin tn  "Reference transistor's source level";
  
  parameter SI.Voltage Von = 2
    "Desired gate to source voltage [V]";

protected
  EL.Sources.ConstantVoltage Vgd(V = Von);
  // A small voltage threshold in a voltage comparator is necessary!
  SMPS.PWM.SchmittTrigger sch(Vth=0.1*Von);

equation
  connect(dp, sch.in_p);
  connect(sch.in_n, dn);
  connect(tn, sch.VMin);
  connect(tn, Vgd.n);
  connect(sch.VMax, Vgd.p);
  connect(sch.out, gp);

  /*
    The gate driver is implemented around a Schmitt trigger.
    VMin is connected to 'tn', i.e. the transistor's source level.
    A constant voltage is connected between VMin and VMax, ensuring the
    Vgs voltage level is high enough when the input signal is high.
    in_n is connected to dn.
    Finally, in_p is connected to dp.
   */

end GateDriver;
