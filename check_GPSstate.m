function valid = check_GPSstate(state)

    b_state = de2bi(state, 16);
    
    if (b_state(2) && b_state(4)) || b_state(15)
        valid = 1;
    else
        valid = 0;
    end
end