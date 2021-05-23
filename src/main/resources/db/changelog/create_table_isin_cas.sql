--liquibase formatted sql
--changeset sudarshan.parthasarathy:create-test-table
--Database: postgresql
CREATE TABLE isin_cas(
  id  SERIAL PRIMARY KEY,
  isin VARCHAR (12) NOT NULL,
  mfname TEXT NOT NULL,
  UNIQUE(isin,mfname)
);
ALTER TABLE isin_cas
  ADD CONSTRAINT lc_mfname
  CHECK (mfname = lower(mfname)); 
--rollback DROP TABLE IF EXISTS
--rollback isin_cas CASCADE
