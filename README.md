# Modelo-No-Supervisado
Análisis de Clúster para Portafolios de Inversión
Trabajo obligatorio realizado en el marco de la materia Machine Learning No Supervisado. Posgrado en Analítica de Negocios - Universidad ORT. Montevideo, Uruguay.

Consigna: Aplicar los conocimientos adquiridos en MLNS a la identificación de clusters de empresas.

1. Conocimiento Específico

2. Datos
Los datos de las acciones que maneja el fondo se encuentran en el archivo ‘equity.csv’.
a. Identifique las variables contínuas de “acciones”.
b. Estandarice estas variables.
c. Explique por qué es importante estandarizar en este caso en particular.

3. Selección de Variables
a. Identifique todos los posibles sub-conjuntos de variables contínuas de “acciones”
b. Efectue un Test de Hopkins con una muestra de n = 50 en todos los casos necesarios. 
c. Detalle sus resultados, explique con qué variables va a trabajar y por qué.

4. Clustering inicial
A priori, usted decide tratar de encontrar estructura solamente en las variables contínuas. Para esto, usa
K-Means.
a. Utilice el criterio del “Gap Statistic” para explorar con 10 muestras el potencial número de clusters
entre 1 y 10.
b. Aplique K-Means con el número óptimo de clusters hallados en el punto anterior. 
c. Grafique los datos sobre las variables (estandarizadas) escogidas en el punto 3 marcando los clusters
de pertenencia y superponiendo los centroides de los clusters
d. Grafique los datos sobre las variables (originales) escogidas en el punto 3 marcando los clusters de
pertenencia.
Qué estructura obtiene? Coincide esto con su intuición?

5. Rating Crediticio
Se obtienen nuevos datos donde se detalla la calidad crediticia por país y sector económico. Los moismos se encuentran en ‘notas.csv’.
En este punto, usted va a agregar la calificación crediticia como un campo adicional de su base de acciones.
Siga los siguientes pasos:
a. Transforme la matriz de calificaciones en una matriz “ws” de números escalonados en forma equidistante,
que respete el orden de las calificaciones (ej: A = 3, B = 2, C = 1).
b. En base a “ws”, asigne para cada acción de “db” el score crediticio numérico correspondiente a su país
y sector económico de pertenencia en una nueva columna llamada ‘score’.
c. Verifique sus resultados

6. Clustering Avanzado
Al incorporar la variable de calificación crediticia, usted debería volver a realizar un análisis de clustering.
Esta vez utiliza el Clustering Jerárquico.
a. Construya un nuevo data.frame “db1” con las variables contínuas seleccionadas y la nueva variable
‘score’ que construyó en el punto anterior.
b. Construya una matriz de distancias “d” en base a “db1” ponderando las variables de acuerdo al siguiente
vector: P = (pscore, pbeta, pdiv) = (0.6, 1, 1).
c. Utilice el criterio de “Silhouette” para explorar el potencial número de clusters en “db1” con el algoritmo
de clustering Jerárquico.
d. Aplique Clustering Jerárquico a “d” y obtenga el dendrograma correspondiente.
e. En base al número óptimo de clusters del punto b, grafique los datos sobre las variables (contínuas
originales) escogidas en el punto 3 marcando los clusters de pertenencia según este nuevo procedimiento
de clustering.
f. Obtenga los centroides de los clusters y agreguelos al gráfico anterior.
Qué estructura obtiene ahora? Hay coincidencia con su intuición?

7. Comparación de Algoritmos de Clustering
En esta etapa usted va a visualizar la diferencia entre los algoritmos de los resultados del punto 4 y 6
a. Construya una tabla comparando las asignaciones a clusters de ambos métodos.
b. Identifique coincidencias y diferencias.

8. Visualización
a. Construya una matriz de distancias “d1” en base a las variables utilizadas en el punto 4.
b. Aplique MDS a “d1” y proyecte su resultado en 2 ejes marcando los clusters obtenidos en el punto 4
en color.
c. Aplique MDS a “d” (del punto 6) y proyecte su resultado en 2 ejes marcando los clusters obtenidos en
el punto 6 en color.

9. Asignación
a. Qué combinciones de país y sector económico se presentan en cada sub-portafolio?
b. Cómo puede caracterizar cada sub-portafolio de acuerdo a las variables contínuas?
c. Qué Cluster asignaría a cada tipo de inversor?

10. Conclusiones
Resuma sus conclusiones explicando los principales puntos de su trabajo. De haberlas, agregue sugerencias
para trabajo futuro en XYZ
