--liquibase formatted sql
--changeset sudarshan.parthasarathy:rollback_isin_cas
--Database: postgresql
 DROP TABLE IF EXISTS isin_cas CASCADE
