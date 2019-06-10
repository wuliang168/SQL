USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[Pro_ItemsViewDrop](
    @RetVal int=0
)
AS
Begin

    -- 判断视图是否存在
    if Exists(select 1 from information_schema.views where TABLE_NAME=N'pVW_ItemsSearch_varchar')
    BEGIN
        -- 删除视图
        DROP VIEW pVW_ItemsSearch_varchar
    END
    
End