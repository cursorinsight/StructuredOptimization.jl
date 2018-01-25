module MatrixDecomposition

using BenchmarkTools
using RegLS
using Images, ImageView

function set_up()
	Frames = 900
	dir = "street"
	img = load("$dir/in000000.jpg")
	n,m = size(img,1),size(img,2)
	#frames = sort(randperm(Frames)[1:N])
	frames = collect(1:45:Frames)
	N = length(frames)

	Y = zeros(Float64,n,m,N)
	for f in eachindex(frames)
		a = @sprintf("%6.6i",frames[f])
		img = load("$dir/in$(a).jpg")
		Y[:,:,f] .= convert(Array{Float64},Gray.(img))
		img = []
	end

	Y = reshape(Y,n*m,N)

	F = Variable(n*m,N)
	B = Variable(n*m,N)
	slv = ZeroFPR
	slv = slv(verbose = 1, tol = 1e-5, adaptive = false, gamma = 0.5)

	R, lambda = 1, 4e-2
	return B, F, Y, R, lambda, n, m, N 
end

function run_demo()
	slv = ZeroFPR(tol = 1e-4)
	setup = set_up()
	solve_problem!(slv,setup...)
	return setup
end

function solve_problem!(slv, B, F, Y, R, lambda, n, m, N)
	@minimize ls(B+F-Y)+lambda*norm(F,1) st rank(B) <= R with slv 
end

function benchmark(;verb = 0, samples = 5, seconds = 100)

	suite = BenchmarkGroup()

	tol = 1e-4
	solvers = ["ZeroFPR",
		   "FPG",
		   "PG"]
	slv_opt = ["(verbose = $verb, tol = $tol)", 
		   "(verbose = $verb, tol = $tol)",
		   "(verbose = $verb, tol = $tol)"]

	for i in eachindex(solvers)

		setup = set_up()
		solver = eval(parse(solvers[i]*slv_opt[i]))

		suite[solvers[i]] = 
		@benchmarkable(solve_problem!(solver, setup...), 
			       setup = ( 
					setup = deepcopy($setup); 
					solver = deepcopy($solver) ), 
			       evals = 1, samples = samples, seconds = seconds)
	end

	results = run(suite, verbose = (verb != 0))
end

function show_results(B, F, Y, R, lambda, n, m, N)
	F = F.x
	B = B.x

	F[F .!=0] = F[F.!=0]+reshape(B,size(F))[F.!=0]
	F[ F.== 0] = 1. #put white in null pixels
	F[F.>1] .= 1; F[F.<0.] .= 0.
	B[B.>1] .= 1; B[B.<0.] .= 0.

	#convert back to images
	Y = reshape(Y,n,m,N)
	B = reshape(B,n,m,N)
	F = reshape(F,n,m,N)
	#
	####videos
	#imshow(Y)
	#imshow(F)
	#imshow(B)
	#
	##images
	idx = round.(Int,linspace(1,N,4)) 
	imshow(hcat([Y[:,:,i] for i in idx]...))
	imshow(hcat([F[:,:,i] for i in idx]...))
	imshow(hcat([B[:,:,i] for i in idx]...))
end


end
