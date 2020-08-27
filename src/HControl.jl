using Compose
function Frame(width, height, lm, rm, tm, bm)
    base = string("compose(context(units=UnitBox(0,0,",
    width, ",",
    height, ",",
    lm, ",", rm,",",
    tm, ",", bm,
        ")),")
    objects = []
    tag = base
    composition = nothing
    add(object) = composition,objects,tag = _frameup(base,objects,object)
    show() = composition
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition)
    (var)->(add;show;tag;base;objects;composition;save;tree;width;height;lm;bm;rm;tm)
end
function _frameup(tag,objects,object)
    push!(objects, object.tag)
    objecttags = ""
    for o in objects
       objecttags = string(objecttags,"(context(),",o, "),")
    end
    tag = string(tag,objecttags,")")
    exp = Meta.parse(tag)
    println(exp)
    composition = eval(exp)
    return(composition,objects,tag)
end
function Container(width, height, lm, rm)
    tag = string("context(units=UnitBox(0,0,",
    width, ",",
    height, ",",
    0px, ",", 0px,",",
    0px, ",", 0px,
        ")),")
    objects = []
    composition = nothing
    add(object) = composition,objects,tag = _containerup(tag,objects,object)
    show() = composition
    tree() = introspect(composition)
    save(name) = draw(SVG(name), composition)
    (var) -> (add;show;base;objects;composition;save;tree;width;height;lm;rm;tag)
end
function _containerup(tag,objects,object)
    if typeof(object.tag) == Core.Box
        tagger = Core.getfield(object.tag, :contents)::Any
    else
        tagger = object.tag
    end
    push!(objects, object.tag)
    objecttags = ""
    for o in objects
       objecttags = string(objecttags,"(context(),",o, "),")
    end
    tag = string(tag,objecttags,"")
    println(tag)
    return(tag,objects,tag)
end
