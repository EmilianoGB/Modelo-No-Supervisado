# Librerías
library(dplyr)
library(gtools)
library(clustertend)
library(tidyr)
library(factoextra)
library(cluster)
library(tibble)
library(rattle)

# Carga de Datos
acciones <- read.csv('equity.csv', row.names = 2)
calificaciones <- read.csv('notas.csv')

#1- Conocimiento específico
plot(acciones$beta, acciones$div)
abline(lm(acciones$div~acciones$beta), col="red", lwd = 3)

# 2- Datos
#a)
glimpse(acciones)
summary(acciones)

#b)
acciones <- acciones[,-1]
accionesz<- data.frame(acciones[,1:2], scale(acciones[,3:6]))
summary(accionesz)
sd(accionesz$div)
plot(accionesz$beta, accionesz$div)
abline(lm(accionesz$div~accionesz$beta), col="red", lwd = 3)
#c)

# 3- Selección de Variables
#a-
#Combinaciones de a 2 variables

combi<-combinations(n = 4, r = 2, names(acciones[,3:6]))
chopkins <- c()

set.seed(1)

for (i in 1:nrow(combi)){
  thopkink <- get_clust_tendency(accionesz[,combi[i,]], n=50, graph = FALSE)
  chopkins <- rbind(chopkins,thopkink)
}
eleccion <- data.frame(combi,chopkins)

#Combinaciones de a 3 variables

combi2<-combinations(n = 4, r = 3, names(acciones[,3:6]))
chopkins2 <- c()

for (i in 1:nrow(combi2)){
  thopkink2 <- get_clust_tendency(accionesz[,combi2[i,]], n=50, graph = FALSE)
  chopkins2 <- rbind(chopkins2,thopkink2)
}
eleccion2 <- data.frame(combi2,chopkins2)
view(remove_rownames(eleccion))
#Conservando las 4 variables continuas
eleccion3 <- get_clust_tendency(accionesz[,3:6], n=50, graph = FALSE)



#De acuerdo con el test de hopkins, la mejor alternativa es conservar las variables que presentan mayor estructura: beta y div.

accionesz <- accionesz[,-c(5:6)]

# 4- Clustering inicial
#a)Criterio del “Gap Statistic”
fviz_nbclust(accionesz[,3:4], FUNcluster = kmeans, method = "gap_stat", nboot = 50,
             k.max = 10, verbose = FALSE, nstart = 50) +
  labs(title = "Número óptimo de clusters")

#b-explicar
solucion <- kmeans(accionesz[,3:4], 3)
#fviz_cluster(solucion, data = acciones[,c(3:4)], frame.type = "convex")
n = 1e2
almacen <- numeric(n)
for(i in 1:n) {
  set.seed(i)
  q <- kmeans(accionesz[,3:4], 3)
  almacen[i] <- q$tot.withinss
}
#---examinamos almacen
almacen
#---valores y frecuencias
table(almacen)
#---seed del máximo(s)
m <- match(min(almacen), almacen)

#---obtenemos solución óptima
#---usamos la seed del máximo
set.seed(m)
#---k-means con seed óptima
q <- kmeans(accionesz[,3:4], 3)
#---verificamos
q$tot.withinss
#---visualización
barplot(c(q$tot.withinss, q$betweenss, q$totss), col = c(2,3,4))

# c)
#---visualización
par(mfrow = c(1,1), pch=16)
accionesz$cluster <- q$cluster
acciones$cluster <- q$cluster

plot(accionesz[,3:4],col=accionesz$cluster+1)
points(q$centers, cex=3, col=5)

# d)
plot(acciones[,3:4],col=acciones$cluster+1)  
#Especulativo azul / conservador verde / crecimiento rojo

#5) Rating Crediticio
#a)
calificaciones
calificaciones <- gather(calificaciones, key = "pais", value = "calificacion", -X)
calificaciones$calificacion <- case_when(calificaciones$calificacion == "A" ~ 3,
                                         calificaciones$calificacion == "B" ~ 2,
                                         TRUE ~ 1)

names(calificaciones) <- c("sector", "country", "score")

#b)
db <- data.frame(left_join(acciones, calificaciones, by= c("sector","country")),row.names = rownames(acciones))


#c) ver función all.equal

#categórica ordinal
#score está asignado de acuerdo a un perfil de riesgo, se puede considerar para determinar donde invertir según el apetito


#6) Clustering avanzado

#a)
db1 <- db[, c(3,4,8)]

#b)
distancia<- daisy(db1,  weights = c(1,1,0.6), metric = "gower")
#?daisy
#c)
fviz_nbclust(db1, hcut, method = 'silhouette')

#d)
h <- hclust(distancia, method = 'complete')
plot(h, hang = -1)

#e)
z <- cutree(h, k = 3)
acciones$clusterh <- z
plot(acciones[,c(3:4)],col=acciones$clusterh+1)

#f)
centros <- centers.hclust(db1, h, nclust = 3)
points(centros[,-3], cex=3, col=5)

#7) Comparación de Algoritmos de Clustering
table(acciones$cluster, acciones$clusterh)

#8) Visualizacion
d1 <- daisy(acciones,  weights = c(0,0,1,1,0,0,0,0), metric = "euclidean")
a<-data.frame(cmdscale(d1, 2),acciones$cluster) 
plot(a[,1],a[,2], col = a$acciones.cluster, pch = 16, xlab = 'Componente 1', ylab = 'Componente 2')

b<- data.frame(cmdscale(distancia, 2),acciones$clusterh) 
plot(b[,1],b[,2], col = b$acciones.clusterh, pch = 16, xlab = 'Componente 1', ylab = 'Componente 2')

#9) Asignacion

acciones$cliente <- case_when(acciones$clusterh == 1 ~ "Conservador",
                              acciones$clusterh == 2 ~ "Crecimiento",
                              TRUE ~ "Especulativo") 
table(acciones$country, acciones$cliente)
table(acciones$sector, acciones$cliente)
table(acciones$country, acciones$cliente)

Conser<-acciones %>% filter(cliente=="Conservador") %>% select(1,2) %>% as.data.frame()  %>% 
  table() %>% as.data.frame() %>% filter(Freq != 0) %>% group_by(country) %>% arrange(desc(Freq)) 

Creci<-acciones %>% filter(cliente=="Crecimiento") %>% select(1,2) %>% as.data.frame()  %>% 
  table() %>% as.data.frame() %>% filter(Freq != 0) %>% group_by(country) %>% arrange(desc(Freq)) 

Espe<-acciones %>% filter(cliente=="Especulativo") %>% select(1,2) %>% as.data.frame()  %>% 
  table() %>% as.data.frame() %>% filter(Freq != 0) %>% group_by(country) %>% arrange(desc(Freq)) 
