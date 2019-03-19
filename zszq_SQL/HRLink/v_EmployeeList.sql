-- v_EmployeeList
SELECT     TOP (100) PERCENT info.emp_id, info.emp_code, info.chn_name AS name_cn, info.eng_name AS name_en, dbo.fnGetAllOrgDesc(info.emp_id, 0) AS org_name_cn, dbo.fnGetAllOrgDesc(info.emp_id, 
                      1) AS org_name_en, info.emp_type_code, info.org_value_id1, info.org_value_id2, info.org_value_id3, info.org_value_id4, info.org_value_id5, info.org_value_id6, info.org_value_id7, 
                      info.org_value_id8, info.max_level_org_value_id, dbo.fn_GetQuitEmpPosition(info.emp_id, 1, dbo.v_Position_info.position_name_cn) AS position_name_cn, dbo.fn_GetQuitEmpPosition(info.emp_id, 
                      2, dbo.v_Position_info.position_name_en) AS position_name_en, dbo.fn_GetQuitEmpPosition(info.emp_id, 0, dbo.v_Position_info.position_code) AS position_code, info.quit_date, 
                      info.employee_date, info.date_of_birth, info.emp_status_code
FROM         dbo.v_Position_info RIGHT OUTER JOIN
                      dbo.POSITION_RELATION_TRX ON dbo.v_Position_info.position_id = dbo.POSITION_RELATION_TRX.position_id RIGHT OUTER JOIN
                      dbo.EMP_INFO_MASTER AS info ON dbo.POSITION_RELATION_TRX.relation_id = info.current_position_code LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS a ON a.org_value_id = info.org_value_id1 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS b ON b.org_value_id = info.org_value_id2 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS c ON c.org_value_id = info.org_value_id3 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS d ON d.org_value_id = info.org_value_id4 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS e ON e.org_value_id = info.org_value_id5 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS f ON f.org_value_id = info.org_value_id6 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS g ON g.org_value_id = info.org_value_id7 LEFT OUTER JOIN
                      dbo.EMP_ORG_VALUE AS h ON h.org_value_id = info.org_value_id8
WHERE     (info.status_code <> '0001')
ORDER BY info.emp_code