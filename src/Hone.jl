
#==
       Hone.jl
    Emmett Boudreau
    April 7th, 2020
==#
module Hone
using Compose
function Circle(x,y,diameter,fillin)
    composition = compose(context(), circle(x,y,diameter), fill(fillin))
   #     "compose(context(),circle(.5,.5,.1))
    tag = string("circle(",string(x),", ",string(y),", ",string(diameter),")")
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  string("circle(",string(x),',',string(y),',',diameter,"), ")
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
function Scatter(x,y,shape)
   topx = maximum(x)
    topy = maximum(y)
    axisx = Line([(-1,-1), (-1,1), (1,1)],:blue)
    axisx_tag = axisx.update((-1,-1), (-1,1), (1,1))
    x = [z = z / topx for z in x]
    y = [z = z / topx for z in x]
    expression = string("compose(context()", ',', axisx_tag)
    # Coordinate parsing -------
    for (i, w) in zip(x, y)
        exp = shape.update(i,w)
        expression = string(expression,string(exp))
    end
    expression = Meta.parse(string(expression))
    composition = eval(expression)
    show() = composition
    tree() = introspect(composition)
    (var)->(show;composition;tree)
end
function Line(pairs, color)
    tree() = introspect(composition)
    show() = composition
    composition = compose(context(), line(pairs), stroke(string(color)))
    pairstring = ""
    for i in pairs
        s = string(i) * ","
        pairstring = pairstring * s
    end
    update(pairs) = string("line([",string(join(pairstring)),"]), stroke(",string(color) ,")", )
    (var)->(show;composition;tree;update;color;pairs)
end
# =====================================
end
