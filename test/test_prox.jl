using Base.Test

ASSERT_REL_TOL = 1e-15

@printf("Testing regularization functions\n")

################################################################################
### L2 norm
################################################################################

# Case: Array{Float64,1}

x = [-1.472658469388188,-0.2715944116787317,-0.05323943816203797,1.0714599486778327,-1.5331256392574706,0.4083764366610342,-0.9444383691511559,-0.7504607478410741,0.7438914169983039,-0.15652009656239366]
lambda = 0.5
gamma = 0.3
g = normL2(lambda)
ref_gx = 1.4092215084194275
ref_y = [-1.3942822988967276,-0.2571399197807538,-0.0504059887445427,1.0144359140099486,-1.4515313531517497,0.38664228587878424,-0.8941745339321049,-0.7105205711181053,0.7043008658028084,-0.14818996026228431]
ref_gy = 1.3342215084194275

gx = g(x)
y, gy1 = g(x, gamma)
gy2 = g(y)

@test abs(gx-ref_gx)/(1+abs(ref_gx)) <= ASSERT_REL_TOL
@test abs(gy1-ref_gy)/(1+abs(ref_gy)) <= ASSERT_REL_TOL
@test abs(gy2-ref_gy)/(1+abs(ref_gy)) <= ASSERT_REL_TOL
@test vecnorm(y-ref_y,Inf)/(1+vecnorm(ref_y,Inf)) <= ASSERT_REL_TOL

# Case: Array{Float64,2}

X = [0.3535118894832371 1.5241779674710798 0.9154551977221661 -0.7706408056940769 0.02826166858518239
 0.02885290814021263 0.8197054052865943 1.0081181456699522 1.316546826366039 -0.4109229336720345
 -0.5433787098088472 -0.7190357958825878 0.7192967938219091 -1.3446328130527854 0.05626927262795177
 -2.515446389368509 -0.860836036351144 0.7458682336574772 -2.1284534456497766 -1.353644535352597
 -0.5182680705374066 1.5018024932414602 -0.7282231210667033 -1.23819364027502 0.2666753635093874]
lambda = 1.3
gamma = 1.1
g = normL2(lambda)
ref_gX = 7.031901701393628
ref_Y = [0.26005515040238586 1.1212362083496195 0.6734394124007889 -0.5669091099706621 0.020790227127256197
 0.021225162686657004 0.6030026678001222 0.7416053711200715 0.9684958077163593 -0.30228863158204416
 -0.3997275234826147 -0.5289467415545362 0.529138740353966 -0.9891567973727414 0.04139355589336898
 -1.8504463600152405 -0.6332597334486701 0.5486855787727465 -1.5657614281150671 -0.995786121216666
 -0.3812552987379808 1.1047760623426084 -0.5357052447439009 -0.9108565876516768 0.19617530224349963]
ref_gY = 5.172901701393626

gX = g(X)
Y, gY1 = g(X, gamma)
gY2 = g(Y)

@test abs(gX-ref_gX)/(1+abs(ref_gX)) <= ASSERT_REL_TOL
@test abs(gY1-ref_gY)/(1+abs(ref_gY)) <= ASSERT_REL_TOL
@test abs(gY2-ref_gY)/(1+abs(ref_gY)) <= ASSERT_REL_TOL
@test vecnorm(Y-ref_Y,Inf)/(1+vecnorm(ref_Y,Inf)) <= ASSERT_REL_TOL

################################################################################
### L1 norm
################################################################################

# Case: Array{Float64,1}

x = [0.24488032099324117,0.6361148017053393,-0.7468003460445393,-0.39461027607226284,-0.766936244339526,0.08238242897650354,-1.4822688010626806,0.23915849610266143,-0.5124773673251194,0.14222091048851146]
lambda = 0.6
gamma = 0.4
g = normL1(lambda)
ref_gx = 3.148709995866231
ref_y = [0.004880320993241177,0.3961148017053393,-0.5068003460445393,-0.15461027607226285,-0.526936244339526,0.0,-1.2422688010626806,0.0,-0.2724773673251194,0.0]
ref_gy = 1.8624528945256253

gx = g(x)
y, gy1 = g(x, gamma)
gy2 = g(y)

@test abs(gx-ref_gx)/(1+abs(ref_gx)) <= ASSERT_REL_TOL
@test abs(gy1-ref_gy)/(1+abs(ref_gy)) <= ASSERT_REL_TOL
@test abs(gy2-ref_gy)/(1+abs(ref_gy)) <= ASSERT_REL_TOL
@test vecnorm(y-ref_y,Inf)/(1+vecnorm(ref_y,Inf)) <= ASSERT_REL_TOL

# Case: Array{Complex{Float64},2}

X = Complex{Float64}[0.48383139850861223 + 0.14880666357496075im -0.476452189543104 + 0.5373862840906938im -0.47734819961688757 + 1.5821400827207137im
                 0.731503968722083 + 0.16028191387997026im -0.43401778891072196 + 0.31094682923492956im -0.6171419681732582 + 1.6633154232600766im
                 0.8143294700727339 + 0.9825764200556435im 0.9956758203961695 + 0.6666719567389796im 0.9364063971363472 + 0.03175404144697325im]
lambda = 0.45
gamma = 0.55
g = normL1(lambda)
ref_gX = 4.2053455230857
ref_Y = Complex{Float64}[0.24726722632640047 + 0.07604924168725978im -0.3122580040459822 + 0.3521930891591931im -0.40585785798447027 + 1.3451899169615815im
                 0.48973954188193203 + 0.1073082231018745im -0.23282376734737972 + 0.16680379025222528im -0.5310468296940786 + 1.4312725885716275im
                 0.6563976577692634 + 0.7920146383087744im 0.7900191090320431 + 0.5289709506755073im 0.6890485776638721 + 0.02336600557303825im]
ref_gY = 3.2029705230857

gX = g(X)
Y, gY1 = g(X, gamma)
gY2 = g(Y)

@test abs(gX-ref_gX)/(1+abs(ref_gX)) <= ASSERT_REL_TOL
@test abs(gY1-ref_gY)/(1+abs(ref_gY)) <= ASSERT_REL_TOL
@test abs(gY2-ref_gY)/(1+abs(ref_gY)) <= ASSERT_REL_TOL
@test vecnorm(Y-ref_Y,Inf)/(1+vecnorm(ref_Y,Inf)) <= ASSERT_REL_TOL
