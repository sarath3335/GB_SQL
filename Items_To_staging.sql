Create table GB_Items_Staging (
ORGANIZATION_ID	Number,
ORGANIZATION_CODE Varchar2(100),
LAST_UPDATE_DATE date,	
LAST_UPDATED_BY	Varchar2(100),
CREATION_DATE	date,
CREATED_BY	Varchar2(100),
LAST_UPDATE_LOGIN	Varchar2(100),
DESCRIPTION	Varchar2(800),
SEGMENT1	Varchar2(100),
PRIMARY_UNIT_OF_MEASURE	Varchar2(100),
PRIMARY_UOM_CODE varchar2(100),
ITEM_TYPE Varchar2(100),	
TEMPLATE_NAME Varchar2(100),	
TEMPLATE_ID	 varchar2(50),
SEGMENT_2 Varchar2(100),
SEGMENT_3 Varchar2(100),
LIST_PRICE_PER_UNIT	number,
SET_PROCESS_ID	varchar2(1),
TRANSACTION_TYPE Varchar2(100),	
PROCESS_FLAG Number
);

ALTER TABLE GB_Items_Staging
  MODIFY PROCESS_FLAG Number;

Select * from GB_Items_Staging;
commit;
Describe GB_Items_Staging;
--Drop table GB_Items_Staging;
update GB_Items_Staging set segment_3 = 'SCM' where segment1='Desk Lamp';

select * from mtl_units_of_measure_tl;
select * from mtl_units_of_measure_tl where upper(Unit_Of_Measure) like '%MONT%';


Select * from mtl_system_items_interface where Segment1='Desk Lamp';

Select * from mtl_system_items_interface