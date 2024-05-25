import os

chapters = [
    "Setup",
    "Data Definition Language (DDL)",
    "Data Manipulation Language (DML)",
    "Data Query Language (DQL)",
    "Data Control Language (DCL)",
    "Transaction Control Language (TCL)",
    "Table Relationships and Constraints",
    "Data Types and Their Manipulation",
    "Indexes",
    "Triggers",
    "Stored Procedures",
    "Functions",
    "Views",
    "Partitions",
    "Error Handling", 
    "Database Security",
    "Query Optimization",
    "Concurrency Control",
    "Backup and Recovery",
    "MySQL Specific Nuances",
    "Auditing and Monitoring User Activity",
    "Practical Use Cases and Examples: Common Pitfalls",
    "Connecting To MySQL"
]

def create_sql_files(chapter_list):
    for i, chapter in enumerate(chapter_list, start=1):
        file_name = f"{i}_{chapter.replace(' ', '_')}.sql"

        with open(file_name, 'w') as file:
            pass
        
        print(f"Created file: {file_name}")

create_sql_files(chapters)
