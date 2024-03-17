DECLARE
    l_max_value NUMBER;
    l_sequence_name VARCHAR2(30);
    l_column_name VARCHAR2(100);
    l_trigger_name VARCHAR2(100);
BEGIN
    -- Step 1: Drop existing sequences
    FOR seq_rec IN (SELECT sequence_name FROM user_sequences) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || seq_rec.sequence_name;
        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- Ignore errors if sequence doesn't exist or cannot be dropped
        END;
    END LOOP;

    FOR column_name_rec IN (
        SELECT utc.table_name, utc.column_name
        FROM user_tab_columns utc
        JOIN user_cons_columns ucc ON ucc.table_name = utc.table_name AND ucc.column_name = utc.column_name
        JOIN user_constraints uc ON ucc.constraint_name = uc.constraint_name
        WHERE utc.data_type = 'NUMBER'
        AND uc.constraint_type = 'P'
        AND uc.owner = 'HR'
    ) LOOP
        -- Fetch the maximum value
        EXECUTE IMMEDIATE 'SELECT NVL(MAX(' || column_name_rec.column_name || '), 0) + 1 FROM ' || column_name_rec.table_name INTO l_max_value;
        
        DBMS_OUTPUT.PUT_LINE('Sequence for ' || column_name_rec.column_name || ' in ' || column_name_rec.table_name || ' created with START WITH value: ' || l_max_value);

        -- Create sequence dynamically
        -- Truncate table and column names to fit within 30 characters
        l_sequence_name := 'seq_' || SUBSTR(column_name_rec.table_name, 1, 20) || '_' || SUBSTR(column_name_rec.column_name, 1, 5);
        
        BEGIN
            -- Ensure l_max_value is numeric
            l_max_value := NVL(l_max_value, 0); -- If l_max_value is null, set it to 0

            -- Create sequence with START WITH value
            EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || l_sequence_name || ' START WITH ' || l_max_value;
            
            -- Get column name
            SELECT column_name INTO l_column_name
            FROM user_tab_columns
            WHERE table_name = column_name_rec.table_name
            AND rownum = 1;
            
            -- Create trigger dynamically
            l_trigger_name := 'TRG_' || SUBSTR(column_name_rec.table_name, 1, 10) || '_' || SUBSTR(column_name_rec.column_name, 1, 10);
            EXECUTE IMMEDIATE '
                CREATE OR REPLACE TRIGGER ' || l_trigger_name || '
                BEFORE INSERT ON ' || column_name_rec.table_name || '
                FOR EACH ROW
                BEGIN
                    :NEW.' || l_column_name || ' := ' || l_sequence_name || '.NEXTVAL;
                END;';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred while creating sequence and trigger for ' || column_name_rec.column_name || ' in ' || column_name_rec.table_name || '.');
        END;
    END LOOP;
END;
/

DECLARE
    l_trigger_name VARCHAR2(100);
BEGIN
    -- Drop existing triggers
    FOR trg_rec IN (SELECT trigger_name FROM user_triggers) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || trg_rec.trigger_name;
        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- Ignore errors if trigger doesn't exist or cannot be dropped
        END;
    END LOOP;
END;
/


SELECT * FROM EMPLOYEES;
INSERT INTO employees (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID, RETIRED_BONUS, RETIRED)
VALUES (null, 'meme', 'ahmed@gmail.com', null, sysdate, 'IT_PROG',null, null, null, null, null, null);
 select* from employees where last_name = 'meme';