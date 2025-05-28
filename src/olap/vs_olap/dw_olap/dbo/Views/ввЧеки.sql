


CREATE VIEW [dbo].[ввЧеки]
AS
SELECT        r.DocDate, CAST(r.DocRef as uniqueidentifier) DocRef, CAST(d.GoodsDetailId as uniqueidentifier) GoodsDetailId, CAST(d.Goods as uniqueidentifier) Goods, CASE WHEN [IsSale] = 1 THEN 1 ELSE - 1 END * d.Count AS Count, CASE WHEN [IsSale] = 1 THEN 1 ELSE - 1 END * d.Price AS Price, 
                         CASE WHEN [IsSale] = 1 THEN 1 ELSE - 1 END * d.Sum AS Sum, CASE WHEN [IsSale] = 1 THEN 1 ELSE 0 END * d.Sum AS SumSale, CASE WHEN [IsSale] = 1 THEN 0 ELSE - 1 END * d.Sum AS SumReturn, 
                         CASE WHEN [IsSale] = 1 THEN 1 ELSE 0 END * d.SumCash AS SumCashSale, CASE WHEN [IsSale] = 1 THEN 0 ELSE - 1 END * d.SumCash AS SumCashReturn, 
                         CASE WHEN [IsSale] = 1 THEN 1 ELSE 0 END * d.SumTerminal AS SumTerminalSale, CASE WHEN [IsSale] = 1 THEN 0 ELSE - 1 END * d.SumTerminal AS SumTerminalReturn, r.IsSale, CAST(d.RetailDocCashierCheckDocRef as uniqueidentifier) RetailDocCashierCheckDocRef, 
                         DATEADD(hour, DATEDIFF(hour, 0, r.DocDate), 0) AS date,CAST(r.StoreRef as uniqueidentifier) StoreRef, CASE WHEN [IsSale] = 1 THEN 1 ELSE - 1 END * CASE WHEN r.[Sum] = 0 THEN 0 ELSE (ROUND(d .[Sum] / r.[Sum], 4)) END AS weight, 
                         CASE WHEN [IsSale] = 1 THEN 1 ELSE 0 END * CASE WHEN r.[Sum] = 0 THEN 0 ELSE (ROUND(d .[Sum] / r.[Sum], 4)) END AS weightSale, 
                         CASE WHEN [IsSale] = 1 THEN 0 ELSE - 1 END * CASE WHEN r.[Sum] = 0 THEN 0 ELSE (ROUND(d .[Sum] / r.[Sum], 4)) END AS weightReturn, r.CashRegisterShiftNumber
FROM           REAL_tabakon.dbo.RetailDocCashierCheck AS r INNER JOIN
                         REAL_tabakon.dbo.RetailDocCashierCheck_GoodsDetail AS d ON d.RetailDocCashierCheckDocRef = r.DocRef

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 346
               Bottom = 136
               Right = 595
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ввЧеки';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ввЧеки';

