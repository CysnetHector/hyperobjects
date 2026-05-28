Class cysnet.VirtualizationLoopProd Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="cysnet.VirtualizationLoopProd" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">10</Setting>
  <Item Name="ClientConnection" Category="" ClassName="cysnet.syncEngine.core.bs.ClientConnection" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="StartSync" Category="Sync Engine Core" ClassName="cysnet.syncEngine.core.bs.StartSync" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">9999999</Setting>
    <Setting Target="Host" Name="Paso">4</Setting>
    <Setting Target="Host" Name="ResetearGlobals">1</Setting>
  </Item>
  <Item Name="SyncProcess" Category="Sync Engine Core" ClassName="cysnet.syncEngine.core.bp.SyncProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ReplyCodeActions">E=F</Setting>
  </Item>
  <Item Name="ChangesProcess" Category="Sync Engine Core" ClassName="cysnet.syncEngine.core.bp.ChangesProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SyncHyperObjects" Category="HyperObjects" ClassName="cysnet.syncEngine.core.bp.SyncEntity" PoolSize="1" Enabled="true" Foreground="false" Comment="Sincronización de entidades hacia HyperObjects" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HyperObjects" Category="Conector,HyperObjects" ClassName="cysnet.hyperobjects.bo.HyperObjects" PoolSize="1" Enabled="true" Foreground="false" Comment="Conector con repositorio FHIR HyperObjects" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="URL">http://webgateway:80/csp/healthshare/hyperobjects/fhir/r4</Setting>
    <Setting Target="Adapter" Name="Credentials">HyperObjects</Setting>
    <Setting Target="Adapter" Name="SSLConfig"></Setting>
    <Setting Target="Host" Name="PrintLog">1</Setting>
    <Setting Target="Host" Name="ResetLastUpdate"></Setting>
  </Item>
  <Item Name="OpenEMR" Category="Conector,OpenEMR" ClassName="cysnet.openEmr.bo.OpenEmr" PoolSize="1" Enabled="true" Foreground="false" Comment="Conector con OpenEMR (HIS)" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ClientIdAndSecret">OpenEMR-ClientSecret</Setting>
    <Setting Target="Host" Name="OauthUser">OpenEMR-Auth</Setting>
    <Setting Target="Adapter" Name="Credentials"></Setting>
    <Setting Target="Adapter" Name="URL">http://host.docker.internal/apis/default</Setting>
    <Setting Target="Host" Name="PrintLog">1</Setting>
    <Setting Target="Host" Name="URLOauth">http://host.docker.internal/oauth2/default</Setting>
    <Setting Target="Host" Name="ResetLastUpdate"></Setting>
    <Setting Target="Adapter" Name="SSLConfig">SSL-Empty</Setting>
  </Item>
  <Item Name="SyncOpenEMR" Category="OpenEMR" ClassName="cysnet.syncEngine.core.bp.SyncEntity" PoolSize="1" Enabled="true" Foreground="false" Comment="Sincronización de entidades hacia OpenEMR" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="StartSyncAudit" Category="" ClassName="cysnet.audit.bs.StartSyncAudit" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MaxItems">100</Setting>
    <Setting Target="Adapter" Name="CallInterval">9999999</Setting>
  </Item>
  <Item Name="SyncAudit" Category="" ClassName="cysnet.audit.bp.SyncAudit" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="AuditLog" Category="" ClassName="cysnet.audit.bo.AuditLog" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="URL">http://webgateway/audit/api</Setting>
    <Setting Target="Adapter" Name="Credentials">HyperObjects</Setting>
  </Item>
  <Item Name="EnviarAlerta" Category="Alert" ClassName="cysnet.alertas.bo.EnviarAlerta" PoolSize="1" Enabled="true" Foreground="false" Comment="Envío de alertas" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Destinatario">laura@cysnet.es</Setting>
    <Setting Target="Host" Name="PrintLog">1</Setting>
    <Setting Target="Host" Name="Remitente">laura@cysnet.es</Setting>
    <Setting Target="Adapter" Name="Credentials">HyperObjects</Setting>
    <Setting Target="Adapter" Name="URL">http://webgateway:80/alerta</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="Alert" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="Proceso de enrutamiento de mensajes de alerta" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">cysnet.alertas.rules.AlertRule</Setting>
  </Item>
</Production>
}

}