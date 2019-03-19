USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[PSP_ProcessYearMutualdeleByDep]    Script Date: 12/19/2016 15:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- PSP_ProcessYearMutualdeleByDep 354,1
ALTER proc [dbo].[PSP_ProcessYearMutualdeleByDep]       
@id int,                
@URID int,                
@RetVal int=0 output           
as
/**
*** 部门普通员工互评考核关闭
*** PASSDEP_PROCESS：
*** pscore：
*** 
*** 
**/
begin 

    -- 1100013	该部门互评和胜任素质测试未开启，无法关闭
    if exists(select 1 from PASSDEP_PROCESS where id=@id and ISNULL(regby,0)=0)
        begin              
            set @RetVal=1100013
            return @RetVal
        end  


    Begin TRANSACTION

    -------- PASSDEP_PROCESS --------
    -- 更新ClosedTime、Closed和Closedby
    update a
    set a.ClosedTime=GETDATE(),a.Closed=1,Closedby=@URID
    from PASSDEP_PROCESS a          
    where id=@id
    -- 异常处理    
    IF @@Error <> 0
    Goto ErrM
    

    -------- pscore --------
    -- 更新score_status
    --------- 普通员工测评 --------
    -- sLevel 1：员工互评
    -- 4-总部普通员工；29-分公司普通员工；11-子公司普通员工；12-一级营业部普通员工；13-二级营业部普通员工
    -- 暂不使用
    update pscore 
    set Closed=1, ClosedTime=GETDATE(),Closedby=@URID
    where KpiDep=@id and SCORE_TYPE in (4,29,11,12,13) AND SCORE_STATUS=1
    -- 异常处理    
    IF @@Error <> 0
    Goto ErrM

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