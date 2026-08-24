# SSIS Inventory — NBU_ETL

## Активні пакети в SSISDB (NBU / NBU_ETL)

| Package | Active Version (package_id) | version_build |
|--------|------------------------------|---------------|
| IR14.dtsx | 1587 | 51 |
| IR15.dtsx | 1588 | 56 |
| IR20.dtsx | 1590 | 99 |
| IR21.dtsx | 1583 | 10 |
| IRB.dtsx  | 1585 | 25 |
| IRN2.dtsx | 1584 | 7 |
| IRPL.dtsx | 1591 | 77 |
| OI_Acts.dtsx | 1589 | 31 |
| ServiceBase.dtsx | 1586 | 4 |

## Пакети в локальному проєкті (NBU.dtproj)

IR14.dtsx  
IR15.dtsx  
IR20.dtsx  
IR21.dtsx  
IRB.dtsx  
IRN2.dtsx  
IRPL.dtsx  
OI_Acts.dtsx  
ServiceBase.dtsx  
IR14_6.dtsx  
IR15_6.dtsx  
FA.dtsx  
1_DataBusSec.dtsx  
IR27.dtsx  
NBU_KZ_Terminated.dtsx  
IR23.dtsx  
BankInfo.dtsx  

## Зайві пакети (локально, але не деплоєні)

IR14_6.dtsx  
IR15_6.dtsx  
FA.dtsx  
1_DataBusSec.dtsx  
BankInfo.dtsx  

## Висновок

Локальний проєкт містить **усі бойові пакети**, але також **8 зайвих**, які треба винести в `/ssis/archive/`.
