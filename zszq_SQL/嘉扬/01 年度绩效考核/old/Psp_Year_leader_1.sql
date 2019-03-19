USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_Year_leader_1]    Script Date: 12/16/2016 17:28:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_Year_leader_1]  --Psp_Year_leader_1 1297,1,1                                                       
@SCORE_Eid int,                        
@type int, -- score_type=perole
@URID int,                                                            
@RetVal int=0 OutPut                                                             
as
/**          
*** 考核递交评分结果
*** Pscore_temp
*** pSCORE：员工评分及排名信息
*** 总部负责人
**** score1：年度工作评分(百分制)
**** WEIGHT1：年度工作权重
**** score2：履职情况打分(百分制)
**** WEIGHT2：履职情况权重
**** SCORE5：目前得分(80*40%+20分)
**** SCORE6：分管领导评分（80分）
**** WEIGHT6：分管领导权重
**** score9：小计(80分)
**** SCORE8：胜任素质测评（20分）
**** WEIGHT：总裁权重(%)
**** SCORETOTAL：总计
**** 普通员工
**** score1：工作业绩(50分)
**** score2：工作纪律性(5分)
**** score3：上进意识(5分)
**** score4：工作主动性(10分)
**** score5：沟通协调能力(5分)
**** score6：团队协作能力(5分)
**** score7：学习发展能力(10分)
**** score8：合规风控有效性(10分)
**** score9：评分小计
**** score12：其他上级评分
**** score13：员工互评
**** score14：兼职合规得分
**** SCORETOTAL：总分
**/
begin

    -------- Pscore --------
    -------- 总部部门负责人 考核评分判断 --------
    -- @type=12,           -- 总部部门负责人 分管领导评分
    if @Type in (12)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=1
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=1
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=13,           -- 总部部门负责人 总裁评分
    if @Type in (13)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a, pscore as b
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_TYPE=1 AND a.eid=b.eid 
            AND ((a.SCORE_STATUS=3 AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1)
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100)))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a, pscore as b
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_TYPE=1 AND a.eid=b.eid 
            AND ((a.SCORE_STATUS=3 AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1)
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0)))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 总部部门副职 考核评分判断 --------
    -- @type=22,           -- 总部部门副职 总部部门负责人评分
    if @Type in (22)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=2
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=2
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=23,           -- 总部部门副职 分管领导评分
    if @Type in (23)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as b,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid  AND a.eid=b.eid AND b.SCORE_STATUS=2 AND ISNULL(b.SUBMIT,0)=1 AND a.SCORE_TYPE IN (2)
            AND ((a.SCORE_STATUS=3 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=3 AND (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=16 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as b,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid  AND a.eid=b.eid AND b.SCORE_STATUS=2 AND ISNULL(b.SUBMIT,0)=1 AND a.SCORE_TYPE IN (2)
            AND ((a.SCORE_STATUS=3 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=3 AND (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=16 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 子公司部门负责人 考核评分判断 --------
    -- @type=102,           -- 子公司部门负责人 子公司总经理评分
    if @Type in (102)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=10
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=10
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=103,           -- 子公司部门负责人 总裁评分
    if @Type in (103)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a, pscore as b
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS=3 AND a.SCORE_TYPE=10
            AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a, pscore as b
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS=3 AND a.SCORE_TYPE=10
            AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 分公司负责人/一级营业部负责人 考核评分判断 --------
    -- @type=2452,           -- 分公司负责人/一级营业部负责人 网点运营管理总部评分
    if @Type in (2452)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE IN (24,5)
            and (isnull(Score1,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE IN (24,5)
            and (isnull(Score1,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=2453,           -- 分公司负责人/一级营业部负责人 合规审计部评分
    if @Type in (2453)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=3 AND SCORE_TYPE IN (24,5)
            and (isnull(Score1,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=3 AND SCORE_TYPE IN (24,5)
            and (isnull(Score1,0)=0))
                begin
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=2454,           -- 分公司负责人/一级营业部负责人 分管领导评分
    if @Type in (2454)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=4 AND SCORE_TYPE IN (24,5)
            and (isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=4 AND SCORE_TYPE IN (24,5)
            and (isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=2455,           -- 分公司负责人/一级营业部负责人 总裁评分
    if @Type in (2455)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a, pscore as b,pscore as c, pscore as d
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS=5 AND a.SCORE_TYPE IN (24,5)
            AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1
            AND a.eid=c.eid AND c.SCORE_STATUS=3 AND isnull(c.SUBMIT,0)=1
            AND a.eid=d.eid AND d.SCORE_STATUS=4 AND isnull(d.SUBMIT,0)=1
            and (isnull(a.Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a, pscore as b,pscore as c, pscore as d
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS=5 AND a.SCORE_TYPE IN (24,5)
            AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1
            AND a.eid=c.eid AND c.SCORE_STATUS=3 AND isnull(c.SUBMIT,0)=1
            AND a.eid=d.eid AND d.SCORE_STATUS=4 AND isnull(d.SUBMIT,0)=1
            and (isnull(a.Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 分公司副职/一级营业部副职/二级营业部经理室 考核评分判断 --------
    -- @type=25672,           -- 分公司副职/一级营业部副职/二级营业部经理室 分公司/一级营业部负责人评分
    if @Type in (25672)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE IN (25,6,7)
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100
            or isnull(Score7,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE IN (25,6,7)
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0
            or isnull(Score7,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=25673,           -- 分公司副职/一级营业部副职/二级营业部经理室 分管领导评分
    if @Type in (25673)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as b,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid 
            and a.eid=b.eid and b.SCORE_STATUS=2 and isnull(b.submit,0)=1  
            AND ((a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (25,6,7) AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (25,6,7) AND (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100
            or isnull(a.Score7,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as b,pscore as c
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid 
            and a.eid=b.eid and b.SCORE_STATUS=2 and isnull(b.submit,0)=1
            AND ((a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (25,6,7) AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (25,6,7) AND (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0
            or isnull(a.Score7,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 总部普通员工 评分判断 --------
    -- @type=42,           -- 总部普通员工 总部部门负责人评分
    if @Type in (42)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid  
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (4) AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (4) and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=16 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0) not between 0 and 50
            or isnull(a.Score2,0) not between 0 and 5
            or isnull(a.Score3,0) not between 0 and 5
            or isnull(a.Score4,0) not between 0 and 10
            or isnull(a.Score5,0) not between 0 and 5
            or isnull(a.Score6,0) not between 0 and 5
            or isnull(a.Score7,0) not between 0 and 10
            or isnull(a.Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 and a.eid=c.eid  
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (4) AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (4) and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=16 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0 
            or isnull(a.Score3,0)=0 
            or isnull(a.Score4,0)=0
            or isnull(a.Score5,0)=0 
            or isnull(a.Score6,0)=0 
            or isnull(a.Score7,0)=0 
            or isnull(a.Score8,0)=0))                                                     
                begin
                    Set @RetVal=1000050
                    Return @RetVal
                end 
        end

    -------- 子公司普通员工 评分判断 --------
    -- @type=112,           -- 子公司普通员工 子公司部门负责人评分
    if @Type in (112)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=11
            and (isnull(Score1,0) not between 0 and 50
            or isnull(Score2,0) not between 0 and 5
            or isnull(Score3,0) not between 0 and 5
            or isnull(Score4,0) not between 0 and 10
            or isnull(Score5,0) not between 0 and 5
            or isnull(Score6,0) not between 0 and 5
            or isnull(Score7,0) not between 0 and 10
            or isnull(Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=11
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0 
            or isnull(Score3,0)=0 
            or isnull(Score4,0)=0                             
            or isnull(Score5,0)=0 
            or isnull(Score6,0)=0 
            or isnull(Score7,0)=0 
            or isnull(Score8,0)=0))                                                     
                begin
                    Set @RetVal=1000050
                    Return @RetVal
                end 
        end


    -------- 分公司/一级营业部及二级营业部普通员工 评分判断 --------
    -- @type=2912131,           -- 分公司/一级营业部及二级营业部普通员工 一级营业部负责人评分
    if @Type in (2912132)
        begin
            -- 分公司普通员工
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as c
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=c.eid 
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (29) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (29) AND a.WEIGHT=70 and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0) not between 0 and 50
            or isnull(a.Score2,0) not between 0 and 5
            or isnull(a.Score3,0) not between 0 and 5
            or isnull(a.Score4,0) not between 0 and 10
            or isnull(a.Score5,0) not between 0 and 5
            or isnull(a.Score6,0) not between 0 and 5
            or isnull(a.Score7,0) not between 0 and 10
            or isnull(a.Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as c
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=c.eid
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (29) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (29) AND a.WEIGHT=70 and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0 
            or isnull(a.Score3,0)=0 
            or isnull(a.Score4,0)=0
            or isnull(a.Score5,0)=0 
            or isnull(a.Score6,0)=0 
            or isnull(a.Score7,0)=0 
            or isnull(a.Score8,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal
                end 
            -- 一级营业部普通员工
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as c
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=c.eid
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (12) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (12) AND a.WEIGHT=70 and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0) not between 0 and 50
            or isnull(a.Score2,0) not between 0 and 5
            or isnull(a.Score3,0) not between 0 and 5
            or isnull(a.Score4,0) not between 0 and 10
            or isnull(a.Score5,0) not between 0 and 5
            or isnull(a.Score6,0) not between 0 and 5
            or isnull(a.Score7,0) not between 0 and 10
            or isnull(a.Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as c
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=c.eid
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (12) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (12) AND a.WEIGHT=70 and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0 
            or isnull(a.Score3,0)=0 
            or isnull(a.Score4,0)=0
            or isnull(a.Score5,0)=0 
            or isnull(a.Score6,0)=0 
            or isnull(a.Score7,0)=0 
            or isnull(a.Score8,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal
                end 
            -- 二级营业部普通员工
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore as a,pscore as b,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=b.eid and a.eid=c.eid  
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (13) AND a.WEIGHT=70 and c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=0 and (b.SCORE_STATUS=2 AND ISNULL(b.submit,0)=1))
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE=13 AND a.WEIGHT=40 and c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1 and b.SCORE_STATUS=2 AND ISNULL(b.submit,0)=1))
            and (isnull(a.Score1,0) not between 0 and 50
            or isnull(a.Score2,0) not between 0 and 5
            or isnull(a.Score3,0) not between 0 and 5
            or isnull(a.Score4,0) not between 0 and 10
            or isnull(a.Score5,0) not between 0 and 5
            or isnull(a.Score6,0) not between 0 and 5
            or isnull(a.Score7,0) not between 0 and 10
            or isnull(a.Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from pscore as a,pscore as b,pscore as c 
            where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.eid=b.eid and a.eid=c.eid  
            AND ((a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
            OR (a.SCORE_STATUS=2 AND a.SCORE_TYPE IN (13) AND a.WEIGHT=70 and c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1)
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=0 and (b.SCORE_STATUS=2 AND ISNULL(b.submit,0)=1))
            OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE=13 AND a.WEIGHT=40 and c.SCORE_STATUS=7 AND isnull(a.compliance,0)=15 AND ISNULL(c.submit,0)=1 and b.SCORE_STATUS=2 AND ISNULL(b.submit,0)=1))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0 
            or isnull(a.Score3,0)=0 
            or isnull(a.Score4,0)=0
            or isnull(a.Score5,0)=0 
            or isnull(a.Score6,0)=0 
            or isnull(a.Score7,0)=0 
            or isnull(a.Score8,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal
                end 
        end


    -------- 二级营业部普通员工 评分判断 --------
    -- @type=132,           -- 二级营业部普通员工 二级营业部负责人评分
    if @Type in (132)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=13 AND WEIGHT=30
            and (isnull(Score1,0) not between 0 and 50
            or isnull(Score2,0) not between 0 and 5
            or isnull(Score3,0) not between 0 and 5
            or isnull(Score4,0) not between 0 and 10
            or isnull(Score5,0) not between 0 and 5
            or isnull(Score6,0) not between 0 and 5
            or isnull(Score7,0) not between 0 and 10
            or isnull(Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=2 AND SCORE_TYPE=13 AND WEIGHT=30
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0 
            or isnull(Score3,0)=0 
            or isnull(Score4,0)=0                             
            or isnull(Score5,0)=0 
            or isnull(Score6,0)=0 
            or isnull(Score7,0)=0 
            or isnull(Score8,0)=0))                                                     
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end


    -------- 区域财务经理 评分判断 --------
    -- @type=171,           -- 区域财务经理 营业部负责人考核评分
    if @Type in (171)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1) AND SCORE_TYPE=17
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1) AND SCORE_TYPE=17
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))                                                   
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end
    -- @type=172,           -- 区域财务经理 计划财务部负责人评分
    if @Type in (172)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (2) AND SCORE_TYPE=17
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (2) AND SCORE_TYPE=17
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))                                                   
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end
    -- @type=173,           -- 区域财务经理 财务总监评分
    if @Type in (173)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from Pscore AS a, Pscore AS b, Pscore AS c
            Where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=17
            AND (a.EID=b.EID AND isnull(b.SUBMIT,0)=1 AND b.SCORE_STATUS in (2))
            AND (a.EID=c.EID AND not exists (select 1 from pscore where EID = c.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=17))
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore AS a, Pscore AS b, Pscore AS c
            Where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=17
            AND (a.EID=b.EID AND isnull(b.SUBMIT,0)=1 AND b.SCORE_STATUS in (2))
            AND (a.EID=c.EID AND not exists (select 1 from pscore where EID = c.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=17))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0))                                                   
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end


    -------- 综合会计（集中） 评分判断 --------
    -- @type=191,           -- 综合会计（集中） 区域财务经理评分
    -- @type=192,           -- 综合会计（集中） 计划财务部负责人评分
    if @Type in (191,192)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1,2) AND SCORE_TYPE=19
            and (isnull(Score1,0) not between 0 and 50
            or isnull(Score2,0) not between 0 and 5
            or isnull(Score3,0) not between 0 and 5
            or isnull(Score4,0) not between 0 and 10
            or isnull(Score5,0) not between 0 and 5
            or isnull(Score6,0) not between 0 and 5
            or isnull(Score7,0) not between 0 and 10
            or isnull(Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1,2) AND SCORE_TYPE=19
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0 
            or isnull(Score3,0)=0 
            or isnull(Score4,0)=0                             
            or isnull(Score5,0)=0 
            or isnull(Score6,0)=0 
            or isnull(Score7,0)=0 
            or isnull(Score8,0)=0))                                                     
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end


    -------- 综合会计（非集中） 评分判断 --------
    -- @type=201,           -- 综合会计（非集中） 区域财务经理评分
    -- @type=202,           -- 综合会计（非集中） 分公司/营业部负责人评分
    if @Type in (201,202)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1,2) AND SCORE_TYPE=20
            and (isnull(Score1,0) not between 0 and 50
            or isnull(Score2,0) not between 0 and 5
            or isnull(Score3,0) not between 0 and 5
            or isnull(Score4,0) not between 0 and 10
            or isnull(Score5,0) not between 0 and 5
            or isnull(Score6,0) not between 0 and 5
            or isnull(Score7,0) not between 0 and 10
            or isnull(Score8,0) not between 0 and 10))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1,2) AND SCORE_TYPE=20
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0 
            or isnull(Score3,0)=0 
            or isnull(Score4,0)=0                             
            or isnull(Score5,0)=0 
            or isnull(Score6,0)=0 
            or isnull(Score7,0)=0 
            or isnull(Score8,0)=0))                                                     
                begin                                                                                
                    Set @RetVal=1000050                                                                                
                    Return @RetVal                                                                                
                end 
        end


    -------- 营业部合规风控专员 评分判断 --------
    -- @type=141,           -- 营业部合规风控专员 分公司/营业部负责人评分
    if @Type in (141)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1) AND SCORE_TYPE=14
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (1) AND SCORE_TYPE=14
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=142,           -- 营业部合规风控专员 合规审计部负责人评分
    if @Type in (142)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (2) AND SCORE_TYPE=14
            and (isnull(Score1,0) not between 0 and 100
            or isnull(Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS in (2) AND SCORE_TYPE=14
            and (isnull(Score1,0)=0 
            or isnull(Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end
    -- @type=143,           -- 营业部合规风控专员 合规风控总监考核
    if @Type in (143)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from Pscore AS a, Pscore AS b, Pscore AS c
            Where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=14
            AND (a.EID=b.EID AND isnull(b.SUBMIT,0)=1 AND b.SCORE_STATUS in (2))
            AND (a.EID=c.EID AND not exists (select 1 from pscore where EID = c.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=14))
            and (isnull(a.Score1,0) not between 0 and 100
            or isnull(a.Score2,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore AS a, Pscore AS b, Pscore AS c
            Where a.SCORE_EID=@SCORE_Eid AND isnull(a.SUBMIT,0)=0 AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=14
            AND (a.EID=b.EID AND isnull(b.SUBMIT,0)=1 AND b.SCORE_STATUS in (2))
            AND (a.EID=c.EID AND not exists (select 1 from pscore where EID = c.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=14))
            and (isnull(a.Score1,0)=0 
            or isnull(a.Score2,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 营业部合规联系人 评分判断 --------
    -- @type=157,           -- 营业部合规联系人 合规审计部负责人评分
    if @Type in (157)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=7 AND compliance=15
            AND (isnull(Score7,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=7 AND compliance=15
            AND (isnull(Score7,0)=0))                                                     
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    -------- 总部兼职合规专员 评分判断 --------
    -- @type=167,           -- 总部兼职合规专员 合规审计部负责人评分
    if @Type in (167)
        begin
            -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
            if exists (select 1 from pscore where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=7 AND compliance=16
            AND (isnull(Score7,0) not between 0 and 100))
                begin
                    Set @RetVal=1000070
                    Return @RetVal
                end
            -- 1000050	提交失败，每项评分都不能为空或等于0
            if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid AND isnull(SUBMIT,0)=0
            AND SCORE_STATUS=7 AND compliance=16
            AND (isnull(Score7,0)=0))
                begin                                                                                
                    Set @RetVal=1000050
                    Return @RetVal                                                                                
                end 
        end


    Begin TRANSACTION

    -------- pSCORE --------
    -------- 总部部门负责人 评分及排名 --------
    -- @type=12,           -- 总部部门负责人 分管领导评分
    if @Type in (12)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=1 AND ISNULL(a.Submit,0)=0
        end
    -- @type=13,           -- 总部部门负责人 总裁评分及排名
    if @Type in (13)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=1 AND ISNULL(a.Submit,0)=0
          --AND a.eid=b.eid and b.SCORE_STATUS=2 and isnull(b.submit,0)=1
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE in (1)
          -- 临时添加
          update a
          set a.SCORE11=a.SCORE1*a.Weight1/100,a.SCORE12=a.SCORE2*a.Weight2/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=1 AND ISNULL(a.Submit,0)=1
        end

    -------- 总部部门副职 评分及排名 --------
    -- @type=22,           -- 总部部门副职 总部部门负责人评分
    if @Type in (22)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=2 AND ISNULL(a.Submit,0)=0
        end
    -- @type=23,           -- 总部部门副职 分管领导评分
    if @Type in (23)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a,pscore as b,pscore as c
          where a.SCORE_EID=@SCORE_Eid AND a.EID=c.EID AND ISNULL(a.Submit,0)=0
          --AND a.eid=b.eid AND b.SCORE_STATUS=2 and isnull(b.submit,0)=1
          AND ((a.SCORE_STATUS in (3) AND a.SCORE_TYPE in (2) AND isnull(a.compliance,0)=0)
          OR (a.SCORE_STATUS in (3) AND a.SCORE_TYPE in (2) AND isnull(a.compliance,0)=16 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1))
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE in (2)
          -- 临时添加
          update a
          set a.SCORE11=a.SCORE1*a.Weight1/100,a.SCORE12=a.SCORE2*a.Weight2/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=2 AND ISNULL(a.Submit,0)=1
        end

    -------- 子公司部门负责人 评分及排名--------
    -- @type=102,           -- 子公司部门负责人 子公司总经理评分
    if @Type in (102)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=10 AND ISNULL(a.Submit,0)=0
        end
    -- @type=103,           -- 子公司部门负责人 总裁评分及排名
    if @Type in (103)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=10 AND ISNULL(a.Submit,0)=0
          AND a.eid=b.eid AND b.SCORE_STATUS=2 and isnull(b.submit,0)=1
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE in (10)
          update a
          set a.SCORE11=a.SCORE1*a.Weight1/100,a.SCORE12=a.SCORE2*a.Weight2/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=10 AND ISNULL(a.Submit,0)=1
        end

    -------- 分公司负责人/一级营业部负责人 评分及排名 --------
    -- @type=2452,           -- 分公司负责人/一级营业部负责人 网点运营管理总部评分
    if @Type in (2452)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=0
          -- 临时添加
          update a
          set a.SCORE11=a.SCORE9*a.Weight/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=1
        end
    -- @type=2453,           -- 分公司负责人/一级营业部负责人 合规审计部评分
    if @Type in (2453)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=0
        end
    -- @type=2454,           -- 分公司负责人/一级营业部负责人 分管领导评分
    if @Type in (2454)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (4) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=0
        end
    -- @type=2455,           -- 分公司负责人/一级营业部负责人 总裁评分
    if @Type in (2455)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a, pscore as b,pscore as c, pscore as d
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (5) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=0
          AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.SUBMIT,0)=1
          AND a.eid=c.eid AND c.SCORE_STATUS=3 AND isnull(c.SUBMIT,0)=1
          AND a.eid=d.eid AND d.SCORE_STATUS=4 AND isnull(d.SUBMIT,0)=1
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (5) AND b.SCORE_TYPE in (24,5)
          update a
          set a.SCORE11=a.SCORE1*a.Weight1/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE in (24,5) AND ISNULL(a.Submit,0)=1
          -- 临时添加
          update a
          set a.SCORE11=a.SCORE9*a.Weight/100
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE IN (24,5) AND ISNULL(a.Submit,0)=1
        end

    -------- 分公司副职/一级营业部副职/二级营业部经理室 评分及排名 --------
    -- @type=25672,           -- 分公司副职/一级营业部副职/二级营业部经理室 分公司/一级营业部负责人评分
    if @Type in (25672)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE IN (25,6,7) AND ISNULL(a.Submit,0)=0
        end
    -- @type=25673,           -- 分公司副职/一级营业部副职/二级营业部经理室 分管领导评分
    if @Type in (25673)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a,pscore as b,pscore as c
          where a.SCORE_EID=@SCORE_Eid AND ISNULL(a.Submit,0)=0 AND a.EID=c.EID
          --AND a.eid=b.eid AND b.SCORE_STATUS=2 AND isnull(b.submit,0)=1
          AND ((a.SCORE_STATUS in (3) AND a.SCORE_TYPE in (25,6,7) AND isnull(a.compliance,0)=0)
          OR (a.SCORE_STATUS in (3) AND a.SCORE_TYPE in (25,6,7) AND isnull(a.compliance,0)=15 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1))
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE in (25,6,7)
        end

    -------- 总部普通员工 评分及排名 --------
    -- @type=42,           -- 总部普通员工 总部部门负责人评分及排名
    if @Type in (42)
        begin
        -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a,pscore as c
          where a.SCORE_EID=@SCORE_Eid AND a.EID=c.EID AND ISNULL(a.Submit,0)=0
          AND ((a.SCORE_STATUS in (2) AND a.SCORE_TYPE in (4) AND isnull(a.compliance,0)=0)
          OR (a.SCORE_STATUS in (2) AND a.SCORE_TYPE in (4) AND isnull(a.compliance,0)=16 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1))
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (2) AND b.SCORE_TYPE=4
        end

    -------- 子公司普通员工 评分及排名 --------
    -- @type=112,           -- 子公司普通员工 子公司部门负责人评分及排名
    if @Type in (112)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE(),a.ranking=(select ranking1 from pvw_ranking where eid=a.eid)
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=11 AND ISNULL(a.Submit,0)=0
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (2) AND b.SCORE_TYPE=11
        end

    -------- 分公司/一级营业部及二级营业部普通员工 评分 --------
    -- @type=2912132,           -- 分公司/一级营业部及二级营业部普通员工 分公司/一级营业部负责人评分及排名
    if @Type in (2912132)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a,pscore as b,pscore as c
          where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=c.EID AND ISNULL(a.Submit,0)=0
          AND ((a.SCORE_STATUS in (2) AND a.SCORE_TYPE in (29,12,13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0)
          OR (a.SCORE_STATUS in (2) AND a.SCORE_TYPE in (29,12,13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=15 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1)
          OR (a.SCORE_STATUS in (3) AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=0 AND b.SCORE_STATUS=2 AND ISNULL(b.SUBMIT,0)=1)
          OR (a.SCORE_STATUS in (3) AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=15 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1 AND b.SCORE_STATUS=2 AND ISNULL(b.SUBMIT,0)=1))
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1
          AND ((b.SCORE_STATUS in (2) AND b.SCORE_TYPE in (29,12,13) AND WEIGHT=70)
          OR (b.SCORE_STATUS in (3) AND b.SCORE_TYPE=13 AND b.WEIGHT=40))
        end

    -------- 二级营业部普通员工 评分 --------
    -- @type=132,           -- 二级营业部普通员工 二级营业部负责人评分
    if @Type in (132)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=13 AND ISNULL(a.Submit,0)=0
        end

    -------- 区域财务经理 评分及排名 --------
    -- @type=171,           -- 区域财务经理 营业部负责人考核评分
    if @Type in (171)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (1) AND a.SCORE_TYPE=17 AND ISNULL(a.Submit,0)=0
          -- 统计考核平均分
          update b
          set b.score11=(select AVG(SCORE9) from pscore where eid=c.eid and SCORE_STATUS=1 AND SCORE_TYPE=17 AND ISNULL(Submit,0)=1)
          from pscore as b,pscore as c
          where c.SCORE_EID=@SCORE_Eid AND c.SCORE_STATUS=1 AND c.SCORE_TYPE=17 AND ISNULL(c.Submit,0)=1
          AND b.eid=c.eid and b.SCORE_STATUS=3 AND b.SCORE_TYPE=17 AND ISNULL(b.Submit,0)=0
        end
    -- @type=172,           -- 区域财务经理 计划财务部负责人评分
    if @Type in (172)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=17 AND ISNULL(a.Submit,0)=0
        end
    -- @type=173,           -- 区域财务经理 财务总监评分及排名
    if @Type in (173)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=17 AND ISNULL(a.Submit,0)=0 AND a.eid=b.eid
          AND not exists (select 1 from pscore where EID = b.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=17)
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE=17
        end

    -------- 综合会计（集中） 评分及排名 --------
    -- @type=191,           -- 综合会计（集中） 区域财务经理评分
    if @Type in (191)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (1) AND a.SCORE_TYPE=19 AND ISNULL(a.Submit,0)=0
        end
    -- @type=192,           -- 综合会计（集中） 计划财务部负责人评分及排名
    if @Type in (192)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=19 AND ISNULL(a.Submit,0)=0
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (2) AND b.SCORE_TYPE=19
        end

    -------- 综合会计（非集中） 评分及排名 --------
    -- @type=201,           -- 综合会计（非集中） 区域财务经理评分
    if @Type in (201)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (1) AND a.SCORE_TYPE=20 AND ISNULL(a.Submit,0)=0
        end
    -- @type=202,           -- 综合会计（非集中） 分公司/营业部负责人评分及排名
    if @Type in (202)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=20 AND ISNULL(a.Submit,0)=0
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (2) AND b.SCORE_TYPE=20
        end

    -------- 营业部合规风控专员 评分及排名 --------
    -- @type=141,           -- 营业部合规风控专员 分公司/营业部负责人评分
    if @Type in (141)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (1) AND a.SCORE_TYPE=14 AND ISNULL(a.Submit,0)=0
          -- 统计考核平均分
          update b
          set b.score11=(select AVG(SCORE9) from pscore where eid=c.eid and SCORE_STATUS=1 AND SCORE_TYPE=14 AND ISNULL(Submit,0)=1)
          from pscore as b,pscore as c
          where c.SCORE_EID=@SCORE_Eid AND c.SCORE_STATUS=1 AND c.SCORE_TYPE=14 AND ISNULL(c.Submit,0)=1
          AND b.eid=c.eid and b.SCORE_STATUS=3 AND b.SCORE_TYPE=14 AND ISNULL(b.Submit,0)=0
        end
    -- @type=142,           -- 营业部合规风控专员 合规审计部负责人评分
    if @Type in (142)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (2) AND a.SCORE_TYPE=14 AND ISNULL(a.Submit,0)=0
        end
    -- @type=143,           -- 营业部合规风控专员 合规风控总监考核及排名
    if @Type in (143)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a, pscore as b
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (3) AND a.SCORE_TYPE=14 AND ISNULL(a.Submit,0)=0 AND a.eid=b.eid
          AND not exists (select 1 from pscore where EID = b.EID and ISNULL(submit,0)=0 AND SCORE_STATUS=1 AND SCORE_TYPE=14)
          -- 刷新员工排名
          update b
          set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
          from pscore as b
          where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE=14
        end

    -------- 营业部合规联系人 评分 --------
    -- @type=157,           -- 营业部合规联系人 合规审计部负责人评分
    if @Type in (157)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (7) AND a.compliance=15 AND ISNULL(a.Submit,0)=0
        end

    -------- 总部兼职合规专员 评分 --------
    -- @type=167,           -- 总部兼职合规专员 合规审计部负责人评分
    if @Type in (167)
        begin
          -- 考核评分确认
          update a
          set a.submit=1,a.submitby=@URID,a.submittime=GETDATE()
          from pscore as a
          where a.SCORE_EID=@SCORE_Eid AND a.SCORE_STATUS in (7) AND a.compliance=16 AND ISNULL(a.Submit,0)=0
        end

    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal
end 
