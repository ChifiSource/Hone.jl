#==
\/\/\Parts/\/\/
==#
include("HDraw.jl")
using Compose
@doc """Scatter\n
-------------------------------\n
The Scatter function will create an object that stores meta information related to the contents of the scatterplot, and then parse coordinates and draw lines to create the plot.\n
Scatter(x,y,shape)\n
x:: An Array of X coordinates.\n
y:: An array of corresponding Y coordinates\n
shape:: Takes a Hone.jl Shape object.\n
big = Scatter(x,y,shape)"""
function Scatter(x,y,shape,debug=false)
   topx = maximum(x)
    topy = maximum(y)
    axisx = Line([(-1,-1), (-1,1), (1,1)],:blue)
   axisx_tag = axisx.update([(-1,-1), (-1,1), (1,1)])
    axisy = Line([(0,0), (0,1), (0,1)],:blue)
    axisy_tag = axisy.update([(0,0), (0,1), (0,1)])
    x = [z = z / topx for z in x]
    y = [z = z / topy for z in y]
    expression = string("compose(context()", ",", axisx_tag, axisy_tag)
    # Coordinate parsing -------
    for (i, w) in zip(x, y)
        exp = shape.update(i,w)
        expression = string(expression,string(exp))
    end
    expression = Meta.parse(string(expression,")"))
    if debug == true println(expression) end
    composition = eval(expression)
    show() = composition
    tree() = introspect(composition)
    (var)->(show;composition;tree)
end
function Grid(divisions,colorx=:lightblue,colory=:lightblue,thickness=.02)
    division_amount = 1 / divisions
    total = 0
    Xexpression = "(context(), "
    while total < 1
        total = total + division_amount
        linedraw = Line([(0,total),(1,total)],colorx,thickness)
        exp = linedraw.update(:hi)
        Xexpression = string(Xexpression,exp)
    end
    Xexpression = string(Xexpression, "),")
    total = 0
    Yexpression = ",(context(), "
    while total < 1
        total = total + division_amount
        linedraw = Line([(total,0),(total,1)],colory,thickness)
        exp = linedraw.update(:hi)
        Yexpression = string(Yexpression,exp)
    end
    Yexpression = string(Yexpression, "),")
    composexp = string("compose(context(), ",Xexpression, Yexpression,")")
    expression = Meta.parse(composexp)
    show() = eval(expression)
    (var)->(show)
end
#---------------------------
