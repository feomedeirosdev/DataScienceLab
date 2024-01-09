import sqlite3
import pandas as pd
import os

# ep_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(os.path.abspath('.'), 'scr')
base_dir = os.path.dirname(src_dir)
data_dir = os.path.join(base_dir, 'data')

# Função que abre e lê um arquivo e armazena na variável result
def import_query(path, **kwards):
    with open(path, 'r', **kwards) as file_open:
        result = file_open.read()
    return result

query = import_query( os.path.join(src_dir, 'ep4/create_safra.sql') )

# print(query)

# Conectar ao banco de dados (se não existir, será criado)
conn = sqlite3.connect(os.path.join(data_dir, 'olist.db'))

# Criar um cursor
cursor = conn.cursor()

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

# # Confirmar as alterações
# # conn.commit()

# # Fechar a conexão
# conn.close()