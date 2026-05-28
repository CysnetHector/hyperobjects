Class cysnet.utils.HelperParameters Extends %RegisteredObject
{

/// Codifica una cadena para ser usada en una URL
ClassMethod encodeValueForURL(value As %String) As %String
{
    return $ZConvert(value, "O", "URL")
}

/// Decodifica una cadena que viene como parametro de una URL
ClassMethod decodeValueFromURL(value As %String) As %String
{
    return $ZConvert(value, "I", "URL")
}

/// Convierte una cadena de parametros de la forma: param1=value1&param2=value2...&paramN=valueN
/// a un objeto JSON
ClassMethod convertURLParametersToJSON(paramString As %String) As %DynamicObject
{
        // Crear un nuevo %DynamicObject
        Set jsonObj = ##class(%DynamicObject).%New()
        
        // Dividir la cadena en pares clave-valor usando '&' como delimitador
        Set numPairs = $Length(paramString, "&")
        For i=1:1:numPairs {
            Set pair = $Piece(paramString, "&", i)
            
            // Dividir cada par en clave y valor usando '=' como delimitador
            Set key = $Piece(pair, "=", 1)
            Set value = ..decodeValueFromURL($Piece(pair, "=", 2))
            
            // Añadir el par clave-valor al objeto JSON
            If (key'="") {
                do jsonObj.%Set(key,value)
            }
        }
        return jsonObj
}

ClassMethod convertJSONToURLParameters(params As %DynamicObject) As %String
{
    set parameters=""
    set iterator = params.%GetIterator()
    while iterator.%GetNext(.param,.value)
    {
        if (parameters'="") set parameters=parameters_"&"
        set parameters=parameters_param_"="_..encodeValueForURL(value)
    }
    return parameters
}

}
