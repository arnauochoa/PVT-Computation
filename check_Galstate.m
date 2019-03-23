function valid = check_Galstate(state)

    b_state = de2bi(state, 16);
    
    if b_state(12)
        valid = 1;
    else
        valid = 0;
    end
end