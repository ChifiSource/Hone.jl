
#==
       Hone.jl
    Emmett Boudreau
    April 7th, 2020
==#
module Hone
using Compose
using Compose: mm
include("HPlot.jl")
include("HDraw.jl")
include("HControl.jl")
# \\\\ Exports \\\\
# Export mm from Compose:
export mm
export Line, Circle, Scatter, Rectangle, Grid, Frame, Linear, Text

# =====================================
end
