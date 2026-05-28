Class cysnet.utils.HelperIntrospector Extends %RegisteredObject
{

// Indica si existe una clase con el nombre especificado 

ClassMethod existsClass(cname As %String) As %Boolean
{
    return (##class(%Dictionary.CompiledClass).%ExistsId(cname))
}

// Indica si existe un método para una determinada clase

ClassMethod classHasMethod(cname As %String, mname As %String) As %Boolean
{
    if ..existsClass(cname)
    {
        set classDef = ##class(%Dictionary.ClassDefinition).%OpenId(cname)
        for i=1:1:classDef.Methods.Count() 
        {
            if (classDef.Methods.GetAt(i).Name = mname) return 1
        }
    }
    return 0
}

}
