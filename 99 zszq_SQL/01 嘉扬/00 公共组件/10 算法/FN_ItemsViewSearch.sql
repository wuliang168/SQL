USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Function [dbo].[FN_ItemsViewSearch](
    @varSearch varchar(100)
)
RETURNS int
AS
Begin


    -- 基于varSearch搜索
    declare @low int,@high int,@mid int,@itemTmp varchar(100),@RetVal int=0
    set @low=1
    set @high=(select MAX(No) from pVW_ItemsSearch_varchar)
    
    while @low <= @high
    BEGIN
        set @mid = (@low + @high)/2
        set @itemTmp = (select Item from pVW_ItemsSearch_varchar where No=@mid)
        if @itemTmp = @varSearch
        BEGIN
            set @RetVal=1
        END
        if @itemTmp > @varSearch
        BEGIN
            set @high = @mid - 1
        END
        else
        BEGIN
            set @low = @mid + 1
        END
    END

    -- 默认返回0
    return @RetVal

End