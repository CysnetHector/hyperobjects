Class cysnet.openEmr.dtl.TestDtl Extends %RegisteredObject
{

ClassMethod test(entidad As %String = "")
{
	#dim sc As %Status = $$$OK
	#dim json, jsonOri As %DynamicObject = ##class(%DynamicObject).%New()
	#dim dtl, direccion, obj As %String = ""
	
	set jsonOri = ""
	
	if (entidad = "") {
		w "ERROR: No se ha definido la entidad",!
	}
	quit:entidad=""

	// ************************************************************************************************************************
	// Organization
	// ************************************************************************************************************************
	if (entidad = "Organization") {
		set dtl = "cysnet.openEmr.dtl.FacilityToOrganization"
		set direccion = "HO"
		set json = {"id":"3","uuid":"9d0659d3-91a1-4e63-9d5e-61da53e35d2a","name":"Our Hospital","phone":"999-111-2222","fax":"000-000-0000","street":"Calle principal nº 26, portal 7, piso 5","city":"Madrid","state":"Madrid","postal_code":"28008","country_code":"Spain","federal_ein":"","website":"","email":"","service_location":"1","billing_location":"1","accepts_assignment":"1","pos_code":"1","x12_sender_id":"","attn":"","domain_identifier":"","facility_npi":"0000000001","facility_taxonomy":"","tax_id_type":"EI","color":"#99FFFF","primary_business_entity":"0","facility_code":"","extra_validation":"1","mail_street":"","mail_street2":"","mail_city":"","mail_state":"","mail_zip":"","oid":"","iban":"","info":"","weno_id":null,"inactive":"0"}
	}

	// ************************************************************************************************************************
	// Practitioner
	// ************************************************************************************************************************
	if (entidad = "Practitioner") {
		set dtl = "cysnet.openEmr.dtl.PractitionerToHyperObjects"
		set direccion = "HO"
		set json = {"id":"5","uuid":"9d065b3f-a511-4043-8f00-3f45102674db","email":"medico1@test.es","phone":"666111000"}
	}

	// ************************************************************************************************************************
	// Patient
	// ************************************************************************************************************************
	if (entidad = "Patient") {
		set dtl = "cysnet.openEmr.dtl.PatientToHyperObjects"
		set direccion = "HO"
		set json = {"id":1,"uuid":"9d065aa2-d7b0-48c3-a04b-86b173a43650","title":"Mrs.","language":"","financial":"","fname":"Paciente","lname":"De Pruebas","mname":"","DOB":"1977-09-02","street":"C/ PRUEBA Nº 7","postal_code":"31006","city":"PAMPLONA","state":"","country_code":"SPAIN","drivers_license":"","ss":"XXXXXXXXYY","occupation":"","phone_home":"ppruebas@test.es","phone_biz":"987654321","phone_contact":"777888999","phone_cell":"666111000","pharmacy_id":0,"status":"","contact_relationship":"Mi Padre","date":"2024-10-03 05:28:19","sex":"Female","referrer":"","referrerID":"","providerID":0,"ref_providerID":0,"email":"ppruebas@test.es","email_direct":"","ethnoracial":"","race":"","ethnicity":"","religion":"","interpretter":"","migrantseasonal":"","family_size":"","monthly_income":"","billing_note":"","homeless":"","financial_review":"0000-00-00 00:00:00","pubpid":"1","pid":1,"genericname1":"","genericval1":"","genericname2":"","genericval2":"","hipaa_mail":"","hipaa_voice":"","hipaa_notice":"","hipaa_message":"","hipaa_allowsms":"","hipaa_allowemail":"","squad":"","fitness":0,"referral_source":"","usertext1":"","usertext2":"","usertext3":"","usertext4":"","usertext5":"","usertext6":"","usertext7":"","usertext8":"","userlist1":"","userlist2":"","userlist3":"","userlist4":"","userlist5":"","userlist6":"","userlist7":"","pricelevel":"standard","regdate":"2024-09-16 17:02:39","contrastart":null,"completed_ad":"NO","ad_reviewed":null,"vfc":"","mothersname":"","guardiansname":"mother","allow_imm_reg_use":"","allow_imm_info_share":"","allow_health_info_ex":"","allow_patient_portal":"","deceased_date":null,"deceased_reason":"","soap_import_status":null,"cmsportal_login":"","care_team_provider":null,"care_team_facility":null,"care_team_status":"active","county":"","industry":"","imm_reg_status":"","imm_reg_stat_effdate":null,"publicity_code":"","publ_code_eff_date":null,"protect_indicator":"","prot_indi_effdate":null,"guardianrelationship":"mother","guardiansex":"Female","guardianaddress":"C/ Prueba Nº 7","guardiancity":"Pamplona","guardianstate":"","guardianpostalcode":"31008","guardiancountry":"SPAIN","guardianphone":"666777888","guardianworkphone":"999111222","guardianemail":"mimadre@test.es","sexual_orientation":"","gender_identity":"","birth_fname":"","birth_lname":"","birth_mname":"","dupscore":0,"name_history":null,"suffix":null,"street_line_2":"","patient_groups":"","prevent_portal_apps":"","provider_since_date":null,"created_by":1,"updated_by":1,"preferred_name":"","nationality_country":"","previous_names":[],"addresses":[{"id":null,"contact_id":null,"contact_address_id":null,"period_start":"2024-10-03 05:28:19","period_end":null,"type":"both","use":"home","priority":0,"line1":"C/ PRUEBA Nº 7","line2":"","city":"PAMPLONA","district":"","state":"","postal_code":"31006","country_code":"SPAIN"}]}
		#; set dtl = "cysnet.openEmr.dtl.HyperObjectsToPatient"
		#; set json = {
		#; 	"resourceType": "Patient",
		#; 	"address": [
		#; 		{
		#; 			"city": "FooTown",
		#; 			"country": "US",
		#; 			"line": [
		#; 				"456 Tree Lane"
		#; 			],
		#; 			"postalCode": "08642",
		#; 			"state": "FL"
		#; 		}
		#; 	],
		#; 	"birthDate": "1992-02-02",
		#; 	"gender": "female",
		#; 	"id": "63",
		#; 	"identifier": [
		#; 		{
		#; 			"system": "http://hyperobjects/OpenEMR",
		#; 			"value": "9d27ff91-2f52-4ea0-a52f-291eb0264cba"
		#; 		},
		#; 		{
		#; 			"system": "http://hyperobjects/OpenEMR/id",
		#; 			"value": "5"
		#; 		},
		#; 		{
		#; 			"system": "http://hyperobjects/OpenEMR/pubpid",
		#; 			"value": "5"
		#; 		}
		#; 	],
		#; 	"meta": {
		#; 		"lastUpdated": "2024-10-03T12:08:35Z",
		#; 		"versionId": "3"
		#; 	},
		#; 	"name": [
		#; 		{
		#; 			"family": "Barsssss",
		#; 			"given": [
		#; 				"Foossss"
		#; 			],
		#; 			"prefix": [
		#; 				"Mr"
		#; 			]
		#; 		}
		#; 	],
		#; 	"telecom": [
		#; 		{
		#; 			"system": "phone",
		#; 			"value": "999888777",
		#; 			"use": "home"
		#; 		},
		#; 		{
		#; 			"system": "email",
		#; 			"value": "fbar@test.es",
		#; 			"use": "home"
		#; 		}
		#; 	],
		#; 	"text": {
		#; 		"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Patient</p></div>",
		#; 		"status": "generated"
		#; 	}
		#; }
	}

	// ************************************************************************************************************************
	// Appointment
	// ************************************************************************************************************************
	if (entidad = "Appointment") {
		#; set dtl = "cysnet.openEmr.dtl.AppointmentToHyperObjects"
		#; set direccion = "HO"
		#; set json = {"pc_eid":7,"pc_uuid":"9d065c33-10ae-4a45-8048-c845ca5f68bc","fname":"Paciente","lname":"De Pruebas","DOB":"1977-09-02","pid":1,"puuid":"9d065aa2-d7b0-48c3-a04b-86b173a43650","pce_aid_uuid":"9d065b3f-a511-4043-8f00-3f45102674db","pce_aid_npi":"3456789011","pc_aid":"5","pc_apptstatus":"-","pc_eventDate":"2024-09-22","pc_startTime":"17:00:00","pc_time":"2024-09-16 17:07:02","pc_facility":4,"pc_billing_location":3,"pc_catid":9,"pc_pid":"1","facility_name":"Urgencias","facility_uuid":"9d096d8f-8043-4664-8cd8-0ca8eaaff8c9","billing_location_name":"Our Hospital","billing_location_uuid":"9d0659ea-5662-49f3-b198-34981513bfd5"}
		set dtl = "cysnet.openEmr.dtl.HyperObjectsToAppointment"
		set json = {  "resourceType": "Appointment",  "end": "2024-09-29T11:30:00Z",  "identifier": [    {      "system": "http://hyperobjects/OpenEMR",      "value": "9d27a79d-9424-433a-9782-268d37dc1973"    },    {      "system": "http://hyperobjects/OpenEMR/eid",      "value": "8"    },    {      "system": "http://hyperobjects/OpenEMR/facility",      "value": "5"    }  ],  "minutesDuration": 30,  "participant": [    {      "actor": {        "identifier": {          "system": "http://hyperobjects/OpenEMR",          "value": "9d065aa2-d7b0-48c3-a04b-86b173a43650"        },        "type": "Patient"      },      "status": "accepted"    },    {      "actor": {        "identifier": {          "system": "http://hyperobjects/OpenEMR/facility",          "value": "9d0b9022-d383-4bf9-adb4-97236f1a8fa0"        },        "type": "Location"      },      "status": "accepted"    }  ],  "start": "2024-09-29T11:00:00Z",  "status": "booked",  "text": {    "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Patient</p></div>",    "status": "generated"  }}

	}

	// ************************************************************************************************************************
	// Encounter
	// ************************************************************************************************************************
	if (entidad = "Encounter") {
		#; set dtl = "cysnet.openEmr.dtl.EncounterToHyperObjects"
		#; set direccion = "HO"
		#; set json = {"pc_eid":7,"pc_uuid":"9d065c33-10ae-4a45-8048-c845ca5f68bc","fname":"Paciente","lname":"De Pruebas","DOB":"1977-09-02","pid":1,"puuid":"9d065aa2-d7b0-48c3-a04b-86b173a43650","pce_aid_uuid":"9d065b3f-a511-4043-8f00-3f45102674db","pce_aid_npi":"3456789011","pc_aid":"5","pc_apptstatus":"-","pc_eventDate":"2024-09-22","pc_startTime":"17:00:00","pc_time":"2024-09-16 17:07:02","pc_facility":4,"pc_billing_location":3,"pc_catid":9,"pc_pid":"1","facility_name":"Urgencias","facility_uuid":"9d096d8f-8043-4664-8cd8-0ca8eaaff8c9","billing_location_name":"Our Hospital","billing_location_uuid":"9d0659ea-5662-49f3-b198-34981513bfd5"}
		set dtl = "cysnet.openEmr.dtl.HyperObjectsToEncounter"
		set json = {"resourceType":"Encounter","text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Encounter.</p></div>"},"status":"planned","class":{"system":"http://terminology.hl7.org/CodeSystem/v3-ActCode","code":"EMER","display":"emergency"},"subject":{"reference":"Patient/62","type":"Patient"},"participant":[{"individual":{"display":"medico1","type":"Practitioner","reference":"Practitioner/53"}}],"serviceProvider":{"reference":"Organization/24","type":"Organization"},"period":{"start":"2024-11-03T12:00:00Z"},"reasonCode":[{"coding":[{"system":"http://snomed.info/sct","code":"3951002","display":"Proctitis"}]}],"id":"146","meta":{"lastUpdated":"2024-10-25T12:20:17Z","versionId":"1"}}

	}

	if (dtl '= "") {
		do ..transformar(json, dtl, obj, direccion, jsonOri)
	}
}

