--  TaxApplication database 
--  Original data created by Srinivas Rao Nagalla
--  Database created to for Tax filling Application
--  Product Owner - Krishna Bodduluri
-- 
--  Current schema by Srinivas Rao Nagalla

DROP DATABASE IF EXISTS taxApplication;
CREATE DATABASE IF NOT EXISTS taxApplication;
USE taxApplication;


DROP TABLE IF EXISTS ADDRESS_TYPE,
                     USER_TYPE,
                     ADDRESS,
                     `USER`, 
                     AGENT, 
                     ORGANIZATION,
                     REGISTRATION,
                     TAX_PAYER,
                     BANK_ACCOUNT,
                     TAX_PAYER_DEPEDENT,
                     FEDRAL_TAX_TRANSANCTION,
                     STATE_TAX_TRANSANCTION;

CREATE TABLE ADDRESS_TYPE (
    ADDRESS_TYPE_ID      INT             NOT NULL,
    DESCRIPTION          VARCHAR(20)     NOT NULL,
    PRIMARY KEY (ADDRESS_TYPE_ID)
);

CREATE TABLE USER_TYPE (
    USER_TYPE_ID      INT         NOT NULL,
    DESCRIPTION       VARCHAR(20) NOT NULL,
    PRIMARY KEY (USER_TYPE_ID)
);

CREATE TABLE ADDRESS (
    ADDRESS_ID        INT          NOT NULL,
    ADDRESS_TYPE_ID   INT          NOT NULL,
    ADDRESS_1         VARCHAR(50)  NOT NULL ,
    ADDRESS_2         VARCHAR(50)           ,
    CITY              VARCHAR(30)  NOT NULL ,
    STATE             VARCHAR(50)  NOT NULL,
    COUNTRY           VARCHAR(30)  NOT NULL,
    ZIP               INT          NOT NULL,
    PRIMARY KEY (ADDRESS_ID),
    FOREIGN KEY (ADDRESS_TYPE_ID) REFERENCES ADDRESS_TYPE (ADDRESS_TYPE_ID)
);

CREATE TABLE `USER` (
    USER_ID             INT          NOT NULL,
    FIRST_NAME          VARCHAR(50)  NOT NULL,
    MIDDLE_NAME         VARCHAR(50)          ,
    LAST_NAME           VARCHAR(50)  NOT NULL,
    BILLING_ADDRESS_ID  INT          NOT NULL,
    MAILING_ADDRESS_ID  INT          NOT NULL,
    PHYSICAL_ADDRESS_ID INT          NOT NULL,
    PRIMARY KEY (USER_ID),
    FOREIGN KEY (BILLING_ADDRESS_ID)  REFERENCES ADDRESS (ADDRESS_ID),
    FOREIGN KEY (MAILING_ADDRESS_ID)  REFERENCES ADDRESS (ADDRESS_ID),
    FOREIGN KEY (PHYSICAL_ADDRESS_ID) REFERENCES ADDRESS (ADDRESS_ID)
); 

CREATE TABLE AGENT (
    AGENT_ID             INT          NOT NULL,
    USER_ID              INT          NOT NULL,
    EIN_NUMBER           INT          NOT NULL,
    OFFICE_ADDRESS_ID    INT          NOT NULL,
    PRIMARY KEY (AGENT_ID),
    UNIQUE (EIN_NUMBER),
    FOREIGN KEY (USER_ID)            REFERENCES `USER` (USER_ID),
    FOREIGN KEY (OFFICE_ADDRESS_ID)  REFERENCES ADDRESS (ADDRESS_ID)
);

CREATE TABLE ORGANIZATION (
   ORGANIZATION_ID             INT          NOT NULL,
   USER_ID                     INT          NOT NULL,
   ORGANIZATION_NAME           VARCHAR(50)  NOT NULL,
   EIN_NUMBER                  INT          NOT NULL,
   ORGANIZATION_ADDRESS_ID     INT          NOT NULL,
   PRIMARY KEY (ORGANIZATION_ID),
   UNIQUE (EIN_NUMBER),
   FOREIGN KEY (USER_ID)  REFERENCES `USER` (USER_ID),
   FOREIGN KEY (ORGANIZATION_ADDRESS_ID)  REFERENCES ADDRESS (ADDRESS_ID)
); 

CREATE TABLE REGISTRATION (
   REGISTRATION_ID             INT          NOT NULL,
   USER_NAME                   VARCHAR(50)  NOT NULL,
   EMAIL_ADDRESS               VARCHAR(50)  NOT NULL,
   PHONE_NUMBER                INT          NOT NULL,
   USER_TYPE_ID                INT          NOT NULL,
   USER_ID                     INT          NOT NULL,
   `PASSWORD`                  VARCHAR(50)  NOT NULL,
   PRIMARY KEY (REGISTRATION_ID),
   UNIQUE (USER_NAME),
   UNIQUE (EMAIL_ADDRESS),
   FOREIGN KEY (USER_TYPE_ID)  REFERENCES USER_TYPE (USER_TYPE_ID),
   FOREIGN KEY (USER_ID)  REFERENCES `USER` (USER_ID)
); 

CREATE TABLE TAX_PAYER (
   TAX_PAYER_ID             INT  NOT NULL,
   USER_ID                  INT  NOT NULL,
   SSN                      INT  NOT NULL,
   PRIMARY KEY (TAX_PAYER_ID),
   UNIQUE (USER_ID),
   UNIQUE (SSN),
   FOREIGN KEY (USER_ID)  REFERENCES `USER` (USER_ID)
); 

