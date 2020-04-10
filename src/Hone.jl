
#==
       Hone.jl
    Emmett Boudreau
    April 7th, 2020
==#
module Hone
using Compose
function Circle(x,y,diameter,fillin)
    bravo = false
    composition = compose(context(), circle(x,y,diameter), fill(fillin))
   #     "compose(context(),circle(.5,.5,.1))
    tag = string("circle(",string(x),", ",string(y),", ",string(diameter),")")
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  bravo = true;tag = string("circle(",string(x),", ",string(y),", ",diameter,")"); if bravo == true return(tag); bravo = false end
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
function Scatter(x,y,shape)
   topx = maximum(x)
    topy = maximum(y)
    x = [z = z / topx for z in x]
    y = [z = z / topx for z in x]
    expression = string("compose(context(),")
    for (i, w) in zip(x, y)
        exp = shape.update(i,w)
        expression = string(expression,string(exp))
    end
    expression = Meta.parse(string(expression, ")"))
    eval(expression)
end
# =====================================
end
