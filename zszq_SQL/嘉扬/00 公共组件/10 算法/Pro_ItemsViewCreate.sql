USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[Pro_ItemsViewCreate](
    @DBTable varchar(100),
    @varItem varchar(100),
    @RetVal int=0
)
AS
Begin

    /* 定义动态SQL
    -- 基于varItem
    */
    declare @sql varchar(200)

    -- 判断视图是否存在
    if Exists(select 1 from information_schema.views where TABLE_NAME=N'pVW_ItemsSearch_varchar')
    BEGIN
        set @sql='ALTER VIEW pVW_ItemsSearch_varchar
        AS
            select ROW_NUMBER() over(order by '+@varItem+') as No, '+@varItem+' as Item
            from '+@DBTable+'
        GO'
    END
    ELSE
    BEGIN
        set @sql='CREATE VIEW pVW_ItemsSearch_varchar
        AS
            select ROW_NUMBER() over(order by '+@varItem+') as No, '+@varItem+' as Item
            from '+@DBTable+'
        GO'
    END

    /* 创建/更新视图
    -- 基于varItem排序
    */
    exec(@sql)

End