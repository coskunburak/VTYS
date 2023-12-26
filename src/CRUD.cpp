#include "C:/Program Files/PostgreSQL/15/include/libpq-fe.h"
#include <iostream>
#include <string>

void print_table(const std::string &table)
{
  for (size_t i = 0; i < table.size(); i++)
  {

    std::cout << table[i];
    if (table[i] == ';')
    {
      std::cout << '\n';
    }
  }
}

std::string get_table(std::string table_name, PGconn *conn)
{
  std::string str;
  std::string query = "select * from ";
  query.append(table_name + ";");

  const char *cstr_query = query.c_str();
  PGresult *res = PQexec(conn, cstr_query);

  for (size_t i = 0; i < PQnfields(res); i++)
  {
    std::string column_name = PQfname(res, i);
    str.append(column_name + "--");
  }
  str.pop_back();
  str.pop_back();
  str.push_back(';');

  for (size_t i = 0; i < PQntuples(res); i++)
  {
    for (size_t j = 0; j < PQnfields(res); j++)
    {
      std::string cell = PQgetvalue(res, i, j);
      str.append(cell + "--");
    }
    str.pop_back();
    str.pop_back();
    str.push_back(';');
  }

  return str;
}

void insert_row(std::string row_data, PGconn *conn, std::string table_name,
                std::string table_columns)
{
  std::string query = "insert into ";
  query.append(table_name);
  query.append(" (");
  query.append(table_columns);
  query.append(") ");
  query.append("values (");
  query.append(row_data);
  query.append(");");

  PGresult *res = PQexec(conn, query.c_str());
  std::cout << PQerrorMessage(conn);
}

void delete_row(PGconn *conn, std::string table_name, std::string condition)
{
  std::string query = "delete from ";
  query.append(table_name);
  query.append(" where ");
  query.append(condition);
  query.append(";");

  PGresult *res = PQexec(conn, query.c_str());
  std::cout << PQerrorMessage(conn);
}

void update_row(PGconn *conn, std::string table_name, std::string column, std::string condition, std::string data)
{
  std::string query = "update ";
  query.append(table_name);
  query.append(" set ");
  query.append(column);
  query.append(" = ");
  query.append(data);
  query.append(" where ");
  query.append(condition);
  query.append(";");

  PGresult *res = PQexec(conn, query.c_str());
  std::cout << PQerrorMessage(conn);
}