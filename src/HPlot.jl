#==
\/\/\Parts/\/\/
==#
include("HControl.jl")
include("HDraw.jl")
using Compose
using DataFrames
@doc """Scatter\n
-------------------------------\n
The Scatter function will create an object that stores meta information related to the contents of the scatterplot, and then parse coordinates and draw lines to create the plot.\n
Scatter(x,y,shape)\n
x:: An Array of X coordinates.\n
y:: An array of corresponding Y coordinates\n
shape:: Takes a Hone.jl Shape object.\n
big = Scatter(x,y,shape)"""
function _arrayscatter(x,y,shape=Circle(.5,.5,25),axiscolor=:lightblue,
        debug=false, grid=Grid(4), custom="", frame=Frame(1280,720,0mm,0mm,0mm,0mm))
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
function Grid(divisions,xlen=1280,ylen=720,colorx=:lightblue,colory=:lightblue,thickness=.3)
    division_amountx = xlen / divisions
    division_amounty = ylen / divisions
    total = 0
    Xexpression = "(context(), "
    while total < xlen
        total = total + division_amountx
        linedraw = Line([(0,total),(1,total)],:lightblue,thickness)
        exp = linedraw.update(:This_symbol_means_nothing)
        Xexpression = string(Xexpression,string(exp))
    end
    Xexpression = string(Xexpression, "),")
    total = 0
    Yexpression = "(context(),"
    while total < ylen
        total = total + division_amounty
        linedraw = Line([(total,0),(total,1)],:lightblue,thickness)
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

Scatter(x::DataFrame,y::Symbol,shape::Array,debug) = _dfscatter(x,y,shape,debug)
Scatter(x::Array,y::Array,shape,debug) = _arrayscatter(x,y,shape,debug)
#---------------------------
