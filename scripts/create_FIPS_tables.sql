DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS risk_limits;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS instruments;

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type INT NOT NULL,
    PRIMARY KEY( account_id )
);

COPY accounts(account_id, account_name, account_type)
FROM '/Users/brmannin/FIPS/data/accounts.csv'
DELIMITER ','
CSV HEADER;



CREATE TABLE IF NOT EXISTS instruments (
    instrument_id INT NOT NULL,
    ticker VARCHAR(8),
    instrument_name VARCHAR(100) NOT NULL,
    instrument_type INT NOT NULL,
    PRIMARY KEY( instrument_id )
);

COPY instruments(instrument_id, ticker, instrument_name, instrument_type)
FROM '../data/instruments.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS positions (
    position_id INT NOT NULL,
    account_id int NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id) ON DELETE CASCADE,
    qty FLOAT(8) NOT NULL,
    PRIMARY KEY( position_id )
);

COPY positions(position_id, account_id, instrument_id, qty)
FROM '../data/positions.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS risk_limits(
    risk_limit_id INT NOT NULL,
    account_id INT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
    risk_type INT NOT NULL,
    confidence FLOAT(4) NOT NULL DEFAULT(0.9900),
    lookback_period INT NOT NULL DEFAULT(200),
    risk_limit INT NOT NULL,
    risk_period_days INT NOT NULL DEFAULT(1)
);

COPY risk_limits(risk_limit_id, account_id, risk_type, confidence, lookback_period, risk_limit, risk_period_days)
FROM '../data/risk_limits.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS price_history(
    price_history_id BIGSERIAL NOT NULL PRIMARY KEY,
    instrument_id INT NOT NULL REFERENCES instruments(instrument_id) ON DELETE CASCADE,
    date_of DATE NOT NULL,
    open FLOAT(8) NOT NULL,
    high FLOAT(8) NOT NULL,
    low FLOAT(8) NOT NULL,
    close FLOAT(8) NOT NULL,
    adj_close FLOAT(8) NOT NULL,
    volume INT NOT NULL
);

COPY price_history(instrument_id, date_of,  open, high, low, close, adj_close,volume)
FROM '../data/price_history.csv'
DELIMITER ','
CSV HEADER;
