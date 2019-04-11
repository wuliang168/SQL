1、修改分公司负责人和一级营业部负责人的考核顺序(OK)
2、修改评分中需要的关联，类似如下
b.SCORE_EID AS approver, 1 AS id
FROM pscore a, pscore b
where a.eid=b.eid AND a.SCORE_TYPE = 4
AND (a.SCORE_status = 1 AND isnull(a.Initialized, 0) = 1 AND ISNULL(a.submit, 0) = 1)
AND (b.SCORE_status = 2 AND isnull(b.Initialized, 0) = 1 AND ISNULL(b.submit, 0) = 0)


3、修改部门考核开启PSP文件(OK)

4、修改部门考核关闭PSP文件，其中如果未进行互评的强制关闭(OK)


5、评分优先普通员工

6、修改分公司负责人和一级营业部负责人合规和网点运营考核EID(OK)

7、每个阶段总分计入到SCORE0中，自评暂定放在原处SCORE9

8、合规联络人有8个人未基于模板填写，明天先邮件通知，再逐个联系

(BS)年度考核-普通员工(二级营业部)年度排名(一级营业部兼职)

*** 修改二级营业部考核中存在score_status=3的kpidep需要修改成adminid