ClassMethod transformar(json As %DynamicObject, dtl As %String, obj As %SerialObject = "", direccion As %String = "", jsonOri As %DynamicObject = "")
{
	#dim dynObj As %DynamicObject = ##class(%DynamicObject).%New()

	if (direccion = "HO") {
		// Obtener la clase del recurso FHIR a partir del target de la DTL:
		set fhirResourceClass = $ClassMethod(dtl, "GetTargetType")

		if (jsonOri = "") {
			// Crear una nueva instancia del objeto FHIR
			set objFhir = $ClassMethod(fhirResourceClass, "%New")
		} else {
			// Importar el JSON en un stream:
			set stream = ##class(%Stream.TmpCharacter).%New()
			do stream.Write(jsonOri.%ToJSON())

			// Importar el stream en el objeto FHIR, a partir de la clase del recurso FHIR:
			set objFhir = $ClassMethod(fhirResourceClass, "FromJSON", stream, "r4")
		}

		if ($IsObject(obj)) {
			// Transformar el objeto a objeto FHIR:
			set sc = $ClassMethod(dtl, "Transform", obj, .objFhir)
		} else {
			// Transformar el objeto dinámico a objeto FHIR:
			set sc = $ClassMethod(dtl, "Transform", json, .objFhir)
		}

	} else {
		// Importar el JSON en un stream:
		set stream = ##class(%Stream.TmpCharacter).%New()
		do stream.Write(json.%ToJSON())

		// Obtener la clase del recurso FHIR a partir del source de la DTL:
		set fhirResourceClass = $ClassMethod(dtl, "GetSourceType")

		// Importar el stream en el objeto FHIR, a partir de la clase del recurso FHIR:
		set objFhir = $ClassMethod(fhirResourceClass, "FromJSON", stream, "r4")
			
		if ($IsObject(obj)) {
			// Transformar el objeto FHIR a objeto dinámico:
			set sc = $ClassMethod(dtl, "Transform", objFhir, .obj)
		} else {
			// Transformar el objeto FHIR a objeto dinámico:
			set sc = $ClassMethod(dtl, "Transform", objFhir, .dynObj)
		}
	}

	if ($$$ISERR(sc)) {
		w "ERROR ("_dtl_"): "_$System.Status.GetErrorText(sc),!
	} else {
		if (direccion = "HO") {
			// Guardar el objeto FHIR en el global:
			set stream = objFhir.ToJSON()
			set jsonOUT = stream.Read(stream.Size)

			w jsonOUT,!!
		} else {
			if ($IsObject(obj)) {
				do obj.%JSONExportToString(.jsonOUT)
				w jsonOUT,!!
			} else {
				w dynObj.%ToJSON(),!!
			}
		}
	}
}

