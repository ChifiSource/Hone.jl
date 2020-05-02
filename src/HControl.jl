using Compose
function Frame(width, height, lm, rm, tm, bm)
    base = string("compose(context(units=UnitBox(0,0,",
    width, ",",
    height, ",",
    lm, ",", rm,",",
    tm, ",", bm,
        ")),")
    objects = []
    composition = nothing
    add(objects) = composition,objects = _frameup(base,objects)
    show() = composition
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition)
    (var)->(add;show;tag;base;objects;composition;save;tree)
end
function _frameup(tag,objects)
    for object in objects
       tag = string(tag,"(context(),",object.tag, ")")
    end
    tag = string(tag,")")
    println(tag)
    exp = Meta.parse(tag)
    composition = eval(exp)
    return(composition,objects)
end
