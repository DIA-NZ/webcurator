-- PROFILE

alter table DB_WCT.PROFILE add column P_HARVESTER_TYPE varchar(40);
update DB_WCT.PROFILE set P_HARVESTER_TYPE='HERITRIX1';
alter table DB_WCT.PROFILE  alter column P_HARVESTER_TYPE set not null;

alter table DB_WCT.PROFILE add column P_DATA_LIMIT_UNIT varchar(40);

alter table DB_WCT.PROFILE add column P_MAX_FILE_SIZE_UNIT varchar(40);

alter table DB_WCT.PROFILE add column P_TIME_LIMIT_UNIT varchar(40);

-- PROFILE_OVERRIDES

alter table DB_WCT.PROFILE_OVERRIDES add column PO_H3_DOC_LIMIT int4, add column PO_H3_DATA_LIMIT float8, add column PO_H3_DATA_LIMIT_UNIT varchar(40),
add column PO_H3_TIME_LIMIT float8, add column PO_H3_TIME_LIMIT_UNIT varchar(40), add column PO_H3_MAX_PATH_DEPTH int4, add column PO_H3_MAX_HOPS int4,
add column PO_H3_MAX_TRANS_HOPS int4, add column PO_H3_IGNORE_ROBOTS bool, add column PO_H3_IGNORE_COOKIES bool, add column PO_H3_OR_DOC_LIMIT bool,
add column PO_H3_OR_DATA_LIMIT bool, add column PO_H3_OR_TIME_LIMIT bool, add column PO_H3_OR_MAX_PATH_DEPTH bool, add column PO_H3_OR_MAX_HOPS bool,
add column PO_H3_OR_MAX_TRANS_HOPS bool, add column PO_H3_OR_IGNORE_ROBOTS bool, add column PO_H3_OR_IGNORE_COOKIES bool, add column PO_H3_OR_BLOCK_URL bool,
add column PO_H3_OR_INCL_URL bool;


-- Provide sensible defaults for new override attributes
update DB_WCT.PROFILE_OVERRIDES set
PO_H3_DATA_LIMIT_UNIT = 'B',
PO_H3_EXTRACT_JS = true,
PO_H3_IGNORE_COOKIES = false,
PO_H3_OR_EXTRACT_JS = false,
PO_H3_OR_IGNORE_COOKIES = false,
PO_H3_OR_MAX_TRANS_HOPS = false,
PO_H3_OR_RAW_PROFILE = false,
PO_H3_TIME_LIMIT_UNIT = 'SECOND',
PO_H3_DATA_LIMIT = PO_MAX_BYES,
PO_H3_DOC_LIMIT = PO_MAX_DOCS,
PO_H3_MAX_HOPS = PO_MAX_HOPS,
PO_H3_MAX_PATH_DEPTH = PO_MAX_PATH_DEPTH,
PO_H3_TIME_LIMIT = PO_MAX_TIME_SEC,
PO_H3_IGNORE_ROBOTS = case PO_ROBOTS_POLICY when 'ignore' then true else false end,
PO_H3_OR_BLOCK_URL = PO_OR_EXCLUSION_URI,
PO_H3_OR_INCL_URL = PO_OR_INCLUSION_URI,
PO_H3_OR_DATA_LIMIT = PO_OR_MAX_BYTES,
PO_H3_OR_DOC_LIMIT = PO_OR_MAX_DOCS,
PO_H3_OR_MAX_HOPS = PO_OR_MAX_HOPS,
PO_H3_OR_MAX_PATH_DEPTH = PO_OR_MAX_PATH_DEPTH,
PO_H3_OR_TIME_LIMIT = PO_OR_MAX_TIME_SEC,
PO_H3_OR_IGNORE_ROBOTS = PO_OR_ROBOTS_POLICY
;


create table DB_WCT.PO_H3_BLOCK_URL (PBU_PROF_OVER_OID int8 not null, PBU_FILTER varchar(255), PBU_IX int4 not null, primary key (PBU_PROF_OVER_OID, PBU_IX));
create table DB_WCT.PO_H3_INCLUDE_URL (PIU_PROF_OVER_OID int8 not null, PIU_FILTER varchar(255), PIU_IX int4 not null, primary key (PIU_PROF_OVER_OID, PIU_IX));

alter table DB_WCT.PO_H3_BLOCK_URL add constraint PBU_FK_1 foreign key (PBU_PROF_OVER_OID) references DB_WCT.PROFILE_OVERRIDES;
alter table DB_WCT.PO_H3_INCLUDE_URL add constraint PIU_FK_1 foreign key (PIU_PROF_OVER_OID) references DB_WCT.PROFILE_OVERRIDES;

GRANT SELECT, INSERT, UPDATE, DELETE ON DB_WCT.PO_H3_BLOCK_URL TO USR_WCT;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_WCT.PO_H3_INCLUDE_URL TO USR_WCT;

INSERT INTO DB_WCT.PO_H3_BLOCK_URL (PBU_PROF_OVER_OID, PBU_FILTER, PBU_IX)
SELECT PEU_PROF_OVER_OID, PEU_FILTER, PEU_IX FROM DB_WCT.PO_EXCLUSION_URI;

INSERT INTO DB_WCT.PO_H3_INCLUDE_URL (PIU_PROF_OVER_OID, PIU_FILTER, PIU_IX)
SELECT PEU_PROF_OVER_OID, PEU_FILTER, PEU_IX FROM DB_WCT.PO_INCLUSION_URI;


alter table DB_WCT.PROFILE add column P_IMPORTED bool not null default false;

alter table DB_WCT.PROFILE_OVERRIDES add column PO_H3_RAW_PROFILE text;
alter table DB_WCT.PROFILE_OVERRIDES add column PO_H3_OR_RAW_PROFILE bool;
update DB_WCT.PROFILE_OVERRIDES set PO_H3_OR_RAW_PROFILE = false;


