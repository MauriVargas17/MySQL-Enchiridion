
/**************************************************/
/*                                                */
/* Chapter 7: Data Types and Their Manipulation   */
/*                                                */
/**************************************************/

/*********************************************/
/*        Numeric Data Types                 */
/*********************************************/

-- Numeric data types store numbers and include types for integers, decimals, and floating-point numbers.

-- Integer Types
CREATE TABLE integer_types_example (
    tinyint_col TINYINT,         -- 1-byte integer (-128 to 127 or 0 to 255)
    smallint_col SMALLINT,       -- 2-byte integer (-32,768 to 32,767 or 0 to 65,535)
    mediumint_col MEDIUMINT,     -- 3-byte integer (-8,388,608 to 8,388,607 or 0 to 16,777,215)
    int_col INT,                 -- 4-byte integer (-2,147,483,648 to 2,147,483,647 or 0 to 4,294,967,295)
    bigint_col BIGINT            -- 8-byte integer (-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 or 0 to 18,446,744,073,709,551,615)
);

-- Decimal Types
CREATE TABLE decimal_types_example (
    decimal_col DECIMAL(10,2),   -- Fixed-point number with 10 digits total, 2 of which are after the decimal point
    numeric_col NUMERIC(10,2)    -- Same as DECIMAL, used interchangeably
);

-- Floating-Point Types
CREATE TABLE float_types_example (
    float_col FLOAT(7,4),        -- 4-byte floating-point number with precision up to 7 digits
    double_col DOUBLE(16,8)      -- 8-byte floating-point number with precision up to 16 digits
);

-- Mathematical Operations on Numeric Data Types
SELECT 
    ABS(-123) AS abs_value,       -- Absolute value
    CEIL(123.45) AS ceil_value,   -- Ceiling value
    FLOOR(123.45) AS floor_value, -- Floor value
    ROUND(123.456, 2) AS round_value, -- Rounds to 2 decimal places
    SQRT(16) AS sqrt_value,       -- Square root
    POW(2, 3) AS pow_value,       -- 2 raised to the power of 3
    EXP(1) AS exp_value,          -- Exponential
    LOG(100) AS log_value,        -- Natural logarithm
    LOG10(100) AS log10_value,    -- Base-10 logarithm
    MOD(10, 3) AS mod_value,      -- Remainder of 10 divided by 3
    RAND() AS rand_value;         -- Random number between 0 and 1

/*********************************************/
/*        String Data Types                  */
/*********************************************/

-- String data types store sequences of characters and include types for fixed-length and variable-length strings.

-- Fixed-Length String Types
CREATE TABLE fixed_length_string_example (
    char_col CHAR(10)            -- Fixed-length string of 10 characters
);

-- Variable-Length String Types
CREATE TABLE variable_length_string_example (
    varchar_col VARCHAR(255)     -- Variable-length string up to 255 characters
);

-- Text Types
CREATE TABLE text_types_example (
    tinytext_col TINYTEXT,       -- Text column with a maximum length of 255 characters
    text_col TEXT,               -- Text column with a maximum length of 65,535 characters
    mediumtext_col MEDIUMTEXT,   -- Text column with a maximum length of 16,777,215 characters
    longtext_col LONGTEXT        -- Text column with a maximum length of 4,294,967,295 characters
);

-- String Operations
SELECT 
    LENGTH('Hello World') AS length_value, -- Length of the string
    LOWER('Hello World') AS lower_value,   -- Convert to lowercase
    UPPER('Hello World') AS upper_value,   -- Convert to uppercase
    SUBSTRING('Hello World', 1, 5) AS substring_value, -- Extract substring
    TRIM('  Hello World  ') AS trim_value, -- Remove leading and trailing spaces
    REPLACE('Hello World', 'World', 'MySQL') AS replace_value, -- Replace substring
    CONCAT('Hello', ' ', 'World') AS concat_value, -- Concatenate strings
    INSTR('Hello World', 'World') AS instr_value, -- Position of substring
    REVERSE('Hello World') AS reverse_value; -- Reverse the string

/*********************************************/
/*        Date and Time Data Types           */
/*********************************************/

-- Date and time data types store dates, times, and timestamps.

CREATE TABLE date_time_example (
    date_col DATE,               -- Stores dates (YYYY-MM-DD)
    datetime_col DATETIME,       -- Stores date and time (YYYY-MM-DD HH:MM:SS)
    timestamp_col TIMESTAMP,     -- Stores timestamp (YYYY-MM-DD HH:MM:SS) with auto-updating capabilities
    time_col TIME,               -- Stores time (HH:MM:SS)
    year_col YEAR(4)             -- Stores year (4-digit format)
);

