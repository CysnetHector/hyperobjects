Class cysnet.utils.HelperRestInvoker Extends %RegisteredObject
{

// Parametros que definen el ContentType

Parameter CONTENTJSON = "application/json";

Parameter CONTENTTEXT = "application/text";

// Parametros que definen el tipo de codificación

Parameter CHARSETUTF8 = "charset=UTF-8";

// Parametros que definen los métodos de llamada

Parameter METHODGET = "Get";

Parameter METHODPOST = "Post";

Parameter METHODPUT = "Put";

Parameter METHODPATCH = "Patch";

Parameter METHODDELETE = "Delete";

// Propiedades privadas de la clase

Property URLBASE As %String [ Private ];

Property AUTH As %String [ Private ];

Property CALLMETHOD As %String [ InitialExpression = "GET", Private ];

Property CALLCONTENTTYPE As %String [ InitialExpression = "application/json", Private ];

Property CALLCHARSET As %String [ InitialExpression = "charset=UTF-8", Private ];

Property RESPONSECONTENTTYPE As %String [ Private ];

Property RESPONSECHARSET As %String [ Private ];

Property BODYCONTENT As %Stream.GlobalCharacter [ Private ];

// Listas de parametros y cabeceras

Property HEADERS As %DynamicObject [ Private ];

Property PARAMETERS As %DynamicObject [ Private ];

Property BODYFROMPARAMETERS As %Boolean [ InitialExpression = 0, Private ];

// Constructor 

Method %OnNew() As %Status
{
    set ..HEADERS = {}
    set ..PARAMETERS = {}
    Quit $$$OK
}

// Establece la URL base para luego concatenar los métodos

Method setUrlBase(url As %String)
{
    s ..URLBASE = url
}

// Establece el modo de autenticación como Basico y las credenciales

Method setBasicAuth(user As %String, pass As %String)
{
    s ..AUTH = "Basic "_$system.Encryption.Base64Encode(user_":"_pass)
}

// Establece el método de llamada

Method setCallMethod(cmethod As %String)
{
    set cmethod = $ZConvert(cmethod, "L")
    if ($ZConvert(..#METHODGET,"L")=cmethod)
    { 
        s ..CALLMETHOD = ..#METHODGET
    }
    elseif ($ZConvert(..#METHODPOST,"L")=cmethod)
    { 
        s ..CALLMETHOD = ..#METHODPOST
    }
    elseif ($ZConvert(..#METHODPUT,"L")=cmethod)
    { 
        s ..CALLMETHOD = ..#METHODPUT
    }
    elseif ($ZConvert(..#METHODPATCH,"L")=cmethod)
    { 
        s ..CALLMETHOD = ..#METHODPATCH
    }
    elseif ($ZConvert(..#METHODDELETE,"L")=cmethod)
    { 
        s ..CALLMETHOD = ..#METHODDELETE
    }
    else
    {
       Throw ##class(%Exception.General).%New("Method not allowed.")
    }
}

// Establece el ContentType para la llamada

Method setCallContentType(ctype As %String)
{
    s ..CALLCONTENTTYPE = ctype
}

// Establece el CHARSET para la llamada

Method setCallCharset(cset As %String)
{
    s ..CALLCHARSET = cset
}

// Establece cual debe ser el ContentType de la respuesta

Method setResponseContentType(ctype As %String)
{
    s ..RESPONSECONTENTTYPE = ctype
}

// Establece cual debe ser el Charset de la respuesta

Method setResponseCharset(cset As %String)
{
    s ..RESPONSECHARSET = cset
}

// Limpia los items de Headers

Method resetHeaders()
{
    set ..HEADERS = {}
}

// Añade un elemento a Headers

Method setHeader(key As %String, value As %String)
{
    do ..HEADERS.%Set(key,value)
}

// Elimina un elemento de Headers

Method removeHeader(key As %String)
{
    do ..HEADERS.%Remove(key)
}

// Verifica si existe un elemento en Headers

Method existsHeader(key As %String) As %Boolean
{
    return ..HEADERS.%IsDefined(key)
}

// Limpia los items de Parametros

Method resetParameters()
{
    set ..PARAMETERS = {}
}

// Añade un elemento a Parametros

Method setParameter(key As %String, value As %String)
{
    do ..PARAMETERS.%Set(key,value)
}

// Elimina un elemento de Parametros

Method removeParameter(key As %String)
{
    do ..PARAMETERS.%Remove(key)
}

// Verifica si existe un elemento en Parametros

Method existsParameter(key As %String) As %Boolean
{
    return ..PARAMETERS.%IsDefined(key)
}

// Añade los parametros como un stream en el body

Method setBodyContent(body As %Stream.GlobalCharacter)
{
    do ..resetParameters()
    do ..BODYCONTENT.CopyFrom(body)
}

// Crea el Body conviertiendo los parametros en JSON

Method setJSONBodyFromParameters(bfp As %Boolean)
{
    set ..BODYFROMPARAMETERS = bfp
}

// Invoca la llamada REST

Method invoke(pApiMethod As %String, Output pResponse As %String, Output pStatusCode As %Integer) As %Status
{
    // Definimos el %Status de respuesta
    set tSC = $$$OK

    // Analizamos la URLBASE para obtener los parametros de llamada
    do ##class(%Net.URLParser).Decompose(..URLBASE_"/"_pApiMethod,.urlparsed)

    // Convertimos a minuscula el protocolo "http", "https", etc.
    set urlparsed("scheme") = $ZCONVERT(urlparsed("scheme"),"L")
    
    // Construimos un HttpRequest y lo inicializamos 
    set restreq = ##class(%Net.HttpRequest).%New()
    set restreq.Https = (urlparsed("scheme")="https")
    set restreq.Server = urlparsed("host")
    if ($D(urlparsed("port"))) set restreq.Port = urlparsed("port")
    
    // Añadimos el ContentType y el Charset de llamada
    set restreq.ContentCharset = ..CALLCHARSET
    set restreq.ContentType = ..CALLCONTENTTYPE

    // Añadimos las cabeceras
    if (..AUTH'="") do restreq.SetHeader("Authorization",..AUTH)
    set iterator = ..HEADERS.%GetIterator()
    while (iterator.%GetNext(.headkey,.headvalue))
    {
        do restreq.SetHeader(headkey,headvalue)
    }

    // Convertimos los posibles parametros que vengan en la URL en parametros
    if ($D(restreq("query")))
    {
        set params = ##class(cysnet.utils.HelperParameters).convertURLParametersToJSON(restreq("query"))
        set iterator = params.%GetIterator()
        while (iterator.%GetNext(.paramName,.paramValue))
        {
            do ..setParameter(paramName,paramValue)
        }
    }

    // Hacemos llamada correspondiente
    set urlendpoint = urlparsed("path")

    // Caso que se haya indicado que genere el Body como JSON a partir de los parametros
    if (..BODYFROMPARAMETERS)
    {
        do restreq.EntityBody.Write(..PARAMETERS.%ToJSON())
    }
    else
    {
        // Si se especifica un Body, se añade a la llamada
        ;if ..BODYCONTENT'=""
        if (..BODYCONTENT.Size > 0)
        {
            ;do restreq.EntityBody.Write(..BODYCONTENT)
            do restreq.EntityBody.CopyFrom(..BODYCONTENT)
        }

        // Si hay parametros, los pasamos en la llamada tras el endpoint 
        if ..PARAMETERS.size()>0
        {
            set params = ##class(cysnet.utils.HelperParameters).convertJSONToURLParameters(..PARAMETERS)
            set urlendpoint = urlendpoint_"?"_params
        }
    }

    // Invocamos el método que corresponda
    set tSC = $METHOD(restreq,..CALLMETHOD,urlendpoint)

    // Si tras la llamada se produce error, devolvemos el error
    if $$$ISOK(tSC)
    {
        s pResponse = restreq.HttpResponse.Data.Read()
        s pStatusCode = restreq.HttpResponse.StatusCode
    }
    quit tSC
}

/*
ClassMethod test()
{
    set rest = ##class(cysnet.utils.HelperRestInvoker).%New()
    do rest.setUrlBase("http://webgateway/audit/api")
    do rest.setBasicAuth("_SYSTEM","SYS")
    do rest.setCallMethod("post")
    do rest.setBodyContent( {"param1":"valor 1", "param2":"valor2"}.%ToJSON() )
    set tSC = rest.invoke("addRecord",.out)
    
    if $$$ISOK(tSC)
    {
        Write out,!
    }
    else
    {
        Write "Error: ", $System.Status.GetErrorText(tSC), !
    }
}
*/
}
