within SMPS.PWM;

partial model DutyCycleAb
  "
  An abstract model with a common circuit for all
  implementations of a duty cycle controller.
  Derived models must provide additional pins and
  additional building blocks that handle either the
  reference voltage or duty cycle directly.  
  "

  parameter SI.Voltage Vm = 2
    "Amplitude voltage of the internal sawtooth voltage generator [V]";

  parameter SI.Voltage Von = 2
    "Output on-voltage [V]";
 
  parameter SI.Frequency fs = 100.e+3
    "Switching frequency of the modulator [Hz]";
 
  EL.Interfaces.PositivePin p  "Positive output pin";
  EL.Interfaces.NegativePin n  "Negative output pin";

protected
  EL.Sources.SawToothVoltage Vgs(V=Vm, period=1/fs);
  SchmittTrigger opamp;
  EL.Sources.ConstantVoltage Vmax(V = Von);
  
equation
  connect(n, Vgs.n);
  connect(n, Vmax.n);
  connect(Vmax.p, opamp.VMax);
  connect(n, opamp.VMin);
  connect(Vgs.p, opamp.in_n);
  connect(p, opamp.out);

  /*
    The pulse - width modulator is built consists of a voltage comparator
    (implemneted as a Schmitt trigger) that compares a reference 
    voltage and the output of an internal saw-tooth voltage generator.
    Whenever the reference voltage is greater than the saw - tooth 
    voltage, voltage at the pin p is set to the high level (Von relative 
    to the pin n.), otherwise the voltage of the pin p equals the pin n.
    Reference voltage must be additionally implemented by derived models.
    
    Note that Vm strongly influences dynamics of a small signal AC model.
    
    For more details and the schematics, see
    http://ecee.colorado.edu/copec/book/slides/Ch7slide.pdf
    from page 138.
   */
 
end DutyCycleAb;
