# Dynamic SQL Project: Automatic Sequence and Trigger Creation for Oracle Database

This project provides a PL/SQL script designed to automate the creation of sequence and trigger pairs for Oracle Database tables dynamically. It performs the following actions:

- Drops existing sequences for each table.
- Creates sequences for numeric primary key columns in each table.
- Creates triggers to automatically populate primary key columns with sequence values on insertion.

## Overview

The script iterates through all tables in the schema, dropping existing sequences, and creating new sequences and triggers for each table's primary key column. It ensures that sequences start with the maximum ID value found in the corresponding column plus one.

## Usage

1. **Preparation**:
    - Ensure you have appropriate permissions to execute DDL commands in your Oracle Database schema.

2. **Execution**:
    - Run the provided PL/SQL script in your Oracle SQL*Plus or SQL Developer environment.

3. **Verification**:
    - After execution, verify that sequences and triggers are created successfully by querying `USER_SEQUENCES` and `USER_TRIGGERS`.

4. **Integrate with Your Workflow**:
    - Incorporate this script into your database deployment or development workflow for seamless management of sequences and triggers.

## Notes

- **Customization**:
    - Modify the script to suit your specific database schema or business logic requirements.

- **Error Handling**:
    - Error handling is implemented to gracefully handle failures during sequence and trigger creation.

## Example

```sql
-- Sample usage of the script
-- Assuming the script is saved as 'create_sequences_triggers.sql'

-- Connect to your Oracle Database instance
sqlplus username/password@database

-- Run the script
@create_sequences_triggers.sql
