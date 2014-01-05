within SMPS.Switch;

model FourQuadrantSwitch
  "
  A four quadrant switch, conducting positive or negative on-state currents
  and blocking positive or negative off-state voltages.
  
  The switch is implemented as a pair of two voltage biderectional switches,
  connected in paralel and in opposite directions. Both transistors and diodes
  are identitcal. Gate driver for the transistors are included.
  "
extends ActiveSwitchAb;

  parameter SI.Resistance Rton = 1.e-5
    "Transistors' on-state resistances [Ohm]";
  parameter SI.Voltage Vdknee = 0
    "Diodes' knee voltages [V]";
  parameter SI.Resistance Rd = 0
    "Diodes' on-state differential reistances [Ohm]";
  parameter SI.Voltage Vgson = 2.0
    "Desired transistors' on-state gate to source voltage, necessary for the gate drivers [V]";

protected
  NMosfet t1(Ron=Rton);
  NMosfet t2(Ron=Rton);
  Diode d1(Vd=Vdknee, Rd=Rd);
  Diode d2(Vd=Vdknee, Rd=Rd);
  GateDriver gd1(Von=Vgson);
  GateDriver gd2(Von=Vgson);
  
equation
  connect(p, d1.p);
  connect(d1.n, t1.d);
  connect(t1.s, n);
  
  connect(p, t2.s);
  connect(t2.d, d2.n);
  connect(d2.p, n);
  
  connect(gd1.dp, ctrl);
  connect(gd1.dn, gnd);
  connect(gd1.tn, t1.s);
  connect(gd1.gp, t1.g);
  
  connect(gd2.dp, ctrl);
  connect(gd2.dn, gnd);
  connect(gd2.tn, t2.s);
  connect(gd2.gp, t2.g);

  /*
    For more details about the schematics, see
    http://ecee.colorado.edu/copec/book/slides/Ch4slide.pdf
    the first implementation on page 23
   */
 
end FourQuadrantSwitch;
