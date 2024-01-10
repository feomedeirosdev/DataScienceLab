import sqlite3
import pandas as pd
import os

# ep_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(os.path.abspath('.'), 'scr')
base_dir = os.path.dirname(src_dir)
data_dir = os.path.join(base_dir, 'data')

print(f"Caminho do projeto:  {base_dir}")
print(f"Caminho da fonte:    {src_dir}")
print(f"Caminho dos dados:   {data_dir}")
# print(f"Caminho do episódio: {ep_dir}")

# Função que abre e lê um arquivo e armazena na variável result
def import_query(path, **kwards):
    with open(path, 'r', **kwards) as file_open:
        result = file_open.read()
    return result

query = import_query( os.path.join(src_dir, 'ep4/create_safra.sql') )

print(query)

# Conectar ao banco de dados (se não existir, será criado)
conn = sqlite3.connect(os.path.join(data_dir, 'olist.db'))

# Criar um cursor
cursor = conn.cursor()

# # Consultar o sistema de tabelas para obter o nome das tabelas
# cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
# tables = cursor.fetchall()

# # Imprimir os nomes das tabelas
# for table in tables:
#     print(table[0])

df = pd.read_sql(query, conn)
lst_col = list(df.columns)

# Variáveis para serem removidas
to_remove = ['seller_id', 'seller_city']

# Variável alvo, target, resposta
target = 'flag_model'

# remove de fato as variáveis
for i in to_remove + [target]:
    lst_col.remove(i)

cat_features = df[ lst_col ].dtypes[ df[ lst_col ].dtypes == 'object' ].index.tolist()
num_features = list(set(lst_col) - set(cat_features))

num_features

# # Consultar dados
# cursor.execute("SELECT * FROM tb_book_sellers")
# rows = cursor.fetchall()
# for row in rows[:1]:
#     print(row)

# # Confirmar as alterações
# # conn.commit()

# # Fechar a conexão
# conn.close()