within SMPS.Switch;

model CurrentBidirectionalSwitch
  "
  A current bidirectional two quadrant switch, conducting positive
  or negative on-state currents and blocking positive off-state voltages.
  
  The switch is implemented using an enhancement mode NMOSFET transistor
  and a diode, connected in parallel. A gate driver for the transistor 
  is included.
  "
extends ActiveSwitchAb;

  parameter SI.Resistance Rton = 1.e-5
    "Transistor's on-state resistance [Ohm]";
  parameter SI.Voltage Vdknee = 0
    "Diode's knee voltage [V]";
  parameter SI.Resistance Rd = 0
    "Diode's on-state differential reistance [Ohm]";
  parameter SI.Voltage Vgson = 2.0
    "Desired transistor's on-state gate to source voltage, necessary for the gate driver [V]";

protected
  NMosfet t(Ron=Rton);
  Diode d(Vd=Vdknee, Rd=Rd);
  GateDriver gd(Von=Vgson);
  
equation
  connect(p, t.d);
  connect(n, t.s);
  connect(t.p, d.n);
  connect(t.n, d.p);
  
  connect(gd.dp, ctrl);
  connect(gd.dn, gnd);
  connect(gd.tn, t.s);
  connect(gd.gp, t.g);
  
  /*
    For more details about the schematics, see
    http://ecee.colorado.edu/copec/book/slides/Ch4slide.pdf
    pp. 12-13
   */

end CurrentBidirectionalSwitch;
