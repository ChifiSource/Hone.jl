#==
\/\/\Parts/\/\/
==#
include("HControl.jl")
include("HDraw.jl")
using Compose
using DataFrames

function _arrayscatter(x,y,shape=Circle(.5,.5,25),axiscolor=:lightblue,
        debug=false, grid=Grid(3), custom="", frame=Frame(1280,720,0mm,0mm,0mm,0mm))
   topx = maximum(x)
    topy = maximum(y)
    axisx = Line([(0,frame.height), (frame.width,frame.height)],axiscolor)
   axisx_tag = axisx.update([(-1,-1), (-1,1), (1,1)])
    axisy = Line([(0,0), (0,frame.height)],axiscolor)
    axisy_tag = axisy.update([(0,0), (0,1), (0,1)])
    grid_tag = grid.update()
    ######
    ######
    fullcustom = ""
    if custom != ""
        [custom = string(fullcustom, i) for i in custom]
    end
    expression = string("")
    # Coordinate parsing -------
    for (i, w) in zip(x, y)
        inputx = (i / topx) * frame.width
        inputy = (w / topy) * frame.height
        exp = shape.update(inputx,inputy)
        expression = string(expression,string(exp))
    end
    expression = string(expression, "(context(),", axisx_tag,grid_tag,custom, axisy_tag,"),")
    tt = transfertype(expression)
    frame.add([tt])
    if debug == true println(expression) end
    composition = eval(expression)
    show() = frame.show()
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition);
    get_frame() = frame
    (var)->(show;composition;tree;save;get_frame)
end
mutable struct transfertype
   tag
end
function Grid(divisions,xlen=1280,ylen=720,colorx=:lightblue,colory=:lightblue,thickness=.2)
    division_amountx = xlen / divisions
    division_amounty = ylen / divisions
    total = 0
    Xexpression = "(context(), "
    while total < xlen
        total = total + division_amountx
        linedraw = Line([(0,total),(xlen,total)],:lightblue,thickness)
        exp = linedraw.update(:This_symbol_means_nothing)
        Xexpression = string(Xexpression,string(exp))
    end
    Xexpression = string(Xexpression, "),")
    total = 0
    Yexpression = "(context(),"
    while total < ylen
        total = total + division_amounty
        linedraw = Line([(total,0),(total,ylen)],:lightblue,thickness)
        exp = linedraw.update(:hi)
        Yexpression = string(Yexpression,string(exp))
    end
    composexp = string(string(Xexpression), string(Yexpression),"),")
    vv = Meta.parse(string("compose(context(),",composexp,")"))
    composition = eval(vv)
    save(name) = draw(SVG(name), composition);
    update() = string(composexp)
    show() = composition
    tag() = composexp
    (var)->(update;composexp;show;save;tag)
end
function _dfscatter(x,y,shape,debug=false)
    topy = maximum(x[y])
    axisx = Line([(-1,-1), (-1,1), (1,1)],:blue)
   axisx_tag = axisx.update([(-1,-1), (-1,1), (1,1)])
    axisy = Line([(0,0), (0,1), (0,1)],:blue)
    axisy_tag = axisy.update([(0,0), (0,1), (0,1)])
    expression = string("compose(context()", ",", axisx_tag, axisy_tag)
    # Coordinate parsing -------
    y = x[y]
    counter = 0
    for col in eachcol(x, false)
        counter = counter + 1
        topx = maximum(col)
       if col !=  y
            for (i, w) in zip(col, y)
                expression = string(expression, "(context(), ")
                current_shape = shape[counter]
                inputx = i / topx
                inputy = w / topy
                exp = current_shape.update(inputx,inputy)
                expression = string(expression,string(exp),"),")
            end
        end
    end
    expression = Meta.parse(string(expression,")"))
    if debug == true println(expression) end
    composition = eval(expression)
    show() = composition
    tree() = introspect(composition)
    (var)->(show;composition;tree)
end
function _arrayline(x,y,color=:orange,weight=50,axiscolor=:lightblue,
    grid=Grid(3), custom="", frame=Frame(1280,720,0mm,0mm,0mm,0mm))
    pairs = []
    topy = maximum(y)
    topx = maximum(x)
    for (i,w) in zip(x,y)
        push!(pairs,[(i * topx / frame.width)=>(w * topy / frame.height)])
    end
    lin = Line(pairs,color,weight)
    expression = string("(context(),",lin.update(:foo),")")
    tt = transfertype(expression)
    frame.add([tt])
    show() = frame.show()
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition);
    get_frame() = frame
    (var)->(show;composition;tree;save;get_frame)
