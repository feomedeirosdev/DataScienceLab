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
# print(query) # Retorna uma string

# Conecta ao banco de dados (se não existir, será criado)
conn = sqlite3.connect(os.path.join(data_dir, 'olist.db'))

# Cria um cursor
cursor = conn.cursor()

df = pd.read_sql(query, conn)
lst_col = list(df.columns)

# Variáveis para serem removidas
to_remove = ['seller_id', 'cidade']

# Variável alvo, target, resposta
target = 'flag_model'

# remove de fato as variáveis
for i in to_remove + [target]:
    lst_col.remove(i)

cat_features = df[ lst_col ].dtypes[ df[ lst_col ].dtypes == 'object' ].index.tolist()
num_features = list(set(lst_col) - set(cat_features))

print(type(num_features))
print(num_features)
print(type(cat_features))
print(cat_features)

from sklearn import tree

clf = tree.DecisionTreeClassifier(max_depth=10)
clf.fit( df[num_features], df[target] )

y_pred = clf.predict( df[num_features] )
y_prod = clf.predict_proba( df[num_features] )

print(y_pred)
print(type(y_pred))
print(y_prod)
print(type(y_prod))

from sklearn import metrics

print()
print(metrics.confusion_matrix(df[target], y_pred))
print(type(metrics.confusion_matrix(df[target], y_pred)))
print()

print(clf.feature_importances_)
clf.feature_importances_

features_importance = pd.Series(clf.feature_importances_, index = num_features)

features_importance.sort_values(ascending=False)[:10]

# # Confirmar as alterações
# # conn.commit()

# # Fechar a conexão
# conn.close()