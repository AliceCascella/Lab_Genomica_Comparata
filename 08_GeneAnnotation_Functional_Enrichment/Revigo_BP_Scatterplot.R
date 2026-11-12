# A plotting R script produced by the Revigo server at http://revigo.irb.hr/
# If you found Revigo useful in your work, please cite the following reference:
# Supek F et al. "REVIGO summarizes and visualizes long lists of Gene Ontology
# terms" PLoS ONE 2011. doi:10.1371/journal.pone.0021800

# --------------------------------------------------------------------------
# If you don't have the ggplot2 package installed, uncomment the following line:
# install.packages( "ggplot2" );
library( ggplot2 );

# --------------------------------------------------------------------------
# If you don't have the scales package installed, uncomment the following line:
# install.packages( "scales" );
library( scales );

# --------------------------------------------------------------------------
# Here is your data from Revigo. Scroll down for plot configuration options.

revigo.names <- c("term_ID","description","frequency","plot_X","plot_Y","log_size","value","uniqueness","dispensability");
revigo.data <- rbind(c("GO:0000053","argininosuccinate metabolic process",0.026573216763974988,-5.439119008202105,-2.6873031054657663,3.971322245242813,-1.6020599913279623,0.908326965249068,0.31038093),
c("GO:0000706","meiotic DNA double-strand break processing",0.012182230035706908,-0.17289682783844937,4.809770909197354,3.6326597132939136,-1.6020599913279623,0.7363172041169174,0.58164953),
c("GO:0000729","DNA double-strand break processing",0.03717411328071458,-0.33845478372839466,2.23415527967029,4.117105502761251,-1.6020599913279623,0.8510763715288635,0.19164882),
c("GO:0006032","chitin catabolic process",0.0988631546337501,-4.962070032797782,5.509317664277977,4.541878654149342,-2.958607314841775,0.9331823355061994,0),
c("GO:0006145","purine nucleobase catabolic process",0.0718640850370191,-4.641266658479929,1.777290557999831,4.403360775765525,-1.3062730510763532,0.8604382065446302,0.45679961),
c("GO:0006357","regulation of transcription by RNA polymerase II",4.563981208420439,2.9380063680804613,-4.230935751035111,6.206175836307942,-2.619788758288394,0.8906294262804176,0.22876141),
c("GO:0006526","L-arginine biosynthetic process",0.2695307749079335,-5.500237923121837,-2.1064677303097663,4.977444652948287,-1.3062730510763532,0.8957222250189788,0.48059619),
c("GO:0006720","isoprenoid metabolic process",0.6301798609312277,-7.520081689816282,2.2420372207338235,5.346298195115413,-1.393618634889395,0.9068733400107333,0.41715314),
c("GO:0007140","male meiotic nuclear division",0.0353543021754039,0.8025262023198046,6.402166624825902,4.095308861385381,-1.3062730510763532,0.8059642915884285,0.6743265),
c("GO:0007608","sensory perception of smell",0.39260224357442014,4.295466024391902,5.501190962780132,5.140787636152006,-2.795880017344075,0.7941659129827625,-0),
c("GO:0007610","behavior",0.18495356330370494,4.610071199451165,5.203380444838136,4.813901087703305,-1.6108339156354674,0.8424915079446494,0.48452679),
c("GO:0008045","motor neuron axon guidance",0.026638514198330906,4.319564655134453,4.646730850547338,3.9723879991074726,-1.8041003475907664,0.8440185576090046,0.41634649),
c("GO:0008300","isoprenoid catabolic process",0.050866701363262795,-6.229624360130452,3.298185084446031,4.253289532254802,-1.3062730510763532,0.873827320512787,0.65776804),
c("GO:0016093","polyprenol metabolic process",0.04413822660571785,-6.656079826140278,0.250709386656398,4.191674531959229,-1.6020599913279623,0.8644244301446655,0.34343201),
c("GO:0016095","polyprenol catabolic process",0.006294104868133818,-6.345345917473459,1.568054912469856,3.3459615418131414,-1.6020599913279623,0.8605440667786043,0.57877064),
c("GO:0016185","synaptic vesicle budding from presynaptic endocytic zone membrane",0.019140665322940103,5.625478580240202,2.3810126923275448,3.82885315967664,-1.3062730510763532,0.9745178698979291,0.15052085),
c("GO:0019098","reproductive behavior",0.0234985593114766,1.782143107286915,6.212901814866539,3.9179254220647413,-1.9208187539523751,0.7263456100170429,0.60932014),
c("GO:0019627","urea metabolic process",0.08638282761511398,-6.371183965294385,-1.5476820992388696,4.483273407582981,-1.6020599913279623,0.8755516449339508,0.54354766),
c("GO:0022414","reproductive process",1.402268080831183,-4.464786242472876,-6.4170427511421595,5.693663646329222,-1.8761483590329142,1,-0),
c("GO:0030111","regulation of Wnt signaling pathway",0.21384625849675767,4.21724664853152,-4.201952320409074,4.876939140345395,-1.393618634889395,0.9002815925761434,0.58639503),
c("GO:0032501","multicellular organismal process",4.906531549051603,6.691020455104088,-1.25997492855905,6.237606565554471,-1.3990271043132518,1,-0),
c("GO:0035337","fatty-acyl-CoA metabolic process",0.0663081250789957,-5.3682683795481765,0.460589181637277,4.368417060738562,-2.5528419686577806,0.8275407475242119,0.03896559),
c("GO:0038007","netrin-activated signaling pathway",0.011131793048242085,2.061373577845142,-1.3929498643906508,3.5935075893317654,-1.6020599913279623,0.8658189629439306,0.13586702),
c("GO:0042138","meiotic DNA double-strand break formation",0.02691389903017979,-0.6684902713635883,5.9954307867707595,3.976854146576219,-1.3062730510763532,0.802294123482246,0.63263637),
c("GO:0043066","negative regulation of apoptotic process",0.33053277369078926,2.3414352885079857,-5.47152122586029,5.066049976839828,-2.886056647693163,0.8335114498789562,-0),
c("GO:0043171","peptide catabolic process",0.08616138414208085,-5.561825634968516,5.421267860223865,4.482158695411276,-2.657577319177794,0.9410843687092455,0.30741974),
c("GO:0043242","negative regulation of protein-containing complex disassembly",0.20274853367513607,1.8078010301478362,-5.42331682425576,4.853795521765805,-1.6108339156354674,0.7006619877206478,0.69761419),
c("GO:0048609","multicellular organismal reproductive process",0.42806726748634066,-0.20231195275078787,7.047035718653335,5.178346619285556,-1.8356471442155629,0.8378946670358709,-0),
c("GO:0051129","negative regulation of cellular component organization",0.4817956998857238,2.0477350086582913,-5.1269737614141455,5.22969719718407,-1.4596705252091262,0.7346477134711389,0.50996833),
c("GO:0060828","regulation of canonical Wnt signaling pathway",0.14946582724070417,4.371530097071978,-3.894196931700441,4.72138187779194,-1.7011469235902934,0.9024872662094356,0.16474901),
c("GO:0070973","protein localization to endoplasmic reticulum exit site",0.02446666475127526,6.6404554993117,0.7918843211802592,3.9354568807116097,-1.3062730510763532,0.994631480154972,-0),
c("GO:0071941","nitrogen cycle metabolic process",0.18416147703477878,-1.3432071484505574,-7.244882342948145,4.81203720303537,-1.6020599913279623,0.9751305062977911,0.04197728),
c("GO:0072350","tricarboxylic acid metabolic process",0.10665058343541499,-6.21246507565542,-2.464299025188727,4.5748065148539965,-2.2291479883578558,0.9096342901890616,0.23327562),
c("GO:0098609","cell-cell adhesion",0.6266907067215135,-2.6293777001493313,-6.13536325878553,5.343886940518804,-1.779891911959945,0.9977939577484141,0.00295091),
c("GO:0140546","defense response to symbiont",0.6622039939544796,1.3192240036818716,1.0166263371069828,5.3678253762566515,-1.3334820194451191,0.8639629139559851,0.36596784));

