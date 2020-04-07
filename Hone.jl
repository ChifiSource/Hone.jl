using Compose
tree(b) = introspect(b.composition)

function Figure()

end
function textbox(value)
    composition = compose(context(), text(0.5, 0.5,value))
    show() = composition
    (test)->(show;composition)
end
function Circle(diameter,x,y,fillin)
    composition = compose(context(), circle(x,y,diameter), fill(fillin))
    show() = composition
    (test)->(show;composition)
end
