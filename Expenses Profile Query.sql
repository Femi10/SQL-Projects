SELECT "Supplier Code" = POH.suppliermastercode,
       "Supplier Name" = POH.suppliername,
       "Company" = DCL.el1,
     --  "Company Name" = el1.el1_name,
       "Business Entity" = DCL.el2,
    --  "Business Entity Name" = el2.el2_name,
   --    "Business Unit Name" = [ent].[description],
       "Nominal" = DCL.el3,
    --   "Nominal Name" = el3.el3_name,
       "Posted Date" = ASS.adddate,
       "Value" = DCL.valuehome,
       "PO Number" = DCL.ref5,
       "PO Type" = CASE WHEN DCL.el3 IN ( 32834, 32835, 32844, 32845 ) THEN 'Major Works'
                        WHEN DCL.el3 IN ( 11303, 31611, 31631, 37303, 39417, 53101, 58101, 58211, 71201, 71202, 71203,
                                          71206, 71213, 71320, 71332, 73301, 82103
                                        ) THEN 'Capital Deal'
                        WHEN DCL.el3 = 76315 THEN 'Non Recoverable'
                        WHEN DCL.el3 BETWEEN 37000
                                     AND     39999 THEN 'Non Recoverable'
                        WHEN DCL.el3 BETWEEN 58000
                                     AND     58999 THEN 'Non Recoverable'
                        WHEN DCL.el3 BETWEEN 30000
                                     AND     35999 THEN 'Service Charge Recoverable'
                        WHEN DCL.el3 BETWEEN 36000
                                     AND     36799 THEN 'Direct Recoveries'
                        WHEN DCL.el3 BETWEEN 36800
                                     AND     36999 THEN 'Managed Operations'
                        WHEN DCL.el3 BETWEEN 71301
                                     AND     71347 THEN 'Development Project PO'
                        WHEN DCL.el3 BETWEEN 76702
                                     AND     76713 THEN 'IS Project PO'
                        WHEN DCL.el3 BETWEEN 40000
                                     AND     45999 THEN 'General PO'
                        ELSE 'No PO'
                   END,
       ISNULL (RIGHT(ihrc1.groupchild, 6), '') AS "Category 1 Code",
       ISNULL (prdg1.name, '') AS "Category 1 Name",
       ISNULL (RIGHT(ihrc2.groupchild, 6), '') AS "Category 2 Code",
       ISNULL (prdg2.name, '') AS "Category 2 Name",
       "Item Code" = POL.itemcode,
       "Item Description" = POL.itemdescription,
       "Barcode" = DCL.ref6,
       "Document" = DCL.doccode,
       "Number" = DCL.docnum,
       "PO Raiser" = POH.originator,
       "Authorising User" = POH.authorisinguser,
       DCH.yr,
       DCH.period,
       DCL.el4 AS Analysis,
       DCL.el5 AS Demise,
       DCL.ref2,
       DCL.ref3,
       DCL.ref4,
       DCL.ref5,
       DCL.el6 AS Tenant,
       DCL.descr,
       DOCC.comm AS comment
FROM Bronze.CODA_pop_invassoc AS ASS
LEFT JOIN Bronze.CODA_oas_dochead DCH ON  DCH.cmpcode            = ASS.invcompany
                              AND DCH.doccode           = ASS.invdocmaster
                              AND DCH.docnum            = ASS.invdocnumber
LEFT JOIN Bronze.CODA_oas_docline AS DCL ON  DCL.cmpcode             = ASS.invcompany
                             AND DCL.doccode            = ASS.invdocmaster
                             AND DCL.docnum             = ASS.invdocnumber
                             AND (DCL.doclinenum - 1)   = ASS.invlinenum
LEFT JOIN Bronze.CODA_pop_porditmline AS POL ON  POL.cmpcode         = ASS.invcompany
                                 AND POL.doccode        = ASS.orderdocmaster
                                 AND POL.docnum         = ASS.orderdocnumber
                                 AND POL.linenumber     = ASS.orderlinenum
LEFT JOIN Bronze.CODA_pop_pordhead AS POH ON  POH.cmpcode            = DCL.cmpcode
                              AND POH.docnum            = DCL.ref5
--LEFT JOIN oas_el1_element AS el1 ON  el1.el1_cmpcode     = DCL.cmpcode
--                                 AND el1.el1_code       = DCL.el1
--LEFT JOIN oas_el2_element AS el2 ON  el2.el2_cmpcode     = DCL.cmpcode
--                                 AND el2.el2_code       = DCL.el2
--LEFT JOIN oas_el3_element AS el3 ON  el3.el3_cmpcode     = DCL.cmpcode
--                                 AND el3.el3_code       = DCL.el3
--LEFT JOIN Bronze.CODA_oas_entitylist AS ent ON ent.cfvalue      = el2.el2_repcode1
LEFT JOIN Bronze.CODA_oas_element el ON  POL.linudfelement1      = el.code
                             AND el.elmlevel            = 2
                             AND POL.cmpcode            = el.cmpcode
LEFT JOIN Bronze.CODA_pop_itemhrc ihrc3 ON ihrc3.itemchild  = 'R' + POL.itemcode
LEFT JOIN Bronze.CODA_pop_itemhrc ihrc2 ON ihrc2.groupchild = ihrc3.parent
LEFT JOIN Bronze.CODA_pop_itemhrc ihrc1 ON ihrc1.groupchild = ihrc2.parent
/* */
LEFT JOIN Bronze.CODA_pop_prdgrpmaster prdg1 ON prdg1.code  = ihrc1.groupchild
LEFT JOIN Bronze.CODA_pop_prdgrpmaster prdg2 ON prdg2.code  = ihrc2.groupchild
LEFT JOIN Bronze.CODA_oas_docclist AS DOCC ON  DOCC.cmpcode          = DCL.cmpcode
                               AND DOCC.doccode         = DCL.doccode
                               AND DOCC.docnum          = DCL.docnum
                               AND DOCC.doclinenum      = DCL.doclinenum
                               AND DOCC.comm LIKE '%<<______>>%'
WHERE 
ASS.invcompany       = 'LS01'
--AND   ASS.adddate BETWEEN ISNULL ('2022-04-01', ASS.adddate)
   --               AND     ISNULL ('2023-04-01', ASS.adddate)
--AND   DCL.linetype           = '158'
--AND   DCL.el3 NOT IN ( '34812', '45101', '58211', '76420', '79101', '82101', '82103', '82205', '82206' )
--AND POL.itemdescription like '%elec%'
--and
--DCL.ref5 in ('301000','302000','304000')
and  POH.originator IN ('smalleye')