one.data <- data.frame(revigo.data);
names(one.data) <- revigo.names;
one.data <- one.data [(one.data$plot_X != "null" & one.data$plot_Y != "null"), ];
one.data$plot_X <- as.numeric( as.character(one.data$plot_X) );
one.data$plot_Y <- as.numeric( as.character(one.data$plot_Y) );
one.data$log_size <- as.numeric( as.character(one.data$log_size) );
one.data$value <- as.numeric( as.character(one.data$value) );
one.data$frequency <- as.numeric( as.character(one.data$frequency) );
one.data$uniqueness <- as.numeric( as.character(one.data$uniqueness) );
one.data$dispensability <- as.numeric( as.character(one.data$dispensability) );
#head(one.data);


# --------------------------------------------------------------------------
# Names of the axes, sizes of the numbers and letters, names of the columns,
# etc. can be changed below

p1 <- ggplot( data = one.data );
p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = value, size = log_size), alpha = I(0.6) );
p1 <- p1 + scale_colour_gradientn( colours = c("blue", "green", "yellow", "red"), limits = c( min(one.data$value), 0) );
p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = log_size), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) ));
p1 <- p1 + scale_size( range=c(5, 30)) + theme_bw(); # + scale_fill_gradientn(colours = heat_hcl(7), limits = c(-300, 0) );
ex <- one.data [ one.data$dispensability < 0.15, ];
p1 <- p1 + geom_text( data = ex, aes(plot_X, plot_Y, label = description), colour = I(alpha("black", 0.85)), size = 3 );
p1 <- p1 + labs (y = "semantic space x", x = "semantic space y");
p1 <- p1 + theme(legend.key = element_blank()) ;
one.x_range = max(one.data$plot_X) - min(one.data$plot_X);
one.y_range = max(one.data$plot_Y) - min(one.data$plot_Y);
p1 <- p1 + xlim(min(one.data$plot_X)-one.x_range/10,max(one.data$plot_X)+one.x_range/10);
p1 <- p1 + ylim(min(one.data$plot_Y)-one.y_range/10,max(one.data$plot_Y)+one.y_range/10);


# --------------------------------------------------------------------------
# Output the plot to screen

p1;

# Uncomment the line below to also save the plot to a file.
# The file type depends on the extension (default=pdf).

# ggsave("/path_to_your_file/revigo-plot.pdf");