end
function _dfline(x,y,shape)

end
    @doc """Scatter\n
    The Scatter function takes either a DataFrame and Symbol OR two Arrays and returns
         a Hone scatter plot object.\n
    -------------------------------\n
    ======== PARAMETERS ======
    (x,y,shape=Circle(.5,.5,25),axiscolor=:lightblue,debug=false, grid=Grid(3), custom="", frame=Frame(1280,720,0mm,0mm,0mm,0mm)\n
    x:: An Array of X coordinates OR a DataFrame containing both X's and Y's to be plotted.\n
    y:: An array of corresponding Y coordinates OR a Symbol representing which DataFrame column to use as Y.\n
    shape:: Takes a Hone.jl Shape object OR an iterable list of shapes with the same length as the number of X's
    in the provided DataFrame, or X\n
    axiscolor:: Symbol representing the color of both the X and Y axis's. For more information on available colors, please
    use ?(HoneColors)\n
    debug:: Boolean that determines whether or not the function will print the meta expression on creation.\n
    grid:: Takes a Hone Grid object. For more information on grids, please use ?(Grid)\n
    custom:: Custom takes a meta expression (as a an unparsed string), and can be used to add customizable features
     to a plot.\n
     frame:: Takes a Hone Frame object. For more information on Frames, please use ?(Frame)\n
    --------------------------------\n
    ========= METHODS ========
    Line.show() - Displays the frame which contains the plot's composition.\n
    Line.tree() - Shows an introspection of contexts contained in the plot's composition.\n
    Line.save(URI) - Saves the plot as a Scalable Vector Graphic (SVG) file at the given URI.\n
    Line.get_frame() - Returns the frame which contains the plot as a child object."""
Scatter(x::DataFrame,y::Symbol,shape::Array,debug) = _dfscatter(x,y,shape,debug)
Scatter(x::Array,y::Array,shape,debug) = _arrayscatter(x,y,shape,debug)
@doc """Line\n
The Line function takes either a DataFrame and Symbol OR two Arrays and returns
     a Hone line plot object.\n
-------------------------------\n
======== PARAMETERS ======\n
(x,y,shape=Circle(.5,.5,25),axiscolor=:lightblue,debug=false, grid=Grid(3), custom="", frame=Frame(1280,720,0mm,0mm,0mm,0mm)\n
x:: An Array of X coordinates OR a DataFrame containing both X's and Y's to be plotted.\n
y:: An array of corresponding Y coordinates OR a Symbol representing which DataFrame column to use as Y.\n
shape:: Takes a Hone.jl Shape object OR an iterable list of shapes with the same length as the number of X's
in the provided DataFrame, or X\n
axiscolor:: Symbol representing the color of both the X and Y axis's. For more information on available colors, please
use ?(HoneColors)\n
debug:: Boolean that determines whether or not the function will print the meta expression on creation.\n
grid:: Takes a Hone Grid object. For more information on grids, please use ?(Grid)\n
custom:: Custom takes a meta expression (as a an unparsed string), and can be used to add customizable features
 to a plot.\n
 frame:: Takes a Hone Frame object. For more information on Frames, please use ?(Frame)\n
--------------------------------\n
========= METHODS ========\n
Line.show() - Displays the frame which contains the plot's composition.\n
Line.tree() - Shows an introspection of contexts contained in the plot's composition.\n
Line.save(URI) - Saves the plot as a Scalable Vector Graphic (SVG) file at the given URI.\n
Line.get_frame() - Returns the frame which contains the plot as a child object."""
Line(x::Array,y::Array,shape) = _arrayline(x,y,shape)
Line(x::DataFrame,y::Symbol,shape) = _dfline(x,y,shape)
@doc """Colors\n
You can use HoneColors(color) to view a color.\n
color:: Symbol used to represent the desired color.\n
----------------------------------------------\n
========== COLORS ============\n
:blue, :green, :lightblue, :pink, :orange, :red, :black, :gray, :white, :yellow,
 :purple, :magenta, :lime
"""
function HoneColors(color)
    d = Circle(.5,.5,.5,color)
    d.show()
end
#---------------------------
