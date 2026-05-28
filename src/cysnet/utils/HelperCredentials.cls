Class cysnet.utils.HelperCredentials Extends %RegisteredObject
{

ClassMethod getValues(credentialname As %String, Output user, Output password) As %Status
{
    // Obtener el objeto de credenciales por el nombre proporcionado
    Set credObj = ##class(Ens.Config.Credentials).%OpenId(credentialname)

    If credObj = "" {
        Quit $$$ERROR("Credentials not found. ")
    }

    // Extraer el usuario y la clave
    Set user = credObj.Username
    Set password = credObj.Password

    Quit $$$OK
}

}
