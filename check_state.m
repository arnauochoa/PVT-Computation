function valid = check_state(state)

    b_state = de2bi(state, 16);
    
    if b_state(4)
        valid = 1;
    else
        valid = 0;
    end
end