CREATE TABLE CUSTOMER (
CUST_ID			SERIAL		PRIMARY KEY,
CUST_LNAME		VARCHAR(50)	NOT NULL,
CUST_FNAME		VARCHAR(50)	NOT NULL,
CUST_EMAIL		VARCHAR(100)	UNIQUE NOT NULL,
CUST_TOTAL_ORDER	NUMERIC(9,2)	DEFAULT 0
);

CREATE TABLE ORDERS (
ORDER_ID	SERIAL		PRIMARY KEY,
ORDER_DATE	TIMESTAMP	NOT NULL,
ORDER_TOTAL	NUMERIC(10,2),
CUST_ID		INT		NOT NULL REFERENCES CUSTOMER ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CUSTOMER_LOG (
CT_LOG_ID	SERIAL		PRIMARY KEY,
CT_LOG_DATE	TIMESTAMP	NOT NULL,
CUST_ID		INT		NOT NULL REFERENCES CUSTOMER ON DELETE CASCADE ON UPDATE CASCADE
);

///////////////////////
CREATE OR REPLACE FUNCTION new_customer_log()
	RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO CUSTOMER_LOG(CT_LOG_DATE, CUST_ID)
		VALUES(CURRENT_DATE, NEW.CUST_ID);
	RETURN NEW;
END
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_new_customer_log
	AFTER INSERT ON CUSTOMER
	FOR EACH ROW
	EXECUTE FUNCTION new_customer_log();


INSERT INTO CUSTOMER(CUST_LNAME, CUST_FNAME, CUST_EMAIL)
	VALUES('Alfanta', 'Arcer', 'email@gmail.com');


SELECT * FROM CUSTOMER_LOG;
SELECT * FROM CUSTOMER;

///////////////////////


CREATE OR REPLACE FUNCTION update_cust_lname()
	RETURNS TRIGGER AS
$$
BEGIN
	IF UPPER(OLD.CUST_LNAME)<> UPPER(NEW.LNAME) THEN
		INSERT INTO CUSTOMER_LOG(CT_LOG_DATE, CUST_ID)
			VALUES(CURRENT_DATE, NEW.CUST_ID);
	ELSE
		RAISE NOTICE 'CUSTOMER LOG NOT UPDATED';
	END IF;

		RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_update_cust_lname
	BEFORE UPDATE ON CUSTOMER
	FOR EACH ROW
	EXECUTE FUNCTION update_cust_lname();

UPDATE CUSTOMER
SET CUST_LNAME = 'ALFANTA' 
WHERE CUST_ID = 6;



////////////////////////////////

CREATE OR REPLACE FUNCTION no_future_date()
	RETURNS TRIGGER AS
$$
BEGIN
	IF NEW.ORDER_DATE > CURRENT_DATE THEN
		RAISE EXCEPTION 'FUTURE DATE NOT ALLOWED';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_no_future_date
	BEFORE INSERT ON ORDERS
	FOR EACH ROW
	EXECUTE FUNCTION no_future_date();

INSERT INTO ORDERS(ORDER_DATE, ORDER_TOTAL, CUST_ID)
	VALUES(CURRENT_DATE, 8999, 6);

INSERT INTO ORDERS(ORDER_DATE, ORDER_TOTAL, CUST_ID)
	VALUES('2024-07-07', 5000, 6);
////////////////////////////////////////////////////

CREATE OR REPLACE FUNCTION update_cust_total_order()
	RETURNS TRIGGER AS

$$ 
DECLARE
	TOTAL_ORDERS NUMERIC (9,2);
BEGIN
	TOTAL_ORDERS := NEW.ORDER TOTAL;

	
	UPDATE CUSTOMER
		SET CUST_TOTAL_ORDER = CUST_TOTAL_ORDER + TOTAL_ORDERS 
		WHERE CUST_ID = NEW.CUST_ID;

	RETURN NEW;

END;

$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_update_cust_total_order
	AFTER INSERT ON ORDERS 
	FOR EACH ROW
	EXECUTE FUNCTION update_cust_total_order();

INSERT INTO ORDERS(ORDER_DATE, ORDER_TOTAL, CUST_ID) 
	VALUES (CURRENT_DATE, 1000, 7);



/////////////////////////////////////////////////
BEGIN
UPDATE invoice SET INV_DATE =CURRENT_DATE WHERE INV_NUMBER = NEW.INV_NUMBER;
RETURN NEW;
END;

$$ LANGUAGE PLPGSQL 

CREATE TRIGGER
AFTER INSERT ON TABLE LINE (IDK SA NAME SA TABLE BRO AHHAAH)
EXECUTE FUNCTION
/////////////////////////////////////////////
Dapat 

IF OLD.V_CODE IN(SELECT * from VENDOR) THEN 

RAISE EXCEPTION 'X';


//////////////////////////////////////////////////////////////////
1.

CREATE OR REPLACE FUNCTION prevent_delete_vendor()
	RETURNS TRIGGER AS

$$ 
BEGIN
	
	IF OLD.V_CODE IN (SELECT V_CODE FROM  PRODUCT) THEN
		RAISE EXCEPTION 'cANT DELETE CHUCHU';
		
	END IF;

	RETURN NEW;

END;

$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_prevent_delete_vendor
	BEFORE DELETE ON VENDOR 
	FOR EACH ROW
	EXECUTE FUNCTION prevent_delete_vendor();

delete from vendor where V_CODE = 21225;

///////////////////////////////////////////////////////////////////////
2.
CREATE OR REPLACE FUNCTION invoice_date()
	RETURNS TRIGGER AS

$$ 
BEGIN
	
	UPDATE INVOICE SET INV_DATE = CURRENT_DATE 
	WHERE INV_NUMBER = NEW.INV_NUMBER;
	
	RETURN NEW;

END;

$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_invoice_date
	AFTER INSERT ON LINE 
	FOR EACH ROW
	EXECUTE FUNCTION invoice_date();

INSERT INTO INVOICE VALUES(1008,10011,'17-JAN-2016');

INSERT INTO LINE VALUES(1009,3,'23109-HB',1,9.95);



