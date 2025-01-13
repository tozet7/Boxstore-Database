BoxStore Database Project
=========================

Welcome to the **BoxStore Database Project**! This repository contains the files and resources for a school project centered around creating, managing, and visualizing data for a fictional box store business.

Repository Structure
--------------------

1. **Database Schema and Data** (`boxstore_database.sql`)
- Contains SQL commands for creating and populating the database.  
- Tables include key entities like customers, products, orders, and employees, with proper relationships and constraints.  
- Demonstrates normalization principles and efficient data organization.

2. **Database Diagram** (`at_0372995_boxstore.drawio`)
- Visual representation of the database schema using an Entity-Relationship Diagram (ERD).  
- Provides a clear view of table relationships, primary/foreign keys, and attribute definitions.  
- Created with draw.io for easy editing and sharing.

3. **Sample Data** (`at_0372995_boxstore_people.csv`)
- A CSV file with sample data, representing employees of the box store.  
- Serves as a dataset for validating the database’s functionality.

Features
--------

1.  **Database Schema**: The SQL script provides a well-designed schema with entities and relationships reflecting real-world business processes.

2.  **Data Visualization**: The draw.io diagram helps understand the logical design of the database.

3.  **Sample Data**: The CSV file offers insights into sample data used for testing and validation.

4.  **Database Compatibility**: The SQL scripts are designed to work with MariaDB but may also be compatible with other relational database systems with minor adjustments.

Installation and Usage
----------------------

1.  Clone the repository:

    ```
    git clone https://github.com/yourusername/boxstore-database-project.git
    ```

2.  Install MariaDB:

    -   [Download and install MariaDB](https://mariadb.org/download/) (tested with version 10.6).

3.  Set up the database using `boxstore_database.sql`:

    -   Open your MariaDB client or terminal.

    -   Run the following command to import the script:

        ```
        mysql -u your_username -p < boxstore_database.sql
        ```

4.  Review the database structure:

    -   Open `at_0372995_boxstore.drawio` using [diagrams.net (draw.io)](https://app.diagrams.net/).

5.  Import the data:

    -   Use the CSV file (`at_0372995_boxstore_people.csv`) as your bulk data import.

Tools and Technologies
----------------------

-   **MariaDB**: Relational database management system used for database creation and management.

-   **SQL**: Query language used to define, manipulate, and query data.

-   **draw.io**: Diagramming tool used to create the Entity-Relationship Diagram.

-   **CSV**: File format used for data analysis and testing.

How to Contribute
-----------------

Contributions are welcome! If you have suggestions or improvements, feel free to fork this repository, make your changes, and submit a pull request.

License
-------

MIT License\
Feel free to use, modify, and distribute this project in accordance with the license.

Acknowledgments
---------------

This project was developed as a school assignment. Special thanks to the instructors and peers who provided guidance and feedback throughout the process.
