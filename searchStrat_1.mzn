% Search Strategies
ann: mode_s = bool_search(mrun, input_order, indomain_max, complete);
ann: start_s = int_search(start, smallest, indomain_min, complete);

ann: modeThenStart = seq_search([mode_s, start_s]); % strat 1

% Search
solve :: modeThenStart minimize makespan;