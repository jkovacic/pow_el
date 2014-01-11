within SMPS.Transformer;

model IdealMultipleWindingTransformer
  "
  An ideal transformer with multiple windings. One winding is referred as primary
  while the other ones are referred as secondary.
  
  Magnetizing current is modeled (w.r.t. to the \"primary\" winding).
  "

  parameter Integer N = 1
    "Number of secondary windings";
  parameter Real np = 1
    "Primary side relative winding turns";
  parameter Real[N] ns = fill(1, N)
    "Array of secondary side relative winding turns";
  parameter SI.Inductance Lm1 = SMPS.BasicConverter.Defaults.L
    "Magnetizing inductance [H]";

  EL.Interfaces.PositivePin pP     "Primary winding's positive pin";
  EL.Interfaces.NegativePin pN     "Primary winding's negative pin";
  EL.Interfaces.PositivePin[N] sP  "Secondary windings' positive pins";
  EL.Interfaces.NegativePin[N] sN  "Secondary windings' negative pins";

  SI.Voltage vp      "Voltage of the primary winding";
  SI.Current ip      "Current into the primary winding";
  SI.Voltage[N] vs   "Voltages of secondary windings";
  SI.Current[N] is   "Currents into secondary windings";

protected
  SI.Current im;  // magnetizing current

equation
  vp = pP.v - pN.v;
  ip = pP.i;
  pP.i + pN.i = 0;

  for wnr in 1 : N loop
    vs[wnr] = sP[wnr].v - sN[wnr].v;
    is[wnr] = sP[wnr].i;
    sP[wnr].i + sN[wnr].i = 0;
    // secondary windings' voltage equations:
    vs[wnr] / ns[wnr] = vp / np;
  end for;

  // Modelica supports a vector dot product, that facilitates
  // the equation for transformer's sum of currents:
  (ip - im) * np + ns * is = 0;

  // The magnetizing inductance is parallel to the primary winding  
  vp = Lm1 * der(im);

end IdealMultipleWindingTransformer;
