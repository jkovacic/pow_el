within SMPS.Switch;
 
model SingleQuadrantSwitch
  "
  A single quadrant switch, conductiong positive on-state currents
  and blocking positive off-state voltages.
  
  The switch is implemented as an enhancement mode NMOSFET transistor
  with a gate driver included.
  "
extends ActiveSwitchAb;
  
  parameter SI.Resistance Ron
    "On-state resistance [Ohm]";
  parameter SI.Voltage Vgson = 2.0
    "Desired on-state gate to source voltage, necessary for the gate driver [V]";

protected
  NMosfet tr(Ron=Ron);
  GateDriver gd(Von=Vgson);

equation
  connect(p, tr.d);
  connect(n, tr.s);
  
  connect(gd.dp, ctrl);
  connect(gd.dn, gnd);
  connect(gd.tn, tr.s);
  connect(gd.gp, tr.g);
  
end SingleQuadrantSwitch;
