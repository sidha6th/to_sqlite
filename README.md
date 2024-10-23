# to_sqlite

A CLI tool that facilitates the conversion of CSV files into SQLite databases and generates corresponding model classes.

## Installation

To install the tool globally on your machine, run the following command:

```bash
dart pub global activate to_sqlite
```

## Getting Started

`Prerequisites:` Dart SDK (version ^3.4.3 or above)

## Usage

Once installed, you can start using this tool command `toSqlite --{options} {file/path.ext}` by passing the necessary CSV file or optional configuration file `(config.json)` to customize how your CSV data is converted into an SQLite database.

## What is config.json?

The `config.json` file is a configuration file that allows you to control how the data from your CSV file is transformed into an SQLite database. It contains information about how to structure your SQLite tables, column names, data types, and other settings that influence the final output. The use of `config.json` is optional, but it gives you a higher degree of flexibility when managing your database.

## Command Options

### Generate Config.json

#### Command: `generate_config --filePath (-f)`

Path to the configuration JSON file that defines the conversion settings.

Example: `toSqlite generate_config -f ./config/config.json`

### Generate Database.sqlite

#### Command: `generate_db --filePath (-f)`

Path to the CSV file you want to convert to SQLite. If no configuration file is provided, the tool will automatically infer the table structure from the CSV.

Example: `toSqlite generate_db -f ./data/myfile.csv`

**By default the `config.json` file will be generated once you run `generate_db` command.**

#### Or

Alternatively, you can pass the config file to customize how the database is generated.

Example: `toSqlite generate_db -f ./config/config.json`

### Generate Model class

#### Command: `generate_class --filePath (-f)`

To Generate Model class based on the CSV or Config.json.

Example: `toSqlite generate_db -f ./data/myfile.csv`

or

Example: `toSqlite generate_db -f config.json`

## Additional information about `config.json`

### Structure of Config.json

```json
{
  /// Path to the CSV file that will be used for creating the SQLite table.
  "csv": "assets/test.csv",

  /// Path where the SQLite file will be created.
  /// Optional: If not provided, the SQLite file will be created in the same directory as the config or CSV file.
  "output_path": "assets",

  /// Name of the table to be created in the SQLite database.
  /// Optional: By default, it will use the name of the CSV file.
  "table_name": "test",

  /// If a nullable value is encountered and type inference is enabled,
  /// this flag decides whether to fallback to String type for that value.
  /// Example: If a column has null values and type inference is enabled,
  /// setting this to true will default the type to String for safety.
  "fallback_to_string_on_nullable_value": false,

  /// Enables automatic type inference based on the CSV data.
  /// If set to true, the package will analyze the values in each column
  /// and infer the appropriate data type (e.g., `int`, `String`).
  /// Useful for automating data type assignment without manually defining all types.
  "enable_type_inference": true,

  /// Name for default ID column which will auto increment on each insertion
  /// to the corresponding table.
  ///
  /// Its optional field if this is not specified in the config
  /// the tool won't create any ID column.
  "auto_incrementing_id_column_name": "auto_incrementing_id",

  /// Defines the columns for the SQLite table.
  /// Each object in this array corresponds to a column definition, containing attributes
  /// like the column name, data type, whether it's nullable, and other properties.
  "table_columns": [
    {
      /// The name of the column in the SQLite table.
      "name": "id",

      /// The data type of the column. Can be `int`, `String`, etc.
      /// The type should match the expected data from the CSV.
      "type": "int",

      /// Specifies whether the column can contain null values.
      /// If false, the column will require a non-null value for each row.
      "nullable": false,

      /// Default value for the column. If no value is provided during insertion,
      /// this value will be used. In this case, it's set to null (meaning no default).
      "default": null,

      /// Specifies whether this column is the primary key of the table.
      /// A primary key uniquely identifies each record in the table.
      "primaryKey": true,

      /// Defines foreign key relationships for the column.
      /// In this case, the "id" column references the "id" column from the "departments" table.
      /// If this column contains a value, that value must exist in the referenced column of the referenced table, ensuring referential integrity.
      "foreign_keys": [
        {
          /// Name of the table that the foreign key references.
          "table": "departments",

          /// Name of the column in the referenced table.
          "column": "id"
        }
      ]
    }
  ]
}
```

## Commonly Faced Issues

On a **Linux-based** system, you might encounter the following error:

_sqlite3: error while loading shared libraries: libsqlite3.so.0: cannot open shared object file: No such file or directory_

This error typically occurs because SQLite is not installed on your system by default. To resolve this issue, you can install SQLite using the following command:

```bash
sudo apt-get install sqlite3 libsqlite3-dev
```

After installation, try running your command again, and the issue should be resolved.
