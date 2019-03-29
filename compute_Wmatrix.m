function W = compute_Wmatrix(weight)

    % Weight is CN0
    weight  =	10.^(-weight/10)/sum(10.^(-weight/10));
    W       =   diag(1./weight);
    
end