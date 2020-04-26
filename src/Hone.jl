
#==
       Hone.jl
    Emmett Boudreau
    April 7th, 2020
==#
module Hone
using Compose
include("HPlot.jl")
include("HDraw.jl")
# \\\\ Exports \\\\
import HPlot: Scatter
import HDraw: Circle
import HDraw: Line
export Line, Circle, Scatter

# =====================================
end
