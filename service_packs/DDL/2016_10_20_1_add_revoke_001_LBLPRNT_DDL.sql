
use [KRR-PA-ISA95_PRODUCTION];
go

/* 001_LBLPRNT_DDL  */
REVOKE REFERENCES TO [001_LBLPRNT_DDL];
go

REVOKE TAKE OWNERSHIP TO [001_LBLPRNT_DDL];
go

REVOKE INSERT TO [001_LBLPRNT_DDL];
go

REVOKE SELECT TO [001_LBLPRNT_DDL];
go

/* 001_LBLPRNT_DML  */
REVOKE ALTER TO [001_LBLPRNT_DML];
go

REVOKE ALTER ANY SCHEMA TO [001_LBLPRNT_DML];
go