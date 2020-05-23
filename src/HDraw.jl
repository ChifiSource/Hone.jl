using Compose
@doc """Line\n
-------------------------------\n
The circle object creates a drawable scalable vector graphic circle.\n
Circle(x,y,diameter,fillin)\n
pairs:: NTuple[Int64/float64] Vector2s determining line position.\n
color:: Fill color, takes Julia Symbol type.\n
line_example = Line([(-1,-1), (-1,1), (1,1)],:blue)"""
function Line(pairs, color=:black, width=2)
    tree() = introspect(composition)
    show() = composition
    composition = compose(context(), line(pairs), stroke(string(color)))
    color = string("\"",string(color),"\"")
    pairstring = ""
    for i in pairs
        s = string(i) * ","
        pairstring = pairstring * s
    end
    update(pairs) = string("line([",string(join(pairstring)),"]), stroke(", color, "), linewidth(",width,"mm),")
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
function Circle(x,y,diameter,fillin=:orange,stroke=:black)
    composition = compose(context(), circle(x,y,diameter), fill(string(fillin)))
    color = string("\"",string(fillin),"\"")
    stroke = string("\"",string(stroke),"\"")
    tag = string("circle(",string(x),",",string(y),',',diameter,"), fill(", color , "),")
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  string("circle(",string(x),",",string(y),',',diameter,"), fill(", color ,"), stroke(",stroke, "),")
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
function Rectangle(x,y,width,height,fillin=:blue)
    composition = compose(context(), rectangle(x,y,width,height), fill(["yellow,blue"]))
    color = string("\"",string(fillin),"\"")
    tag = string("rectangle(",string(x),",",string(y),',',width,',',height, "), fill(", color , "),")
    tree() = introspect(composition)
    show() = composition
    x = x
    y = y
    update(x,y) =  string("rectangle(",string(x),",",string(y),',',width,',',height, "), fill(", color , "),")
    (var)->(show;composition;tree;tag;x;y;update;diameter)
end
function Text(label,x,y,stroke,size)
    color = string("\"",string(stroke),"\"")
    label = string("\"",string(label),"\"")
    tag = string("text(",x, ",", y, ",", label, ",hcenter, vcenter),",
        "stroke(", color,
        "), fontsize(", size, "),")
    expression = string("compose(context(), ",tag,")")
    exp = Meta.parse(expression)
    show() = eval(exp)
    update() = tag
    (var)->(show;expression;tag;exp)
end
#---------------------------------------------------
