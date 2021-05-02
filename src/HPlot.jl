#==
\/\/\Parts/\/\/
==#
include("HControl.jl")
include("HDraw.jl")
using Compose
using DataFrames

function Scatter(x::Array, y::Array; shape = Circle(.5,.5,25),
        grid = Grid(4),
        features = [Axis(:X), Axis(:Y)],
        frame=Frame(1280,720,0mm,0mm),
        )
    points = Points(x, y, frame, shape)
    frame.add(points)
    glabels = GridLabels(x,y, grid)
    frame.add(grid)
    frame.add(glabels)
    for feature in features
        frame.add(feature);
    end
    frame.add(points)
    return(frame)
end
function Scatter(x::DataFrame,
     y::Symbol, shape::Array, axiscolor=:lightblue, grid=Grid(3),
    frame=Frame(Frame(1280, 720, 0mm, 0mm))
    )
    topy = maximum(x[!, y])
    axisx = Line([(-1,-1), (-1,1), (1,1)],:blue)
   axisx_tag = axisx.update([(-1,-1), (-1,1), (1,1)])
    axisy = Line([(0,0), (0,1), (0,1)],:blue)
    axisy_tag = axisy.update([(0,0), (0,1), (0,1)])
    expression = string("compose(context()", ",", axisx_tag, axisy_tag)
    # Coordinate parsing -------
    y = x[!, y]
    counter = 0
    for col in eachcol(x, false)
        counter = counter + 1
        topx = maximum(col)
       if col !=  y
            for (i, w) in zip(col, y)
                expression = string(expression, "(context(), ")
                current_shape = shape[counter]
                inputx = (i / topx) * frame.width
                inputy = (w / topy) * frame.height
                exp = current_shape.update(inputx,inputy)
                expression = string(expression,string(exp),"),")
            end
        end
    end
    expression = string(expression,")")
    tt = transfertype(expression)
    frame.add(expression)
    return(frame)
end

mutable struct transfertype
   tag
end
@doc """Grid\n
The Grid function constructs a Grid type using percentages based on canvas sizes and divisions.\n
-------------------------------\n
======== PARAMETERS ======\n
(divisions,xlen=1280,ylen=720,colorx=:lightblue,colory=:lightblue,thickness=.2)\n
divisions:: An Int64 that determines the number of lines the grid will contain.\n
xlen:: An Int64 or Float64 representing the width of the canvas or area.\n
ylen:: An Int64 or Float64 representing the height of the canvas or area.\n
colorx:: A Hone Color symbol that will determine the color of the lines drawn on
the x axis. For more information on Hone Colors, refer to ?(HoneColors).\n
colory:: A Hone Color symbol that will determine the color of the lines drawn on
the y axis. For more information on Hone Colors, refer to ?(HoneColors).\n
thickness:: Will determine the width of each line in the grid.
--------------------------------\n
========= METHODS ========\n
Grid.show() - Shows the Grid's composition.\n
Grid.update() - Returns the Grid's Meta-tag.\n
Grid.save(URI) - Saves Grid as a Scalable Vector Graphic (SVG) File in the provided URI"""
function Grid(divisions,frame=Frame(1280,720,0mm,0mm),colorx=:lightblue,colory=:lightblue,thickness=.2)
    xlen = frame.width
    ylen = frame.height
    division_amountx = ylen / divisions
    division_amounty = xlen / divisions
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
        println(total)
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
    tag = composexp
    (var)->(update;composexp;show;save;tag;division_amountx;division_amounty;frame;divisions)
end
#--------
function _arrayline(x,y,color=:orange,weight=2,axiscolor=:lightblue,
    grid=Grid(3), frame=Frame(1280,720,0mm,0mm))
    pairs = []
    topy = maximum(y)
    topx = maximum(x)
    for (i,w) in zip(x,y)
        x = (i / topx * frame.width)
        y = (w / topy * frame.height)
        pair = Tuple([x,y])
        push!(pairs,pair)
    end
    pairs = Array{Tuple{Float64,Real},1}(pairs)
    lin = Line(pairs,color,weight)
    axisx = Line([(0,frame.height), (frame.width,frame.height)],axiscolor)
    axisy = Line([(0,0), (0,frame.height)],axiscolor)
    expression = string("(context(),",lin.update(:foo),"), (context(), ",grid.update(),
    "), (context(), ",axisx.update(:foo),axisy.update(:foo),")")
    tt = transfertype(expression)
    frame.add(tt)
    show() = frame.show()
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition);
    get_frame() = frame
    (var)->(show;composition;tree;save;get_frame)
end
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
Linear(x::Array,y::Array,shape) = _arrayline(x,y,shape)
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
@doc """GridLabels\n
GridLabels provide labels to individual lines on the grid of your plot.\n
-------------------------------\n
======== PARAMETERS ======\n
(x,y,grid)\n
x:: An Array of X coordinates OR a DataFrame containing both X's and Y's to be plotted.\n
y:: An array of corresponding Y coordinates OR a Symbol representing which DataFrame column to use as Y.\n
grid:: Takes a Hone Grid object. For more information on grids, please use ?(Grid)\n
--------------------------------\n
"""
function GridLabels(x,y,grid)
    frame = grid.frame
    divamounty = grid.division_amounty
    divamountx = grid.division_amountx
    total = divamountx
    topx = maximum(x)
    topy = maximum(y)
    xlabels = []
    while total < (divamountx * grid.divisions)
        percentage = total / frame.height
        curr_label = topy * percentage
        push!(xlabels,(curr_label, frame.height - total))
        total += divamountx
    end
    xtags = ""
    for (key,data) in xlabels
        textlabel = Label(string(round(key)), 40 , data, "", 3)
        xtags = string(xtags, textlabel.tag)
    end
    # Ys
    total = divamounty
    ylabels = []
    while total < (divamounty * grid.divisions)
        percentage = total / frame.width
        curr_label = topx * percentage
        push!(ylabels,(curr_label, frame.width - total))
        total += divamounty
    end
    ytags = ""
    for (key,data) in ylabels
        textlabel = Label(string(round(key)), frame.width - data ,frame.height - 40 , "", 3)
        ytags = string(ytags, textlabel.tag)
    end
    tag = string(xtags,ytags)
    ()->(tag;xtags;ytags)
end
function Points(x, y, frame=Frame(1280,720,0mm,0mm), shape=Circle(.5, .5, 25))
    fheight = frame.height
    fwidth = frame.width
    topx = maximum(x)
    topy = maximum(y)
   express = string("")
    # Coordinate parsing -------
    for (i, w) in zip(x, y)
        inputx = (i / topx) * fwidth
        inputy = (w / topy) * fheight
        inputy = fheight - inputy
        println(inputx)
        println(inputy)
        exp = shape.update(inputx,inputy)
        express = string(express,string(exp))
    end
    tag = express
    show() = eval(Meta.parse(string("compose(context(), ", tag,")")))
    (var)->(tag;show)
end
function Axis(orientation=:X, axiscolor = :gray, frame=Frame(1280,720,0mm,0mm),)
    if orientation == :X
        pairs = [(0,frame.height), (frame.width,frame.height)]
    else orientation == :Y
        pairs = [(0,0),(0, frame.height)]
    end
    axis = Line(pairs,axiscolor)
    tag = axis.update([pairs])
    (var)->(tag)
end
#---------------------------
