-- pVW_pPensionPerYYDisDiff

select a.PensionYear, a.EID, a.BID, ISNULL(a.EmpPensionPerYYRST,0) as EmpPensionPerYYRST_old,
    c.EmpPensionPerYYDisAccu as EmpPensionPerYYDisAccu,
    (case when c.EmpPensionPerYYDisAccu-b.EmpPensionPerMMTT>=0 then c.EmpPensionPerYYDisAccu-b.EmpPensionPerMMTT
else 0 end) as EmpPensionPerYYDisAccu_diff, b.EmpPensionPerMMTT as EmpPensionPerMM
from pPensionUpdatePerEmp a
    inner join (select EID, BID, (ISNULL(EmpPensionPerMMATax,0)+ISNULL(EmpPensionPerMMBTax,0)) as EmpPensionPerMMTT
    from pEmpPensionPerMM_register) as b on ISNULL(b.EID,b.BID)=ISNULL(a.EID,a.BID)
    -- 企业年金累计金额
    left join (select m.EID, m.BID, m.PensionYear,
        (select SUM(ISNULL(EmpPensionPerYYRST,0))
        from pPensionUpdatePerEmp
        where DATEDIFF(YY,PensionYear,m.PensionYear)>=0
            and YEAR(PensionYear) in (select YEAR(PensionYear)
            from pPensionPerYY
            where ISNULL(IsDisMM,0)=1)
            and ISNULL(EID,BID)=ISNULL(m.EID,m.BID)) as EmpPensionPerYYDisAccu
    from pPensionUpdatePerEmp m
    group by m.EID,m.BID,m.PensionYear,m.EmpPensionPerYYRST) as c on ISNULL(a.EID,a.BID)=ISNULL(c.EID,c.BID) and DATEDIFF(YY,c.PensionYear,a.PensionYear)=0
where YEAR(a.PensionYear) in (select YEAR(PensionYear)
from pPensionPerYY
where ISNULL(IsDisMM,0)=1)
group by a.EID,a.BID,a.PensionYear,b.EmpPensionPerMMTT,c.EmpPensionPerYYDisAccu,a.EmpPensionPerYYRST