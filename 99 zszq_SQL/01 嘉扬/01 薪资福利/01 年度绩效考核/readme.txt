1���޸ķֹ�˾�����˺�һ��Ӫҵ�������˵Ŀ���˳��(OK)
2���޸���������Ҫ�Ĺ�������������
b.SCORE_EID AS approver, 1 AS id
FROM pscore a, pscore b
where a.eid=b.eid AND a.SCORE_TYPE = 4
AND (a.SCORE_status = 1 AND isnull(a.Initialized, 0) = 1 AND ISNULL(a.submit, 0) = 1)
AND (b.SCORE_status = 2 AND isnull(b.Initialized, 0) = 1 AND ISNULL(b.submit, 0) = 0)


3���޸Ĳ��ſ��˿���PSP�ļ�(OK)

4���޸Ĳ��ſ��˹ر�PSP�ļ����������δ���л�����ǿ�ƹر�(OK)


5������������ͨԱ��

6���޸ķֹ�˾�����˺�һ��Ӫҵ�������˺Ϲ��������Ӫ����EID(OK)

7��ÿ���׶��ּܷ��뵽SCORE0�У������ݶ�����ԭ��SCORE9

8���Ϲ���������8����δ����ģ����д���������ʼ�֪ͨ���������ϵ

(BS)��ȿ���-��ͨԱ��(����Ӫҵ��)�������(һ��Ӫҵ����ְ)

*** �޸Ķ���Ӫҵ�������д���score_status=3��kpidep��Ҫ�޸ĳ�adminid