ClassMethod testNodes() As %Status
{
	#dim sc As %Status = $$$OK
	#dim err = ""
	#dim obj As %DynamicAbstractObject
	#dim itr As %Iterator.AbstractIterator
	#dim campo, valor, idEntidad As %String = ""
	#dim i As %Integer

	try {
		set origen = "OpenEMR"
		set entidad = "appointment"
		set accion = "I"
		set claves = ""
		set bidireccional = 1

		// Convertir json a objeto
		set obj = ##class(%DynamicAbstractObject).%FromJSON("{""pc_eid"":7,""pc_uuid"":""9d065c33-10ae-4a45-8048-c845ca5f68bc"",""fname"":""Paciente"",""lname"":""De Pruebas"",""DOB"":""1977-09-02"",""pid"":1,""puuid"":""9d065aa2-d7b0-48c3-a04b-86b173a43650"",""pce_aid_uuid"":""9d065b3f-a511-4043-8f00-3f45102674db"",""pce_aid_npi"":""3456789011"",""pc_aid"":""5"",""pc_apptstatus"":""+"",""pc_eventDate"":""2024-09-22"",""pc_startTime"":""17:00:00"",""pc_endTime"":""17:15:00"",""pc_time"":""2024-09-16 17:07:02"",""pc_facility"":4,""pc_billing_location"":3,""pc_catid"":9,""pc_pid"":""1"",""facility_name"":""Urgencias"",""facility_uuid"":""9d096d8f-8043-4664-8cd8-0ca8eaaff8c9"",""billing_location_name"":""Our Hospital"",""billing_location_uuid"":""9d0659ea-5662-49f3-b198-34981513bfd5""}")
		set itr = obj.%GetIterator()
		
		set nodes = ""
		set nodesWithId = ""
		
		set sc = ##class(cysnet.syncEngine.core.util.JsonHelper).recorrerJson(itr, entidad, accion, .nodes, .nodesWithId, "")

		// Obtener los valores para el idEntidad, separados por -
		set idEntidad = ""
		// Si no se pasa el valor "claves", obtener idEntidad de las "k" del XML:
		if ( (claves = "")||(claves = "*") ) {
			set listIds = $listfromstring(nodesWithId, ",")
		} else {
			set listIds = $listfromstring(claves, ",")
		}
		set ptr = 0 
		while $listnext(listIds, ptr, value) {
			if (idEntidad '= "") {
				set idEntidad = idEntidad_"-"
			}
			if ((accion = "D")&&($d(nodes(value, "o")))) {
				set idEntidad = idEntidad_nodes(value, "o")
			} elseif ($d(nodes(value, "n"))) {
				set idEntidad = idEntidad_nodes(value, "n")
			}
		}
		// Quitar el guión del final (si tiene)
		set idEntidad = "http://hyperobjects/"_origen_"|"_$ZStrip(idEntidad,">","-")

		// Si no se encuentra el idEntidad, probar a obtener el valor de nodesWithId
		if (idEntidad = "")&&(nodesWithId '= "")&&($d(nodes(nodesWithId, "n"))) {
			set idEntidad = nodes(nodesWithId, "n")
		}

		// In case no ID Error
		if (idEntidad = "") {
			set sc = $$$ERROR("No se ha encontrado ID entidad para "_entidad)
		}
		
		
		if ($$$ISOK(sc)) {
			// Inicializar el objeto dinámico:
			set dynObj = {}
			
			// Recorrer los nodos y añadirlos al objeto dinámico:
			set key = $Order(nodes(""))
			while (key '= "") {
				// Si es unidireccional, añadirlo siempre al objeto dinámico;
				// Si es bidireccional, y el valor "old" es diferente al "new", añadirlo al objeto dinámico:
				if ( (bidireccional = 0)||((bidireccional = 1)&&(nodes(key, "o") '= nodes(key, "n"))) ) {
					// Si el nuevo valor es vacío, añadirlo al objeto como NULL para saber que hay que eliminar el valor
					if (nodes(key, "n") = "") {
						do dynObj.%Set(key, "NULL")
					} else {
						do dynObj.%Set(key, nodes(key, "n"))
					}
				}
				set key = $Order(nodes(key))
			}
			
			if ($IsObject(dynObj)) {
				w dynObj."pc_apptstatus",!
			} else {
				set sc = $$$ERROR("("_origen_", "_entidad_") No se ha podido generar el objeto dinámico ")
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		w "*** ERROR *** "_$System.Status.GetErrorText(sc),!
	}
    quit sc
}

}
