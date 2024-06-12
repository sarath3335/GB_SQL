set serveroutput on;

CREATE OR REPLACE PACKAGE gbm_items_insertion AS
    PROCEDURE gbm_stg_to_interface;

END gbm_items_insertion;

CREATE OR REPLACE PACKAGE BODY gbm_items_insertion AS
    PROCEDURE gbm_stg_to_interface IS

        lc_org_id      NUMBER;
        lc_status      VARCHAR(1);
        lc_temp_id     NUMBER;
        lc_uom_code    VARCHAR2(100);
        lc_category_id NUMBER;
        CURSOR cursor_items_stg IS
        SELECT
            *
        FROM
            gb_items_staging
        WHERE
            lc_status IS NULL;
    BEGIN
--        dbms_output.put_line('entry to loop');
        FOR i IN cursor_items_stg LOOP
    dbms_output.put_line('entered into the loop');
    lc_status := NULL;
  ------------------------------------------------------------------------   Organization code validation   success
    BEGIN
--                dbms_output.put_line('validation 1');
--                dbms_output.put_line(i.organization_code);  
        SELECT
            organization_id
        INTO lc_org_id
        FROM
            mtl_parameters
        WHERE
            organization_code = i.organization_code;
        lc_status := 'S';
    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            dbms_output.put_line('ERROR IN GETTING ORGANIZATION_ID');
    END;
  ----------------------------------------------------------------------------   Template validation        Success
    BEGIN
--                dbms_output.put_line('validation 2');
        SELECT
            template_id
        INTO lc_temp_id
        FROM
            mtl_item_templates
        WHERE
            upper(template_name) = upper(i.template_name);
        lc_status := 'S';
    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            dbms_output.put_line('ERROR IN GETTIN TEMPLATE_NAME');
    END;
  ----------------------------------------------------------------------------   UOM Validation success
    BEGIN 
--              dbms_output.put_line('validation 3');
        SELECT DISTINCT
            uom_code
        INTO lc_uom_code
        FROM
            mtl_units_of_measure
        WHERE
            upper(unit_of_measure) = i.primary_unit_of_measure;
        lc_status := 'S';
    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            dbms_output.put_line('ERROR IN GETTING UNIT_OF_MEASURE');
              
    END;
  ----------------------------------------------------------------------------   Category validation 
    BEGIN
--    dbms_output.put_line('validation 1');
        SELECT
            category_id
        INTO lc_category_id
        FROM
            mtl_categories_v
        WHERE
                upper(segment2) = upper(i.segment_2)
            AND upper(segment3) = upper(i.segment_3);
        lc_status := 'S';
    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            dbms_output.put_line('ERROR IN GETTING CATEGORY SEGMENTS');
--            dbms_output.put_line(i.Segment_2 ||'22222222');
--            dbms_output.put_line(i.Segment_3 || '333333333');
    END;
             IF ( lc_status = 'S' ) THEN
    dbms_output.put_line('Success--');
    INSERT INTO mtl_system_items_interface (
        organization_id,
        organization_code,
        last_update_date,
        last_updated_by,
        creation_date
        ,created_by,
        last_update_login,
        description,
        segment1,
        primary_unit_of_measure,
        primary_uom_code,
        item_type,
        template_name,
        template_id,
        segment2,
        segment3,
        list_price_per_unit,
        set_process_id,
        transaction_type,
        process_flag
    
    ) VALUES (

        lc_org_id,
        i.Organization_Code,
        sysdate ,
        1015524,
        sysdate,
        1015524,
        1015524,
        i.description,
        i.segment1,
        i.primary_unit_of_measure,
        lc_uom_code,
        null ,
        i.Template_Name,
        lc_temp_id,
        i.segment_2,
        i.segment_3,
        i.List_Price_Per_unit,
        i.set_Process_Id,
        i.Transaction_Type,
        1);
      

END IF;
        END LOOP;

    END gbm_stg_to_interface;

END gbm_items_insertion;

set serveroutput on;
Exec gbm_items_insertion.gbm_stg_to_interface;

select * from mtl_system_items_interface where trunc(Creation_date)= '11-06-24';

select * from mtl_interface_errors;


select sysdate from dual;