%%%%%%%%%%%%%%%%%
%
% Compute nodes and weights of a Gauss-Kronrod rule for the Gauss-Legendre rule with n nodes on [0,1]
%
% This little GNU Octave script just calls Gautschi's Gauss-Kronrod methods (unfortunately written for
% Octave/MATLAB) and outputs in a form useable in C++.
% You may want to edit the data type DT (or use a template) in the definition of the vectors.
%
% This needs the following MATLAB scripts from Gautschi's OPQ:
% kronrod.m
% r_jacobi01.m
% r_jacobi.m
% r_kronrod.m
%
% Obtainable here: https://www.cs.purdue.edu/archives/2002/wxg/codes/OPQ.html
%
% Node that everything is only up to rougly machine precision. If you need multi precision, there should
% be a suitable implementation for the MATLAN Multiprecision toolbox.
%%%%%%%%%%%%%%%%%


%transform to [0,1]
linear_transform = @(x) 0.5.*(x+ones(size(x))); 

printf("std::vector<DT> weights_;\n");
printf("std::vector<DT> nodes_;\n");
printf("switch(n) {\n");

for n=1:10
  prec = ceil(3*n/2)+5; %necessary precision (plus some extra)
  ab=r_jacobi(prec); %jacobi matrix

  gk = kronrod(n, ab);

  nodes=linear_transform(gk(:,1));
  weights=0.5.*gk(:,2); %employ change of interval

  printf("  case %d: \n", n);
  printf("    weights_.resize(%d);\n", length(weights));
  printf("    nodes_.resize(%d);\n\n", length(nodes));

  for i=1:length(nodes)
    printf("    nodes_[%d]   = %1.15f;\n", i-1, nodes(i));
    printf("    weights_[%d] = %1.15f;\n", i-1, weights(i));
  end
  printf("    break;\n\n");

end
printf("  default:\n    throw std::range_error(\"No suitable Gauss-Kronrod rule found\");\n");
printf("}\n");
