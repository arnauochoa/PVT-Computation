function E1C_2 = check_Galstate(state)

    b_state = de2bi(state, 16);
    
    if b_state(12)
        E1C_2 = 1;
    else
        E1C_2 = 0;
    end
end