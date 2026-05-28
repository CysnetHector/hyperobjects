Class cysnet.openEmr.bo.OpenEmr Extends cysnet.rest.bo.RestManager
{

Parameter SETTINGS = "OauthUser:Basic:credentialsSelector,ClientIdAndSecret:Basic:credentialsSelector,URLOauth,ResetLastUpdate";

/// OAuth User/pass de OpenEMR
Property OauthUser As %String;

/// ClientID y ClientSecret de OpenEMR
Property ClientIdAndSecret As %String;

Property %OauthUserObj As Ens.Config.Credentials;

Property %ClientIdAndSecretObj As Ens.Config.Credentials;

/// URL para la autenticación
Property URLOauth As %String(MAXLEN = "");

/// Fecha de la última búsqueda
/// Si este campo es distinto de vacío, se obtendrán los cambios desde este LastUpdate
Property ResetLastUpdate As %TimeStamp;

Method getToken(pRequest As cysnet.openEmr.msg.GetTokenRequest, Output pResponse As cysnet.openEmr.msg.GetTokenResponse) As %Status
{
	If '$IsObject(..%OauthUserObj) Do ..OauthUserSet(..OauthUser) Quit:'$IsObject(..%OauthUserObj) $$$ERROR($$$EnsErrNoCredentials,..OauthUser)
	If '$IsObject(..%ClientIdAndSecretObj) Do ..ClientIdAndSecretSet(..ClientIdAndSecret) Quit:'$IsObject(..%ClientIdAndSecretObj) $$$ERROR($$$EnsErrNoCredentials,..ClientIdAndSecret)

	quit ##class(cysnet.openEmr.bo.core.OpenEmrCore).getToken(.pResponse, $this)
}

Method getChanges(pRequest As cysnet.syncEngine.core.msg.GetChangesRequest, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse) As %Status
{
	quit ##class(cysnet.openEmr.bo.core.OpenEmrCore).getChanges(pRequest, .pResponse, $this)
}

Method getEntity(pRequest As cysnet.openEmr.msg.GetRequest, Output pResponse As cysnet.openEmr.msg.GetResponse) As %Status
{
	quit ##class(cysnet.openEmr.bo.core.OpenEmrCore).getEntity(pRequest, .pResponse, $this)
}

Method upsertEntity(pRequest As cysnet.openEmr.msg.UpsertRequest, Output pResponse As cysnet.openEmr.msg.UpsertResponse) As %Status
{
	quit ##class(cysnet.openEmr.bo.core.OpenEmrCore).upsertEntity(pRequest, .pResponse, $this)
}

Method deleteEntity(pRequest As cysnet.openEmr.msg.DeleteRequest, Output pResponse As cysnet.openEmr.msg.DeleteResponse) As %Status
{
	quit ##class(cysnet.openEmr.bo.core.OpenEmrCore).deleteEntity(pRequest, .pResponse, $this)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="cysnet.openEmr.msg.GetTokenRequest"> 
		<Method>getToken</Method>
	</MapItem>
	<MapItem MessageType="cysnet.syncEngine.core.msg.GetChangesRequest"> 
		<Method>getChanges</Method>
	</MapItem>
	<MapItem MessageType="cysnet.openEmr.msg.GetRequest"> 
		<Method>getEntity</Method>
	</MapItem>
	<MapItem MessageType="cysnet.openEmr.msg.UpsertRequest"> 
		<Method>upsertEntity</Method>
	</MapItem>
	<MapItem MessageType="cysnet.openEmr.msg.DeleteRequest"> 
		<Method>deleteEntity</Method>
	</MapItem>
</MapItems>
}

/// This method parallels the inherited CredentialsSet method used here for HTTP credentials.
Method OauthUserSet(pInVal As %String) As %Status [ Internal ]
{
	#; (Re)Set the Credentials object; do it always because we never know if the source row fields might have been updated
	#; make sure to instantiate even if re-setting to the InitialExpression string
	Set ..%OauthUserObj=$$$NULLOREF

	Set tClassname=$zobjmethod($this,"%ClassName",1) ; call subclass
	Set tClass = $$$comMemberKeyGet(tClassname,$$$cCLASSproperty,"%OauthUserObj",$$$cPROPtype)
	If ""'=tClass {
		Set tSC=##Class(Ens.Config.Credentials).GetCredentialsObj(.tObj,tClassname,tClass,pInVal)
		
		Set:$$$ISOK(tSC) ..%OauthUserObj=tObj
		If $$$ISOK(tSC) { Set ..%OauthUserObj=tObj }
		ElseIf '$$$StatusEquals(tSC,$$$EnsErrNoCallerCredentials) {
			$$$LOGSTATUS(tSC)
		}
	}
	Set i%SOAPCredentials=pInVal
	Quit $$$OK
}

/// This method parallels the inherited CredentialsSet method used here for HTTP credentials.
Method ClientIdAndSecretSet(pInVal As %String) As %Status [ Internal ]
{
	#; (Re)Set the Credentials object; do it always because we never know if the source row fields might have been updated
	#; make sure to instantiate even if re-setting to the InitialExpression string
	Set ..%ClientIdAndSecretObj=$$$NULLOREF

	Set tClassname=$zobjmethod($this,"%ClassName",1) ; call subclass
	Set tClass = $$$comMemberKeyGet(tClassname,$$$cCLASSproperty,"%ClientIdAndSecretObj",$$$cPROPtype)
	If ""'=tClass {
		Set tSC=##Class(Ens.Config.Credentials).GetCredentialsObj(.tObj,tClassname,tClass,pInVal)
		
		Set:$$$ISOK(tSC) ..%ClientIdAndSecretObj=tObj
		If $$$ISOK(tSC) { Set ..%ClientIdAndSecretObj=tObj }
		ElseIf '$$$StatusEquals(tSC,$$$EnsErrNoCallerCredentials) {
			$$$LOGSTATUS(tSC)
		}
	}
	Set i%SOAPCredentials=pInVal
	Quit $$$OK
}

}
