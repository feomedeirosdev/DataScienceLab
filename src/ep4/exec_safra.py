import sqlite3
import pandas as pd
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--date", '-d', help='Data para referência de safra: YYYY-MM-DD', default='2017-04-01')

args = parser.parse_args()
date = args.date

# src_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(os.path.abspath('.'), 'src')
base_dir = os.path.dirname(src_dir)
data_dir = os.path.join(base_dir, 'data')

# Função que abre e lê um arquivo e armazena na variável result
def import_query(path, **kwards):
    with open(path, 'r', **kwards) as file_open:
        result = file_open.read()
    return result

# Istanciando query para string
query = import_query(os.path.join(src_dir, 'ep4/query_04.sql'))
query = query.format(date=date)

# Conecta ao banco de dados (se não existir, será criado)
conn = sqlite3.connect(os.path.join(data_dir, 'olist.db'))

# Cria um cursor
cursor = conn.cursor()

try:
    print()
    print('Removendo dados duplicados... ', end='')
    cursor.execute('DELETE FROM tb_book_sellers WHERE dt_ref = {date}'.format(date=date))
    print('ok.')
except:
    print('Tabela não encontada... ')

try:
    print()
    print('Criando tabela... ', end='')
    base_query = 'CREATE TABLE tb_book_sellers AS \n {query}'
    cursor.execute(base_query.format(query=query))
    print('ok.')
except:
    print()
    print()
    print('Tabela existente, inserindo dados... ', end='')
    base_query = 'INSERT INTO tb_book_sellers \n  {query}'
    cursor.execute(base_query.format(query=query))
    print('ok.')
    print()

# cursor.execute('DELETE FROM tb_book_sellers WHERE dt_ref = {date}'.format(date=date))
    
conn.commit()
conn.close()