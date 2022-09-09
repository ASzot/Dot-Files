function isnumeric(x)
{
    return ( x == x+0 );
}

function name_to_number(name, predefined)
{
    if (isnumeric(name))
        return name;

    if (name in predefined)
        return predefined[name];

    return name;
}

function colour(v1, v2, v3)
{
    if (v3 == "" && v2 == "" && v1 == "")
        return;

    if (v3 == "" && v2 == "")
        return sprintf("%c[%dm", 27, name_to_number(v1, fgcolours));
    else if (v3 == "")
        return sprintf("%c[%d;%dm", 27, name_to_number(v1, bgcolours), name_to_number(v2, fgcolours));
    else
        return sprintf("%c[%d;%d;%dm", 27, name_to_number(v1, attributes), name_to_number(v2, bgcolours), name_to_number(v3, fgcolours));
}

function colour_int(num)
{
    if (num > 0){
        return sprintf("%s%3d%s", colour("Green"), num, cln)
    } else {
        # return sprintf("%3d", num)
        return sprintf("   ")
        # return sprintf("%s%3d%s", colour("Black"), num, cln)
    }
}

function colour_int_blue(num)
{
    if (num > 0){
        return sprintf("%s%3d%s", colour("Blue"), num, cln)
    } else {
        # return sprintf("%3d", num)
        return sprintf("   ")
        # return sprintf("%s%3d%s", colour("Black"), num, cln)
    }
}


function colour_int_custom(num, clr, indent)
{
    if (num > 0){
        return sprintf("%s%*d%s", clr, indent, num, cln)
    } else {
        return sprintf("%s%*d%s", cln, indent, num, cln)
    }
}

function colour_str_custom(inp_str, clr, indent)
{
    if (inp_str > 0){
        return sprintf("%s%*s%s", clr, indent, inp_str, cln)
    } else {
        return sprintf("%s%*s%s", cln, indent, inp_str, cln)
    }
}

BEGIN {
    fgcolours["None"] = 0;

    fgcolours["Black"] = 30;
    fgcolours["Red"] = 31;
    fgcolours["Green"] = 32;
    fgcolours["Yellow"] = 33;
    fgcolours["Blue"] = 34;
    fgcolours["Magenta"] = 35;
    fgcolours["Cyan"] = 36;
    fgcolours["White"] = 37;

    bgcolours["Black"] = 40;
    bgcolours["Red"] = 41;
    bgcolours["Green"] = 42;
    bgcolours["Yellow"] = 43;
    bgcolours["Blue"] = 44;
    bgcolours["Magenta"] = 45;
    bgcolours["Cyan"] = 46;
    bgcolours["White"] = 47;

    attributes["None"] = 0;
    attributes["Bold"] = 1;
    attributes["Underscore"] = 4;
    attributes["Blink"] = 5;
    attributes["ReverseVideo"] = 7;
    attributes["Concealed"] = 8;

    # hack to use attributes for just "None"
    noc = colour("None");
    red = colour("Red");
    cln = noc;
}