-- Date and Time Functions
SELECT 
    NOW() AS now_value,            -- Current date and time
    CURDATE() AS curdate_value,    -- Current date
    CURTIME() AS curtime_value,    -- Current time
    DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date, -- Format date
    DATE_ADD(NOW(), INTERVAL 1 DAY) AS date_add_value, -- Add 1 day to current date
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS date_sub_value, -- Subtract 1 month from current date
    DATEDIFF('2023-12-31', '2023-01-01') AS datediff_value, -- Difference in days between two dates
    DAY('2023-12-31') AS day_value,  -- Extract day
    MONTH('2023-12-31') AS month_value, -- Extract month
    YEAR('2023-12-31') AS year_value,  -- Extract year
    HOUR(NOW()) AS hour_value,      -- Extract hour
    MINUTE(NOW()) AS minute_value,  -- Extract minute
    SECOND(NOW()) AS second_value,  -- Extract second
    TIMESTAMPDIFF(YEAR, '2000-01-01', NOW()) AS age_in_years -- Calculate age in years
;

/*********************************************/
/*        Binary Data Types                  */
/*********************************************/

-- Binary data types store binary data, such as images or files.

CREATE TABLE binary_example (
    binary_col BINARY(16),       -- Fixed-length binary data
    varbinary_col VARBINARY(255),-- Variable-length binary data
    blob_col BLOB,               -- Binary Large Object, up to 65,535 bytes
    mediumblob_col MEDIUMBLOB,   -- Binary Large Object, up to 16,777,215 bytes
    longblob_col LONGBLOB        -- Binary Large Object, up to 4,294,967,295 bytes
);

-- Binary Data Operations
-- Consult the stored values
SELECT 
    HEX(binary_col) AS hex_value,          -- Convert binary data to hexadecimal
    LENGTH(binary_col) AS binary_length    -- Length of binary data
FROM binary_example;

-- Compress and uncompress a example text
SET @compressed_value = COMPRESS('example_text');

SELECT 
    @compressed_value AS compressed_value,
    UNCOMPRESS(@compressed_value) AS uncompressed_value;

/*********************************************/
/*        Spatial Data Types                 */
/*********************************************/

-- Spatial data types store geometric and geographic data.

CREATE TABLE spatial_example (
    geometry_col GEOMETRY,       -- Stores any type of geometry
    point_col POINT,             -- Stores a point
    linestring_col LINESTRING,   -- Stores a line string
    polygon_col POLYGON,         -- Stores a polygon
    multipoint_col MULTIPOINT,   -- Stores multiple points
    multilinestring_col MULTILINESTRING,-- Stores multiple line strings
    multipolygon_col MULTIPOLYGON, -- Stores multiple polygons
    geometrycollection_col GEOMETRYCOLLECTION -- Stores a collection of geometry objects
);

-- Spatial Data Functions
SELECT 
    ST_AsText(POINT(1, 1)) AS point_as_text,    -- Convert point to WKT
    ST_Distance(POINT(1, 1), POINT(2, 2)) AS distance, -- Calculate distance between points
    ST_Contains(ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))'), POINT(0.5, 0.5)) AS 'contains'; -- Check if polygon contains point

/*********************************************/
/*        JSON Data Types                    */
/*********************************************/

-- JSON data types store JSON-formatted data.
-- Create table json_example
DROP TABLE IF EXISTS json_example;

CREATE TABLE json_example (
    json_col JSON                -- Stores JSON data
);

-- Insert data for the example
INSERT INTO json_example (json_col) VALUES 
('{"key": "value", "another_key": {"nested_key": "nested_value"}}');

-- JSON Data Functions
SELECT 
    JSON_EXTRACT(json_col, '$.key') AS json_extract_value, -- Extract data from JSON
    JSON_UNQUOTE(JSON_EXTRACT(json_col, '$.key')) AS json_unquote_value, -- Unquote extracted data
    JSON_SET(json_col, '$.new_key', 'value') AS json_set_value, -- Set data in JSON
    JSON_REMOVE(json_col, '$.key') AS json_remove_value, -- Remove data from JSON
    JSON_CONTAINS(json_col, '"value"', '$.key') AS json_contains_value, -- Check if JSON contains value
    JSON_KEYS(json_col) AS json_keys_value, -- Get keys from JSON
    JSON_ARRAY('value1', 'value2') AS json_array_value, -- Create JSON array
    JSON_OBJECT('key1', 'value1', 'key2', 'value2') AS json_object_value -- Create JSON object
FROM json_example;

/*********************************************/
/*        Data Type Conversions              */
/*********************************************/

-- Data type conversions convert data from one type to another.

-- Implicit Conversion Example
-- MySQL automatically converts values as needed:
INSERT INTO integer_types_example (tinyint_col) VALUES ('123'); -- String to integer conversion

-- Explicit Conversion Example
-- Use CAST() or CONVERT() for explicit conversions:
SELECT 
    CAST('123' AS SIGNED INTEGER) AS cast_to_int,  -- Converts string to integer
    CONVERT('123.45', DECIMAL(5,2)) AS convert_to_decimal, -- Converts string to decimal
    CAST('2023-01-01' AS DATE) AS cast_to_date;   -- Converts string to date
SELECT JSON_EXTRACT(json_col, '$.key') AS json_extract_value FROM json_example; -- Extracts data from JSON


