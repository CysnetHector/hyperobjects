Class cysnet.utils.HelperGlobals Extends %RegisteredObject
{

/*
    Indica si existe un global cuyo nombre se pasa como parámetro
*/
ClassMethod existsGlobal(gname As %String) As %Boolean
{
    return $D(@gname)>0
}

/*
    Indica si existe un global cuyo nombre se pasa como parámetro y la clave indicada
*/
ClassMethod existsGlobalKey(gname As %String, keys...) As %Boolean
{
    if (keys>0)
    {
        set fullgname = gname_"("_..generateIndex(0,keys...)_")"
        return $D(@fullgname)>0
    }
    return 0
}

ClassMethod getFirstIndex(gname As %String)
{
    set gname = gname _ "("""")"
    return $Order(@gname)
}

/// Método que proporciona el index de un nodo del global:
/// - ^global(""): primer nodo del global
/// - ^global("a",""): primer nodo del nodo "a"
/// - ^global("a","b"): siguente nodo del nodo "a"
ClassMethod getIndex(gname As %String, direction As %Integer(DISPLAYLIST=",1,-1",VALUELIST=",1,-1"), keys...)
{
    set fullgname = gname
    set fullgname = fullgname_"("_..generateIndex(0,keys...)_")" 
    return $Order(@fullgname, direction)
}

/*
    Establece un valor en un global cuyo nombre se indica como primer argumento
    Luego se indican las claves del global, como argumentos separados por coma
    El último argumento indicado se asume como valor de la clave previa.
*/
ClassMethod setGlobalValue(gname As %String, args...)
{
   // Formamos el nombre completo del global
    set fullgname = gname

    if (args>1)
    {
        set fullgname = fullgname_"("_..generateIndex(args-1,args...)_")"
    } 
    s @fullgname=args(args)
}

/*
    Devuelve el valor de un global cuyo nombre es indicado como primer argumento
    y la clave del elemento indicaca por el resto de argumentos.
*/
ClassMethod getGlobalValue(gname As %String, keys...)
{
    // Formamos el nombre completo del global
    set fullgname = gname
    if ($get(keys(1), "")'="") {
        set fullgname = fullgname_"("_..generateIndex(0,keys...)_")"
    }
    return @fullgname
}

/*
    Elimina un global completo a partir de su nombre
*/
ClassMethod removeGlobal(gname As %String)
{
    if ..existsGlobal(gname)
    {
        kill @gname
    }
}

/*
    Elimina un elemento de un global a partir de su nombre y su indice
*/
ClassMethod removeGlobalValue(gname As %String, keys...)
{
    set index = ..generateIndex(0,keys...)
    set gname = gname_"("_index_")"
    if ..existsGlobal(gname)
    {
        kill @gname
    }
}

/*
    Método privado que devuelve una cadena que representa una clave de indexación
*/
ClassMethod generateIndex(count, args...) As %String [ Private ]
{
    set index = ""
    if (count=0) || (count>args) set count = (args)
    if (count>0)
    {
        // Genera el indice por concatenación
        For i=1:1:count
        {
            set index = index_""""_args(i)_""""
            if (i<count) set index = index_","
        }
    }
    return index
}

}
