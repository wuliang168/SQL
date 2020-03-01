USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_EMPCheckUp]
    @RetVal int=0 Output
as
Begin

    Begin TRANSACTION


    -- 6月17日
    IF DATEDIFF(dd,GETDATE(),'2019-06-17 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777839812', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958010115', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18038160228', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15967126903', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667174006', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658183766', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958174546', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18222891890', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15381658197', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18606510037', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869185827', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13621904970', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13605804556', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18767150706', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13601370177', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757103562', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13026325398', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18616377193', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758165807', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958167769', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13634165618', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958061989', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858095857', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968814197', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158112505', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18506822355', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13456200931', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758102095', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13818515273', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13706504214', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777868603', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968397049', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15824436764', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819195218', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15505759796', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606626018', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858026878', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088656931', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15900774433', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13685779760', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868811807', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858297975', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738171911', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18958025993', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868059917', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13067756940', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738089060', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956193', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13705814185', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13456994890', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735534020', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13989584321', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13626719205', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657199339', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17764569379', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758702956', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15325880048', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13805790998', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957152606', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968166128', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958057294', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13810886281', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18698568585', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月18日
    IF DATEDIFF(dd,GETDATE(),'2019-06-18 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15221701587', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13575791501', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13335713695', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588869811', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968845000', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15888812470', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957198023', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15168245780', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588192625', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969079766', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738173445', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657118877', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956331', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957152603', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17858062621', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658816679', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18814803918', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958191636', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13567151059', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18267163308', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606621234', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732287521', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17098073668', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13600530920', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658810750', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957192482', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15267097729', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13761733947', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657011333', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13605718283', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13810007300', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18506833981', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18072939019', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18257193981', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13566546625', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757119028', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968832624', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158805055', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15257195959', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758200054', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735438650', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968149618', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658198135', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18767135478', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958098090', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13336007889', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15924162218', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18072727007', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869126640', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819979123', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15757132139', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13093789389', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13666633605', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868710692', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17757176353', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18605880151', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13705718116', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13816783861', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968895300', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18867522797', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15669072863', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088347085', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月19日
    IF DATEDIFF(dd,GETDATE(),'2019-06-19 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819453158', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968093139', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15356639275', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588040568', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15958288413', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158865127', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588089748', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13806522667', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18566252165', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819462157', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588751050', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18857124764', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667026186', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18605711211', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13989850514', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15957113377', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18057127794', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732226029', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18936279553', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868805566', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18698587310', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18072749994', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658809160', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18167163964', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13575496578', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667107779', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13616856802', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668012888', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13967186554', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757602520', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18814862698', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18968128718', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13105715570', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13456739088', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15988865117', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15857506868', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18101840010', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15958196399', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675819903', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15996368578', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735825018', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18606509726', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658136822', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758262524', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588418593', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957189109', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969950207', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13357121545', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857107687', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18106569840', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088666850', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13335729417', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18705189940', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858102544', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968106564', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13282000709', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15990025753', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777428459', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858272735', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957109734', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13386525860', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15136234374', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月20日
    IF DATEDIFF(dd,GETDATE(),'2019-06-20 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675833315', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857110180', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588104585', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15606525525', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868016456', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668169089', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868897525', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868818815', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606618077', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658115736', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667107675', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757105901', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15692179175', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588825696', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15757198501', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18756072542', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15168205318', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15267912221', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18458425828', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13805783215', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668200915', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13867428501', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13685750710', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957167808', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969973983', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13071877706', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13750825226', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968180234', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15990115023', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732270864', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757196870', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13625720111', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13506817712', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13685755274', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738104683', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18270883366', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668010170', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18888957697', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13522772071', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13162576772', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13567960030', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15988110707', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15268141221', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15356638822', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13989892573', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957515705', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18857577171', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956301', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15267131781', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15221653161', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17706510608', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758035906', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18368194682', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17826830870', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15757187067', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869558866', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667911290', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588863888', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668200130', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13216167683', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957155818', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月21日
    IF DATEDIFF(dd,GETDATE(),'2019-06-21 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588090971', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732259464', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957151535', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675867318', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13515716184', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958060935', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606627990', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657115170', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18968181001', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15067160782', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658819996', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777433878', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588471887', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13967196267', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868111762', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13706817703', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13336199616', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732277991', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18683694021', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957181828', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858043066', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868129361', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088641647', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13071886688', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857146657', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158134128', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18694581110', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13616718870', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18605889426', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13646847018', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858283381', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18601257018', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13375710218', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18858135620', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858274079', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758074330', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735593758', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13750880903', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18698550201', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18814863039', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13376835050', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18106563318', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18202104993', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588335985', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18672973669', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15957180817', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15267035210', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18626868230', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857195599', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15057182061', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735571857', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735889264', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15967166797', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15967188879', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758985588', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18905710575', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13429224037', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13905815455', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18367365088', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15397107655', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738124562', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月24日
    IF DATEDIFF(dd,GETDATE(),'2019-06-24 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858255518', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957189128', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18857106869', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675887615', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657121351', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668141612', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858086532', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738172683', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13906525201', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957175628', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588407775', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13616525239', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858190456', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658820611', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13575459005', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667046619', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668489869', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757177299', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958135806', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15695712682', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13750827719', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869126550', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13732278585', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15305711677', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18606519155', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957108333', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588037599', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758235099', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13661822745', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738082437', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13018947736', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18368832813', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158021284', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968806590', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13620919167', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13396569995', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18817950369', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13750816989', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758272963', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18202541707', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657520891', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13666650975', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15888871929', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18505812158', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15801727604', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18205815661', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667214900', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18626890418', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17367073784', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957155557', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15397150688', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13123925946', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15990101298', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777891921', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13968191002', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18757107468', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13335814998', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13185711777', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819176640', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18612826936', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588061199', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月25日
    IF DATEDIFF(dd,GETDATE(),'2019-06-25 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758873195', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15658895101', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13989812900', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15325818788', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15700198584', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15557152526', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13185039481', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13901602816', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588079795', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667180755', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13634182105', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668106367', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18768107646', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18958086565', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868452206', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869158884', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15657176950', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869152643', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15549370360', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13951832756', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658803713', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15068193212', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958123400', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18989497289', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13819138171', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868060078', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18698585117', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15157168543', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668007700', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('17091600235', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15988141383', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18989878066', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588752461', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588017081', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18258162051', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658137512', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588787632', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735577206', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15258816260', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13655810312', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869016858', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15967120415', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868009893', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18768114682', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18058702963', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869018168', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868706635', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158014686', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588037233', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868130196', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13867456286', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088636309', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675820073', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758102417', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15168492835', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18257027799', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758253013', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868416526', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868123132', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088686998', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13937575944', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月26日
    IF DATEDIFF(dd,GETDATE(),'2019-06-26 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18258190047', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13666660016', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869159217', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658889687', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858161258', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15356658297', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956329', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956330', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18667106556', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13575458942', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758216413', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957172077', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777550278', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956157', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15869195996', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735539520', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868843929', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588300083', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15068712296', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13615714560', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588709696', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15205811858', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588314498', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606618691', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18858104612', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658802632', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658841859', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15167763032', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13616751156', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18867133335', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18651890019', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13071817230', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15968177854', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18805712599', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13605718990', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18505815858', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18768460297', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15990117165', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868794105', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588117126', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777477574', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958114185', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758252836', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958122007', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18958026362', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13906525534', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777851007', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15990013972', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735808217', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957110153', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13757169345', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18049956285', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588817952', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957157298', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957180668', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18817875215', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18814882851', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957155718', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13906517424', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15068104099', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18758119184', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月27日
    IF DATEDIFF(dd,GETDATE(),'2019-06-27 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13736366870', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957189125', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13429663944', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868827340', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777876782', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658836482', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15067179825', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668111760', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15857130843', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588703712', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13615710703', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15267107449', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088677898', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15700128461', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13656686105', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13666633420', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15805712824', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158112679', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15658159035', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18106588619', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15805796126', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15058112891', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958029348', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13906525124', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18058850066', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735578735', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18626882856', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13805760804', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158107396', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13305818418', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15167397373', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13777592879', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13676801866', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13983232721', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758160571', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858076718', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13357186849', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18805712162', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18626876595', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13685779367', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18268060063', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18857879132', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13018980575', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735879065', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668109898', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088655739', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15867117558', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13429611693', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18868723335', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13157180991', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13357107688', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13362591111', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15336555065', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15268512578', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857196373', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15268540653', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18057016688', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18768127282', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858650725', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158810558', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13606640055', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END

    -- 6月28日
    IF DATEDIFF(dd,GETDATE(),'2019-06-28 0:0:0')=1
    BEGIN
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958488118', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957172075', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588845373', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957172081', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868051041', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13758270864', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958027491', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15558066316', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088615219', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13857151216', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13065536617', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15394201627', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15088717866', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956191', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13516707007', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858100527', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735899698', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657108599', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18368162833', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868471687', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18606504755', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13588143296', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658854022', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13738035443', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13967177808', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658156677', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13456892098', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957571224', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13735851971', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15158880242', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15868457969', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13957109392', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13883340380', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15998631167', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13805763393', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18818265063', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956318', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18221755325', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957198003', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15858177629', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969006035', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18657101200', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13615713258', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18969956308', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13868120943', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18658810719', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958197134', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18368664004', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15372583322', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13958033225', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13858119268', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13989889656', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13516719884', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13666676536', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('15168384378', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13675882998', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18957198018', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13906500593', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13456311595', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18867133352', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18668056950', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('13067809967', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        VALUES('18357146940', N'各位领导同事，您的体检日期安排在明天，请您于明天上午8:00至9:30期间到邵逸夫医院3号楼9楼护士站报到。因体检项目增加，医院体检资源较紧张，排队等候时间较长，请耐心等待，注意体检秩序，谢谢配合。。【人力资源部】');
    END


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

End