CREATE TABLE BANK_ACCOUNT (
   BANK_ACCOUNT_ID          INT          NOT NULL,
   TAX_PAYER_ID             INT          NOT NULL,
   BANK_NAME                VARCHAR(50)  NOT NULL,
   BRANCH_NAME              VARCHAR(50)          ,
   ACCOUNT_NUMBER           INT          NOT NULL,
   BANK_ADDRESS_ID          INT          NOT NULL,
   ROUTING_NUMBER           VARCHAR(15)  NOT NULL,
   PRIMARY KEY (BANK_ACCOUNT_ID),
   FOREIGN KEY (TAX_PAYER_ID)  REFERENCES TAX_PAYER(TAX_PAYER_ID),
   FOREIGN KEY (BANK_ADDRESS_ID)  REFERENCES ADDRESS (ADDRESS_ID)
); 

CREATE TABLE TAX_PAYER_DEPEDENT (
   TAX_PAYER_DEPEDENT_ID          INT          NOT NULL,
   TAX_PAYER_ID                   INT          NOT NULL,
   `YEAR`                         INT          NOT NULL,
   MARITAL_STATUS                 TINYINT      NOT NULL,
   NUMBER_OF_DEPEDENT             INT          NOT NULL,
   DEPENDENT                      TINYINT      NOT NULL,
   DEPENDENT_TAX_PAYER_ID         INT          NOT NULL,
   PRIMARY KEY (TAX_PAYER_DEPEDENT_ID),
   UNIQUE (TAX_PAYER_DEPEDENT_ID,TAX_PAYER_ID,`YEAR`),
   FOREIGN KEY (TAX_PAYER_ID)            REFERENCES TAX_PAYER(TAX_PAYER_ID),
   FOREIGN KEY (DEPENDENT_TAX_PAYER_ID)  REFERENCES TAX_PAYER (TAX_PAYER_ID)
); 

CREATE TABLE FEDRAL_TAX_TRANSANCTION (
   FEDRAL_TAX_TRANSANCTION_ID          INT                 NOT NULL,
   TAX_PAYER_ID                        INT                 NOT NULL,
   `YEAR`                              INT                 NOT NULL,
   FILER_TYPE_ID                       INT                 NOT NULL,
   FILER_USER_ID                       INT                 NOT NULL,
   N_TH_YEAR_OF_TAX_FILLING            INT                 NOT NULL,
   ANNUAL_INCOME                       DECIMAL(20 ,2)      NOT NULL,
   FEDRAL_TAX                          DECIMAL(20 ,2)      NOT NULL,
   FEDRAL_TAX_PAID                     DECIMAL(20 ,2)      NOT NULL,
   FEDRAL_DIFFERENCE                   DECIMAL(20 ,2)      NOT NULL,
   FEDRAL_BANK_ACCOUNT_ID              INT                 NOT NULL,
   PRIMARY KEY (FEDRAL_TAX_TRANSANCTION_ID),
   UNIQUE (TAX_PAYER_ID,`YEAR`),
   FOREIGN KEY (TAX_PAYER_ID)    REFERENCES TAX_PAYER(TAX_PAYER_ID),
   FOREIGN KEY (FILER_TYPE_ID)  REFERENCES USER_TYPE (USER_TYPE_ID),
   FOREIGN KEY (FILER_USER_ID)  REFERENCES  `USER` (USER_ID),
   FOREIGN KEY (FEDRAL_BANK_ACCOUNT_ID)  REFERENCES  BANK_ACCOUNT (BANK_ACCOUNT_ID)
);


CREATE TABLE STATE_TAX_TRANSANCTION (
   STATE_TAX_TRANSANCTION_ID           INT                 NOT NULL,
   TAX_PAYER_ID                        INT                 NOT NULL,
   `YEAR`                              INT                 NOT NULL,
   FILER_TYPE_ID                       INT                 NOT NULL,
   FILER_USER_ID                       INT                 NOT NULL,
   N_TH_YEAR_OF_TAX_FILLING            INT                 NOT NULL,
   STATE_NAME                          VARCHAR(50)         NOT NULL,
   STATE_CODE                          VARCHAR(5)          NOT NULL,
   ANNUAL_INCOME                       DECIMAL(20 ,2)      NOT NULL,
   STATE_TAX                           DECIMAL(20 ,2)      NOT NULL,
   STATE_TAX_PAID                      DECIMAL(20 ,2)      NOT NULL,
   STATE_DIFFERENCE                    DECIMAL(20 ,2)      NOT NULL,
   STATE_BANK_ACCOUNT_ID               INT                 NOT NULL,
   PRIMARY KEY (STATE_TAX_TRANSANCTION_ID),
   UNIQUE (TAX_PAYER_ID,`YEAR`,STATE_CODE),
   FOREIGN KEY (TAX_PAYER_ID)               REFERENCES  TAX_PAYER(TAX_PAYER_ID),
   FOREIGN KEY (FILER_TYPE_ID)              REFERENCES  USER_TYPE (USER_TYPE_ID),
   FOREIGN KEY (FILER_USER_ID)              REFERENCES  `USER` (USER_ID),
   FOREIGN KEY (STATE_TAX_TRANSANCTION_ID)  REFERENCES  BANK_ACCOUNT (BANK_ACCOUNT_ID)
);
