#include "C:/Program Files/PostgreSQL/15/include/libpq-fe.h"
#include "CRUD.cpp"
#include <cstdio>
#include <iostream>
#include <locale.h>
#include <ostream>
#include <process.h>
#include <string>

// 
int main() {
  setlocale(LC_ALL, "Turkish.UTF-8");

  const char *conn_info =
      "host=localhost user=postgres password=a port=5432 "
      "dbname=FutbolVeritabaniYonetimi connect_timeout=10";

  PGconn *conn = PQconnectdb(conn_info);

  if (PQstatus(conn) == CONNECTION_BAD) {
    std::cout << "CONNECTION BAD!\n" << PQerrorMessage(conn) << std::endl;
    return 1;
  }
  std::cout << PQerrorMessage(conn);
  std::cout << "CONNECTION OK!\n";

  char secenek;
  while (true) {
    std::cout << "1. insert_row\n";
    std::cout << "2. print_table\n";
    std::cout << "3. update_row\n";
    std::cout << "4. delete_row\n";
    std::cout << "5. exit\n";
    std::cin >> secenek;
    std::string table_name;
    std::string row_data;
    std::string table_columns;
    std::string column;
    std::string condition;
    std::string data;
    switch (secenek) {
    case '1':
      std::cout << "\ntable_name : ";
      std::cin >> table_name;
      std::cout << "\ntable_columns :";
      std::cin >> table_columns;
      std::cout << "row_data : ";
      std::cin >> row_data;
      insert_row(row_data, conn, table_name, table_columns);
      std::cout <<'\n';
      break;
    case '2':
      std::cout << "\ntable_name : ";
      std::cin >> table_name;
      print_table(get_table(table_name, conn));
      std::cout <<'\n';
      break;
    case '3':
      std::cin.ignore();
      std::cout << "\ntable_name : ";
      std::getline(std::cin, table_name);
      std::cout << "\ncolumn : ";
      std::getline(std::cin, column);
      std::cout << "\ncondition : ";
      std::getline(std::cin, condition);
      std::cout << "\ndata : ";
      std::getline(std::cin, data);
      update_row(conn, table_name, column, condition, data);
      std::cout <<'\n';
      break;
    case '4':
      std::cin.ignore();
      std::cout << "\ntable_name : ";
      std::getline(std::cin, table_name);
      std::cout << "\ncondition : ";
      std::getline(std::cin, condition);
      delete_row(conn, table_name, condition);
      std::cout <<'\n';
      break;
    case '5':
      exit(1);
      break;
    }
  }

  return 0;
}