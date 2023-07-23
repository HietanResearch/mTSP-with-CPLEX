args <- commandArgs(trailingOnly=TRUE)
nodes_filename <- args[1]
routes_filename <- args[2]
output_filename <- args[3]

library(igraph, warn.conflicts = FALSE)

nodes <- as.matrix(read.csv(nodes_filename, header=F))
routes <- read.csv(routes_filename, header=F)

colors <- c(
	"#FF4B00",
	"#FFF100",
	"#03AF7A",
	"#005AFF",
	"#4DC4FF",
	"#FF8082",
	"#F6AA00",
	"#990099",
	"#804000"
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

shape_arg <- c("square", rep("circle", times=(vcount(g))))

pdf(output_filename)

plot(g,
	 layout=nodes,
	 vertex.shape=shape_arg,
	 vertex.color="#333333",
	 vertex.size=5,
	 vertex.label=NA,
	 edge.color=colors_arg,
	 edge.width=1,
	 edge.arrow.size=0.5
)
box()
