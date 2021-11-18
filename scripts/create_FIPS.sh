#!/bin/bash

psql -U postgres -d fips -c "\i create_FIPS_tables.sql;"
