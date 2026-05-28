Class cysnet.openEmr.dtl.TestOpenEmrDtl Extends %RegisteredObject
{

ClassMethod testFromHyperObjects(entidad As %String = "")
{
	#dim sc As %Status = $$$OK
	#dim dynObj As %DynamicObject = ##class(%DynamicObject).%New()
	
	if (entidad = "") {
		set entidad = "Patient"
	}

	quit:entidad=""

	// ************************************************************************************************************************
	// Patient
	// ************************************************************************************************************************
	if (entidad = "Patient") {
		set ho = {
			"resourceType": "Patient",
			"id": "1027",
			"text": {
				"status": "generated",
				"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n\t\t\t<table>\n\t\t\t\t<tbody>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Name</td>\n\t\t\t\t\t\t<td>Peter James \n              <b>Chalmers</b> (&quot;Jim&quot;)\n            </td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Address</td>\n\t\t\t\t\t\t<td>534 Erewhon, Pleasantville, Vic, 3999</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Contacts</td>\n\t\t\t\t\t\t<td>Home: unknown. Work: (03) 5555 6473</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Id</td>\n\t\t\t\t\t\t<td>MRN: 12345 (Acme Healthcare)</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</tbody>\n\t\t\t</table>\n\t\t</div>"
			},
			"identifier": [
				{
					"use": "usual",
					"type": {
						"coding": [
							{
								"system": "http://terminology.hl7.org/CodeSystem/v2-0203",
								"code": "MR"
							}
						]
					},
					"system": "urn:oid:1.2.36.146.595.217.0.1",
					"value": "12345",
					"period": {
						"start": "2001-05-06"
					},
					"assigner": {
						"display": "Acme Healthcare"
					}
				}
			],
			"active": true,
			"name": [
				{
					"use": "official",
					"family": "Chalmers",
					"given": [
						"Peter",
						"James"
					]
				},
				{
					"use": "usual",
					"given": [
						"Jim"
					]
				},
				{
					"use": "maiden",
					"family": "Windsor",
					"given": [
						"Peter",
						"James"
					],
					"period": {
						"end": "2002"
					}
				}
			],
			"telecom": [
				{
					"use": "home"
				},
				{
					"system": "phone",
					"value": "(03) 5555 6473",
					"use": "work",
					"rank": 1
				},
				{
					"system": "phone",
					"value": "(03) 3410 5613",
					"use": "mobile",
					"rank": 2
				},
				{
					"system": "phone",
					"value": "(03) 5555 8834",
					"use": "old",
					"period": {
						"end": "2014"
					}
				}
			],
			"gender": "male",
			"birthDate": "1974-12-25",
			"deceasedBoolean": false,
			"address": [
				{
					"use": "home",
					"type": "both",
					"text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
					"line": [
						"534 Erewhon St"
					],
					"city": "PleasantVille",
					"district": "Rainbow",
					"state": "Vic",
					"postalCode": "3999",
					"period": {
						"start": "1974-12-25"
					}
				}
			],
			"contact": [
				{
					"relationship": [
						{
							"coding": [
								{
									"system": "http://terminology.hl7.org/CodeSystem/v2-0131",
									"code": "N"
								}
							]
						}
					],
					"name": {
						"family": "du Marché",
						"given": [
							"Bénédicte"
						]
					},
					"telecom": [
						{
							"system": "phone",
							"value": "+33 (237) 998327"
						}
					],
					"address": {
						"use": "home",
						"type": "both",
						"line": [
							"534 Erewhon St"
						],
						"city": "PleasantVille",
						"district": "Rainbow",
						"state": "Vic",
						"postalCode": "3999",
						"period": {
							"start": "1974-12-25"
						}
					},
					"gender": "female",
					"period": {
						"start": "2012"
					}
				}
			],
			"managingOrganization": {
				"reference": "Organization/1"
			},
			"meta": {
				"lastUpdated": "2024-08-09T06:02:56Z",
				"versionId": "1"
			}
		}
		set dtl = "cysnet.openEmr.dtl.HyperObjectsToPatient"
		
		// Importar el JSON en un stream:
		set stream = ##class(%Stream.TmpCharacter).%New()
		do stream.Write(ho.%ToJSON())

		// Obtener la clase del recurso FHIR a partir del source de la DTL:
		set fhirResourceClass = $ClassMethod(dtl, "GetSourceType")

		// Importar el stream en el objeto FHIR, a partir de la clase del recurso FHIR:
		set objFhir = $ClassMethod(fhirResourceClass, "FromJSON", stream, "r4")
			
		// Transformar el objeto FHIR a objeto dinámico:
		set sc = $ClassMethod(dtl, "Transform", objFhir, .dynObj)
		
		if ($$$ISERR(sc)) {
			w "OpenEmr-Error: "_$System.Status.GetErrorText(sc),!
		} else {
			w dynObj.%ToJSON(),!!
		}
	}
}

ClassMethod testToHyperObjects(reset As %Boolean = 0, entidad As %String = "")
{
	#dim sc As %Status = $$$OK

	if (entidad = "") {
		set entidad = "Patient"
	}

	quit:entidad=""

	if (reset = 1) {
		Xecute ("k ^cysnet.sync."_entidad)
	}
	
	// ************************************************************************************************************************
	// Patient
	// ************************************************************************************************************************
	if (entidad = "Patient") {
		set dtl = "cysnet.openEmr.dtl.PatientToHyperObjects"
		set json = {
			"id": 1,
			"uuid": "9c98db7e-a2bd-4e5f-a8d3-4816fbe79354",
			"title": "Mrs.",
			"language": "",
			"financial": "",
			"fname": "Laura",
			"lname": "Blázquez",
			"mname": "",
			"DOB": "1986-12-03",
			"street": "C/ PRUEBA Nº 7",
			"postal_code": "31006",
			"city": "PAMPLONA",
			"state": "NAV",
			"country_code": "Spain",
			"drivers_license": "",
			"ss": "",
			"occupation": "",
			"phone_home": "",
			"phone_biz": "",
			"phone_contact": "910000000",
			"phone_cell": "",
			"pharmacy_id": 0,
			"status": "",
			"contact_relationship": "",
			"date": "2024-08-06 12:55:16",
			"sex": "Female",
			"referrer": "",
			"referrerID": "",
			"providerID": 0,
			"ref_providerID": 0,
			"email": "laura@cysnet.es",
			"email_direct": "laura@cysnet.es",
			"ethnoracial": "",
			"race": "",
			"ethnicity": "",
			"religion": "",
			"interpretter": "",
			"migrantseasonal": "",
			"family_size": "",
			"monthly_income": "",
			"billing_note": "",
			"homeless": "",
			"financial_review": "0000-00-00 00:00:00",
			"pubpid": "1",
			"pid": 1,
			"genericname1": "",
			"genericval1": "",
			"genericname2": "",
			"genericval2": "",
			"hipaa_mail": "",
			"hipaa_voice": "",
			"hipaa_notice": "",
			"hipaa_message": "",
			"hipaa_allowsms": "",
			"hipaa_allowemail": "",
			"squad": "",
			"fitness": 0,
			"referral_source": "",
			"usertext1": "",
			"usertext2": "",
			"usertext3": "",
			"usertext4": "",
			"usertext5": "",
			"usertext6": "",
			"usertext7": "",
			"usertext8": "",
			"userlist1": "",
			"userlist2": "",
			"userlist3": "",
			"userlist4": "",
			"userlist5": "",
			"userlist6": "",
			"userlist7": "",
			"pricelevel": "standard",
			"regdate": "2024-07-24 06:41:54",
			"contrastart": null,
			"completed_ad": "NO",
			"ad_reviewed": null,
			"vfc": "",
			"mothersname": "",
			"guardiansname": "",
			"allow_imm_reg_use": "",
			"allow_imm_info_share": "",
			"allow_health_info_ex": "",
			"allow_patient_portal": "",
			"deceased_date": null,
			"deceased_reason": "",
			"soap_import_status": null,
			"cmsportal_login": "",
			"care_team_provider": null,
			"care_team_facility": null,
			"care_team_status": "active",
			"county": "",
			"industry": "",
			"imm_reg_status": "",
			"imm_reg_stat_effdate": null,
			"publicity_code": "",
			"publ_code_eff_date": null,
			"protect_indicator": "",
			"prot_indi_effdate": null,
			"guardianrelationship": "",
			"guardiansex": "",
			"guardianaddress": "",
			"guardiancity": "",
			"guardianstate": "",
			"guardianpostalcode": "",
			"guardiancountry": "",
			"guardianphone": "",
			"guardianworkphone": "",
			"guardianemail": "",
			"sexual_orientation": "",
			"gender_identity": "",
			"birth_fname": "",
			"birth_lname": "",
			"birth_mname": "",
			"dupscore": 0,
			"name_history": null,
			"suffix": null,
			"street_line_2": "",
			"patient_groups": "",
			"prevent_portal_apps": "",
			"provider_since_date": null,
			"created_by": 1,
			"updated_by": 1,
			"preferred_name": "",
			"nationality_country": "",
			"previous_names": [],
			"addresses": [
				{
					"id": null,
					"contact_id": null,
					"contact_address_id": null,
					"period_start": "2024-08-06 12:55:16",
					"period_end": null,
					"type": "both",
					"use": "home",
					"priority": 0,
					"line1": "C/ PRUEBA Nº 7",
					"line2": "",
					"city": "PAMPLONA",
					"district": "",
					"state": "NAV",
					"postal_code": "31006",
					"country_code": "Spain"
				}
			]
		}

		set sc = ##class(cysnet.syncEngine.core.util.JsonHelper).Procesar(json.%ToJSON(), "cysnet.sync", "OpenEMR", entidad, 0, "I", "id", dtl, "", .idEntidad)
		if ($$$ISERR(sc)) {
			w "OpenEmr-Error: "_$System.Status.GetErrorText(sc),!
		}

		set ho = {
			"resourceType": "Patient",
			"address": [
				{
					"city": "PAMPLONA",
					"country": "Spain",
					"line": [
						"C/ PRUEBA Nº 7"
					],
					"postalCode": "31006",
					"state": "NAV"
				}
			],
			"birthDate": "1986-12-03",
			"gender": "female",
			"identifier": [
				{
					"system": "http://hyperobjects/OpenEMR",
					"value": "9c98db7e-a2bd-4e5f-a8d3-4816fbe79354"
				}
			],
			"name": [
				{
					"family": "Blázquez",
					"given": [
						"Laura"
					],
					"prefix": [
						"Mrs."
					]
				}
			],
			"text": {
				"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Patient</p></div>",
				"status": "generated"
			},
			"id": "259864",
			"meta": {
				"lastUpdated": "2024-08-07T05:24:14Z",
				"versionId": "1"
			}
		}

		#; set sc = ##class(cysnet.syncEngine.core.util.HyperObjectsHelper).Procesar(ho.%ToJSON(), "cysnet.sync", "HO", entidad, 0, "I", "id", "", "", .idEntidad)

		if ($$$ISERR(sc)) {
			w "HyperObjects-Error: "_$System.Status.GetErrorText(sc),!
		}

	}

	if ($$$ISOK(sc)) {
		do ..pintar(entidad)
	}

	quit
}

ClassMethod pintar(entidad As %String)
{
	#dim lvl1, lvl2, lvl3, data, json = ""

	set lvl1 = ""
	for {
		Xecute ("(in,out) set out = $Order(^cysnet.sync."_entidad_"(in),1)", lvl1, .lvl1)
		quit:lvl1=""

		set json = ""
		set lvl2 = ""
		for {
			Xecute ("(in,in2,out,out2) set out = $Order(^cysnet.sync."_entidad_"(in,in2),1,out2)", lvl1, lvl2, .lvl2, .json)
			quit:lvl2=""
			
			if (json '= "") {
				w "--> "_lvl1_", "_lvl2_": ",!
				w json,!
				w "--------------------------------",!!
			}

			set lvl3 = ""
			for {
				Xecute ("(in,in2,in3,out,out2) set out = $Order(^cysnet.sync."_entidad_"(in,in2,in3),1,out2)", lvl1, lvl2, lvl3, .lvl3, .data)
				quit:lvl3=""

				if (data '= "") {
					w "--> "_lvl1_", "_lvl2_": "_$lts(data),!
					#; Xecute ("(in,in2,out) set out = ^cysnet.sync."_entidad_"(in,in2)", $li(data,1), $li(data,2), .out)
					#; w out,!
					#; w "--------------------------------",!!
				}
			}
		}
	}
}

}
