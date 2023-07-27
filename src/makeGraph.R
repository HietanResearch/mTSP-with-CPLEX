args <- commandArgs(trailingOnly=TRUE)
nodes_filename <- args[1]
routes_filename <- args[2]
output_filename <- args[3]

library(igraph, warn.conflicts = FALSE)

nodes <- as.matrix(read.csv(nodes_filename, header=F))
routes <- read.csv(routes_filename, header=F)

colors <- c(
	"#FF4B00",
	"#005AFF",
	"#03AF7A",
	"#4DC4FF",
	"#F6AA00",
	"#FFF100"
)

edges_arg <- c()
colors_arg <- c()

for(y in 1:nrow(routes)){
	for(x in 1:ncol(routes)){
		if(routes[y, x] >= 1){
			edges_arg <- append(edges_arg, c(y, x))
			colors_arg <- append(colors_arg, colors[routes[y, x]])
		}
	}
}

g <- graph(edges=edges_arg)

shape_arg <- c("square", rep("circle", times=(vcount(g)-1)))

pdf(output_filename)

plot(g,
	 layout=nodes,
	 vertex.shape=shape_arg,
	 vertex.color="#333333",
	 vertex.size=5,
	 vertex.label=c(0:(vcount(g)-1)),
	 vertex.label.color="#FFFFFF",
	 vertex.label.cex=0.5,
	 edge.color=colors_arg,
	 edge.width=1,
	 edge.arrow.size=0.5
)
box()
