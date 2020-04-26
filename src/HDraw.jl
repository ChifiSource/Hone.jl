using Compose
@doc """Line\n
-------------------------------\n
The circle object creates a drawable scalable vector graphic circle.\n
Circle(x,y,diameter,fillin)\n
pairs:: NTuple[Int64/float64] Vector2s determining line position.\n
color:: Fill color, takes Julia Symbol type.\n
line_example = Line([(-1,-1), (-1,1), (1,1)],:blue)"""
function Line(pairs, color)
    tree() = introspect(composition)
    show() = composition
    composition = compose(context(), line(pairs), stroke(string(color)))
    color = string("\"",string(color),"\"")
    pairstring = ""
    for i in pairs
        s = string(i) * ","
        pairstring = pairstring * s
    end
    update(pairs) = string("line([",string(join(pairstring)),"]), stroke(", color, "),")
    (var)->(show;composition;tree;update;color;pairs)
end
@doc """Circle\n
-------------------------------\n
The circle object creates a drawable scalable vector graphic circle.\n
Circle(x,y,diameter,fillin)\n
x:: The X position of the Circle.\n
y:: The Y position of the Circle.\n
diameter:: The diameter of the circle.\n
fillin:: Fill color, takes Julia Symbol type.\n
big = Circle(.5,.5,.01,:orange)"""
function Circle(x,y,diameter,fillin)
    composition = compose(context(), circle(x,y,diameter), fill(string(fillin)))
    color = string("\"",string(fillin),"\"")
    tag = string("circle(",string(x),",",string(y),',',diameter,"), fill(", color , "),")
    println(color)
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  string("circle(",string(x),",",string(y),',',diameter,"), fill(", color , "),")
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
#---------------------------------------------------
