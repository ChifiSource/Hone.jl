module HDraw
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
    composition = compose(context(), circle(x,y,diameter), fill(string(fillin))
    tag = string("circle(",string(x),", ",string(y),", ",string(diameter),"fill(string(","))")
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  string("circle(",string(x),",",string(y),',',diameter,",fill(string(",Symbol(fillin),")))")
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
#---------------------------------------------------
end
