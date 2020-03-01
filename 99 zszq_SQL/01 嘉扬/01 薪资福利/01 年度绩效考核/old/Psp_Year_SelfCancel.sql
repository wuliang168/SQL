USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_Year_SelfCancel]    Script Date: 12/24/2016 22:27:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_Year_SelfCancel]                             
@id int,                                  
@URID int,                                    
@RetVal int=0 OutPut                                     
as                                    
begin                        
    declare @EID varchar(20),                                
    @badge varchar(20),                               
    @pProcessID varchar(20) ,                            
    @SCORE_STATUS varchar(20),    
    @SCORE_Type  varchar(20)         

    -- 获取@pProcessID(年度考核ID)，@EID(员工EID)，@badge(员工工号)，@SCORE_Status(员工考核阶段)
    select @pProcessID=pProcessID from pscore where id=@id                       
    select @EID=EID from pscore where id=@id                                 
    select @badge=badge from pscore where id=@id                    
    select @SCORE_STATUS=SCORE_STATUS,@SCORE_Type=SCORE_Type from Pscore where id=@id            

    -- 1100035	数据还未提交，不需取消！
    if exists (select 1 from pscore where  id=@id and isnull(Submit,0)=0)                                                        
    begin
        Set @RetVal=1100035
        Return @RetVal
    end           
           
    Begin TRANSACTION                                    
    -------- pEmpProcess_Year --------
    -- 更新员工年度考核表
    -- 更新score_status(年度考核阶段，0-自评开始)
    update a                                
    set a.score_status=0                               
    from pEmpProcess_Year a                                
    where eid=@eid                                
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM           


    -------- PYEAR_LZ --------
    -- 更新员工年度个人总结表
    -- 更新SubmitTime(递交时间)和Submit(递交状态)
    update a
    set a.SubmitTime=NULL,a.Submit=NULL
    from PYEAR_LZ a
    where a.Sid=@id
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM                   


    -------- pYear_GS --------
    -- 更新员工年度主要工作内容表
    -- 更新SubmitTime(递交时间)和Submit(递交状态) 
    update a                      
    set a.SubmitTime=NULL,a.Submit=NULL              
    from pYear_GS a                      
    where a.badge=@badge and SCORE_Type=@SCORE_Type                      
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM 
           
    -------- pSCORE --------
    -- 更新员工评分及排名信息表
    -- 更新SubmitTime(初始化时间)和Submit(初始化状态)            
    update a                        
    set a.SubmitTime=NULL,a.Submit=NULL
    from pSCORE a              
    where id=@ID                        
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